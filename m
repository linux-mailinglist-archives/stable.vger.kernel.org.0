Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B0A200EFE
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392036AbgFSPNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:13:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389288AbgFSPNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:13:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EC5B20776;
        Fri, 19 Jun 2020 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579625;
        bh=vnJnuGcOif0ZQt2pk1jhNRe0T23Cva12UBps7k4pmTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AmrFZGnKzn2iXdKqYlSszlQKxCu+UlGazTj33uZs7qI9yQKsu9ZfqdY4wFTao1P7
         NhFiEmA5qGYpTfNrXoqPmL7n8/VEViOtHdluFdvnW8J6WAXo+7P5k25JJngDwuv+Gm
         Vnf+cXap5GlT2bBzFd8VSXxM0kF82+P8NvpjhUuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/261] PCI: vmd: Add device id for VMD device 8086:9A0B
Date:   Fri, 19 Jun 2020 16:33:19 +0200
Message-Id: <20200619141658.920530144@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

[ Upstream commit ec11e5c213cc20cac5e8310728b06793448b9f6d ]

This patch adds support for this VMD device which supports the bus
restriction mode.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 2 ++
 include/linux/pci_ids.h      | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index a35d3f3996d7..afc1a3d240b5 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -854,6 +854,8 @@ static const struct pci_device_id vmd_ids[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_VMD_28C0),
 		.driver_data = VMD_FEAT_HAS_MEMBAR_SHADOW |
 				VMD_FEAT_HAS_BUS_RESTRICTIONS,},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_VMD_9A0B),
+		.driver_data = VMD_FEAT_HAS_BUS_RESTRICTIONS,},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, vmd_ids);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 228f66347620..dae9ffe4478f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3008,6 +3008,7 @@
 #define PCI_DEVICE_ID_INTEL_84460GX	0x84ea
 #define PCI_DEVICE_ID_INTEL_IXP4XX	0x8500
 #define PCI_DEVICE_ID_INTEL_IXP2800	0x9004
+#define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
 #define PCI_VENDOR_ID_SCALEMP		0x8686
-- 
2.25.1



