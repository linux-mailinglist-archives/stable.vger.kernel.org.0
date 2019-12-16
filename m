Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F16112138B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbfLPSCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbfLPSCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:02:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15C3420700;
        Mon, 16 Dec 2019 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519355;
        bh=KcBt+yw1EEX1lJ66mdf9EzMUbehHmEDYVMVolsts3S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ScZ58oZ1fSJZ7ektP6cu4pQLllEOcr2zl8Sc3VkQxbVqYQQMWcMexEyI0sJcA8PD
         IM7smlzjfJbf4SK9AiArOoXFisFiIHnchPZUTKmKzIjownJ5qlcwiZ7ta6oMddCTLo
         zOqe1vnjDC84bSyU2dEjjVaHZgY1eaBYVut4oCS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.19 032/140] usb: dwc3: pci: add ID for the Intel Comet Lake -H variant
Date:   Mon, 16 Dec 2019 18:48:20 +0100
Message-Id: <20191216174758.199333810@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 3c3caae4cd6e122472efcf64759ff6392fb6bce2 upstream.

The original ID that was added for Comet Lake PCH was
actually for the -LP (low power) variant even though the
constant for it said CMLH. Changing that while at it.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191212093713.60614-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/dwc3-pci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -29,7 +29,8 @@
 #define PCI_DEVICE_ID_INTEL_BXT_M		0x1aaa
 #define PCI_DEVICE_ID_INTEL_APL			0x5aaa
 #define PCI_DEVICE_ID_INTEL_KBP			0xa2b0
-#define PCI_DEVICE_ID_INTEL_CMLH		0x02ee
+#define PCI_DEVICE_ID_INTEL_CMLLP		0x02ee
+#define PCI_DEVICE_ID_INTEL_CMLH		0x06ee
 #define PCI_DEVICE_ID_INTEL_GLK			0x31aa
 #define PCI_DEVICE_ID_INTEL_CNPLP		0x9dee
 #define PCI_DEVICE_ID_INTEL_CNPH		0xa36e
@@ -306,6 +307,9 @@ static const struct pci_device_id dwc3_p
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
 	  (kernel_ulong_t) &dwc3_pci_mrfld_properties, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_CMLLP),
+	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_CMLH),
 	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
 


