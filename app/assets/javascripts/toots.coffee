$ ->
  instances = $('.instance')
  i = 0
  while i < instances.length

    selectorId = '#instance-' + i.toString(10)

    fetchJson '/api/instance?instance=' + instances.eq(i).data('instance'), selectorId
    i++


fetchJson = (url, selectorId) ->
  d3.json url, (data) ->
    h = 500
    w = 500
    random = d3.random.irwinHall(2)
    countMax = d3.max(data, (d) ->
      d[1]
    )
    sizeScale = d3.scale.linear().domain([
      0
      countMax
    ]).range([
      10
      60
    ])
    colorScale = d3.scale.category20()
    words = data.map((d) ->
      {
        text: d[0]
        size: sizeScale(parseInt(d[1]))
      }
    )

    draw = (words, selectorId) ->
      console.log selectorId
      d3.select(selectorId).attr(
        'width': w
        'height': h
      ).append('g').attr('transform', 'translate(150,150)').selectAll('text').data(words).enter().append('text').style(
        'font-family': 'Impact'
        'font-size': (d) ->
          d.size + 'px'
        'fill': (d, i) ->
          colorScale i
      ).attr(
        'text-anchor': 'middle'
        'transform': (d) ->
          'translate(' + [
            parseInt(d.x)
            parseInt(d.y)
          ] + ')rotate(' + d.rotate + ')'
      ).text (d) ->
        d.text
      return

    d3.layout.cloud().size([
      w
      h
    ]).words(words).rotate(->
      Math.round(1 - random()) * 90
    ).font('Impact').fontSize((d) ->
      d.size
    ).on('end', (d, i) ->
      draw(d, selectorId)
    ).start()

    return