Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5B422EF6C
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730826AbgG0OQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730835AbgG0OQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:16:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51CA920775;
        Mon, 27 Jul 2020 14:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859377;
        bh=ryk1JkLK4R/2OzRJdodKgOOsjjAB4I2jemhgOQ6/pEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfALPcFbNQTxlXyoVWEo4eSwbIGb7Q/FlS0HdoSkS0EE+/QvhhUr8K9bBoLE/yOti
         W1YdnuuieCVS3RQWlZnoArvHf5FIEXTBexpzlIYIhxxe/VUPCjOI0M3XhMgDBF9Kpd
         zi768sA3vz8xgCirrmhC6RWVX9UGl6VikeMaKPWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/138] usb: dwc3: pci: add support for the Intel Tiger Lake PCH -H variant
Date:   Mon, 27 Jul 2020 16:04:40 +0200
Message-Id: <20200727134929.620975084@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit c3f595a8119207cc0f82b3dc6ec5bbf6f3e6b135 ]

This patch adds the necessary PCI ID for TGP-H devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 96c05b121fac8..47b7e83d90626 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -38,6 +38,7 @@
 #define PCI_DEVICE_ID_INTEL_ICLLP		0x34ee
 #define PCI_DEVICE_ID_INTEL_EHLLP		0x4b7e
 #define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
+#define PCI_DEVICE_ID_INTEL_TGPH		0x43ee
 
 #define PCI_INTEL_BXT_DSM_GUID		"732b85d5-b7a7-4a1b-9ba0-4bbd00ffd511"
 #define PCI_INTEL_BXT_FUNC_PMU_PWR	4
@@ -358,6 +359,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGPLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGPH),
+	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
+
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_NL_USB),
 	  (kernel_ulong_t) &dwc3_pci_amd_properties, },
 	{  }	/* Terminating Entry */
-- 
2.25.1



