Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B91B3C9088
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbhGNTzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241177AbhGNTu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B430613D8;
        Wed, 14 Jul 2021 19:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292029;
        bh=+p7B6GVMOb/x6+ESFC8PwwUHIni2GDlUyQwkjRzavhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULWaSO7RK2qIInumUkK5EaK3uYwGoyXt8EbkQJ/00mwkbAT994MdNyISNa2CCUoXK
         nNkNZgRoTX38jg1geIt+aM9ycXBx/NerKPfDn6VvuNQss6n06hW+LsVMetOJKZwsrQ
         /z8mJTTmnV2F1My/Fsp7QhTZjR8IiR6Vr2dKCS3CvDFGBAUqSSAwr+p/DUapt4xocI
         /LSU69Fo8h3wymrV4zYKViPmkG3W0c7uDlOd0yrOtt4mAR1E2hYZOHraFosaV/rjCF
         BrI8f3jUsgcmehR8NoYy/THzTR0IgwOwxRwIrCJxCLDmxKNrf/Uf9Q83ynXuk2JWnt
         789Zpd60gtoYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 30/39] soc/tegra: fuse: Fix Tegra234-only builds
Date:   Wed, 14 Jul 2021 15:46:15 -0400
Message-Id: <20210714194625.55303-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
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
index 0ec6385eb15e..7c47a0cebf3b 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra30.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra30.c
@@ -48,7 +48,8 @@
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

