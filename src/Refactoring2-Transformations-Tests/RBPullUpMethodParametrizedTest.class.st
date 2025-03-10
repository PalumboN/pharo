Class {
	#name : #RBPullUpMethodParametrizedTest,
	#superclass : #RBAbstractRefactoringTest,
	#category : #'Refactoring2-Transformations-Tests-Parametrized'
}

{ #category : #tests }
RBPullUpMethodParametrizedTest class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase: { #rbClass -> RBPullUpMethodRefactoring };
		addCase: { #rbClass -> RBPullUpMethodTransformation };
		yourself
]

{ #category : #tests }
RBPullUpMethodParametrizedTest >> addClassHierarchy [
	model defineClass: 'Object subclass: #SomeClass 
		instanceVariableNames: '''' 
		classVariableNames: ''Foo'' 
		poolDictionaries: '''' 
		category: #''Refactory-Test data'''.
	model defineClass: 'SomeClass subclass: #Subclass 
		instanceVariableNames: '''' 
		classVariableNames: '''' 
		poolDictionaries: '''' 
		category: #''Refactory-Test data'''.
	model defineClass: 'Subclass subclass: #Foo1 
		instanceVariableNames: '''' 
		classVariableNames: '''' 
		poolDictionaries: '''' 
		category: #''Refactory-Test data'''.
	model defineClass: 'Subclass subclass: #Foo2 
		instanceVariableNames: '''' 
		classVariableNames: '''' 
		poolDictionaries: '''' 
		category: #''Refactory-Test data'''.
]

{ #category : #tests }
RBPullUpMethodParametrizedTest >> addClassHierarchyForPools [
	model defineClass: 'SharedPool subclass: #TotoSharedPool 
		instanceVariableNames: '''' 
		classVariableNames: ''SP'' 
		poolDictionaries: '''' 
		category: #''Refactory-Test data'''.
	model defineClass: 'Object subclass: #TotoSuperclass 
		instanceVariableNames: '''' 
		classVariableNames: '''' 
		poolDictionaries: '''' 
		category: #''Refactory-Test data'''.
	model defineClass: 'TotoSuperclass subclass: #Toto 
		instanceVariableNames: '''' 
		classVariableNames: '''' 
		poolDictionaries: ''TotoSharedPool'' 
		category: #''Refactory-Test data'''.
	
	(model classNamed: #Toto) compile: 'poolReference ^ SP' classified: #(#accessing).
]

{ #category : #accessing }
RBPullUpMethodParametrizedTest >> constructor [ 
	^ #pullUp:from:
]

{ #category : #accessing }
RBPullUpMethodParametrizedTest >> defaultNamespace [
	^RBNamespace
]

{ #category : #'failure tests' }
RBPullUpMethodParametrizedTest >> testDoesntPullUpReferencesInstVar [
	| refactoring class |
	class := model classNamed: ('RBTransformation', 'RuleTestData1') asSymbol.
	refactoring := self createRefactoringWithModel: model 
		andArguments: { #(#foo ) . class }.
	[ self shouldFail: refactoring ] valueSupplyingAnswer: false.
]

{ #category : #tests }
RBPullUpMethodParametrizedTest >> testPullUpAndCopyDown [
	| class |
	self addClassHierarchy.
	class := model classNamed: #Foo1.
	class compile: 'yourself ^1' classified: #(#accessing).
	self proceedThroughWarning: [ 
		self executeRefactoring: (self createRefactoringWithModel: model 
			andArguments: { #(#yourself) . class }) ].
	self assert: (class superclass parseTreeFor: #yourself) 
			equals: (self parseMethod: 'yourself ^1').
	self deny: (class directlyDefinesMethod: #yourself).
	class := model classNamed: #Foo2.
	self assert: (class directlyDefinesMethod: #yourself).
	self assert: (class parseTreeFor: #yourself) 
			equals: ((model classNamed: #Object) parseTreeFor: #yourself)
]

{ #category : #'failure tests' }
RBPullUpMethodParametrizedTest >> testPullUpClassMethod [
	| class |
	class := model classNamed: #Object.
	class addClassVariable: #Foo.
	class classSide 
		compile: 'foo ^Foo'
		classified: #(#accessing ).
	self shouldFail: (self createRefactoringWithModel: model
		andArguments: { #(#foo ) . class classSide })
]

{ #category : #tests }
RBPullUpMethodParametrizedTest >> testPullUpInAHighHierarchyClass [
	| class superClass |
	
	self addClassHierarchy .
	class := model classNamed: #Foo1.
	self addClassHierarchy.
	superClass := model classNamed: #SomeClass .
	class compile: 'example ^1' classified: #(#accessing).
	self executeRefactoring: (rbClass 
				model: model
				pullUp: #(#example)
				from: class 
				to: superClass ).
	self assert: (superClass parseTreeFor: #example) 
				equals: (self parseMethod: 'example ^1').
	self deny: (class directlyDefinesMethod: #example).
	class := model classNamed: #Subclass.
	self assert: (class definesMethod: #example).
	self assert: (class parseTreeFor: #example) 
				equals: ((model classNamed: #SomeClass) parseTreeFor: #example)
]

{ #category : #tests }
RBPullUpMethodParametrizedTest >> testPullUpMethodWithCopyOverriddenMethodsDown [
	| refactoring |
	self proceedThroughWarning: 
		[ refactoring := self createRefactoringWithArguments: 
			{ #(#isComposite ) . RBCompositeLintRuleTestData }.
		self executeRefactoring: refactoring ].
	self assert: ((refactoring model classNamed: #RBBasicLintRuleTestData) 
			parseTreeFor: #isComposite) 
		equals: (self parseMethod: 'isComposite ^false').
	self assert: ((refactoring model classNamed: ('RBFoo' , 'LintRuleTestData') asSymbol) 
			parseTreeFor: #isComposite) 
		equals: (self parseMethod: 'isComposite ^false').
	self assert: ((refactoring model classNamed: #RBLintRuleTestData) 
			parseTreeFor: #isComposite) 
		equals: (self parseMethod: 'isComposite ^true').
	self deny: ((refactoring model classNamed: #RBCompositeLintRuleTestData) 
		directlyDefinesMethod: #isComposite)
]

{ #category : #tests }
RBPullUpMethodParametrizedTest >> testPullUpMethodWithSharedPool [
	| class superClass |
	
	self addClassHierarchyForPools.
	class := model classNamed: #Toto.
	superClass := model classNamed: #TotoSuperclass.
	self proceedThroughWarning: [ 
		self executeRefactoring: (rbClass
			model: model
			pullUp: #(#poolReference)
			from: class 
			to: superClass) ].
	self assert: (superClass parseTreeFor: #poolReference) 
				equals: (self parseMethod: 'poolReference ^ SP').
	self deny: (class directlyDefinesMethod: #poolReference).
]

{ #category : #tests }
RBPullUpMethodParametrizedTest >> testPullUpReferencesInstVar [
	| refactoring class superClass |
	class := model classNamed: ('RBTransformation', 'RuleTestData1') asSymbol.
	refactoring := self createRefactoringWithModel: model
		andArguments: { #(#foo ) . class }.
	[ self executeRefactoring: refactoring ] valueSupplyingAnswer: true.
	superClass := model classNamed: ('RBFooLint', 'RuleTestData1') asSymbol.
	self assert: (superClass parseTreeFor: #foo) 
				equals: (self parseMethod: 'foo ^ foo').
	self assert: (superClass directlyDefinesInstanceVariable: #foo).
	self deny: (class directlyDefinesMethod: #foo).
	self deny: (class directlyDefinesInstanceVariable: #foo).
]

{ #category : #'failure tests' }
RBPullUpMethodParametrizedTest >> testPullUpWhenSuperClassDoesNotDirectlyImplement [
	| classEnvironment classes |
	classes := #(#ClassA #ClassB #ClassC)
		inject: OrderedCollection new
		into: [ :sum :each | 
			testingEnvironment
				at: each
				ifPresent: [ :class | 
					sum
						add: class;
						add: class class ].
			sum ].
	classEnvironment := RBClassEnvironment classes: classes.
	model name: 'Test'.
	"Classes"
	#('Object subclass: #ClassA
		instanceVariableNames: ''''
		classVariableNames: ''''
		poolDictionaries: ''''
		category: ''Testing'' ' 
		
		'ClassA subclass: #ClassB
		instanceVariableNames: ''''
		classVariableNames: ''''
		poolDictionaries: ''''
		category: ''Testing'' ' 
		
		'ClassB subclass: #ClassC
		instanceVariableNames: ''''
		classVariableNames: ''''
		poolDictionaries: ''''
		category: ''Testing'' ') do: [ :each | model defineClass: each ].
	#(#(#ClassA #(#('foo
			^ ''ClassA foo''' #private))) #(#ClassC #(#('foo
			^ ''ClassC foo''' #private))))
		do: [ :each | 
			| class |
			class := model classNamed: each first.
			each last
				do:
					[ :methodPair | class compile: methodPair first classified: methodPair last ] ].
	self shouldntWarn:
			 (self createRefactoringWithModel: model
				andArguments: { #(#foo) . (model classNamed: #ClassC) })
]

{ #category : #'failure tests' }
RBPullUpMethodParametrizedTest >> testPullUpWithInvalidSuperSend [
	| class |
	self addClassHierarchy .
	(model classNamed: #Foo2) compile: 'yourself ^super yourself + 1'
		classified: #(#accessing).
	class := model classNamed: #Foo1.
	class compile: 'yourself ^1' classified: #(#accessing).
	
	self shouldFail: (self createRefactoringWithModel: model 
		andArguments: { #(#yourself) . class })
]

{ #category : #'failure tests' }
RBPullUpMethodParametrizedTest >> testPullUpWithMethodThatCannotBePullUp [
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''' category: #''Refactory-Test data'''.
	(model classNamed: #SomeClass) compile: 'yourself ^54'
		classified: #(#accessing).
	
	self shouldFail: (self createRefactoringWithModel: model
		andArguments: { #(#yourself) . (model classNamed: #SomeClass) })
]

{ #category : #'failure tests' }
RBPullUpMethodParametrizedTest >> testPullUpWithSuperSendThatCannotBeCopiedDown [
	| class |
	self addClassHierarchy.
	(model classNamed: #Object) compile: 'foo ^3' classified: #(#accessing).
	(model classNamed: #Subclass) compile: 'foo ^super foo'
		classified: #(#accessing).
	(class := model classNamed: #Foo2) compile: 'foo ^1'
		classified: #(#accessing).
	
	self shouldFail: (self createRefactoringWithModel: model 
		andArguments: { #(#foo) . class })
]
