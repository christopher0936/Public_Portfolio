# Chris McLaughlin - V00912353

# Assignment 4
# Do not make changes to this code except where you see comments containing the word TODO.

# Each subclass of GeometryExpression, including subclasses of GeometryValue,
#  needs to respond to messages preprocess_prog and eval_prog.
# Each subclass of GeometryValue additionally needs:
#   * shift
#   * intersect, which uses the double-dispatch pattern
#   * intersectPoint, intersectLine, and intersectVerticalLine for
#       for being called by intersect of appropriate clases and doing
#       the correct intersection calculuation
#   * (We would need intersectNope and intersectLineSegment, but these
#      are provided by GeometryValue and should not be overridden.)
#   *  intersectWithSegmentAsLineResult, which is used by
#      intersectLineSegment as described in the assignment
# You can define other helper methods, but will not find much need to.
# Note: geometry objects should be immutable: assign to fields only during
#       object construction
# Note: For eval_prog, represent environments as arrays of 2-element arrays
#       as described in the assignment

class GeometryExpression
  # do *not* change this class definition
  Epsilon = 0.00001
end

class GeometryValue
  # Do *not* change methods in this class definition; you can add methods if you wish

  private

  # some helper methods that may be generally useful
  def real_close(r1, r2)
    (r1 - r2).abs < GeometryExpression::Epsilon
  end

  def real_close_point(x1, y1, x2, y2)
    real_close(x1, x2) && real_close(y1, y2)
  end

  # two_points_to_line could return a Line or a VerticalLine
  def two_points_to_line(x1, y1, x2, y2)
    if real_close(x1, x2)
      VerticalLine.new x1
    else
      m = (y1 - y2).to_f / (x1 - x2)
      b = y2 - m * x2
      Line.new(m, b)
    end
  end

  public

  # we put this in this class so all subclasses can inherit it:
  # the intersection of self with a Nope is a Nope object
  def intersectNope(np)
    np # could also have Nope.new here instead
  end

  # we put this in this class so all subclasses can inhert it:
  # the intersection of self with a LineSegment is computed by
  # first intersecting with the line containing the segment and then
  # calling the result's intersectWithSegmentAsLineResult with the segment
  def intersectLineSegment(seg)
    line_result = intersect(two_points_to_line(seg.x1, seg.y1, seg.x2, seg.y2))
    line_result.intersectWithSegmentAsLineResult seg
  end

  # MYCODE
  # Every value evals to itself
  def eval_prog(env)
    self
  end

  # Needs overridden for LineSegment but all other values preprocess to themselves
  def preprocess_prog
    self
  end
end

class Nope < GeometryValue
  # Do *not* change this class definition: everything is done for you
  # (although this is the easiest class, it shows what methods every subclass
  # of geometry values needs)

  # Note: no initialize method only because there is nothing it needs to do
  def eval_prog(env)
    self # all values evaluate to self
  end

  def preprocess_prog
    self # no pre-processing to do here
  end

  def shift(dx, dy)
    self # shifting no-points is no-points
  end

  def intersect(other)
    other.intersectNope self # will be Nope but follow double-dispatch
  end

  def intersectPoint(p)
    self # intersection with point and no-points is no-points
  end

  def intersectLine(line)
    self # intersection with line and no-points is no-points
  end

  def intersectVerticalLine(vline)
    self # intersection with line and no-points is no-points
  end

  # if self is the intersection of (1) some shape s and (2)
  # the line containing seg, then we return the intersection of the
  # shape s and the seg.  seg is an instance of LineSegment
  def intersectWithSegmentAsLineResult(seg)
    self
  end
end

