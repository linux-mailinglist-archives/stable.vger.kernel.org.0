Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9DD364C6D
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243354AbhDSUum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243127AbhDSUsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:48:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD1EA613CD;
        Mon, 19 Apr 2021 20:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865158;
        bh=16fpY5rO3cf5iWH5/MnPIubK4xnVxNDzEtc05YWhV4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S34lSMrwOC2pzG6/aADNE0I8hpa6f4IhHqeWF06KgRnBo3grzs8VG4T9FyAUZ0TS7
         ya4OiEk2fYQ5yhaASQpP0wGBKejt+v15YngiiJT5II/25HbJqQuMPNQl4PDWF0vi8T
         Cag82Q3IYlF9RmZAQIwVX3KJk56ChdRPFw1iwCQazn7CRs/Knvvge8d7/SfgF2D5LA
         xUw/r0jpH7yswVVhPpPVR1gCUWupFH19rMep71uGpqn30k5lnB8vn8G001Bpm0YOSH
         Yx/juvtNoTmo8nMCOF/ZaxeDHfsHcVaIjZRtmJwZXtxd4cNl9gYSyAHo0TBeopLBJu
         g+uiZIeE4ytDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/8] ARM: dts: Fix swapped mmc order for omap3
Date:   Mon, 19 Apr 2021 16:45:48 -0400
Message-Id: <20210419204554.7071-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204554.7071-1-sashal@kernel.org>
References: <20210419204554.7071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit a1ebdb3741993f853865d1bd8f77881916ad53a7 ]

Also some omap3 devices like n900 seem to have eMMC and micro-sd swapped
around with commit 21b2cec61c04 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for
drivers that existed in v4.4").

Let's fix the issue with aliases as discussed on the mailing lists. While
the mmc aliases should be board specific, let's first fix the issue with
minimal changes.

Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 2008648b8c9f..0a7600d06fb5 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -23,6 +23,9 @@ aliases {
 		i2c0 = &i2c1;
 		i2c1 = &i2c2;
 		i2c2 = &i2c3;
+		mmc0 = &mmc1;
+		mmc1 = &mmc2;
+		mmc2 = &mmc3;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
-- 
2.30.2

