Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE5520E822
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732861AbgF2WDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgF2SfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6203246A6;
        Mon, 29 Jun 2020 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443999;
        bh=GZC9kGIvaaQaiIdoIERM7cmqDj/kun1P6DXSKhfyYk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhmtJnBHq3cqBHTvjOt599cFk9D6ieFnnOIHQUqPfdi+2p8KUC/MCcCxivV/y1HmJ
         N55+9MM+navxK8ghrwnrJ+5rjaTtJ7vlWyeJ520sh2VYOMKptCa2+Dybm4q/RK8s86
         pHeIvP/cH5SHQThWPit5oMTv/XWrLCl+rXrOtuKM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 104/265] ARM: bcm: Select ARM_TIMER_SP804 for ARCH_BCM_NSP
Date:   Mon, 29 Jun 2020 11:15:37 -0400
Message-Id: <20200629151818.2493727-105-sashal@kernel.org>
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

From: Matthew Hagan <mnhagan88@gmail.com>

[ Upstream commit 0386e9ce5877ee73e07675529d5ae594d00f0900 ]

The NSP SoC includes an SP804 timer so should be enabled here.

Fixes: a0efb0d28b77 ("ARM: dts: NSP: Add SP804 Support to DT")
Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-bcm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 6aa938b949db2..1df0ee01ee02b 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -53,6 +53,7 @@ config ARCH_BCM_NSP
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_775420
 	select ARM_ERRATA_764369 if SMP
+	select ARM_TIMER_SP804
 	select THERMAL
 	select THERMAL_OF
 	help
-- 
2.25.1

