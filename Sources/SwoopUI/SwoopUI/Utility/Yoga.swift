//
//  Yoga.swift
//  Cutlass
//
//  Created by Rocco Bowling on 5/19/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

// swiftlint:disable line_length
// swiftlint:disable identifier_name

import Foundation
import Flynn
import Yoga

public typealias YogaID = UInt64
public typealias Pixel = Float

public class YogaNode {
    private var parent: YogaNode?
    private var node: YGNodeRef

    private var yogaID: YogaID

    private var views: [Viewable] = []
    private var children: [YogaNode] = []

    private var name: String = ""

    private var _usesLeft: Bool = true
    private var _usesTop: Bool = true

    private var _safeTop: Bool = false
    private var _safeLeft: Bool = false
    private var _safeBottom: Bool = false
    private var _safeRight: Bool = false

    public init() {
        node = YGNodeNew()
        yogaID = YGNodeGetID(node)
    }

    public func print() {
        YGNodePrint(node, [.layout, .style, .children])
    }

    public func layout() {
        YGNodeCalculateLayout(node, YGNodeStyleGetWidth(node).value, YGNodeStyleGetHeight(node).value, .LTR)
    }

    // MARK: - Render

    public func render(_ bitmap: Bitmap) {
        recurseRender(0, 0, bitmap)
    }

    private func recurseRender(_ pX: Int, _ pY: Int, _ bitmap: Bitmap) {

        let x = pX + Int(YGNodeLayoutGetLeft(node))
        let y = pY + Int(YGNodeLayoutGetTop(node))
        let w = Int(YGNodeLayoutGetWidth(node))
        let h = Int(YGNodeLayoutGetHeight(node))

        for view in views {
            view.render(bitmap, Rect(x: x, y: y, width: w, height: h))
        }

        for child in children {
            child.recurseRender(x, y, bitmap)
        }
    }

    // MARK: - Yoga Setters

    @discardableResult public func removeAll() -> Self {
        children.removeAll()
        YGNodeRemoveAllChildren(node)
        return self
    }

    @discardableResult func view(_ view: Viewable) -> Self {
        views.append(view)
        return self
    }

    @discardableResult func views(_ view: [Viewable]) -> Self {
        views.append(contentsOf: views)
        return self
    }

    @discardableResult public func child(_ yoga: YogaNode) -> Self {
        children.append(yoga)
        YGNodeInsertChild(node, yoga.node, YGNodeGetChildCount(node))
        return self
    }

    @discardableResult public func children(_ yogas: [YogaNode]) -> Self {
        children.append(contentsOf: yogas)
        for yoga in yogas {
            YGNodeInsertChild(node, yoga.node, YGNodeGetChildCount(node))
        }
        return self
    }

    @discardableResult public func name(_ name: String) -> Self {
        self.name = name
        debugPrint(name)
        return self
    }

    // MARK: - YGNode Setters

    @discardableResult public func fill() -> Self {
        YGNodeStyleSetWidthPercent(node, 100)
        YGNodeStyleSetHeightPercent(node, 100)
        return self
    }

    @discardableResult public func fit() -> Self {
        YGNodeStyleSetWidthAuto(node)
        YGNodeStyleSetHeightAuto(node)
        return self
    }

    @discardableResult public func center() -> Self {
        YGNodeStyleSetJustifyContent(node, .center)
        YGNodeStyleSetAlignItems(node, .center)
        return self
    }

    @discardableResult public func size(_ posX: Pixel, _ posY: Pixel) -> Self {
        YGNodeStyleSetWidth(node, posX)
        YGNodeStyleSetHeight(node, posY)
        return self
    }

    @discardableResult public func size(_ pctX: Percentage, _ pctY: Percentage) -> Self {
        YGNodeStyleSetWidthPercent(node, pctX.value)
        YGNodeStyleSetHeightPercent(node, pctY.value)
        return self
    }

