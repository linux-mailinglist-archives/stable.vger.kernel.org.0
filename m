Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4236973E6
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 09:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfHUHvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 03:51:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:24467 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfHUHvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 03:51:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 00:51:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="329947256"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 21 Aug 2019 00:51:04 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        stable@vger.kernel.org
Subject: [GIT PULL v1 4/4] intel_th: pci: Add Tiger Lake support
Date:   Wed, 21 Aug 2019 10:49:55 +0300
Message-Id: <20190821074955.3925-5-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190821074955.3925-1-alexander.shishkin@linux.intel.com>
References: <20190821074955.3925-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds support for the Trace Hub in Tiger Lake PCH.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: stable@vger.kernel.org # v4.14+
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index 5c4e4fbec936..91dfeba62485 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -204,6 +204,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x45c5),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Tiger Lake PCH */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa0a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{ 0 },
 };
 
-- 
2.23.0.rc1

