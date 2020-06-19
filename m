Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51123201518
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394556AbgFSQSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390787AbgFSPCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3574E2186A;
        Fri, 19 Jun 2020 15:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578925;
        bh=71QOEYd4mBZicWPn2Biybt/GmESDda4rHMGH7Q1BeRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJwE6hoxDZGud0h4vQrUsAz7UH8fEgV0Sb3s71K1Mt0lTK8zKVzPWPGS7yPrAs+Sq
         +cfqaKA0DelKQt5kl96XsCL4ZrWns0S+FYHcjYFUw95GE0EqSuS4tI/Jb0bt1U5zDU
         70wmf3ZbA6pxAgWdnAPahSatdTzmIDqWeX3Ph7Jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 209/267] PCI: Move Synopsys HAPS platform device IDs
Date:   Fri, 19 Jun 2020 16:33:14 +0200
Message-Id: <20200619141658.760043050@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <thinh.nguyen@synopsys.com>

[ Upstream commit b6061b1e566d70c7686d194a6c47dc6ffa665c77 ]

Move Synopsys HAPS platform device IDs to pci_ids.h so that both
drivers/pci/quirks.c and dwc3-haps driver can reference these IDs.

Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-haps.c | 4 ----
 include/linux/pci_ids.h      | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-haps.c b/drivers/usb/dwc3/dwc3-haps.c
index c9cc33881bef..02d57d98ef9b 100644
--- a/drivers/usb/dwc3/dwc3-haps.c
+++ b/drivers/usb/dwc3/dwc3-haps.c
@@ -15,10 +15,6 @@
 #include <linux/platform_device.h>
 #include <linux/property.h>
 
-#define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3		0xabcd
-#define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3_AXI	0xabce
-#define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB31	0xabcf
-
 /**
  * struct dwc3_haps - Driver private structure
  * @dwc3: child dwc3 platform_device
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 2792bca03088..05705d0b5689 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2361,6 +2361,9 @@
 #define PCI_DEVICE_ID_CENATEK_IDE	0x0001
 
 #define PCI_VENDOR_ID_SYNOPSYS		0x16c3
+#define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3		0xabcd
+#define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3_AXI	0xabce
+#define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB31	0xabcf
 
 #define PCI_VENDOR_ID_USR		0x16ec
 
-- 
2.25.1



