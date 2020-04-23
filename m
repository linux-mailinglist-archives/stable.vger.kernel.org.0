Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD691B68CB
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgDWXRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:17:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49102 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728287AbgDWXGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:39 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvQ-0004gE-GB; Fri, 24 Apr 2020 00:06:32 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvP-00E6nJ-10; Fri, 24 Apr 2020 00:06:31 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Heikki Krogerus" <heikki.krogerus@linux.intel.com>,
        "Felipe Balbi" <felipe.balbi@linux.intel.com>
Date:   Fri, 24 Apr 2020 00:05:30 +0100
Message-ID: <lsq.1587683028.608558908@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 103/245] usb: dwc3: pci: add Intel Cannonlake PCI IDs
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

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 682179592e48fa66056fbad1a86604be4992f885 upstream.

Intel Cannonlake PCH has the same DWC3 than Intel
Sunrisepoint. Add the new IDs to the supported devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
[bwh: Backported to 3.16: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -38,6 +38,8 @@
 #define PCI_DEVICE_ID_INTEL_APL		0x5aaa
 #define PCI_DEVICE_ID_INTEL_KBP		0xa2b0
 #define PCI_DEVICE_ID_INTEL_GLK		0x31aa
+#define PCI_DEVICE_ID_INTEL_CNPLP	0x9dee
+#define PCI_DEVICE_ID_INTEL_CNPH	0xa36e
 
 struct dwc3_pci {
 	struct device		*dev;
@@ -201,6 +203,8 @@ static const struct pci_device_id dwc3_p
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_APL), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_KBP), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_GLK), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CNPLP), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CNPH), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);

