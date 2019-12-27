Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B556412B8FA
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfL0RlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:41:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfL0RlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E845A2173E;
        Fri, 27 Dec 2019 17:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468459;
        bh=2/AR+100ByIuaMU3kpLIuFMXpkvzl8NCXRQQ5iDGItk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFvKpnEHjK08oIEwsO5tVLkbYio/x3j/cRcpooDy2xWpKUSgfWGQguPacWw76qs+8
         qjGnSVtOJKa/6YX28LkKP4NCnFS9ZvPP1FwLhJlrxf2wjAQtXKx14TOlz6ldqfPwYs
         LKxy2u3h+Gi6MTqDRJrLJkh8Appw/2Xl11QJRdX8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 002/187] spi: pxa2xx: Add support for Intel Jasper Lake
Date:   Fri, 27 Dec 2019 12:37:50 -0500
Message-Id: <20191227174055.4923-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 9c7315c9fca5de203538163cf42699bb10328902 ]

LPSS SPI on Intel Jasper Lake is compatible with Intel Ice Lake which
follows Intel Cannon Lake. Add PCI IDs of Jasper Lake.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20191125125159.15404-1-jarkko.nikula@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index bb6a14d1ab0f..3580a551c038 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1441,6 +1441,10 @@ static const struct pci_device_id pxa2xx_spi_pci_compound_match[] = {
 	{ PCI_VDEVICE(INTEL, 0x4b2a), LPSS_BXT_SSP },
 	{ PCI_VDEVICE(INTEL, 0x4b2b), LPSS_BXT_SSP },
 	{ PCI_VDEVICE(INTEL, 0x4b37), LPSS_BXT_SSP },
+	/* JSL */
+	{ PCI_VDEVICE(INTEL, 0x4daa), LPSS_CNL_SSP },
+	{ PCI_VDEVICE(INTEL, 0x4dab), LPSS_CNL_SSP },
+	{ PCI_VDEVICE(INTEL, 0x4dfb), LPSS_CNL_SSP },
 	/* APL */
 	{ PCI_VDEVICE(INTEL, 0x5ac2), LPSS_BXT_SSP },
 	{ PCI_VDEVICE(INTEL, 0x5ac4), LPSS_BXT_SSP },
-- 
2.20.1

