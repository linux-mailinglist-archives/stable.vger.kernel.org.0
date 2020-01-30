Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC78C14E250
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgA3SpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731016AbgA3SpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 735972082E;
        Thu, 30 Jan 2020 18:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409922;
        bh=z0Eloz/7uH30N/JaCMyrHQ6PHSsN/zgQzEJaOUFKGCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QP2iy013wLE5fS+XCoj9QVpZ/6y3JOn4RQMOR5usAASl6aQ4dsZHmOKQTzCB0tXw8
         c6gPCVDRo+UTUp4ZT8OEssFFS41Av1nsGnoxnkixuPhBs4+XtTf3B/mxAoOTi27McN
         DVdLX1m34Xtk6jOmPvRanSA5a3BNR/LLLnbagtB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/110] spi: pxa2xx: Add support for Intel Comet Lake-H
Date:   Thu, 30 Jan 2020 19:39:01 +0100
Message-Id: <20200130183624.185123304@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



