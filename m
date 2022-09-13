Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E9F5B6FCB
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbiIMORk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbiIMORM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:17:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A035562AAD;
        Tue, 13 Sep 2022 07:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 515F3614C1;
        Tue, 13 Sep 2022 14:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD6DC433C1;
        Tue, 13 Sep 2022 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078340;
        bh=X/uA6NqDIAGlXXCAZHKU2/YGa+tqi88YXHVzDTESRag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGMvEDF4wKmE8NQFUb+WK5z2+7LGpXBy2zyNHL8r2UpCmffIauKzjpp4sl5/yLSZM
         W+YACJdhb7moVEVhQ/hvBZMx7DH4OoSM+6Mmo6QwfAiKElilpKqmpH9FnpRj1A4OjJ
         zGOmVk7hNVqR2jRErZlIZRb8P+mzokWnK89Txnco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 075/192] ARM: dts: imx6qdl-vicut1.dtsi: Fix node name backlight_led
Date:   Tue, 13 Sep 2022 16:03:01 +0200
Message-Id: <20220913140413.703653400@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: David Jander <david@protonic.nl>

[ Upstream commit 83c75e1bc2b83b3f0c718833bde677ebfa736283 ]

This naming error slipped through, so now that a new backlight node has
been added with correct spelling, fix this one also.

Fixes: 98efa526a0c4 ("ARM: dts: imx6qdl-vicut1/vicutgo: Add backlight_led node")
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-vicut1.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-vicut1.dtsi b/arch/arm/boot/dts/imx6qdl-vicut1.dtsi
index a1676b5d2980f..c5a98b0110dd3 100644
--- a/arch/arm/boot/dts/imx6qdl-vicut1.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-vicut1.dtsi
@@ -28,7 +28,7 @@
 		enable-gpios = <&gpio4 28 GPIO_ACTIVE_HIGH>;
 	};
 
-	backlight_led: backlight_led {
+	backlight_led: backlight-led {
 		compatible = "pwm-backlight";
 		pwms = <&pwm3 0 5000000 0>;
 		brightness-levels = <0 16 64 255>;
-- 
2.35.1



