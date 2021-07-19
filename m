Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304093CE3FF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347539AbhGSPlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348547AbhGSPf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FE7E61879;
        Mon, 19 Jul 2021 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711246;
        bh=r5EcMHYVJ7lLgi+IgoWeooNmnEAxM3OkhSNWpiylMPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSqLgjCkAEGKgHikzrkLwNSyJNIeHNqm5Gkkv7XTkxumGTYBHhgm20l4DPnoW9its
         OdTdX6F3SClZYXyvabg8jNNOmgBcNMFIp51UHtzKUDqGTEGLDzPVFQDJi/vrIW0u/9
         GfL+eC1Jht3gMjphMaGH9hk2JjNrRKTxCLt17Waw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 283/351] arm64: defconfig: Do not override the MTK_PMIC_WRAP symbol
Date:   Mon, 19 Jul 2021 16:53:49 +0200
Message-Id: <20210719144954.401225685@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit f0e70d4946332c681ceaba940652f30c7c33473d ]

Commit 'fbbe38309d56 ("arm64: defconfig: Allow mt8173-based boards to boot
from usb")' added the MTK_PMIC_WRAP config built-in. It needs to be
built-in in order to be able to boot from USB or the MMC without needing
a ramdisk, but that symbol was already defined as a module so now we are
getting the following warning:

  arch/arm64/configs/defconfig:996:warning: override: reassigning to symbol MTK_PMIC_WRAP

Remove the MTK_PMIC_WRAP=m from the defconfig to remove the error.

Fixes: fbbe38309d56 ("arm64: defconfig: Allow mt8173-based boards to boot from usb")
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20210423075201.2616023-1-enric.balletbo@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/configs/defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 08c6f769df9a..9907a431db0d 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -491,7 +491,6 @@ CONFIG_SPI_S3C64XX=y
 CONFIG_SPI_SH_MSIOF=m
 CONFIG_SPI_SUN6I=y
 CONFIG_SPI_SPIDEV=m
-CONFIG_MTK_PMIC_WRAP=m
 CONFIG_SPMI=y
 CONFIG_PINCTRL_SINGLE=y
 CONFIG_PINCTRL_MAX77620=y
-- 
2.30.2



