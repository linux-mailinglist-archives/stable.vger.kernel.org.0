Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A46551A745
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354893AbiEDRDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354992AbiEDQ7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:59:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1890148E7A;
        Wed,  4 May 2022 09:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8A24B82792;
        Wed,  4 May 2022 16:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674ACC385AA;
        Wed,  4 May 2022 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683069;
        bh=qKRNoo6AJog9cupwDJH/dQVPuRBuUHh+anIhDpvOv7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1JyxlVpUNRxjW7yERoGRhtZQw69jeedMy0oMmFspSb8NbvZqbyDYfNOPKdrvuZP5i
         gwGJ3y8ZmSrZIqfwYWhIbW/dqXvnUb0KDG4YoNcgq4A1N2ayjztA4Iwj6yCVHxzq1z
         N5cQm4uVCb9Y1n6o6vtaSuQGoUq2UXQ1sCOQLnjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/129] ARM: dts: Fix mmc order for omap3-gta04
Date:   Wed,  4 May 2022 18:44:06 +0200
Message-Id: <20220504153025.338409370@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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
index 80c9e5e34136..cc8a378dd076 100644
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



