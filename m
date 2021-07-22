Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833613D2837
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhGVPz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230141AbhGVPzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:55:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC8661362;
        Thu, 22 Jul 2021 16:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971775;
        bh=pbGFywMX/HXgnVhLfPBMR6TlD4JSNwxkFicirbiQYdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOon9tFDbAKdALJTDQvln/MuGqxSRpdQrTl7Tc1c9g0ciadJFKkuCu55puQsaLGdz
         bnFX7GMn9HE5U6xaJQdli6t84pW+/zS82uBpNVbxPlXNNF/KzDVYoHWFtXYJVDgIrS
         PXTkDVQtwNjWdVddrES0FBOvkTCYjReLe1I1f3nA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/125] ARM: imx: pm-imx5: Fix references to imx5_cpu_suspend_info
Date:   Thu, 22 Jul 2021 18:30:12 +0200
Message-Id: <20210722155625.392356425@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



