Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BB911EF6
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfEBPoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbfEBP0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:26:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C48FA20C01;
        Thu,  2 May 2019 15:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810781;
        bh=uGYza00XV509ulcCWStHCVAXfERLnsbLdzv62TTibjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLuAJnzM++Jl4FoZL9UnrnoYDMJtHXVN0VQUnW8PRMLYae7vaFwuulwSdhI5MEEG0
         WEJZrhti4tQxXWNXhTu5Zb1abFZ0LZNnkatk/9CbV7qgUQCGqcVmHNzzMGjiF3DMFV
         OAue22Fq7A4TzjRSmQ2OLr1kwNIDbISAvTzN/MTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 27/72] usb: dwc3: pci: add support for Comet Lake PCH ID
Date:   Thu,  2 May 2019 17:20:49 +0200
Message-Id: <20190502143335.591920570@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7ae622c978db6b2e28b4fced6ecd2a174492059d ]

This patch simply adds a new PCI Device ID

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index fdc6e4e403e8..8cced3609e24 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -29,6 +29,7 @@
 #define PCI_DEVICE_ID_INTEL_BXT_M		0x1aaa
 #define PCI_DEVICE_ID_INTEL_APL			0x5aaa
 #define PCI_DEVICE_ID_INTEL_KBP			0xa2b0
+#define PCI_DEVICE_ID_INTEL_CMLH		0x02ee
 #define PCI_DEVICE_ID_INTEL_GLK			0x31aa
 #define PCI_DEVICE_ID_INTEL_CNPLP		0x9dee
 #define PCI_DEVICE_ID_INTEL_CNPH		0xa36e
@@ -305,6 +306,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
 	  (kernel_ulong_t) &dwc3_pci_mrfld_properties, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_CMLH),
+	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SPTLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
 
-- 
2.19.1