    @discardableResult public func bounds(_ posX: Float, _ posY: Float, _  width: Float, _ height: Float) -> Self {
        YGNodeStyleSetPosition(node, .start, posX)
        YGNodeStyleSetPosition(node, .top, posY)
        YGNodeStyleSetWidth(node, width)
        YGNodeStyleSetHeight(node, height)
        return self
    }

    @discardableResult public func grow(_ vvv: Float = 0.0) -> Self { YGNodeStyleSetFlexGrow(node, vvv); return self }
    @discardableResult public func shrink(_ vvv: Float = 1.0) -> Self { YGNodeStyleSetFlexShrink(node, vvv); return self }

    @discardableResult public func safeTop(_ vvv: Bool=true) -> Self { _safeTop = vvv; return self }
    @discardableResult public func safeLeft(_ vvv: Bool=true) -> Self { _safeLeft = vvv; return self }
    @discardableResult public func safeBottom(_ vvv: Bool=true) -> Self { _safeBottom = vvv; return self }
    @discardableResult public func safeRight(_ vvv: Bool=true) -> Self { _safeRight = vvv; return self }

    @discardableResult public func rows() -> Self { YGNodeStyleSetFlexDirection(node, .row); return self }
    @discardableResult public func columns() -> Self { YGNodeStyleSetFlexDirection(node, .column); return self }

    @discardableResult public func rowsReversed() -> Self { YGNodeStyleSetFlexDirection(node, .rowReverse); return self }
    @discardableResult public func columnsReversed() -> Self { YGNodeStyleSetFlexDirection(node, .columnReverse); return self }

    @discardableResult public func rightToLeft() -> Self { YGNodeStyleSetDirection(node, .RTL); return self }
    @discardableResult public func leftToRight() -> Self { YGNodeStyleSetDirection(node, .LTR); return self }

    @discardableResult public func justifyStart() -> Self { YGNodeStyleSetJustifyContent(node, .flexStart); return self }
    @discardableResult public func justifyCenter() -> Self { YGNodeStyleSetJustifyContent(node, .center); return self }
    @discardableResult public func justifyEnd() -> Self { YGNodeStyleSetJustifyContent(node, .flexEnd); return self }
    @discardableResult public func justifyBetween() -> Self { YGNodeStyleSetJustifyContent(node, .spaceBetween); return self }
    @discardableResult public func justifyAround() -> Self { YGNodeStyleSetJustifyContent(node, .spaceAround); return self }
    @discardableResult public func justifyEvenly() -> Self { YGNodeStyleSetJustifyContent(node, .spaceEvenly); return self }

    @discardableResult public func nowrap() -> Self { YGNodeStyleSetFlexWrap(node, .noWrap); return self }
    @discardableResult public func wrap() -> Self { YGNodeStyleSetFlexWrap(node, .wrap); return self }

    @discardableResult public func itemsAuto() -> Self { YGNodeStyleSetAlignItems(node, .auto); return self }
    @discardableResult public func itemsStart() -> Self { YGNodeStyleSetAlignItems(node, .flexStart); return self }
    @discardableResult public func itemsCenter() -> Self { YGNodeStyleSetAlignItems(node, .center); return self }
    @discardableResult public func itemsEnd() -> Self { YGNodeStyleSetAlignItems(node, .flexEnd); return self }
    @discardableResult public func itemsBetween() -> Self { YGNodeStyleSetAlignItems(node, .spaceBetween); return self }
    @discardableResult public func itemsAround() -> Self { YGNodeStyleSetAlignItems(node, .spaceAround); return self }
    @discardableResult public func itemsBaseline() -> Self { YGNodeStyleSetAlignItems(node, .baseline); return self }
    @discardableResult public func itemsStretch() -> Self { YGNodeStyleSetAlignItems(node, .stretch); return self }

