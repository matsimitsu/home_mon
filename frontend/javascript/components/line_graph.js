import React        from 'react';
import ReactDom     from 'react-dom';
import moment       from 'moment';
import d3           from 'd3';

class LineGraph extends React.Component {

  constructor(props) {
    super(props);
    this._handleResize = this._handleResize.bind(this)
    this.state = {width: 0}
  }

  _handleResize() {
    let style = window.getComputedStyle(ReactDom.findDOMNode(this), null)
    let width = parseInt(style.getPropertyValue("width"))
    this.setState({width: width})
  }

  componentDidMount() {
    window.addEventListener('resize', this._handleResize)
    this._handleResize()
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this._handleResize)
  }

  render() {
    let gradientFrom = this.props.gradientFrom || '#bdbdbd'
    let gradientTo   = this.props.gradientTo || '#f0f0f0'
    let className    = this.props.className

    let width  = (this.state.width)|| 0
    let height = this.props.height || 100
    let data   = (this.props.data  || []).map (d => {
      return {
        ts: moment.utc(d.ts, 'YYYY-MM-DD HH:mm:ss').local().toDate(),
        count: d.count
      }
    })
    let from   = d3.min(data, (d) => { return d.ts })
    let to     = d3.max(data, (d) => { return d.ts })
    let top    = d3.max(data, (d) => { return d.count })

    let x   = d3.time.scale.utc().domain([from, to]).range([0, width - 2])
    let y   = d3.scale.linear().domain([0, top]).range([height - 4, 2])

    let line = d3.svg.line()
      .x( (d) => { return x(d.ts) })
      .y( (d) => { return y(d.count) })
      .interpolate('monotone')

    let style     = {width: `${width}px`, height: `${height}px`}
    let pathStyle = {stroke: `url(#${className})`}

    return (
      <div className="mod-line-graph">
        <svg width={width} height={height}>
          <linearGradient
            id={className}
            y1={height}
            y2={0}
            x1={0}
            x2={0}
            gradientUnits="userSpaceOnUse"
          >
            <stop stopColor={gradientFrom} />
            <stop stopColor={gradientTo} offset="100%" />
          </linearGradient>
          <g transform="translate(0,0)">
            <path className="line" d={line(data)} style={pathStyle} />
          </g>
        </svg>
      </div>
    );
  }

}

export default LineGraph;

