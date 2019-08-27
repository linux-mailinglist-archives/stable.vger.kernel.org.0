Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC1D9E0AC
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbfH0IEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731737AbfH0IEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:04:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE6582184D;
        Tue, 27 Aug 2019 08:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893061;
        bh=bS5fJU6Q5vs0dVw3qx7MQAt99UORwMPBakMMNkqV5kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKMLqski7fYhdYe4pyuLjgRGVK+Q0zt3nj2ck38Emw8UA2ZOmV+M8FZTa8i4dHhIE
         iJlpnFmYkDvQkhOlycWLnckJmpbLJwz3BQQpSDFBsflyoC1suh8Bfjkcnz95pKpTio
         vUjHde79qDLIYv/FleSh1Rex65EChnVBNb4/fQrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 065/162] spi: pxa2xx: Add support for Intel Tiger Lake
Date:   Tue, 27 Aug 2019 09:49:53 +0200
Message-Id: <20190827072740.418385720@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a4127952859a869cf3fc5a49547dbe2ffa2eac89 ]

Intel Tiger Lake -LP LPSS SPI controller is otherwise similar than
Cannon Lake but has more controllers and up to two chip selects per
controller.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20190801134901.12635-1-jarkko.nikula@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index c1af8887d9186..1f32c9e3ca65c 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1453,6 +1453,14 @@ static const struct pci_device_id pxa2xx_spi_pci_compound_match[] = {
 	{ PCI_VDEVICE(INTEL, 0x02aa), LPSS_CNL_SSP },
 	{ PCI_VDEVICE(INTEL, 0x02ab), LPSS_CNL_SSP },
 	{ PCI_VDEVICE(INTEL, 0x02fb), LPSS_CNL_SSP },
+	/* TGL-LP */
+	{ PCI_VDEVICE(INTEL, 0xa0aa), LPSS_CNL_SSP },
+	{ PCI_VDEVICE(INTEL, 0xa0ab), LPSS_CNL_SSP },
+	{ PCI_VDEVICE(INTEL, 0xa0de), LPSS_CNL_SSP },
+	{ PCI_VDEVICE(INTEL, 0xa0df), LPSS_CNL_SSP },
+	{ PCI_VDEVICE(INTEL, 0xa0fb), LPSS_CNL_SSP },
+	{ PCI_VDEVICE(INTEL, 0xa0fd), LPSS_CNL_SSP },
+	{ PCI_VDEVICE(INTEL, 0xa0fe), LPSS_CNL_SSP },
 	{ },
 };
 
-- 
2.20.1



