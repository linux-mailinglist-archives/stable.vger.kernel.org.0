Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A7118632A
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgCPClB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729584AbgCPCdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:33:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FB1E20737;
        Mon, 16 Mar 2020 02:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326029;
        bh=glIX5Z7bJqEDQ5JgvMe9Z3yqwXPHOV3ppkP4+fwmd/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MExo3ygi1aa5Pbf/WpfwN9WQD6IwYAl+52M/EV5jch7Pu3mgrnvb2GIm95TKXDDAU
         Pv75Y/7SSXUJjkh66yPCIVq8rdVMdt9SorUV/NOjYDwXALsXGlVLSCwvnp16/jHn5t
         xTknl9+VbDgNkuw9xDPELxufPAknkJ8mbhC7IIMs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 24/41] ARM: bcm2835_defconfig: Explicitly restore CONFIG_DEBUG_FS
Date:   Sun, 15 Mar 2020 22:33:02 -0400
Message-Id: <20200316023319.749-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023319.749-1-sashal@kernel.org>
References: <20200316023319.749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 1bba60808404b873defa0f3560497eb2e8fe86b8 ]

The commit 0e4a459f56c3 ("tracing: Remove unnecessary DEBUG_FS dependency")
accidentally dropped the DEBUG FS support in bcm2835_defconfig. So
restore the config as before the commit.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 0e4a459f56c3 ("tracing: Remove unnecessary DEBUG_FS dependency")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/bcm2835_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
index 519ff58e67b30..0afcae9f7cf8a 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -178,6 +178,7 @@ CONFIG_SCHED_TRACER=y
 CONFIG_STACK_TRACER=y
 CONFIG_FUNCTION_PROFILER=y
 CONFIG_TEST_KSTRTOX=y
+CONFIG_DEBUG_FS=y
 CONFIG_KGDB=y
 CONFIG_KGDB_KDB=y
 CONFIG_STRICT_DEVMEM=y
-- 
2.20.1