class Point < GeometryValue
  # Note: You may want a private helper method like the local helper function inbetween in the ML code
  private
  #let inbetween v end1 end2 =
  #(end1 -. epsilon <= v && v <= end2 +. epsilon) ||
  #(end2 -. epsilon <= v && v <= end1 +. epsilon)
  #in
  def inbetween(v, end1, end2)
    (((end1 - GeometryExpression::Epsilon <= v) and (v <= end2 + GeometryExpression::Epsilon)) or ((end2 - GeometryExpression::Epsilon <= v) and (v <= end1 + GeometryExpression::Epsilon)))
  end
  public

  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  ## TODO: *add* methods to this class -- do *not* change given code and do not override any methods
  def shift(dx, dy)
    Point.new(x+dx, y+dy)
  end

  def intersect(other)
    other.intersectPoint self
  end

  # |Point p1, Point p2 -> if eq_point p1 p2 then v1 else Nope
  def intersectPoint(p)
    if real_close_point(x, y, p.x, p.y)
      self
    else
      Nope.new()
    end
  end

  #| Point (x, y), Line (m, b) ->
  #if eq y ((m *. x) +. b) then v1 else Nope
  def intersectLine(line)
    if real_close(y, ((line.m * x) + line.b))
      self
    else
      Nope.new()
    end
  end

  #| Point (x1, _), VerticalLine x2 -> if eq x1 x2 then v1 else Nope
  def intersectVerticalLine(vline)
    if real_close(x, vline.x)
      self
    else
      Nope.new()
    end
  end

  #| Point (x0, y0) ->
  # (* See if the point is within the segment bounds (assumes v1 was preprocessed) *)
  # let inbetween v end1 end2 =
  #   (end1 -. epsilon <= v && v <= end2 +. epsilon) ||
  #   (end2 -. epsilon <= v && v <= end1 +. epsilon)
  # in
  # let x1, y1, x2, y2 = seg in
  # if inbetween x0 x2 x1 && inbetween y0 y2 y1 then Point (x0, y0)
  # else Nope
  def intersectWithSegmentAsLineResult(lseg)
    if (inbetween(x, lseg.x2, lseg.x1) and inbetween(y, lseg.y2, lseg.y1))
      Point.new(x, y)
    else
      Nope.new()
    end
  end
end

class Line < GeometryValue
  attr_reader :m, :b

  def initialize(m, b)
    @m = m
    @b = b
  end

  ## TODO: *add* methods to this class -- do *not* change given code and do not override any methods
  #|Line (m, b) -> Line (m, b+.dY-.(m*.dX))
  def shift(dx, dy)
    Line.new(m, b + dy - (m * dx))
  end

  def intersect(other)
    other.intersectLine self
  end

  def intersectPoint(p)
    p.intersectLine self
  end

  #| Line (m1, b1), Line (m2, b2) ->
  #    if eq m1 m2 then
  #      if eq b1 b2 then v1 (* same line *) else Nope (* parallel *)
  #    else
  #      (* one-point intersection *)
  #      let x = (b2 -. b1) /. (m1 -. m2) in
  #      let y = (m1 *. x) +. b1 in
  #      Point (x, y)
  def intersectLine(line)
    if real_close(m, line.m)
      if real_close(b, line.b)
        self # same line
      else
        Nope.new() # parallel
      end
    else
      # one point intersection
      x = ((line.b - b) / (m - line.m))
      y = ((m * x) + b)
      Point.new(x, y)
    end
  end

  #| Line (m1, b1), VerticalLine x2 -> Point (x2, (m1 *. x2) +. b1)
  def intersectVerticalLine(vline)
    Point.new(vline.x, (m * vline.x) + b)
  end

  #| Line _ -> v1 (* So segment seg is on line v2 *)
  def intersectWithSegmentAsLineResult(lseg)
    lseg
  end
end

class VerticalLine < GeometryValue
  attr_reader :x

  def initialize(x)
    @x = x
  end

  ## TODO: *add* methods to this class -- do *not* change given code and do not override any methods

  # VerticalLine x -> VerticalLine (x+.dX)
  def shift(dx, dy=nil)
    VerticalLine.new(x+dx)
  end

  def intersect(other)
    other.intersectVerticalLine self
  end

  def intersectPoint(p)
    p.intersectVerticalLine self
  end

  def intersectLine(line)
    line.intersectVerticalLine self
  end

  #| VerticalLine x1, VerticalLine x2 ->
  #if eq x1 x2 then v1 (* same line *) else Nope (* parallel *)
  def intersectVerticalLine(vline)
    if real_close(x, vline.x)
      self
    else
      Nope.new()
    end
  end

  # Same as for line
  def intersectWithSegmentAsLineResult(lseg)
    lseg
  end
