Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8F23C8E29
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhGNTqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235127AbhGNTp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDD1061402;
        Wed, 14 Jul 2021 19:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291746;
        bh=9vX5Pw3btHf51G/PwJ69a7b1fuw17DF2HH/8DIhR/qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oP8iSICBAzcBYDXDGRNWR6kybekp57LHF94BD/Iara8zFDArMrnfvlac73WhTyrT4
         bjeKGQ7zJACRF3e/zA4qHGErFj7FjC8hvjHfZ1u/38OAcA0axDpNENGVK8IXTaPTaI
         IQOicRN/sHo1zElSs5n+z22etxmm1ZomuWuP0bkOTfZ4GCJx+9osfBeW9Kc6frMYd+
         Ejv6AjB7qdiU4uIL6W53vUM8ut2YoQpa2Mf7ZtAYSRM+5N1fR6XXKnBTj8a0OGdywS
         ZeqkEx0V5wA5H8wktJeLVwmUlobJUftsZWUid7HztdDNoT4yMUuwHGJYAZ/E3qgTcZ
         PZhVYR71m7ZqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 077/102] soc/tegra: fuse: Fix Tegra234-only builds
Date:   Wed, 14 Jul 2021 15:40:10 -0400
Message-Id: <20210714194036.53141-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit e2d0ee225e49a5553986f3138dd2803852a31fd5 ]

The tegra30_fuse_read() symbol is used on Tegra234, so make sure it's
available.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/fuse-tegra30.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/tegra/fuse/fuse-tegra30.c b/drivers/soc/tegra/fuse/fuse-tegra30.c
index 9ea7f0168457..c1aa7815bd6e 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra30.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra30.c
@@ -37,7 +37,8 @@
     defined(CONFIG_ARCH_TEGRA_132_SOC) || \
     defined(CONFIG_ARCH_TEGRA_210_SOC) || \
     defined(CONFIG_ARCH_TEGRA_186_SOC) || \
-    defined(CONFIG_ARCH_TEGRA_194_SOC)
+    defined(CONFIG_ARCH_TEGRA_194_SOC) || \
+    defined(CONFIG_ARCH_TEGRA_234_SOC)
 static u32 tegra30_fuse_read_early(struct tegra_fuse *fuse, unsigned int offset)
 {
 	if (WARN_ON(!fuse->base))
-- 
2.30.2

