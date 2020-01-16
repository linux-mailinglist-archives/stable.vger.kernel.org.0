Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E6B13E2F8
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgAPQ7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387494AbgAPQ50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 983BF2467E;
        Thu, 16 Jan 2020 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193846;
        bh=LWfOhuUCSRHlkBTUYtRzpo2sbP9fou7RPxTKLQqvUxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTfODH++/Jf/b3aFCy3tDQ7/ffBVSnPUTI6ndtZLk1lCcjpKJa4xq93+Uzr5uKu2u
         qQY4bkGfGoYwp7MTd6TVlYN+MOS4x4e/hbDC/1W/z+EPtWM2/KiFWs0HonBJ3x5kKa
         Dru8a8DQRFAM59cscwcA4dzQsfnG+feobVPSHj8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 099/671] arm64: defconfig: Re-enable bcm2835-thermal driver
Date:   Thu, 16 Jan 2020 11:45:30 -0500
Message-Id: <20200116165502.8838-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 4d9226fd9a0d747030575d7cb184b30c6e64f155 ]

The bcm2835-thermal driver was added with commit ac178e4280e6
("ARM64: bcm2835: add thermal driver to default config"). Unfortunately
this was accidentally dropped by commit eb1e6716cc9c
("arm64: defconfig: sync with savedefconfig"). So enable the driver again.

Fixes: eb1e6716cc9c ("arm64: defconfig: sync with savedefconfig")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index db8d364f8476..1a4f8b67bbe8 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -365,6 +365,7 @@ CONFIG_THERMAL_EMULATION=y
 CONFIG_ROCKCHIP_THERMAL=m
 CONFIG_RCAR_GEN3_THERMAL=y
 CONFIG_ARMADA_THERMAL=y
+CONFIG_BCM2835_THERMAL=m
 CONFIG_BRCMSTB_THERMAL=m
 CONFIG_EXYNOS_THERMAL=y
 CONFIG_TEGRA_BPMP_THERMAL=m
-- 
2.20.1

