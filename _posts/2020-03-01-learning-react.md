---
layout: post
title: "Memoir on React.js"
comments: false
description: Learning react
keywords: "notes"
tags:
    - learning
---


Whenever I wanted to write an application, the best I would do was write vanilla javascript and would try to make it minimal as possible, I would handle all my user interactions by googling for js snippets and carefully attaching them in `<script>` so that
everything works but I have been trying to work with kepler.gl for sometime now and since it is written in react it was hard for me to understand a lot of it, also I hear whispers of react's awesomeness a lot on the internet.

I am gonna start learning react and am gonna try my best to document it here so that it is easy to come back here for reference 

After spending sometime installing node and all the modules, I came across something called the Virtual DOM. There is an awesome video on youtube explaning all about it <https://www.youtube.com/watch?v=d7pyEDqBDeE> So basically react has a virtual DOM stored in memory which is synced with the actual DOM with a libray called ReactDOM. This syncing is called reconciliation which runs a diff algorithm between the real and vitual DOM, More explanation <https://reactjs.org/docs/reconciliation.html>

So I created by first react app with `npx create-react-app my-app` There was a public folder with all the html and static files, I changed the src and added two files 

index.js 

```jsx
import React from 'react';
import ReactDOM from 'react-dom';

ReactDOM.render(<h1> Hello World ! </h1>, document.getElementById('root'));
```

To render a React element into a root DOM node, we can use ReactDOM.render():

index.html

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Test</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
```

Running `npm start` would render a simple Hello World !

Alright, customary hello world ✔️

---

Moving onto **JSX** 

JSX is a syntax extension to JavaScript, it enables you to create variables like this 

```jsx
const object = "World"
const element = <h1>Hello, {object}</h1>;
ReactDOM.render(
  element,
  document.getElementById('root')
);
```

You can also write custom functions

```jsx
function getSquare(num) {
        return num**2
}
const num = 10
const element = (
        <h1> Square of number {num} is {getSquare(num)} </h1>
);
ReactDOM.render(element, document.getElementById('root'));
```

More on <https://reactjs.org/docs/introducing-jsx.html> ✔️

---

**Elements** 

Elements are the smallest building blocks of React apps and it describes what you want to see on the screen, They are **Immutable**

We can update the UI by creating a new element and passing it to ReactDOM.render().

More on <https://reactjs.org/docs/rendering-elements.html> ✔️

```jsx
function tick() {
  const element = (
    <div>
      <h1>Hello, world!</h1>
      <h2>It is {new Date().toLocaleTimeString()}.</h2>
    </div>
  );
  ReactDOM.render(element, document.getElementById('root'));
}
setInterval(tick, 1000);
```

To display the current time, we use a function that fetches the time and use setInterval() method that calls a function or evaluates an expression at specified intervals, here it does it every 1 second so we see the clock ticking every second

### React Only Updates What’s Necessary

React DOM compares the element and its children to the previous one, and only applies the DOM updates necessary to bring the DOM to the desired state. (based on the diff algorithm we discussed) here react changes only the current time

---

**Components and Props** 

Components let you split the UI into independent, reusable pieces, and think about each piece in isolation. They accept arbitrary inputs (called “props” or properties) and return React elements describing what should appear on the screen

Seems like I can use define a simple function or an ES6 class to define a component

Props can be passed to components like function arguments. They stands for properties and is being used for passing data from one component to another. props data is read-only, which means that data coming from the parent should not be changed by child components and also data can flow only from parent to child

```jsx
extends React.Component {
  render() {
    return <h2>I like {this.props.language} cause I heard someone talking about it on twitter!</h2>
  }
}
const mylanguage = <Language language="Rust" />;
ReactDOM.render(mylanguage, document.getElementById('root'));
```

Components can refer to other components in their output. This lets us use the same component abstraction for any level of detail. A button, a form, a dialog, a screen: in React apps, all those are commonly expressed as components.

For example, we can create an App component that renders language:


```jsx
function Language(props) {
  return <h1>Man ! {props.language} sucks</h1>;
}
function App() {
  return(
  <div>
    <Language language="Javascript" />
    <Language language="Javascript" />
    <Language language="Still Javascript" />
  </div>
  );
}
ReactDOM.render(<App />, document.getElementById('root'));
```

#### Whether you declare a component as a function or a class, it must never modify its own props.

#### All React components must act like pure functions with respect to their props.

But application UIs are dynamic and change over time. That is where states come in. State allows React components to change their output over time in response to user actions, network responses, and anything else, without violating this rule.

**State is similar to props, but it is private and fully controlled by the component**

We need to convert a function into a class, let's do it for Language

- We replace this.props.language to this.state.language
- Add a class constructor that assigns the initial this state
- Pass props to the base constructor


```jsx
class Language extends React.Component {
  constructor(props) {
    super(props);
    this.state = {"language": "javascript"};
  }
  render() {
    return (
      <div>
        <h1>I hate {this.state.language} </h1>
      </div>
    );
  }
}

