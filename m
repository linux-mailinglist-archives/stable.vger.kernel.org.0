Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F0A12B898
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfL0R4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:56:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727648AbfL0Rlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BCBE21D7E;
        Fri, 27 Dec 2019 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468514;
        bh=xYHCqeSqTyw7YMuYYvLayPiWngIzGhgLfcAOH/sluAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPX4HnfrphBP8ln/fWl2yzFEk5lrA0IECFZ9h5UOstSh70hVWUBskl/aZ6GJ14oG5
         y1cw2khDQx885oRrQQ5q24bDlP4Q8WCmSNTb/kfQkqBAjL6+IuVjVF8IupXWQbevEd
         IMgeM0M9ucaRpfdDfBSyAYJ909pmYl33UKEeqiFU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 047/187] ARM: exynos_defconfig: Restore debugfs support
Date:   Fri, 27 Dec 2019 12:38:35 -0500
Message-Id: <20191227174055.4923-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit a2315d3aea5976acd919d3d3fcf82f752562c25b ]

Commit 9f532d26c75c ("ARM: exynos_defconfig: Trim and reorganize with
savedefconfig") removed explicit enable line for CONFIG_DEBUG_FS, because
that feature has been selected by other enabled options: CONFIG_TRACING,
which in turn had been selected by CONFIG_PERF_EVENTS and
CONFIG_PROVE_LOCKING.

In meantime, commit 0e4a459f56c3 ("tracing: Remove unnecessary DEBUG_FS
dependency") removed the dependency between CONFIG_DEBUG_FS and
CONFIG_TRACING, so CONFIG_DEBUG_FS is no longer enabled in default builds.

Enable it again explicitly, as debugfs support is essential for various
automated testing tools.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/exynos_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 08db1c83eb2d..736ed7a7bcf8 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -348,6 +348,7 @@ CONFIG_PRINTK_TIME=y
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO=y
 CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_SOFTLOCKUP_DETECTOR=y
 # CONFIG_DETECT_HUNG_TASK is not set
-- 
2.20.1

