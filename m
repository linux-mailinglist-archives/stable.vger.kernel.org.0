Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31B120E704
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgF2Vw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CF7D2469F;
        Mon, 29 Jun 2020 15:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443995;
        bh=h1exmCBpP4dvGL6YomoSTtUxadSu5YsmIGfU3pB2C+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yj6lLEgdnKqLpoOrkFRtTBimi/I0Lb1E+oPB6m+Pujc3awe15W//qyXY9PeXBQQ4r
         xYxh9v70rWoL4NZd1WR6Led9tAYu7I2K53j/YX/AtscN9Zd4P+Bzkb9Excy4tOFDtj
         nAepcD7hoaHfVYFYwMhAMgqa6TERCE14L8wAwuFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oskar Holmlund <oskar@ohdata.se>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 100/265] ARM: dts: Fix am33xx.dtsi ti,sysc-mask wrong softreset flag
Date:   Mon, 29 Jun 2020 11:15:33 -0400
Message-Id: <20200629151818.2493727-101-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oskar Holmlund <oskar@ohdata.se>

[ Upstream commit 9f872f924545324a06fa216ad38132804c20f2db ]

AM335x TRM: Figure 16-23 define sysconfig register and soft_reset
are in first position corresponding to SYSC_OMAP4_SOFTRESET defined
in ti-sysc.h.

Fixes: 0782e8572ce4 ("ARM: dts: Probe am335x musb with ti-sysc")
Signed-off-by: Oskar Holmlund <oskar@ohdata.se>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index be76ded7e4c0c..ed6634d34c3c7 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -335,7 +335,7 @@
 			      <0x47400010 0x4>;
 			reg-names = "rev", "sysc";
 			ti,sysc-mask = <(SYSC_OMAP4_FREEEMU |
-					 SYSC_OMAP2_SOFTRESET)>;
+					 SYSC_OMAP4_SOFTRESET)>;
 			ti,sysc-midle = <SYSC_IDLE_FORCE>,
 					<SYSC_IDLE_NO>,
 					<SYSC_IDLE_SMART>;
-- 
2.25.1

