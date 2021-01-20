Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9579A2FC8B6
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731669AbhATCbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:31:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730573AbhATB3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95C5723426;
        Wed, 20 Jan 2021 01:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106050;
        bh=vQtWiPkKsULz+3Pgk2ydlIu7asw7caLs9bmvdVS17LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHKheC7VKD9soLAbVFfGyYjz6BwWC4cbD7jzZVSkN6nyVrD9oyUsxzJ32eIg/z08R
         E4A3Pg4ECsZgK923DQ6t8CpaHF+h7PyEgdVNbBCr3kz4cmub9bs0vStVCYwxA5dMTf
         8hKfyqe7JKHnZuZmjx3+6EOJZjm2Gq/ijyqWGt+o2O8ABFMfGHgI7x+AOIvKywh/kY
         E0cgq78e0it/ndMXFStCohuF3MiDKJzHKO0bQqm1CRTdpoX1Mj/C1xMopoQBS+X/jC
         4u1I9ziOhR+wjlY1EzvrUc0llknarLBwx42mBVtnNh3B6ErFxMVq/i8p+aLGkc9516
         qdJ9ATICjDgGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 19/26] riscv: defconfig: enable gpio support for HiFive Unleashed
Date:   Tue, 19 Jan 2021 20:26:56 -0500
Message-Id: <20210120012704.770095-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
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
index 420a0dbef3866..3c656fe97e583 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -62,6 +62,8 @@ CONFIG_HW_RANDOM=y
 CONFIG_HW_RANDOM_VIRTIO=y
 CONFIG_SPI=y
 CONFIG_SPI_SIFIVE=y
+CONFIG_GPIOLIB=y
+CONFIG_GPIO_SIFIVE=y
 # CONFIG_PTP_1588_CLOCK is not set
 CONFIG_DRM=y
 CONFIG_DRM_RADEON=y
-- 
2.27.0

