Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEDB5EA447
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbiIZLnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238307AbiIZLmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:42:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0AB72692;
        Mon, 26 Sep 2022 03:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 918AF609FE;
        Mon, 26 Sep 2022 10:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897FBC433D6;
        Mon, 26 Sep 2022 10:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189110;
        bh=A7t4uV2wOZ1LNnRMm6YGpL8nwXWxKD2W+rQwKzu+fQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBc+nEz65LAnTTr0GQQk3I1mJlOOZDGXMFC/pT9Qke1KZSUU8elxUrg3JewFigrZL
         X3pkR8uXc2O2Y5lbs7Zdn4rk6fbxRE6s/VG6XC6l718uQivN7jMffUG4VB7wHHBlgt
         LU/1MxLrCp76p3LxD0gMv83N1H9+420ve8/1bp/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 077/207] arm64: dts: imx8mm: Reverse CPLD_Dn GPIO label mapping on MX8Menlo
Date:   Mon, 26 Sep 2022 12:11:06 +0200
Message-Id: <20220926100810.023426281@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 8194a356226ce6f53e1d98b44c0436c583db89d2 ]

The CPLD_Dn GPIO assignment between SoM and CPLD has now been clarified
in schematic and the assignment is reversed. Update the DT to match the
hardware.

Fixes: 510c527b4ff57 ("arm64: dts: imx8mm: Add i.MX8M Mini Toradex Verdin based Menlo board")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts b/arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts
index 92eaf4ef4563..57ecdfa0dfc0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts
@@ -152,11 +152,11 @@ &gpio4 {
 	 * CPLD_reset is RESET_SOFT in schematic
 	 */
 	gpio-line-names =
-		"CPLD_D[1]", "CPLD_int", "CPLD_reset", "",
-		"", "CPLD_D[0]", "", "",
-		"", "", "", "CPLD_D[2]",
-		"CPLD_D[3]", "CPLD_D[4]", "CPLD_D[5]", "CPLD_D[6]",
-		"CPLD_D[7]", "", "", "",
+		"CPLD_D[6]", "CPLD_int", "CPLD_reset", "",
+		"", "CPLD_D[7]", "", "",
+		"", "", "", "CPLD_D[5]",
+		"CPLD_D[4]", "CPLD_D[3]", "CPLD_D[2]", "CPLD_D[1]",
+		"CPLD_D[0]", "", "", "",
 		"", "", "", "",
 		"", "", "", "KBD_intK",
 		"", "", "", "";
-- 
2.35.1



