Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5820D35E6B0
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 20:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbhDMSwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 14:52:02 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:10344 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbhDMSwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 14:52:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618339905; x=1649875905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NVi2qJkQYl/QOl1GTnV0usjq9qMnoCW4gJoRXamww6w=;
  b=RO78e6w80GCL3QEku9NWvTMDnxERIln1KjBju+s6K+FkJW/YTKB1RTgT
   +bDpzoboTC1odlKMQ55e5boKMJjIqW7ILsFTWe1fGUPZqUVV//Gso1AVG
   GOklZ0scH4R7jAkFkdlycR22IAe7B+uwO5cbFNfyXB+RZZC2LCu+6Q6Y1
   zYhCIooKUdzDntVASyK+LKbn9WDZLSTnaHQAEKt1Q+5uxAssaXQB01LO2
   DXAPS/Q4DUN/EZqBliU+maljSXGwj5QIRHLWmzzlIb4UCh/+8NhVOuz+f
   If7DI2QG7oVlntQKiwc07Jz6ofATWu7JVk1G6vpsr+AEc8mzFXfF3mPI4
   Q==;
IronPort-SDR: N40JtfVe3x3ErXv9Ev5517iNN+Ps2L/S+OnrP3dvaVJbgsUHpnDK71RvEPddkVTvzxS6Bc9hHF
 pjIOEhJ5R9JWQJG+fFQ9tJ/nCffDWngj1aQIghnukh+c1KLFrpY7QYLaRO+ihUxW6j7zvuOJNQ
 s8qbTTBno4KVruXVduBe/ntnAD8GqZqL1QyEZIJrwxDbQiMlKJ6qsQJS5CzTUviBXVSptgLXQA
 hXgSUR9OfG1UoPMw6HqzRBXO94YM3X1Xm4xCBVDZZR0lbZDgYzqvfu1ZWr+u03pPb0UqIRkDtT
 8gs=
X-IronPort-AV: E=Sophos;i="5.82,220,1613404800"; 
   d="scan'208";a="268861792"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2021 02:51:33 +0800
IronPort-SDR: 5oeG8mTvCKJgRuRf5L+RdpDWEmnPj0I/yS9X1YkC3xTMGYKy+hJOlM1waAFeK2Z3vdqukoqrYb
 BuP7SN5MPQgYUHPy10pvg5CkD+eMAomVrGXVOe3MbYI0xhQ0BfgD4JTdXMLVu+qnLB1sh54Vo1
 p35VxfALu8XxpFfcOFhAMR109VHfanPnwuw2xM/6V8laqEMSXXQm9V6/4jpr52+552Qp7GrhiC
 umLvMPM8HGDG6kZwQCBSX2gGfdyaceBkgFbD2gBWkewfgq6WAu28er4njY+KxtpzMyQI8z1p2V
 gouHsUJO/YSKFAGlJ00rOG5x
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 11:32:31 -0700
IronPort-SDR: jmXfY52GUQmZNonCMjRsO2+wq47WQPo43xdrs5lgz9j/1Achg3B9eiwh3LxEJw99tRmgohCTsm
 UClL3UtrLIFGehSlb/mUr/IrdETaN1WkXZCxfdJsq8n0OQDg0EqOOymMgetQ6Xk3YXnhtVOhP1
 zEF8lCfkU3AmNvIXjQVedYb3NW4thvbZ4F/UaAIuXkz8jEXIFoyA0bgGA9dRloH2zpGqMg47L9
 2WUyJb8adLJ/fSriSMrmturivVz3grXR9Y3jQPfUc+WvD0ERtaOqNGEPkOHwYJagMTFO+XcdPS
 JJE=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Apr 2021 11:51:28 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     Prike.Liang@amd.com
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] PCI: add AMD PCIe quirk
Date:   Tue, 13 Apr 2021 11:51:18 -0700
Message-Id: <20210413185119.5655-2-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210413185119.5655-1-chaitanya.kulkarni@wdc.com>
References: <20210413185119.5655-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The NVME device pluged in some AMD PCIE root port will resume timeout
from s2idle which caused by NVME power CFG lost in the SMU FW restore.
This issue can be workaround by using PCIe power set with simple
suspend/resume process path instead of APST. In the onwards ASIC will
try do the NVME shutdown save and restore in the BIOS and still need PCIe
power setting to resume from RTD3 for s2idle.

In this preparation patch add a PCIe quirk for the AMD.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
[ck: split patches for nvme and pcie]
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc: <stable@vger.kernel.org> # 5.11+
---
 drivers/pci/quirks.c | 10 ++++++++++
 include/linux/pci.h  |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 653660e3ba9e..f95c8b2de25a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -312,6 +312,16 @@ static void quirk_nopciamd(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8151_0,	quirk_nopciamd);
 
+static void quirk_amd_nvme_fixup(struct pci_dev *dev)
+{
+	struct pci_dev *rdev;
+
+	dev->dev_flags |= PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND;
+	pci_info(dev, "AMD simple suspend opt enabled\n");
+
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1630, quirk_amd_nvme_fixup);
+
 /* Triton requires workarounds to be used by the drivers */
 static void quirk_triton(struct pci_dev *dev)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 86c799c97b77..cebc49e87707 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -227,6 +227,9 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_NO_FLR_RESET = (__force pci_dev_flags_t) (1 << 10),
 	/* Don't use Relaxed Ordering for TLPs directed at this device */
 	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
+	/* AMD simple suspend opt quirk */
+	PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND =
+					(__force pci_dev_flags_t) (1 << 12),
 };
 
 enum pci_irq_reroute_variant {
-- 
2.22.1

