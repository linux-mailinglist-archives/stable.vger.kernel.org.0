Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E675B2599F3
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgIAQqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730190AbgIAP1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:27:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BCBA206FA;
        Tue,  1 Sep 2020 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974039;
        bh=KgBhFEvDd4HhOIDlllG/eGKY+sri+AR5ajXaMJEUJ+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYEsh8DaFoXPX6M+2qjDpGnROzjgfqjak90iF9hGiqTBpMofJXUz7LRsiGTX49lkm
         UmOTpCk+CUxLgy1lXxwPkgx2SjQGgIFgTvojlyNITPDcjFeUjv16KLnjO1LeV40kTB
         Rpa8V/3DM0UkehZ7lM5Q1MtWBI9O2GMDOgIBNeqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/214] mfd: intel-lpss: Add Intel Emmitsburg PCH PCI IDs
Date:   Tue,  1 Sep 2020 17:08:20 +0200
Message-Id: <20200901150953.936263152@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3ea2e4eab64cefa06055bb0541fcdedad4b48565 ]

Intel Emmitsburg PCH has the same LPSS than Intel Ice Lake.
Add the new IDs to the list of supported devices.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
index b33030e3385c7..bc0f3c22021b7 100644
--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -196,6 +196,9 @@ static const struct pci_device_id intel_lpss_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x1ac4), (kernel_ulong_t)&bxt_info },
 	{ PCI_VDEVICE(INTEL, 0x1ac6), (kernel_ulong_t)&bxt_info },
 	{ PCI_VDEVICE(INTEL, 0x1aee), (kernel_ulong_t)&bxt_uart_info },
+	/* EBG */
+	{ PCI_VDEVICE(INTEL, 0x1bad), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0x1bae), (kernel_ulong_t)&bxt_uart_info },
 	/* GLK */
 	{ PCI_VDEVICE(INTEL, 0x31ac), (kernel_ulong_t)&glk_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0x31ae), (kernel_ulong_t)&glk_i2c_info },
-- 
2.25.1



