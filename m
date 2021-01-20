Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4942FC7E6
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbhATC33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730036AbhATB2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC818221E5;
        Wed, 20 Jan 2021 01:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106003;
        bh=hMs1Enxi29RFmdXP40/oB+4f2xHXZetfroIgBXwOUt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPUN3LQ7Ss1/VXbohDCt8yrRLDCH4/+/j+vxCtSelaDzdkkA04/y6FLC6DISzDDYm
         iY+q0cMk/BI+mlhKiRrUHSZDd88TylmVzjpfWysQ0aD5nqLKV3DxofP4MSMV4Szy4F
         hWK3Uz3UPKgmyel80jYSp3H0YRq0Saa+HrAobYy5jHy6luC53Y5WsOZc5NVBo40lkc
         Bi/ZvgGg+Z8Vu7s96zQyzwq7cNN7nIZIPT1VVGSzkpHncIFS7rWHYkOHQxVMXGJxX1
         HDGt1syXnUEwnsT/KPm5T37TrPvRjgbOR28aGdfx42+oPjW5def/TGsrgkLBbZMZVt
         hy33v4L68imZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 31/45] riscv: defconfig: enable gpio support for HiFive Unleashed
Date:   Tue, 19 Jan 2021 20:25:48 -0500
Message-Id: <20210120012602.769683-31-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagar Shrikant Kadam <sagar.kadam@sifive.com>

[ Upstream commit 0983834a83931606a647c275e5d4165ce4e7b49f ]

Ethernet phy VSC8541-01 on HiFive Unleashed has its reset line
connected to a gpio, so enable GPIO driver's required to reset
the phy.

Signed-off-by: Sagar Shrikant Kadam <sagar.kadam@sifive.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/configs/defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index d222d353d86d4..8c3d1e4517031 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -64,6 +64,8 @@ CONFIG_HW_RANDOM=y
 CONFIG_HW_RANDOM_VIRTIO=y
 CONFIG_SPI=y
 CONFIG_SPI_SIFIVE=y
+CONFIG_GPIOLIB=y
+CONFIG_GPIO_SIFIVE=y
 # CONFIG_PTP_1588_CLOCK is not set
 CONFIG_POWER_RESET=y
 CONFIG_DRM=y
-- 
2.27.0