    @discardableResult public func selfAuto() -> Self { YGNodeStyleSetAlignSelf(node, .auto); return self }
    @discardableResult public func selfStart() -> Self { YGNodeStyleSetAlignSelf(node, .flexStart); return self }
    @discardableResult public func selfCenter() -> Self { YGNodeStyleSetAlignSelf(node, .center); return self }
    @discardableResult public func selfEnd() -> Self { YGNodeStyleSetAlignSelf(node, .flexEnd); return self }
    @discardableResult public func selfBetween() -> Self { YGNodeStyleSetAlignSelf(node, .spaceBetween); return self }
    @discardableResult public func selfAround() -> Self { YGNodeStyleSetAlignSelf(node, .spaceAround); return self }
    @discardableResult public func selfBaseline() -> Self { YGNodeStyleSetAlignSelf(node, .baseline); return self }
    @discardableResult public func selfStretch() -> Self { YGNodeStyleSetAlignSelf(node, .stretch); return self }

    @discardableResult public func absolute() -> Self { YGNodeStyleSetPositionType(node, .absolute); return self }
    @discardableResult public func relative() -> Self { YGNodeStyleSetPositionType(node, .relative); return self }

    @discardableResult public func origin(_ posX: Pixel, _ posY: Pixel) -> Self { YGNodeStyleSetPosition(node, .left, posX); YGNodeStyleSetPosition(node, .top, posY); _usesLeft = true; _usesTop = true; return self }
    @discardableResult public func origin(_ pctX: Percentage, _ pctY: Percentage) -> Self { YGNodeStyleSetPositionPercent(node, .left, pctX.value); YGNodeStyleSetPositionPercent(node, .top, pctY.value); _usesLeft = true; _usesTop = true; return self }

    @discardableResult public func top(_ pixel: Pixel) -> Self { YGNodeStyleSetPosition(node, .top, pixel); _usesTop = true; return self }
    @discardableResult public func left(_ pixel: Pixel) -> Self { YGNodeStyleSetPosition(node, .left, pixel); _usesLeft = true; return self }
    @discardableResult public func bottom(_ pixel: Pixel) -> Self { YGNodeStyleSetPosition(node, .bottom, pixel); _usesTop = false; return self }
    @discardableResult public func right(_ pixel: Pixel) -> Self { YGNodeStyleSetPosition(node, .right, pixel); _usesLeft = false; return self }

    @discardableResult public func top(_ percent: Percentage) -> Self { YGNodeStyleSetPositionPercent(node, .top, percent.value); _usesTop = true; return self }
    @discardableResult public func left(_ percent: Percentage) -> Self { YGNodeStyleSetPositionPercent(node, .left, percent.value); _usesLeft = true; return self }
    @discardableResult public func bottom(_ percent: Percentage) -> Self { YGNodeStyleSetPositionPercent(node, .bottom, percent.value); _usesTop = false; return self }
    @discardableResult public func right(_ percent: Percentage) -> Self { YGNodeStyleSetPositionPercent(node, .right, percent.value); _usesLeft = false; return self }

    @discardableResult public func paddingAll(_ pixel: Pixel) -> Self { YGNodeStyleSetPadding(node, .all, pixel); return self }
    @discardableResult public func paddingTop(_ pixel: Pixel) -> Self { YGNodeStyleSetPadding(node, .top, pixel); return self }
    @discardableResult public func paddingLeft(_ pixel: Pixel) -> Self { YGNodeStyleSetPadding(node, .left, pixel); return self }
    @discardableResult public func paddingBottom(_ pixel: Pixel) -> Self { YGNodeStyleSetPadding(node, .bottom, pixel); return self }
    @discardableResult public func paddingRight(_ pixel: Pixel) -> Self { YGNodeStyleSetPadding(node, .right, pixel); return self }

