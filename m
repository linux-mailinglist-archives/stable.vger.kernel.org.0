Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB51FA361
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbfKMCJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:09:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbfKMB7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E453222CF;
        Wed, 13 Nov 2019 01:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610387;
        bh=JZdrSf66McTwmVPyGVXRXf/zpqf72r7V9/3MkaYOAbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxR/OFpCDoy53maRjsUukBnMd8txkRj6hZ4aOBqhKKVD01D28y/Y0M4hsuIpjfLl7
         BCjK/dLsIfZdpCj/8wIF7rbiXeAge5SdTjbI3KC11QqxfIPThvFHnDvYr7uHMCw1nT
         LHguDND+MhR/V1OySLNRVDNqB+ZkEaqBfpnFQYIo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/68] ata: ahci_brcm: Allow using driver or DSL SoCs
Date:   Tue, 12 Nov 2019 20:58:34 -0500
Message-Id: <20191113015932.12655-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 7fb44929cb0e5cdcde143e1ca3ca57b5b8247db0 ]

The Broadcom STB AHCI controller is the same as the one found on DSL
SoCs, so we will utilize the same driver on these systems as well.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 5d16fc4fa46c7..a8d4f4b5a77eb 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -100,7 +100,8 @@ config SATA_AHCI_PLATFORM
 
 config AHCI_BRCM
 	tristate "Broadcom AHCI SATA support"
-	depends on ARCH_BRCMSTB || BMIPS_GENERIC || ARCH_BCM_NSP
+	depends on ARCH_BRCMSTB || BMIPS_GENERIC || ARCH_BCM_NSP || \
+		   ARCH_BCM_63XX
 	help
 	  This option enables support for the AHCI SATA3 controller found on
 	  Broadcom SoC's.
-- 
2.20.1

