Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774EE283A4B
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgJEPdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:32798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbgJEPdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F24682074F;
        Mon,  5 Oct 2020 15:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911986;
        bh=G5hrtPkBKUHFRI3P2Zv0nM+kDQLimzUvLpyPv2bFVrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEzo3WfmYCF/MdPJqms6BSJx16GQd1CNXezb690mkT1wXVqefX6OYC6AkgS4Fj4rr
         LySnFSQMycPZlbUneYM+tJ9s6/qKgh7sJPHF/tQmCJFb072B3REWJ4q5XGNAQGXswG
         QrvpTU6yQilMuCI/yQm64yB2W6Q1+GZszk6vya/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 57/85] clk: tegra: Fix missing prototype for tegra210_clk_register_emc()
Date:   Mon,  5 Oct 2020 17:26:53 +0200
Message-Id: <20201005142117.466629174@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 2f878d04218c8b26f6d0ab26955ca6b03848a1ad ]

Include the Tegra driver's clk.h to pull in the prototype definition for
this function so that compilers don't warn about it being missing.

Fixes: 0ac65fc946d3 ("clk: tegra: Implement Tegra210 EMC clock")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra210-emc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra210-emc.c b/drivers/clk/tegra/clk-tegra210-emc.c
index 352a2c3fc3740..51fd0ec2a2d04 100644
--- a/drivers/clk/tegra/clk-tegra210-emc.c
+++ b/drivers/clk/tegra/clk-tegra210-emc.c
@@ -12,6 +12,8 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
+#include "clk.h"
+
 #define CLK_SOURCE_EMC 0x19c
 #define  CLK_SOURCE_EMC_2X_CLK_SRC GENMASK(31, 29)
 #define  CLK_SOURCE_EMC_MC_EMC_SAME_FREQ BIT(16)
-- 
2.25.1



