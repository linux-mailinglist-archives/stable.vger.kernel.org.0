Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D63B103ABD
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 14:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfKTNIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 08:08:47 -0500
Received: from mga07.intel.com ([134.134.136.100]:42229 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbfKTNIr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 08:08:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 05:08:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,222,1571727600"; 
   d="scan'208";a="196848302"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 20 Nov 2019 05:08:27 -0800
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 2/3] intel_th: pci: Add Ice Lake CPU support
Date:   Wed, 20 Nov 2019 15:08:05 +0200
Message-Id: <20191120130806.44028-3-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120130806.44028-1-alexander.shishkin@linux.intel.com>
References: <20191120130806.44028-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds support for the Trace Hub in Ice Lake CPU.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index 91dfeba62485..04a956ece9f7 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -204,6 +204,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x45c5),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Ice Lake CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8a29),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{
 		/* Tiger Lake PCH */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa0a6),
-- 
2.24.0