end

class LineSegment < GeometryValue
  # Note: This is the most difficult class.
  #       In the sample solution, preprocess_prog is about 15 lines long and
  #       intersectWithSegmentAsLineResult is about 40 lines long
  attr_reader :x1, :y1, :x2, :y2

  def initialize(x1, y1, x2, y2)
    @x1 = x1
    @y1 = y1
    @x2 = x2
    @y2 = y2
  end

  ## TODO: *add* methods to this class -- do *not* change given code and do not override any methods

  # | LineSegment (x1, y1, x2, y2) -> if (eq_point (x1, y1) (x2, y2)) then 
  #   Point (x1, y1)
  # else
  #   if (not(eq x1 x2)) then
  #     if (x2 > x1) then
  #       LineSegment (x2, y2, x1, y1)
  #     else
  #       LineSegment (x1, y1, x2, y2)
  #   else
  #     if (y2 > y1) then
  #       LineSegment (x2, y2, x1, y1)
  #     else
  #       LineSegment (x1, y1, x2, y2)
  def preprocess_prog
    if real_close_point(x1, y1, x2, y2)
      Point.new(x1,y1)
    else
      if not(real_close(x1, x2))
        if x2 > x1
          LineSegment.new(x2, y2, x1, y1)
        else
          self
        end
      else
        if y2 > y1
          LineSegment.new(x2, y2, x1, y1)
        else
          self
        end
      end
    end
  end

  #| LineSegment (x1, y1, x2, y2) -> LineSegment (x1+.dX, y1+.dY, x2+.dX, y2+.dY)
  def shift(dx, dy)
    LineSegment.new(x1+dx,y1+dy,x2+dx,y2+dy)
  end

  def intersect(other)
    other.intersectLineSegment self
  end

  def intersectPoint(p)
    p.intersectLineSegment self
  end

  def intersectLine(line)
    line.intersectLineSegment self
  end

  def intersectVerticalLine(vline)
    vline.intersectLineSegment self
  end

  #   | LineSegment seg2 ->
  #   (* The hard case within the hardest case:
  #     seg and seg2 are on the same line (or vertical line), but they could be
  #      (1) disjoint, or
  #      (2) overlapping, or
  #      (3) one inside the other, or
  #      (4) just touching.
  #     And we treat vertical segments differently, so there are 4*2 cases. *)
  #  let x1end, y1end, x1start, y1start = seg in
  #  let x2end, y2end, x2start, y2start = seg2 in
  #  if eq x1start x1end then
  #    (* The segments are on a vertical line *)
  #    (* Let segment a start at or below start of segment b *)
  #    let (aXend, aYend, aXstart, aYstart), (bXend, bYend, bXstart, bYstart) =
  #      if y1start < y2start then (seg, seg2) else (seg2, seg)
  #    in
  #    if eq aYend bYstart then Point (aXend, aYend) (* just touching *)
  #    else if aYend < bYstart then Nope (* disjoint *)
  #    else if aYend > bYend then LineSegment (bXend, bYend, bXstart, bYstart) (* b inside a *)
  #    else LineSegment (aXend, aYend, bXstart, bYstart) (* overlapping *)
  #  else
  #    (* The segments are on a (non-vertical) line *)
  #    (* Let segment a start at or to the left of start of segment b *)
  #    let (aXend, aYend, aXstart, aYstart), (bXend, bYend, bXstart, bYstart) =
  #      if x1start < x2start then (seg, seg2) else (seg2, seg)
  #    in
  #    if eq aXend bXstart then Point (aXend, aYend) (* just touching *)
  #    else if aXend < bXstart then Nope (* disjoint *)
  #    else if aXend > bXend then LineSegment (bXend, bYend, bXstart, bYstart) (* b inside a *)
  #    else LineSegment (aXend, aYend, bXstart, bYstart) (* overlapping *)
  def intersectWithSegmentAsLineResult(lseg)
    # seg1 = self, seg2 = lseg
    # seg is x1, y1, x2, y2
    # so x1end -> x1; y1end -> y1; x1start -> x2; y1start -> y2
    # and x2end -> lseg.x1; y2end -> lseg.y1; x2start -> lseg.x2; y2start -> lseg.y2;
    if real_close(x2, x1)
      # The segments are on a vertical line
      if y2 < lseg.y2 # Just going to use the same temp variables since this is getting too hard to reason through while porting
        aXend, aYend, aXstart, aYstart, bXend, bYend, bXstart, bYstart = x1, y1, x2, y1, lseg.x1, lseg.y1, lseg.x2, lseg.y2
      else
        aXend, aYend, aXstart, aYstart, bXend, bYend, bXstart, bYstart = lseg.x1, lseg.y1, lseg.x2, lseg.y1, x1, y1, x2, y2
      end
      # Seg A now starts at or below start of seg B
      if real_close(aYend, bYstart)
        Point.new(aXend, aYend) # just touching
      elsif aYend < bYstart
        Nope.new() # disjoint
      elsif aYend > bYend
        LineSegment.new(bXend, bYend, bXstart, bYstart) # b inside a
      else
        LineSegment.new(aXend, aYend, bXstart, bYstart) # overlapping
      end
    else
      # the segments are on a non-vertical line
      if x2 < lseg.x2
        aXend, aYend, aXstart, aYstart, bXend, bYend, bXstart, bYstart = x1, y1, x2, y1, lseg.x1, lseg.y1, lseg.x2, lseg.y2
      else
        aXend, aYend, aXstart, aYstart, bXend, bYend, bXstart, bYstart = lseg.x1, lseg.y1, lseg.x2, lseg.y1, x1, y1, x2, y2
      end
      # Seg A now starts at or the left of start of seg B
      if real_close(aXend, bXstart)
        Point.new(aXend, aYend) # Just touching
      elsif aXend < bXstart
        Nope.new() # disjoint
      elsif aXend > bXend
        LineSegment.new(bXend, bYend, bXstart, bYstart) # b inside a
      else
        LineSegment.new(aXend, aYend, bXstart, bYstart) #overlapping
      end
    end
  end