    @discardableResult public func paddingAll(_ percent: Percentage) -> Self { YGNodeStyleSetPaddingPercent(node, .all, percent.value); return self }
    @discardableResult public func paddingTop(_ percent: Percentage) -> Self { YGNodeStyleSetPaddingPercent(node, .top, percent.value); return self }
    @discardableResult public func paddingLeft(_ percent: Percentage) -> Self { YGNodeStyleSetPaddingPercent(node, .left, percent.value); return self }
    @discardableResult public func paddingBottom(_ percent: Percentage) -> Self { YGNodeStyleSetPaddingPercent(node, .bottom, percent.value); return self }
    @discardableResult public func paddingRight(_ percent: Percentage) -> Self { YGNodeStyleSetPaddingPercent(node, .right, percent.value); return self }

    @discardableResult public func marginAll(_ pixel: Pixel) -> Self { YGNodeStyleSetMargin(node, .all, pixel); return self }
    @discardableResult public func marginTop(_ pixel: Pixel) -> Self { YGNodeStyleSetMargin(node, .top, pixel); return self }
    @discardableResult public func marginLeft(_ pixel: Pixel) -> Self { YGNodeStyleSetMargin(node, .left, pixel); return self }
    @discardableResult public func marginBottom(_ pixel: Pixel) -> Self { YGNodeStyleSetMargin(node, .bottom, pixel); return self }
    @discardableResult public func marginRight(_ pixel: Pixel) -> Self { YGNodeStyleSetMargin(node, .right, pixel); return self }

    @discardableResult public func marginAll(_ percent: Percentage) -> Self { YGNodeStyleSetMarginPercent(node, .all, percent.value); return self }
    @discardableResult public func marginTop(_ percent: Percentage) -> Self { YGNodeStyleSetMarginPercent(node, .top, percent.value); return self }
    @discardableResult public func marginLeft(_ percent: Percentage) -> Self { YGNodeStyleSetMarginPercent(node, .left, percent.value); return self }
    @discardableResult public func marginBottom(_ percent: Percentage) -> Self { YGNodeStyleSetMarginPercent(node, .bottom, percent.value); return self }
    @discardableResult public func marginRight(_ percent: Percentage) -> Self { YGNodeStyleSetMarginPercent(node, .right, percent.value); return self }

    // These are direct calls to the Yoga methods (most of which require parameters)

    @discardableResult public func direction(_ vvv: YGDirection) -> Self { YGNodeStyleSetDirection(node, vvv); return self }
    @discardableResult public func flexDirection(_ vvv: YGFlexDirection) -> Self { YGNodeStyleSetFlexDirection(node, vvv); return self }

    @discardableResult public func justifyContent(_ vvv: YGJustify) -> Self { YGNodeStyleSetJustifyContent(node, vvv); return self }

    @discardableResult public func alignContent(_ vvv: YGAlign) -> Self { YGNodeStyleSetAlignContent(node, vvv); return self }
    @discardableResult public func alignItems(_ vvv: YGAlign) -> Self { YGNodeStyleSetAlignItems(node, vvv); return self }
    @discardableResult public func alignSelf(_ vvv: YGAlign) -> Self { YGNodeStyleSetAlignSelf(node, vvv); return self }

    @discardableResult public func positionType(_ vvv: YGPositionType) -> Self { YGNodeStyleSetPositionType(node, vvv); return self }

    @discardableResult public func overflow(_ vvv: YGOverflow) -> Self { YGNodeStyleSetOverflow(node, vvv); return self }
    @discardableResult public func display(_ vvv: YGDisplay) -> Self { YGNodeStyleSetDisplay(node, vvv); return self }

    @discardableResult public func flexWrap(_ vvv: YGWrap) -> Self { YGNodeStyleSetFlexWrap(node, vvv); return self }
    @discardableResult public func flex(_ vvv: Float) -> Self { YGNodeStyleSetFlex(node, vvv); return self }
    @discardableResult public func flexGrow(_ vvv: Float) -> Self { YGNodeStyleSetFlexGrow(node, vvv); return self }
    @discardableResult public func flexShrink(_ vvv: Float) -> Self { YGNodeStyleSetFlexShrink(node, vvv); return self }
    @discardableResult public func flexAuto() -> Self { YGNodeStyleSetFlexBasisAuto(node); return self }

