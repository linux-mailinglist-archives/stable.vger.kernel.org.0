Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0623C8F2C
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbhGNTwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234095AbhGNTsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0971E6140E;
        Wed, 14 Jul 2021 19:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291821;
        bh=pbGFywMX/HXgnVhLfPBMR6TlD4JSNwxkFicirbiQYdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRFzE2dV+qk42yLSpSLD6mODTPCeJXLSpZBem1tp0H37N21N2yPtLodoiL4N4xO16
         ihSzCERfZYlF845Ubnou87XN8gt0Vl2+Yz0ag6GfPyQPofGhE9cwyRtS++g5SkQG21
         OBbEoExHUTudRMI2bntguW7dGyOK3lcs4fKP8qLijbGFOy4FRMomPd5Hy6Vw99RlK1
         4Ypzhe0BYUa25wIOOn7rCR0YdNl9YmG3KSIBA5R27kpNk0QkZg4APj0Zocy3waNnS2
         QYu4iX4VdBEjy8BKDCOAXTn5PB06niyQlhX/zhS6ulVrkU1nAc4n6yTT0++TbDFftI
         uwY+w+QWOg3dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 23/88] ARM: imx: pm-imx5: Fix references to imx5_cpu_suspend_info
Date:   Wed, 14 Jul 2021 15:41:58 -0400
Message-Id: <20210714194303.54028-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index 41b8aad65363..46570ec2fbcf 100644
--- a/arch/arm/mach-imx/suspend-imx53.S
+++ b/arch/arm/mach-imx/suspend-imx53.S
@@ -28,11 +28,11 @@
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

