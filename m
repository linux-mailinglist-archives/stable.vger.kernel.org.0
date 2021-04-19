Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECEA364C7F
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243440AbhDSUvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234275AbhDSUt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E90613DC;
        Mon, 19 Apr 2021 20:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865171;
        bh=h7XoYrVfkHNqKpUvm46qFUEtioICcPkbOOgIkdyI6W0=;
        h=From:To:Cc:Subject:Date:From;
        b=jPmjAX3U/Q6cdUZqtwTyEK1AqgvzXO451h1uM/xOqTuSOSYEOi4Fm8lJG4EIHPRkH
         9eSDcrSxBCZiKsivsen3mLupXs4CcSBbGFzwaBnrhxoWvmRLAMfuJRCSbfbDisZ0CC
         eFkV7T/yD2A85MoFmX+fb4Steb530bHx1SxRnP3MUS4v82u8wBIBFvEQkqT6dhK7zh
         /PFyG2B0nZZ5n9EBh5mt57Gfgz2qCM7GHGQZvyG01dQx1HxL8K7Go5BYWIevax7baN
         hL7OHG0JTaJ/pSYDYSd5x3AJbs7kIIfQg/1/TA4zb9oXCV9zVjyJmk6wsij6O3f5ti
         bfiV3ce2Pm3Hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/7] ARM: dts: Fix swapped mmc order for omap3
Date:   Mon, 19 Apr 2021 16:46:02 -0400
Message-Id: <20210419204608.7191-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 8a2b25332b8c..a2e41d79e829 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -22,6 +22,9 @@ aliases {
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

