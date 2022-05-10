Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE7C5217D8
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243029AbiEJN3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239589AbiEJN3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:29:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B5D366BF;
        Tue, 10 May 2022 06:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CCEF61663;
        Tue, 10 May 2022 13:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC30FC385A6;
        Tue, 10 May 2022 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188856;
        bh=laynf76DuemHAcHFOzu1PPKqPkAK/Zd29BLiX/RFYHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=028mdfjE39TYjHl6BBc4uGaS+RRrgBwuVtPgVqLvi61vSDBxcYnW81pmjO+4oGqW+
         Kw8x2NL7TeVMrMDMAeOwvj4tXxBNTJ3ACTkkI/zLYOMApHRst7eI6PhnDAsid6xLg9
         g3cznQHdwxMHk+zS2B6bjlC/Yl3lOGZqWpnlVq80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/88] ARM: dts: Fix mmc order for omap3-gta04
Date:   Tue, 10 May 2022 15:07:13 +0200
Message-Id: <20220510130734.564462760@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index a5aed92ab54b..820bdd5326ab 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -29,6 +29,8 @@ memory@80000000 {
 	aliases {
 		display0 = &lcd;
 		display1 = &tv0;
+		/delete-property/ mmc2;
+		/delete-property/ mmc3;
 	};
 
 	/* fixed 26MHz oscillator */
-- 
2.35.1



