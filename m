Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761DA14E108
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgA3Skv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbgA3Skt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:40:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4640D205F4;
        Thu, 30 Jan 2020 18:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409648;
        bh=Uyts+bCz/NHWkyUpy2uc0xejtrqIFr1mu7HfUw+1riM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxYa0I+KoCyaz8JQkHeLjNrgxb9lnhKQ+Y+Fn2rFDe2Yll6cKMxWPPamcm3IB88O4
         ssofvB6SOEhhct6vpAFI1RS0cKFFUARMhKw2zXRN6iL5pUDYiy6Mihk797QA0624CV
         1nf2lW2w2f9VYh0zfKpcsmACEsme0SCuYkvOlA1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.5 04/56] usb: dwc3: pci: add ID for the Intel Comet Lake -V variant
Date:   Thu, 30 Jan 2020 19:38:21 +0100
Message-Id: <20200130183609.826754441@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit f5ae8869095552e3396ee3e404f9586cc6a828f0 upstream.

There is one more Comet Lake PCH variant, CML-V, that has
its own PCI ID.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200117093033.48616-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/dwc3-pci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -34,6 +34,7 @@
 #define PCI_DEVICE_ID_INTEL_GLK			0x31aa
 #define PCI_DEVICE_ID_INTEL_CNPLP		0x9dee
 #define PCI_DEVICE_ID_INTEL_CNPH		0xa36e
+#define PCI_DEVICE_ID_INTEL_CNPV		0xa3b0
 #define PCI_DEVICE_ID_INTEL_ICLLP		0x34ee
 #define PCI_DEVICE_ID_INTEL_EHLLP		0x4b7e
 #define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
@@ -342,6 +343,9 @@ static const struct pci_device_id dwc3_p
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_CNPH),
 	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_CNPV),
+	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICLLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
 


