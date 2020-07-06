Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926FB215B99
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 18:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgGFQNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 12:13:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:10083 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbgGFQNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 12:13:52 -0400
IronPort-SDR: C3AQHKixvhCZnxsg/Mr1F9c+B6XmgSE5zl/TNKPlcDQBIO2iQzofH0p+bkXnR5ozp0YjLED4gU
 wJnmjREZ1Cgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9673"; a="146520663"
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="146520663"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 09:13:52 -0700
IronPort-SDR: NQtfma3Qh61Hy+cAr24WO5ZRPjPT6HNuqrAqUUKQ+40BkwqhsWROzPIRqCFen+NMeV5SAAZfuQ
 S3IUSFqr+BPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="283084190"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 06 Jul 2020 09:13:49 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] intel_th: pci: Add Jasper Lake CPU support
Date:   Mon,  6 Jul 2020 19:13:36 +0300
Message-Id: <20200706161339.55468-2-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706161339.55468-1-alexander.shishkin@linux.intel.com>
References: <20200706161339.55468-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds support for the Trace Hub in Jasper Lake CPU.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v4.14+
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index 7ccac74553a6..f1dc1eef9ba2 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -238,6 +238,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4da6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Jasper Lake CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4e29),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{
 		/* Elkhart Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4529),
-- 
2.27.0

