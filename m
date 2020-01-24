Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6744E147688
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbgAXBUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730396AbgAXBRX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C7D72087E;
        Fri, 24 Jan 2020 01:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828642;
        bh=z0Eloz/7uH30N/JaCMyrHQ6PHSsN/zgQzEJaOUFKGCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jccYSLQ1LmqUy9YDf/7GAgZnou0SKt+kEvDD4Dy/t8PjhkdataAD3TuzWbA4Mksha
         zNnhBZmmmCcmqbwvc1S09wIAQmN0P4T9u18yofnNB25PWCHgnojVavQusuLPO/WbYs
         OC0DRiB4ipNTllwizMrJCZ0CJt8T59GLd2owa7y8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/33] spi: pxa2xx: Add support for Intel Comet Lake-H
Date:   Thu, 23 Jan 2020 20:16:47 -0500
Message-Id: <20200124011708.18232-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit f0cf17ed76cffa365001d263ced1f130ec794917 ]

Add Intel Comet Lake-H LPSS SPI PCI IDs.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20191029115802.6779-1-jarkko.nikula@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 9f92165fe09f8..2fd843b18297d 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1461,6 +1461,10 @@ static const struct pci_device_id pxa2xx_spi_pci_compound_match[] = {
 	{ PCI_VDEVICE(INTEL, 0x02aa), LPSS_CNL_SSP },
 	{ PCI_VDEVICE(INTEL, 0x02ab), LPSS_CNL_SSP },
 	{ PCI_VDEVICE(INTEL, 0x02fb), LPSS_CNL_SSP },
+	/* CML-H */
+	{ PCI_VDEVICE(INTEL, 0x06aa), LPSS_CNL_SSP },
+	{ PCI_VDEVICE(INTEL, 0x06ab), LPSS_CNL_SSP },
+	{ PCI_VDEVICE(INTEL, 0x06fb), LPSS_CNL_SSP },
 	/* TGL-LP */
 	{ PCI_VDEVICE(INTEL, 0xa0aa), LPSS_CNL_SSP },
 	{ PCI_VDEVICE(INTEL, 0xa0ab), LPSS_CNL_SSP },
-- 
2.20.1

