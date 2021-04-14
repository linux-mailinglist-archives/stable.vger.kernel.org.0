Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09A235F998
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 19:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345473AbhDNRNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 13:13:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:3013 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347495AbhDNRNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 13:13:14 -0400
IronPort-SDR: YLQjkXNT7SumxBiEW/sDGaq/DOcaiuHfUblZtFKyF/mUcJ89lwaAc/nxRIBBjInUGHyEkGRVfB
 AdQX+9DlKVGA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="181811952"
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="181811952"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 10:12:52 -0700
IronPort-SDR: vRh3F02xob3Jgmtzot2IaYvLGE9q9HNXdPRw8cFWkH010gRIJxVldoBaCj8waeKtXM+BrFb3Ku
 1BkG+TNTjjig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="382428039"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 14 Apr 2021 10:12:51 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 7/7] intel_th: pci: Add Alder Lake-M support
Date:   Wed, 14 Apr 2021 20:12:51 +0300
Message-Id: <20210414171251.14672-8-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414171251.14672-1-alexander.shishkin@linux.intel.com>
References: <20210414171251.14672-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds support for the Trace Hub in Alder Lake-M PCH.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v4.14+
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index a756c995fc7a..7da4f298ed01 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -273,6 +273,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x51a6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Alder Lake-M */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x54a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
-- 
2.30.2

