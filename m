Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3523C2DB3
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhGJCYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231908AbhGJCYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:24:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3927F613E8;
        Sat, 10 Jul 2021 02:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883728;
        bh=LTJWYMUPiITN3Wa6Cf/Hoco6oaVd8XiUe0xBl1/a+Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGplkn3OMf6cHh7S3IJ7VUI/Duaq5OaelPxDSLnaDTyznF7TZkXOC6FfD5YSefQhf
         STLV+XYtvPo9e3W8/IbeZ2GpP0QFpWpjaiy2keVhyfNeQvSIfhG0DPfRDxgx1eoat3
         MKJTHu02sb2nvu0t1ml6Fz5oHu3MlmPGf0IG068eiN94C6BHf5YDE2ocRyvxUH0d+S
         PcWelUaTXoGiaJ1w5FP1ByI6OMqLOirFwxTKg0FECfUEjM36Fx78rAcXB2eiCbAOiD
         V5JzJG78AfanCN64r+v1J2Jmbn+FdW4G8BPnB1j6GnN1OmbM8SoDLM0z1Sdd4M67BA
         XOBnj+RPDxyGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raymond Tan <raymond.tan@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 008/104] usb: dwc3: pci: Fix DEFINE for Intel Elkhart Lake
Date:   Fri,  9 Jul 2021 22:20:20 -0400
Message-Id: <20210710022156.3168825-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raymond Tan <raymond.tan@intel.com>

[ Upstream commit 457d22850b27de3aea336108272d08602c55fdf7 ]

There's no separate low power (LP) version of Elkhart Lake, thus
this patch updates the PCI Device ID DEFINE to indicate this.

Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Raymond Tan <raymond.tan@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20210512135901.28495-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 19789e94bbd0..45ec5ac9876e 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -36,7 +36,7 @@
 #define PCI_DEVICE_ID_INTEL_CNPH		0xa36e
 #define PCI_DEVICE_ID_INTEL_CNPV		0xa3b0
 #define PCI_DEVICE_ID_INTEL_ICLLP		0x34ee
-#define PCI_DEVICE_ID_INTEL_EHLLP		0x4b7e
+#define PCI_DEVICE_ID_INTEL_EHL			0x4b7e
 #define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
 #define PCI_DEVICE_ID_INTEL_TGPH		0x43ee
 #define PCI_DEVICE_ID_INTEL_JSP			0x4dee
@@ -167,7 +167,7 @@ static int dwc3_pci_quirks(struct dwc3_pci *dwc)
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
 		if (pdev->device == PCI_DEVICE_ID_INTEL_BXT ||
 		    pdev->device == PCI_DEVICE_ID_INTEL_BXT_M ||
-		    pdev->device == PCI_DEVICE_ID_INTEL_EHLLP) {
+		    pdev->device == PCI_DEVICE_ID_INTEL_EHL) {
 			guid_parse(PCI_INTEL_BXT_DSM_GUID, &dwc->guid);
 			dwc->has_dsm_for_pm = true;
 		}
@@ -375,8 +375,8 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICLLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_EHLLP),
-	  (kernel_ulong_t) &dwc3_pci_intel_swnode },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_EHL),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGPLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
-- 
2.30.2

