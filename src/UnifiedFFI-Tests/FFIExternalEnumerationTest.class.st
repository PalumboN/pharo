"
Tests for external enumerations
"
Class {
	#name : #FFIExternalEnumerationTest,
	#superclass : #TestCase,
	#category : #'UnifiedFFI-Tests-Tests'
}

{ #category : #accessing }
FFIExternalEnumerationTest >> enumClass [
	^ FFITestEnumeration
]

{ #category : #primitives }
FFIExternalEnumerationTest >> ffiTestCall: enumValue format: format to: buffer [
	^ self 
		ffiCall: #( int sprintf ( void* buffer, String format, FFITestEnumeration enumValue ) )
		library: LibC
		fixedArgumentCount: 2
]

{ #category : #primitives }
FFIExternalEnumerationTest >> ffiTestReturn: aNumber format: format to: buffer [
	^ self 
		ffiCall: #( FFITestEnumeration sprintf ( void* buffer, String format, int aNumber ) )
		library: LibC
		fixedArgumentCount: 2
]

{ #category : #tests }
FFIExternalEnumerationTest >> testCall [
	| result buffer |

	self skipOnAppleARM.

	buffer := ByteArray new: 100. 
	result := self ffiTestCall: self enumClass DDD format: '%d' to: buffer.
	self assert: result equals: 4.
	self assert: (buffer first: result) asString equals: '2400'	
]

{ #category : #tests }
FFIExternalEnumerationTest >> testEnumIdents [
	self assert: self enumClass AAA value equals: 1.
	self assert: self enumClass DDD value equals: 2400
]

{ #category : #tests }
FFIExternalEnumerationTest >> testEnumIncludes [
	self assert: (self enumClass includes: #DDD).
	self deny: (self enumClass includes: #EEE)
]

{ #category : #tests }
FFIExternalEnumerationTest >> testFromInteger [
	self assert: (self enumClass fromInteger: 1) value equals: 1.
	self assert: (self enumClass fromInteger: 2) value equals: 2.
	self assert: (self enumClass fromInteger: 3) value equals: 3.
	self assert: (self enumClass fromInteger: 2400) value equals: 2400.
	self should: [ self enumClass fromInteger: 234 ] raise: Error
]

{ #category : #tests }
FFIExternalEnumerationTest >> testNewError [
	self should: [ self enumClass new ] raise: ShouldNotImplement
]

{ #category : #tests }
FFIExternalEnumerationTest >> testReturn [
	| result buffer |

	self skipOnAppleARM.

	buffer := ByteArray new: 100. 
	result := self ffiTestReturn: 123 format: '%d' to: buffer.
	self assert: result equals: self enumClass CCC.
	self assert: (buffer first: result value) asString equals: '123'	
]
