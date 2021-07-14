Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE08D3C90BE
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239219AbhGNT4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239002AbhGNTvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C585C613D0;
        Wed, 14 Jul 2021 19:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292098;
        bh=LBXD4Wz1qxz5k3KFOfls2JXbaV7WDf+oET1woDyQzbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7s2F96yrnI2lT5jwZKLpEGRYUSNRRuFMBwx7ggB75SDjnk7r+63YTk6TA/VwT6Rz
         Wkvn+F+nMjW/1zAxCA5SRjOLthaDaz36EpZ7ua5lKuliOzDkpazbYfmF2lVkrtoZv4
         8kabGJpa4cw2PJyhDJalWzmhGKpu4cMmILSpLaz9fU9mtNt7/8NLHYeItOLcG+qsUA
         v3Q6IySKPPqCUZ9T3SfWSJQqb4FolSVkrS3Ftiw+w9LUW7h15QKN5GhUmajUPW5r5B
         5rXyMUpmks0N/+Qs6Xw1esW4iMR6foXl4WS9TLrRRyqTYGdFGyWzupVichguHfaJJn
         dtUeo3SJhDbJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 08/18] ARM: imx: pm-imx5: Fix references to imx5_cpu_suspend_info
Date:   Wed, 14 Jul 2021 15:47:56 -0400
Message-Id: <20210714194806.55962-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194806.55962-1-sashal@kernel.org>
References: <20210714194806.55962-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit 89b759469d525f4d5f9c29cd3b1f490311c67f85 ]

The name of the struct, as defined in arch/arm/mach-imx/pm-imx5.c,
is imx5_cpu_suspend_info.

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/suspend-imx53.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/suspend-imx53.S b/arch/arm/mach-imx/suspend-imx53.S
index 5ed078ad110a..f12d24104075 100644
--- a/arch/arm/mach-imx/suspend-imx53.S
+++ b/arch/arm/mach-imx/suspend-imx53.S
@@ -33,11 +33,11 @@
  *                              ^
  *                              ^
  *                      imx53_suspend code
- *              PM_INFO structure(imx53_suspend_info)
+ *              PM_INFO structure(imx5_cpu_suspend_info)
  * ======================== low address =======================
  */
 
-/* Offsets of members of struct imx53_suspend_info */
+/* Offsets of members of struct imx5_cpu_suspend_info */
 #define SUSPEND_INFO_MX53_M4IF_V_OFFSET		0x0
 #define SUSPEND_INFO_MX53_IOMUXC_V_OFFSET	0x4
 #define SUSPEND_INFO_MX53_IO_COUNT_OFFSET	0x8
-- 
2.30.2