end

# Note: there is no need for getter methods for the non-value classes

class Intersect < GeometryExpression
  def initialize(e1, e2)
    @e1 = e1
    @e2 = e2
  end

  def preprocess_prog
    Intersect.new(@e1.preprocess_prog, @e2.preprocess_prog)
  end

  def eval_prog(env)
    @e1.eval_prog(env).intersect(@e2.eval_prog(env))
  end
end

class Let < GeometryExpression
  # Note: Look at Var to guide how you implement Let
  def initialize(s, e1, e2)
    @s = s
    @e1 = e1
    @e2 = e2
  end

  def preprocess_prog
    Let.new(@s, @e1.preprocess_prog, @e2.preprocess_prog)
  end

  #| Let (s, e1, e2) -> eval_prog e2 ((s, eval_prog e1 env) :: env)
  def eval_prog(env)
    @e2.eval_prog(Array.new(env).unshift([@s,@e1.eval_prog(env)]))
  end
end

class Var < GeometryExpression
  def initialize(s)
    @s = s
  end

  def preprocess_prog
    self
  end

  def eval_prog(env) # remember: do not change this method
    pr = env.assoc @s
    raise "undefined variable" if pr.nil?
    pr[1]
  end

end

class Shift < GeometryExpression
  def initialize(dx, dy, e)
    @dx = dx
    @dy = dy
    @e = e
  end

  def preprocess_prog
    Shift.new(@dx,@dy,@e.preprocess_prog)
  end

  def eval_prog(env)
    @e.eval_prog(env).shift(@dx,@dy)
  end

  ## TODO: *add* methods to this class -- do *not* change given code and do not override any methods
end