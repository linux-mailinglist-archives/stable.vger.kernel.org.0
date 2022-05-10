Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565EC521758
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242733AbiEJNW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243289AbiEJNVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:21:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6D42C336B;
        Tue, 10 May 2022 06:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F33DF6123F;
        Tue, 10 May 2022 13:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD81C385A6;
        Tue, 10 May 2022 13:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188510;
        bh=lwwCpzWHUUhleWMxpvTZOhW5QOtkJCzvcj55PnUh7gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gm2NPsmSCHIa0wRmEqkkChzl/h0xVa2vyQ4hBKW82/I/wx9/MUM6UDh0gJYt3R9/+
         wlBo7l/dRw+KQ+UfgkNlsKH2PuEJs1RTYVXnhm7GtjommHe/z+5qyUVb2TWTD1Munh
         B5TNR+eZCStmGEhPe9yYT1SW7aPaqUC8srEiEaTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/78] ARM: dts: Fix mmc order for omap3-gta04
Date:   Tue, 10 May 2022 15:07:16 +0200
Message-Id: <20220510130733.427851952@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
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
index ee028aa663fa..312267724033 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -29,6 +29,8 @@ memory@80000000 {
 	aliases {
 		display0 = &lcd;
 		display1 = &tv0;
+		/delete-property/ mmc2;
+		/delete-property/ mmc3;
 	};
 
 	gpio-keys {
-- 
2.35.1



