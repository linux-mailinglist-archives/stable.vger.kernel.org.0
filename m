Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10C62B62F7
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732081AbgKQNdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:33:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732075AbgKQNdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A03472078E;
        Tue, 17 Nov 2020 13:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620018;
        bh=tdRDeBb688Tbj/zy/2sTeleiGzaqdpmOChiOlz+fbb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6/2hzKShMKR+P2lQyo0kcE1rYJEfeEsCiqUrMPG//BAgSZ2Dh9MtlhpDar6b2wGn
         +lLhsNFINJV+Q/XUkqtVFAY4pAJECjIGQd1qfepLf9WNnS0M6o564UI1/g3BPlqJ8O
         Nz4tNkjRi7IUbZGx0p4UvwQPePUddLoiEzQjMO7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 080/255] usb: dwc3: pci: add support for the Intel Alder Lake-S
Date:   Tue, 17 Nov 2020 14:03:40 +0100
Message-Id: <20201117122142.844636842@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 1384ab4fee12c4c4f8bd37bc9f8686881587b286 ]

This patch adds the necessary PCI ID for Intel Alder Lake-S
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 242b6210380a4..bae6a70664c80 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -40,6 +40,7 @@
 #define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
 #define PCI_DEVICE_ID_INTEL_TGPH		0x43ee
 #define PCI_DEVICE_ID_INTEL_JSP			0x4dee
+#define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
 
 #define PCI_INTEL_BXT_DSM_GUID		"732b85d5-b7a7-4a1b-9ba0-4bbd00ffd511"
 #define PCI_INTEL_BXT_FUNC_PMU_PWR	4
@@ -367,6 +368,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_JSP),
 	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADLS),
+	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
+
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_NL_USB),
 	  (kernel_ulong_t) &dwc3_pci_amd_properties, },
 	{  }	/* Terminating Entry */
-- 
2.27.0



