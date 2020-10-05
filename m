Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C36C2830B1
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 09:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgJEHNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 03:13:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:10321 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgJEHNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 03:13:45 -0400
IronPort-SDR: /Su1NUr/Jymq1cG2JiMA6a5UDih6klicJp+DgBWVXYBVOV5e+wj8h2quTBpWFeFJc3fErNrXsB
 JaGibMtgkIWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="227479280"
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="227479280"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 00:13:44 -0700
IronPort-SDR: 2fgGBSpZc6W9S/cEpbagK3r66wvPu0ILY77b0ryC/wlJXYV+v1Y8hTsbaRH4ngckWjYbaYnAiR
 DWDmjkBLYJ3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="309718120"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 05 Oct 2020 00:13:43 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 7/8] intel_th: pci: Add Alder Lake-S support
Date:   Mon,  5 Oct 2020 10:13:18 +0300
Message-Id: <20201005071319.78508-8-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005071319.78508-1-alexander.shishkin@linux.intel.com>
References: <20201005071319.78508-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds support for the Trace Hub in Alder Lake-S.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: stable@vger.kernel.org # v4.14+
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index 21fdf0b93516..dda4476b8553 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -263,6 +263,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x1bcc),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Alder Lake */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7aa6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{ 0 },
 };
 
-- 
2.28.0

