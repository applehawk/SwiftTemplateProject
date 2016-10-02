//
//  PList.swift
//  StreamingTwitter
//
//  Created by Hawk on 26/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import Foundation

public struct PListError: Error {
    
    public enum ErrorKind: CustomStringConvertible {
        case invalidAppOnlyBearerToken
        case responseError(code: Int)
        case invalidPListResponse
        case badOAuthResponse
        case urlResponseError(status: Int, headers: [NSObject: AnyObject], errorCode: Int)
        case plistParseError
        
        public var description: String {
            switch self {
            case .invalidAppOnlyBearerToken:
                return "invalidAppOnlyBearerToken"
            case .invalidPListResponse:
                return "invalidPListResponse"
            case .responseError(let code):
                return "responseError(code: \(code))"
            case .badOAuthResponse:
                return "badOAuthResponse"
            case .urlResponseError(let code, let headers, let errorCode):
                return "urlResponseError(status: \(code), headers: \(headers), errorCode: \(errorCode)"
            case .plistParseError:
                return "jsonParseError"
            }
        }
        
    }
    
    public var message: String
    public var kind: ErrorKind
    
    public var localizedDescription: String {
        return "[\(kind.description)] - \(message)"
    }
    
}

public func ==(lhs: PList, rhs: PList) -> Bool {
    switch (lhs, rhs) {
    case (.null, .null):
        return true
        
    case (.bool(let lhsValue), .bool(let rhsValue)):
        return lhsValue == rhsValue
        
    case (.string(let lhsValue), .string(let rhsValue)):
        return lhsValue == rhsValue
        
    case (.number(let lhsValue), .number(let rhsValue)):
        return lhsValue == rhsValue
        
    case (.array(let lhsValue), .array(let rhsValue)):
        return lhsValue == rhsValue
        
    case (.object(let lhsValue), .object(let rhsValue)):
        return lhsValue == rhsValue
        
    default:
        return false
    }
}

public enum PList : Equatable, CustomStringConvertible {
    
    case string(String)
    
    case number(Double)
    
    case object([String : PList])
    
    case array([PList])
    
    case bool(Bool)
    
    case null
    
    case invalid
    
    
    public init(_ rawValue: Any) {
        switch rawValue {
        case let plist as PList:
            self = plist
            
        case let array as [PList]:
            self = .array(array)
            
        case let dict as [String: PList]:
            self = .object(dict)
            
        case let data as Data:
            do {
                let object = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
                self = PList(object)
            } catch {
                self = .invalid
            }
            
        case let array as [Any]:
            let newArray = array.map { PList($0) }
            self = .array(newArray)
            
        case let dict as [String: Any]:
            var newDict = [String: PList]()
            for (key, value) in dict {
                newDict[key] = PList(value)
            }
            self = .object(newDict)
            
        case let string as String:
            self = .string(string)
            
        case let number as NSNumber:
            self = number.isBoolean ? .bool(number.boolValue) : .number(number.doubleValue)
            
        case _ as Optional<Any>:
            self = .null
            
        default:
            assert(true, "This location should never be reached")
            self = .invalid
        }
        
    }
    
    public var string : String? {
        guard case .string(let value) = self else {
            return nil
        }
        return value
    }
    
    public var integer : Int? {
        guard case .number(let value) = self else {
            return nil
        }
        return Int(value)
    }
    
    public var double : Double? {
        guard case .number(let value) = self else {
            return nil
        }
        return value
    }
    
    public var object : [String: PList]? {
        guard case .object(let value) = self else {
            return nil
        }
        return value
    }
    
    public var array : [PList]? {
        guard case .array(let value) = self else {
            return nil
        }
        return value
    }
    
    public var bool : Bool? {
        guard case .bool(let value) = self else {
            return nil
        }
        return value
    }
    
    public subscript(key: String) -> PList {
        guard case .object(let dict) = self, let value = dict[key] else {
            return .invalid
        }
        return value
    }
    
    public subscript(index: Int) -> PList {
        guard case .array(let array) = self, array.count > index else {
            return .invalid
        }
        return array[index]
    }
    
    static func parse(plistData: Data) throws -> PList {
        do {
            let object = try PropertyListSerialization.propertyList(from: plistData, options: .mutableContainers, format: nil)
            return PList(object)
        } catch {
            throw PListError(message: "\(error)", kind: .plistParseError)
        }
    }
    
    static func parse(string : String) throws -> PList {
        do {
            guard let data = string.data(using: .utf8, allowLossyConversion: false) else {
                throw PListError(message: "Cannot parse invalid string", kind: .plistParseError)
            }
            return try parse(plistData: data)
        } catch {
            throw PListError(message: "\(error)", kind: .plistParseError)
        }
    }
    
    func stringify(_ indent: String = "  ") -> String? {
        guard self != .invalid else {
            assert(true, "The PList value is invalid")
            return nil
        }
        return prettyPrint(indent, 0)
    }
    
    public var description: String {
        guard let string = stringify() else {
            return "<INVALID PLIST>"
        }
        return string
    }
    
    private func prettyPrint(_ indent: String, _ level: Int) -> String {
        let currentIndent = (0...level).map({ _ in "" }).joined(separator: indent)
        let nextIndent = currentIndent + "  "
        
        switch self {
        case .bool(let bool):
            return bool ? "true" : "false"
            
        case .number(let number):
            return "\(number)"
            
        case .string(let string):
            return "\"\(string)\""
            
        case .array(let array):
            return "[\n" + array.map { "\(nextIndent)\($0.prettyPrint(indent, level + 1))" }.joined(separator: ",\n") + "\n\(currentIndent)]"
            
        case .object(let dict):
            return "{\n" + dict.map { "\(nextIndent)\"\($0)\" : \($1.prettyPrint(indent, level + 1))"}.joined(separator: ",\n") + "\n\(currentIndent)}"
            
        case .null:
            return "null"
            
        case .invalid:
            assert(true, "This should never be reached")
            return ""
        }
    }
}


extension PList: ExpressibleByStringLiteral,
    ExpressibleByIntegerLiteral,
    ExpressibleByBooleanLiteral,
    ExpressibleByFloatLiteral,
    ExpressibleByArrayLiteral,
    ExpressibleByDictionaryLiteral,
ExpressibleByNilLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        let object = elements.reduce([String: Any]()) { $0 + [$1.0: $1.1] }
        self.init(object)
    }
    
    public init(arrayLiteral elements: AnyObject...) {
        self.init(elements)
    }
    
    public init(nilLiteral: ()) {
        self.init(NSNull())
    }
    
}

private func +(lhs: [String: Any], rhs: [String: Any]) -> [String: Any] {
    var lhs = lhs
    for element in rhs {
        lhs[element.key] = element.value
    }
    return lhs
}

private extension NSNumber {
    
    var isBoolean: Bool {
        return NSNumber(value: true).objCType == self.objCType
    }
}
