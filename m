Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936FC37877A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbhEJLPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236466AbhEJLIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F31F61998;
        Mon, 10 May 2021 11:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644489;
        bh=L8VDUPKv8QfZ92U9A2hsW7q1d3eFy7Gb1/0R1Qe6Ozc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9jvZ6IRrOsCH80uvZPO0JBYXX1bHeHTVvBDDDcD5aSso5YbIThZzF5nNPErT6bAe
         Kze+FsBmqENekwpHbqLhGFEc2GvQr/EAcu+Mizkx9ZkVhYTpUaXgyZoc78FB88yxeO
         smmQpWKAXbQBEMW7XaHznsj9BWHHhctNqCnzVniA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russ Weight <russell.h.weight@intel.com>,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>,
        Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 102/384] fpga: dfl: pci: add DID for D5005 PAC cards
Date:   Mon, 10 May 2021 12:18:11 +0200
Message-Id: <20210510102018.241055915@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russ Weight <russell.h.weight@intel.com>

[ Upstream commit a78a51a851ed3edc83264a67e2ba77a34f27965f ]

This patch adds the approved PCI Express Device IDs for the
PF and VF for the card for D5005 PAC cards.

Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Signed-off-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/dfl-pci.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/fpga/dfl-pci.c b/drivers/fpga/dfl-pci.c
index 04e47e266f26..b44523ea8c91 100644
--- a/drivers/fpga/dfl-pci.c
+++ b/drivers/fpga/dfl-pci.c
@@ -69,14 +69,16 @@ static void cci_pci_free_irq(struct pci_dev *pcidev)
 }
 
 /* PCI Device ID */
-#define PCIE_DEVICE_ID_PF_INT_5_X	0xBCBD
-#define PCIE_DEVICE_ID_PF_INT_6_X	0xBCC0
-#define PCIE_DEVICE_ID_PF_DSC_1_X	0x09C4
-#define PCIE_DEVICE_ID_INTEL_PAC_N3000	0x0B30
+#define PCIE_DEVICE_ID_PF_INT_5_X		0xBCBD
+#define PCIE_DEVICE_ID_PF_INT_6_X		0xBCC0
+#define PCIE_DEVICE_ID_PF_DSC_1_X		0x09C4
+#define PCIE_DEVICE_ID_INTEL_PAC_N3000		0x0B30
+#define PCIE_DEVICE_ID_INTEL_PAC_D5005		0x0B2B
 /* VF Device */
-#define PCIE_DEVICE_ID_VF_INT_5_X	0xBCBF
-#define PCIE_DEVICE_ID_VF_INT_6_X	0xBCC1
-#define PCIE_DEVICE_ID_VF_DSC_1_X	0x09C5
+#define PCIE_DEVICE_ID_VF_INT_5_X		0xBCBF
+#define PCIE_DEVICE_ID_VF_INT_6_X		0xBCC1
+#define PCIE_DEVICE_ID_VF_DSC_1_X		0x09C5
+#define PCIE_DEVICE_ID_INTEL_PAC_D5005_VF	0x0B2C
 
 static struct pci_device_id cci_pcie_id_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_INT_5_X),},
@@ -86,6 +88,8 @@ static struct pci_device_id cci_pcie_id_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_DSC_1_X),},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_VF_DSC_1_X),},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_PAC_N3000),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_PAC_D5005),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_PAC_D5005_VF),},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, cci_pcie_id_tbl);
-- 
2.30.2



