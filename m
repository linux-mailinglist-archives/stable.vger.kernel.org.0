Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E046799B6
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjAXNlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbjAXNlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:41:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36A43754D;
        Tue, 24 Jan 2023 05:41:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B8E9B811D3;
        Tue, 24 Jan 2023 13:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8291C433EF;
        Tue, 24 Jan 2023 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567694;
        bh=WxcJGs9JmjBIz7MtnQGfiAVBOir7rh3JhjDNt+dDZOk=;
        h=From:To:Cc:Subject:Date:From;
        b=rvAfeWZK/CWUZTEYI2tElEbrhO3yRvn3ugE5VoYTMkjCnA3fTpf2jc2UGsmfFGZ22
         NNX3ppFyTglQg0LZ/zx9IlX3l6ui0+FThUdzqJq1mGtKhat/71p00unbQYTOiRq25O
         pMLNl2ZOhCq4W7O0Yk1FzyGUSpT/bfs+45j6WdVBv2cJbtGKSqD9YXwqU7cKzQPpKn
         v9eYPk9vYGSdN3Ld4nWm3Zve37Vd4PNxqvc0tiFMbD73WAJ/hCVJPr46VZNdxUvjpP
         NxXIRs/O2/CFm13lTVE1GzTlWXZ273M4nrrXm1NmBwEIaBULL4CKqR6HAd6MjqqhwL
         cPrAPPJvaitRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 01/35] ARM: dts: imx: Fix pca9547 i2c-mux node name
Date:   Tue, 24 Jan 2023 08:40:57 -0500
Message-Id: <20230124134131.637036-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f78985f9f58380eec37f82c8a2c765aa7670fc29 ]

"make dtbs_check":

    arch/arm/boot/dts/imx53-ppd.dtb: i2c-switch@70: $nodename:0: 'i2c-switch@70' does not match '^(i2c-?)?mux'
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml
    arch/arm/boot/dts/imx53-ppd.dtb: i2c-switch@70: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'i2c@0', 'i2c@1', 'i2c@2', 'i2c@3', 'i2c@4', 'i2c@5', 'i2c@6', 'i2c@7' were unexpected)
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml

Fix this by renaming the PCA9547 node to "i2c-mux", to match the I2C bus
multiplexer/switch DT bindings and the Generic Names Recommendation in
the Devicetree Specification.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-ppd.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53-ppd.dts b/arch/arm/boot/dts/imx53-ppd.dts
index 37d0cffea99c..70c4a4852256 100644
--- a/arch/arm/boot/dts/imx53-ppd.dts
+++ b/arch/arm/boot/dts/imx53-ppd.dts
@@ -488,7 +488,7 @@ &i2c1 {
 	scl-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 
-	i2c-switch@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9547";
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.39.0