ReactDOM.render(
  <Language />,
  document.getElementById('root')
);
``` 
You can change the state by using `setState`

```jsx
  switchSides = () => {
    this.setState({language: "myself"});
  }

  render() {
    return (
      <div>
        <h1>I hate {this.state.language}</h1>
        <button
          type="button"
          onClick={this.switchSides}
        >Change color</button>
      </div>
    );
  }
}
```

When a value in the state object changes, the component will re-render, meaning that the output will change according to the new value.

More on <https://reactjs.org/docs/react-component.html>

- States should only be updated using setState() and not like this.state.language (this will not rerender)
- Updates to state can be async so updates to setState() can be batched so don't rely on this.state or this.props 

so instead of accepting an object we accept a function, like

```jsx
this.setState(function(state, props) {
  return {
    counter: state.counter + props.increment
  };
});
```

Another cool thing about states is its “top-down” or “unidirectional” data flow. Any state is always owned by some specific component, and any data or UI derived from that state can only affect components “below” them in the tree.


**Events** 

react events are in camelCase and look something like this

```jsx
function ActionLink() {
  function handleClick(e) {
    e.preventDefault();
    console.log('The link was clicked.');
  }

  return (
    <a href="#" onClick={handleClick}>
      Click me
    </a>
  );
}
```

Here, e is a synthetic event and also you generally don’t need to call addEventListener to add listeners to a DOM element after it is created. Instead, just provide a listener when the element is initially rendered.

More on <https://reactjs.org/docs/handling-events.html>

Another cool thing I found on the docs was Containment, this is in cases when components don’t know their children ahead of time and since react elements like <Contacts /> and <Chat /> are just objects, so you can pass them as props like any other data.

```jsx
function Contacts() {
  return <div className="Contacts" />;
}

function Chat() {
  return <div className="Chat" />;
}

function SplitPane(props) {
  return (
    <div className="SplitPane">
      <div className="SplitPane-left">
        {props.left}
      </div>
      <div className="SplitPane-right">
        {props.right}
      </div>
    </div>
  );
}

function App() {
  return (
    <SplitPane
      left={
        <Contacts />
      }
      right={
        <Chat />
      } />
  );
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

In React, this is also achieved by composition, where a more “specific” component renders a more “generic” one and configures it with props:

```jsx
function Dialog(props) {
  return (
    <FancyBorder color="blue">
      <h1 className="Dialog-title">
        {props.title}
      </h1>
      <p className="Dialog-message">
        {props.message}
      </p>
    </FancyBorder>
  );
}

function WelcomeDialog() {
  return (
    <Dialog
      title="Welcome"
      message="Thank you for visiting our spacecraft!" />
  );
}
```

All this can also be done for components defined as classes

```jsx
function Dialog(props) {
  return (
    <FancyBorder color="blue">
      <h1 className="Dialog-title">
        {props.title}
      </h1>
      <p className="Dialog-message">
        {props.message}
      </p>
      {props.children}
    </FancyBorder>
  );
}

class SignUpDialog extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.handleSignUp = this.handleSignUp.bind(this);
    this.state = {login: ''};
  }

  render() {
    return (
      <Dialog title="Mars Exploration Program"
              message="How should we refer to you?">
        <input value={this.state.login}
               onChange={this.handleChange} />
        <button onClick={this.handleSignUp}>
          Sign Me Up!
        </button>
      </Dialog>
    );
  }

  handleChange(e) {
    this.setState({login: e.target.value});
  }

  handleSignUp() {
    alert(`Welcome aboard, ${this.state.login}!`);
  }
}
```

React docs are pretty neat, but the best part was <https://reactjs.org/docs/thinking-in-react.html> where we go through the process of building stuff out

Some notes from it 


- When designing components remember that a component should ideally only do one thing. If it ends up growing, it should be decomposed into smaller subcomponents

- Drawing out component can be intuitive in figuring out what are the child and parent components

- Build a static version (cause interactivity needs more thinking and less writing). Build components that reuse other components and pass data using props but no states cause its static

State vs Props 

props (short for “properties”) and state are both plain JavaScript objects. While both hold information that influences the output of render, they are different in one important way: props get passed to the component (similar to function parameters) whereas state is managed within the component (similar to variables declared within a function).

- React is all about one-way data flow down the component hierarchy. It is important to understand which component should own what state

- Use the common parent component to hold states or create a component to hold states and add it somewhere in the hierarchy above the common owner component 

- Inverse data flow where we pass altered state due to user input is through callbacks which calls setState()

Done with the doc and onward we go 

:wq ciao
