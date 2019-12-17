Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33CF122AB6
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 12:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfLQLzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 06:55:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:39120 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbfLQLzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 06:55:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 03:55:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,325,1571727600"; 
   d="scan'208";a="205451578"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 17 Dec 2019 03:55:46 -0800
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 1/4] intel_th: pci: Add Comet Lake PCH-V support
Date:   Tue, 17 Dec 2019 13:55:24 +0200
Message-Id: <20191217115527.74383-2-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191217115527.74383-1-alexander.shishkin@linux.intel.com>
References: <20191217115527.74383-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds Intel(R) Trace Hub PCI ID for Comet Lake PCH-V.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index ebf3e30e989a..4b2f37578da3 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -204,6 +204,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x06a6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Comet Lake PCH-V */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa3a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{
 		/* Ice Lake NNPI */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x45c5),
-- 
2.24.0

