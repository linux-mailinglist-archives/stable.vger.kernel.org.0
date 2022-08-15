Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38654594A2E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347265AbiHOXPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244990AbiHOXN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:13:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADEE9C1EA;
        Mon, 15 Aug 2022 13:01:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7572B80EA8;
        Mon, 15 Aug 2022 20:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9D2C433B5;
        Mon, 15 Aug 2022 20:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593672;
        bh=PJE+inI1DtTXcax9IrXNRS5Dqpo+upJVHA2pt0tSuOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cB87dhCrGPHRRoMaJee0Ow1Cirm/HzJGhYBnFkUOVmZGur5Voc+8mb1HYIG/Z3SFt
         lw5zYnqcFW+nPCNGNgbU5VQDSprTvS5gtngK7WbxGbMCSFzofu9EMm/u7gW7S5UADF
         +nvlojG2a7OoMd4Cwhy1aP/4UhjZx8ecEQOHLiB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Maxime Ripard <maxime@cerno.tech>, Peng Fan <peng.fan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Robby Cai <robby.cai@nxp.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0305/1157] dt-bindings: display: bridge: ldb: Fill in reg property
Date:   Mon, 15 Aug 2022 19:54:21 +0200
Message-Id: <20220815180451.855180319@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 16c8d76abe83d75b578d72ee22d25a52c764e14a ]

Add missing reg and reg-names properties for both 'LDB_CTRL'
and 'LVDS_CTRL' registers.

Fixes: 463db5c2ed4ae ("drm: bridge: ldb: Implement simple Freescale i.MX8MP LDB bridge")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Robby Cai <robby.cai@nxp.com>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: devicetree@vger.kernel.org
To: dri-devel@lists.freedesktop.org
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220504012601.423644-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/display/bridge/fsl,ldb.yaml         | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/bridge/fsl,ldb.yaml b/Documentation/devicetree/bindings/display/bridge/fsl,ldb.yaml
index 77f174eee424..2ebaa43eb62e 100644
--- a/Documentation/devicetree/bindings/display/bridge/fsl,ldb.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/fsl,ldb.yaml
@@ -24,6 +24,15 @@ properties:
   clock-names:
     const: ldb
 
+  reg:
+    minItems: 2
+    maxItems: 2
+
+  reg-names:
+    items:
+      - const: ldb
+      - const: lvds
+
   ports:
     $ref: /schemas/graph.yaml#/properties/ports
 
@@ -56,10 +65,15 @@ examples:
     #include <dt-bindings/clock/imx8mp-clock.h>
 
     blk-ctrl {
-        bridge {
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        bridge@5c {
             compatible = "fsl,imx8mp-ldb";
             clocks = <&clk IMX8MP_CLK_MEDIA_LDB>;
             clock-names = "ldb";
+            reg = <0x5c 0x4>, <0x128 0x4>;
+            reg-names = "ldb", "lvds";
 
             ports {
                 #address-cells = <1>;
-- 
2.35.1



