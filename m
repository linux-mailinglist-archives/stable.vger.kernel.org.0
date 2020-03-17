Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB2118798D
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 07:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgCQGWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 02:22:46 -0400
Received: from mga12.intel.com ([192.55.52.136]:53584 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbgCQGWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 02:22:45 -0400
IronPort-SDR: +azU9KTbT/uGwkqhfzF0glUxJs9xhBgjquxo58d+DCn2Rz7vtqv85pkCJCFFxHqe1you1W7jjG
 ZPTnJJdv8EyA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 23:22:45 -0700
IronPort-SDR: 0Rart/UNFK9CkZpPLwjAesvd0ykiK1JmZTlo/PiaByT8Fe6TQGGmSt/YMeQBgrrQ7QFgli2Ylq
 hZaSQAs7Bp9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="445390328"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 16 Mar 2020 23:22:43 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 6/6] intel_th: pci: Add Elkhart Lake CPU support
Date:   Tue, 17 Mar 2020 08:22:15 +0200
Message-Id: <20200317062215.15598-7-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
References: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds support for the Trace Hub in Elkhart Lake CPU.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index ad7e51ebe49e..7ccac74553a6 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -238,6 +238,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4da6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Elkhart Lake CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4529),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{
 		/* Elkhart Lake */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4b26),
-- 
2.25.1

