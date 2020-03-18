---
layout: post
title: "Memoir on React.js"
comments: false
description: Learning react
keywords: "notes"
tags:
    - learning
---

---
** **Learning in progress**

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