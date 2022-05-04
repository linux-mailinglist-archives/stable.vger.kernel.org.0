Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A8C51A8ED
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355901AbiEDRMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357088AbiEDRJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3832B48E6F;
        Wed,  4 May 2022 09:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 696F0618EE;
        Wed,  4 May 2022 16:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1288C385A4;
        Wed,  4 May 2022 16:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683423;
        bh=QnEGDlMn9uLf+kFwnUU586VzqNWXp9vWlFw59N18DH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=havZQ0PgtUMbDU5GGOp3P1lhXIRpIMXIeEYZ69N1Cq7CEeIsO0hrucTIUE/syRGDV
         B+p3Mol7mR+k7Zm1SqDjMD2Fs9mJ+xaettK1nIjLRobKKWoPYpFINajpQaDzg4t7xS
         VEqsgIrVd7zE+OgxXJyHfs7HiJh8Uk/CdbsKEhtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 089/225] ARM: dts: Fix mmc order for omap3-gta04
Date:   Wed,  4 May 2022 18:45:27 +0200
Message-Id: <20220504153118.862004216@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit 09269dd050094593fc747f2a5853d189fefcb6b5 ]

Commit a1ebdb374199 ("ARM: dts: Fix swapped mmc order for omap3")
introduces general mmc aliases. Let's tailor them to the need
of the GTA04 board which does not make use of mmc2 and mmc3 interfaces.

Fixes: a1ebdb374199 ("ARM: dts: Fix swapped mmc order for omap3")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Message-Id: <dc9173ee3d391d9e92b7ab8ed4f84b29f0a21c83.1646744420.git.hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 7e3d8147e2c1..0365f06165e9 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -31,6 +31,8 @@ chosen {
 	aliases {
 		display0 = &lcd;
 		display1 = &tv0;
+		/delete-property/ mmc2;
+		/delete-property/ mmc3;
 	};
 
 	ldo_3v3: fixedregulator {
-- 
2.35.1



