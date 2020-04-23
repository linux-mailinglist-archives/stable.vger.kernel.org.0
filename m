Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566961B68C0
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgDWXRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:17:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49230 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728306AbgDWXGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:41 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvR-0004gY-41; Fri, 24 Apr 2020 00:06:33 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvP-00E6nY-8A; Fri, 24 Apr 2020 00:06:31 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Felipe Balbi" <felipe.balbi@linux.intel.com>
Date:   Fri, 24 Apr 2020 00:05:33 +0100
Message-ID: <lsq.1587683028.180692525@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 106/245] usb: dwc3: pci: Add Support for Intel
 Elkhart Lake Devices
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <felipe.balbi@linux.intel.com>

commit dbb0569de852fb4576d6f62078d515f989a181ca upstream.

This patch simply adds a new PCI Device ID

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
[bwh: Backported to 3.16:
 - No properties support
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -42,6 +42,7 @@
 #define PCI_DEVICE_ID_INTEL_CNPLP	0x9dee
 #define PCI_DEVICE_ID_INTEL_CNPH	0xa36e
 #define PCI_DEVICE_ID_INTEL_ICLLP	0x34ee
+#define PCI_DEVICE_ID_INTEL_EHLLP	0x4b7e
 
 struct dwc3_pci {
 	struct device		*dev;
@@ -209,6 +210,7 @@ static const struct pci_device_id dwc3_p
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CNPLP), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CNPH), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICLLP), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_EHLLP), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);

