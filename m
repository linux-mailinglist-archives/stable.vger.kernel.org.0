Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32F835F995
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 19:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347350AbhDNRNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 13:13:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:3013 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347203AbhDNRNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 13:13:12 -0400
IronPort-SDR: Myw7lsq0W/KsMxo2RP6szAGXk0+0fgKDwT5nR9wDbxiVKyhE1yzs2VDHaNSR6khhnKOwuskzJ8
 ATdNLizxiHfw==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="181811946"
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="181811946"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 10:12:50 -0700
IronPort-SDR: UQckz1FkrQiQpsuD5xV8IlfJVgprDNyAIX/tM4mdkxtSeeyM2KJ4hWkE8FiQZIxpNvEPS+99t2
 771HW/BMYp6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="382428018"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 14 Apr 2021 10:12:48 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 6/7] intel_th: pci: Add Rocket Lake CPU support
Date:   Wed, 14 Apr 2021 20:12:50 +0300
Message-Id: <20210414171251.14672-7-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414171251.14672-1-alexander.shishkin@linux.intel.com>
References: <20210414171251.14672-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds support for the Trace Hub in Rocket Lake CPUs.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org> # v4.14+
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index 759994055cb4..a756c995fc7a 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -278,6 +278,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Rocket Lake CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{ 0 },
 };
 
-- 
2.30.2

