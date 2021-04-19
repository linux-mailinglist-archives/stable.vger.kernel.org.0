Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CECF3643DC
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240071AbhDSNWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241473AbhDSNUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C5E61408;
        Mon, 19 Apr 2021 13:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838218;
        bh=IUudeNzLjiu55I1f2gUgqTTfVAgi+VGRktbxudd8noU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upPrjucknFvXhtvi7ZUKwX3Kb9hkX5FHKQZGQLBLD10KiOvsFbkKPdC9T2Z/qenEn
         koeTiCjY0lrt+zFzCBAunHi3mTR939tAfU2RptYY7asS4r49qZPjnYLsmbMWNbApXh
         5MIsfooJ7JIblumSnRvj2PA19y6nVmaKlskBc6zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/103] ARM: OMAP2+: Fix warning for omap_init_time_of()
Date:   Mon, 19 Apr 2021 15:06:37 +0200
Message-Id: <20210419130530.755167357@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit a3efe3f6d0eb64363f74af4b0e8ba6d19415cef2 ]

Fix warning: no previous prototype for 'omap_init_time_of'.

Fixes: e69b4e1a7577 ("ARM: OMAP2+: Add omap_init_time_of()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/board-generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 7290f033fd2d..1610c567a6a3 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -33,7 +33,7 @@ static void __init __maybe_unused omap_generic_init(void)
 }
 
 /* Clocks are needed early, see drivers/clocksource for the rest */
-void __init __maybe_unused omap_init_time_of(void)
+static void __init __maybe_unused omap_init_time_of(void)
 {
 	omap_clk_init();
 	timer_probe();
-- 
2.30.2



