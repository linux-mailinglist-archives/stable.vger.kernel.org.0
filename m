Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7943C9005
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240677AbhGNTxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240810AbhGNTuF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67F3D61445;
        Wed, 14 Jul 2021 19:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291966;
        bh=ZsjOBOn7ekvjQPImv8aRTkazMMKmWRxk7Lfg4IDUzss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFqbIy2ku2pmFiFKYljnAigecEQrIt6frO2IBLXMtvD8WuMkivHZD2HSoizy2hmhr
         Pw8/9QK12Qy/8fPq2k6jd0nR6fcODnwfSMkp8gHW0FLdRlpzDcPmQ9F1DE/Gk/GCwG
         dRRYYv9MCoURzWfv4E6Iftdz0Ve+6i9L6lcx7D8VlCa6uoUVSDpSB+8FbsAhLu0JKX
         uTvdGFHTC6qJSpbiIryVG4uz6ZB1d2deZtHlyc6O29kaNqtH9oxuZTycu4puePNkoi
         Xf/mSuqi63vJs8kVwUxirPeWR40C1yGtAANj8EjgvYJSPw183/m8XUpMO7Zb42HajV
         13kVpjUAcutmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 37/51] soc/tegra: fuse: Fix Tegra234-only builds
Date:   Wed, 14 Jul 2021 15:44:59 -0400
Message-Id: <20210714194513.54827-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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
index 9c3ef0a02fd4..15060c847ecc 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra30.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra30.c
@@ -36,7 +36,8 @@
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

