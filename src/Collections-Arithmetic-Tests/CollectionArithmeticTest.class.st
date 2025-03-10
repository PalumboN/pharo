"
Unit tests for collection arithmetic
"
Class {
	#name : #CollectionArithmeticTest,
	#superclass : #TestCase,
	#category : #'Collections-Arithmetic-Tests'
}

{ #category : #tests }
CollectionArithmeticTest >> testAdd [
	| collection |
	collection := #(1 2 3).
	self assert: collection + 1 equals: #(2 3 4).
	self assert: 1 + collection  equals: #(2 3 4)
]

{ #category : #tests }
CollectionArithmeticTest >> testAverage [
	| collection |
	collection := #(1 2 3).
	self assert: collection average equals: 2
]

{ #category : #tests }
CollectionArithmeticTest >> testAverageIfEmpty [
	| collection |
	collection := #(1 2 3 4).
	self assert: (collection averageIfEmpty: [ 0 ]) equals: 2.5
]

{ #category : #tests }
CollectionArithmeticTest >> testAverageIfEmptyWithEmptyArray [
	self assert: (#() averageIfEmpty: [ 0 ]) equals: 0
]

{ #category : #tests }
CollectionArithmeticTest >> testAverageIfEmptyWithEmptyCollection [
	self should: [#() averageIfEmpty: [ CollectionIsEmpty signal: 'Collection empty' ]] raise: CollectionIsEmpty
]

{ #category : #tests }
CollectionArithmeticTest >> testAverageWithEmptyArray [
	self should: [ #() average ] raise: CollectionIsEmpty
]

{ #category : #tests }
CollectionArithmeticTest >> testAverageWithEmptyArrayShouldRaiseExecption [
	self should: [ #() average ] raise: CollectionIsEmpty
]

{ #category : #tests }
CollectionArithmeticTest >> testAverageWithEmptyDictionary [
	self should: [ Dictionary new average ] raise: CollectionIsEmpty
]

{ #category : #tests }
CollectionArithmeticTest >> testAverageWithEmptyOrderedCollection [
	self should: [ OrderedCollection new average ] raise: CollectionIsEmpty
]

{ #category : #tests }
CollectionArithmeticTest >> testAverageWithEmptySet [
	self should: [ Set new average ] raise: CollectionIsEmpty
]

{ #category : #tests }
CollectionArithmeticTest >> testDevision [
	| collection |
	collection := #(2 4).
	self assert: collection / 2 equals: #(1 2).
	self assert: 10 / #(20) equals: {1/2}
]

{ #category : #tests }
CollectionArithmeticTest >> testRunningAverage [
	| result collection |
	collection := #(1 1 2 2 3 3).
	result := collection runningAverage: 2. 

	self assert: result equals: {1 . (3/2) . 2 . (5/2) . 3}.
]

{ #category : #tests }
CollectionArithmeticTest >> testRunningAverageSubscriptOutOfBounds [
	| collection |
	collection := #(1 1 2 2 3 3).

	self should: [ collection runningAverage: 7 ] raise: SubscriptOutOfBounds.
	self  should: [ collection runningAverage: -2 ] raise: SubscriptOutOfBounds.
]

{ #category : #tests }
CollectionArithmeticTest >> testRunningAverageWithFullSubsetSizeIsSameAsAverage [
	| collection |
	collection := #(1 1 2 2 3 3).
	
	self
		assert: (collection runningAverage: collection size) 
		equals: { collection average }.
]

{ #category : #tests }
CollectionArithmeticTest >> testRunningAverageWithSubsetSize1IsSameAsCollection [
	| collection |
	collection := #(1 1 2 2 3 3).
	
	self
		assert: (collection runningAverage: 1) 
		equals: collection.
]

{ #category : #tests }
CollectionArithmeticTest >> testRunningMax [
	| result collection |
	collection := #(1 1 2 2 3 3).
	result := collection runningMax: 3. 

	self assert: result equals: {2 . 2 . 3 . 3}.
]

{ #category : #tests }
CollectionArithmeticTest >> testRunningMin [
	| result collection |
	collection := #(1 1 2 2 3 3).
	result := collection runningMin: 3. 

	self assert: result equals: {1 . 1 . 2 . 2}.
]

{ #category : #tests }
CollectionArithmeticTest >> testSumWithDoubles [
	| collection sum |
	collection := #(33.33d0 33.33d0 33.34d0).
	sum := collection sum: [:e | e yourself].
	self assert: sum equals: 33.33d0 + 33.33d0 + 33.34d0.
	self assert: sum equals: 100d0
]
