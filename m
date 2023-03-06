Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7302C6ABE2C
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 12:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjCFLbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 06:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCFLbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 06:31:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28A125B8B
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 03:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5CF2B80AD3
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 11:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16696C433D2;
        Mon,  6 Mar 2023 11:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678102270;
        bh=J5xwg5EuSwCw6Cc/Fh8U0EdF1iozZT2v48LJUcUGJcE=;
        h=Subject:To:Cc:From:Date:From;
        b=NbkVaBHozj63JqW3L8NWULx0T4PItVJ1jTn1qXQu+k+H/0XC0KHvAB5cu84deVKPf
         x95h+lskjUAb1vMg6Zj5rqkuysFN1DI35oPLEbJKHVgj0M3acx30bBvKgCb2/gDVbs
         RwImH7KQeJEm0FyQN/VSTzLtmJf+8Lsk7ntBBfpw=
Subject: FAILED: patch "[PATCH] ARM: dts: exynos: correct HDMI phy compatible in Exynos4" failed to apply to 4.14-stable tree
To:     krzysztof.kozlowski@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 12:31:07 +0100
Message-ID: <167810226715267@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x af1c89ddb74f170eccd5a57001d7317560b638ea
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167810226715267@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

af1c89ddb74f ("ARM: dts: exynos: correct HDMI phy compatible in Exynos4")
73a901d09a21 ("ARM: dts: exynos: Add soc node to exynos4")
9097b4bd9fce ("ARM: dts: exynos: Use pmu label in exynos4412")
e030be47ac48 ("ARM: dts: exynos: Use labels instead of full paths in exynos4210")
e58864515240 ("ARM: dts: exynos: Use pinctrl labels in exynos4412-pinctrl")
88c166cec136 ("ARM: dts: exynos: Use pinctrl labels in exynos4210-pinctrl")
3be1ecf291df ("ARM: dts: exynos: Use lower case hex addresses in node unit addresses")
6351fe9375f4 ("ARM: dts: exynos: Add G3D power domain to Exynos5250")
c0d40bb3ac71 ("ARM: dts: exynos: Add audio power domain to Exynos5250")
9fbb4c096323 ("ARM: dts: exynos: Fix power domain node names for Exynos5250")
528832d4c01a ("ARM: dts: exynos: Add audio power domain support to Exynos542x SoCs")
cdd745c8c76b ("ARM: dts: exynos: Remove duplicate definitions of SSS nodes for Exynos5")
78a68acf3d33 ("ARM: dts: exynos: Switch to dedicated Odroid XU3 sound card binding")
061ae5326613 ("Merge tag 'samsung-dt-4.15' of git://git.kernel.org/pub/scm/linux/kernel/git/krzk/linux into next/soc")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From af1c89ddb74f170eccd5a57001d7317560b638ea Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Wed, 25 Jan 2023 10:45:05 +0100
Subject: [PATCH] ARM: dts: exynos: correct HDMI phy compatible in Exynos4

The HDMI phy compatible was missing vendor prefix.

Fixes: ed80d4cab772 ("ARM: dts: add hdmi related nodes for exynos4 SoCs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230125094513.155063-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 55afe9972460..d1adaee2af58 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -605,7 +605,7 @@ i2c_8: i2c@138e0000 {
 			status = "disabled";
 
 			hdmi_i2c_phy: hdmiphy@38 {
-				compatible = "exynos4210-hdmiphy";
+				compatible = "samsung,exynos4210-hdmiphy";
 				reg = <0x38>;
 			};
 		};

