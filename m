Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBD3F4722
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391669AbfKHLrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391661AbfKHLrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04147206A3;
        Fri,  8 Nov 2019 11:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213668;
        bh=4weDkqTsOQdRJ1VVtlFZaJNDdQk1IFqH0ZSgQo7C+Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCzbuIE/DblqSWBaBi0mK4evRLCf2FBQdlxdnuPi5JepE4cYVZWhU17f7zE0G0Soz
         wiXgl6gm5tinOttn4yhC52IK4+3l5pJZRtJT1+/se8URKugIcIWB1WZ+0JEYWFZoPh
         /NfzySOF2leba06tARq/vEt54wfLe0zsi534eO/E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 21/44] ARM: dts: omap3-gta04: tvout: enable as display1 alias
Date:   Fri,  8 Nov 2019 06:46:57 -0500
Message-Id: <20191108114721.15944-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H. Nikolaus Schaller" <hns@goldelico.com>

[ Upstream commit 8905592b6e50cec905e6c6035bbd36201a3bfac1 ]

The omap dss susbystem takes the display aliases to find
out which displays exist. To enable tv-out we must define
an alias.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 9b9510e057f3f..196b3f5158c90 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -28,6 +28,7 @@
 
 	aliases {
 		display0 = &lcd;
+		display1 = &tv0;
 	};
 
 	gpio-keys {
-- 
2.20.1

