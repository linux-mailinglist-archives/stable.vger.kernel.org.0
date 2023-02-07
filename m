Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E684568D75D
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjBGM7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjBGM7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A397EE4
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D470613EA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F034C433D2;
        Tue,  7 Feb 2023 12:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774744;
        bh=dCoBYjpxtCIQuvMBOX58QUxAXYRwvFahDHUMUiem8tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sv8CmS4jE4f1R2a/s0VWzlbklObjJNobtE9+AWFp/XnCqbmrVzYD5eISlRO/6roed
         Fpdcqndg6DifM+U3pkQKMlIeYmkYvxNKm9XV8dDheego+xC8EG07OtOwOTX49eyX3D
         A545mexj7tDul1suwU2JVzoKGeIHytYEtvm2AyoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frank Li <Frank.Li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/208] arm64: dts: freescale: imx8dxl: fix sc_pwrkeys property name linux,keycode
Date:   Tue,  7 Feb 2023 13:54:18 +0100
Message-Id: <20230207125634.524261181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit cfb47bf5a470bdd80e8ac2f7b2f3a34563ecd4ea ]

linux,keycode should be "linux,keycodes" according binding-doc
Documentation/devicetree/bindings/input/fsl,scu-key.yaml

Fixes: f537ee7f1e76 ("arm64: dts: freescale: add i.MX8DXL SoC support")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
index 5ddbda0b4def..f2c4d13b2f3c 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
@@ -157,7 +157,7 @@
 
 		sc_pwrkey: keys {
 			compatible = "fsl,imx8qxp-sc-key", "fsl,imx-sc-key";
-			linux,keycode = <KEY_POWER>;
+			linux,keycodes = <KEY_POWER>;
 			wakeup-source;
 		};
 
-- 
2.39.0



