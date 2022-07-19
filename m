Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4620C579D61
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241917AbiGSMu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242244AbiGSMt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:49:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8CB57258;
        Tue, 19 Jul 2022 05:19:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 638F9B81B2D;
        Tue, 19 Jul 2022 12:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB51C341C6;
        Tue, 19 Jul 2022 12:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233188;
        bh=8HMYi2EllsBRqBevCrSHuIbvxXPKyVJozZ70rU+aggg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyQIA/tDZRxACrlt7fNh+PMuzbfvFhOW4KJyGICzMHnfKzaauaJhUCMCLUI0+uyJt
         DHwkPcDgz6vos1UC/ZfyZPQijQH/0UaLX41Hp58nmpwha7LEtEZlFCuL8gU42xU+Wc
         U9gVkB/tApm5iKBFD8CfRFVl9u9chF4hTkMV9g0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kris Bahnsen <kris@embeddedTS.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 037/231] ARM: dts: imx6qdl-ts7970: Fix ngpio typo and count
Date:   Tue, 19 Jul 2022 13:52:02 +0200
Message-Id: <20220719114717.277066323@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kris Bahnsen <kris@embeddedTS.com>

[ Upstream commit e95ea0f687e679fcb0a3a67d0755b81ee7d60db0 ]

Device-tree incorrectly used "ngpio" which caused the driver to
fallback to 32 ngpios.

This platform has 62 GPIO registers.

Fixes: 9ff8e9fccef9 ("ARM: dts: TS-7970: add basic device tree")
Signed-off-by: Kris Bahnsen <kris@embeddedTS.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-ts7970.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-ts7970.dtsi b/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
index fded07f370b3..d6ba4b2a60f6 100644
--- a/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
@@ -226,7 +226,7 @@ gpio8: gpio@28 {
 		reg = <0x28>;
 		#gpio-cells = <2>;
 		gpio-controller;
-		ngpio = <32>;
+		ngpios = <62>;
 	};
 
 	sgtl5000: codec@a {
-- 
2.35.1