    @discardableResult public func flexBasis(_ pixel: Pixel) -> Self { YGNodeStyleSetFlexBasis(node, pixel); return self }
    @discardableResult public func flexBasis(_ percent: Percentage) -> Self { YGNodeStyleSetFlexBasisPercent(node, percent.value); return self }

    @discardableResult public func position(edge: YGEdge, _ pixel: Pixel) -> Self { YGNodeStyleSetPosition(node, edge, pixel); return self }
    @discardableResult public func position(edge: YGEdge, _ percent: Percentage) -> Self { YGNodeStyleSetPositionPercent(node, edge, percent.value); return self }

    @discardableResult public func margin(edge: YGEdge, _ pixel: Pixel) -> Self { YGNodeStyleSetMargin(node, edge, pixel); return self }
    @discardableResult public func margin(edge: YGEdge, _ percent: Percentage) -> Self { YGNodeStyleSetMarginPercent(node, edge, percent.value); return self }
    @discardableResult public func marginAuto(edge: YGEdge) -> Self { YGNodeStyleSetMarginAuto(node, edge); return self }

    @discardableResult public func padding(edge: YGEdge, _ pixel: Pixel) -> Self { YGNodeStyleSetPadding(node, edge, pixel); return self }
    @discardableResult public func padding(edge: YGEdge, _ percent: Percentage) -> Self { YGNodeStyleSetPaddingPercent(node, edge, percent.value); return self }

    @discardableResult public func border(edge: YGEdge, pixel: Pixel) -> Self { YGNodeStyleSetBorder(node, edge, pixel); return self }

    @discardableResult public func width(_ pixel: Pixel) -> Self { YGNodeStyleSetWidth(node, pixel); return self }
    @discardableResult public func width(_ percent: Percentage) -> Self { YGNodeStyleSetWidthPercent(node, percent.value); return self }
    @discardableResult public func widthAuto() -> Self { YGNodeStyleSetWidthAuto(node); return self }

    @discardableResult public func height(_ pixel: Pixel) -> Self { YGNodeStyleSetHeight(node, pixel); return self }
    @discardableResult public func height(_ percent: Percentage) -> Self { YGNodeStyleSetHeightPercent(node, percent.value); return self }
    @discardableResult public func heightAuto() -> Self { YGNodeStyleSetHeightAuto(node); return self }

    @discardableResult public func minWidth(_ pixel: Pixel) -> Self { YGNodeStyleSetMinWidth(node, pixel); return self }
    @discardableResult public func minWidth(_ percent: Percentage) -> Self { YGNodeStyleSetMinWidthPercent(node, percent.value); return self }

    @discardableResult public func minHeight(_ pixel: Pixel) -> Self { YGNodeStyleSetMinHeight(node, pixel); return self }
    @discardableResult public func minHeight(_ percent: Percentage) -> Self { YGNodeStyleSetMinHeightPercent(node, percent.value); return self }

    @discardableResult public func maxWidth(_ pixel: Pixel) -> Self { YGNodeStyleSetMaxWidth(node, pixel); return self }
    @discardableResult public func maxWidth(_ percent: Percentage) -> Self { YGNodeStyleSetMaxWidthPercent(node, percent.value); return self }

    @discardableResult public func maxHeight(_ pixel: Pixel) -> Self { YGNodeStyleSetMaxHeight(node, pixel); return self }
    @discardableResult public func maxHeight(_ percent: Percentage) -> Self { YGNodeStyleSetMaxHeightPercent(node, percent.value); return self }

    @discardableResult public func aspectRatio(ratio: Float) -> Self { YGNodeStyleSetAspectRatio(node, ratio); return self }

    func getWidth() -> Float { return YGNodeLayoutGetWidth(node); }
    func getHeight() -> Float { return YGNodeLayoutGetHeight(node); }
}
