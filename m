Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7F1200E03
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391097AbgFSPEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:04:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391075AbgFSPEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:04:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFD5621BE5;
        Fri, 19 Jun 2020 15:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579044;
        bh=cZPf0UtNWH0uESVxUsiQsfii7dgWe+ZEcCUAOQqq2TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWODFXpKDCi9roM4K9PX6ibb/jxNzIfPYbbcVvpMNFGBqcv1HWewCU2Z0IGYy+3Hb
         WhDvzv8cOPudB+peY/bU6oSLkyZldlG1ieSCJPR3gBeE4wOmU/egE/9wGGBCVdvchN
         O78o5ZQ6ay8ri9bukqgUSMIerA0bXWvaz3UMDw7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 224/267] serial: 8250_pci: Move Pericom IDs to pci_ids.h
Date:   Fri, 19 Jun 2020 16:33:29 +0200
Message-Id: <20200619141659.452856976@linuxfoundation.org>
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

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 62a7f3009a460001eb46984395280dd900bc4ef4 ]

Move the IDs to pci_ids.h so it can be used by next patch.

Link: https://lore.kernel.org/r/20200508065343.32751-1-kai.heng.feng@canonical.com
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci.c | 6 ------
 include/linux/pci_ids.h            | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index bbe5cba21522..02091782bc1e 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1690,12 +1690,6 @@ pci_wch_ch38x_setup(struct serial_private *priv,
 #define PCIE_DEVICE_ID_WCH_CH384_4S	0x3470
 #define PCIE_DEVICE_ID_WCH_CH382_2S	0x3253
 
-#define PCI_VENDOR_ID_PERICOM			0x12D8
-#define PCI_DEVICE_ID_PERICOM_PI7C9X7951	0x7951
-#define PCI_DEVICE_ID_PERICOM_PI7C9X7952	0x7952
-#define PCI_DEVICE_ID_PERICOM_PI7C9X7954	0x7954
-#define PCI_DEVICE_ID_PERICOM_PI7C9X7958	0x7958
-
 #define PCI_VENDOR_ID_ACCESIO			0x494f
 #define PCI_DEVICE_ID_ACCESIO_PCIE_COM_2SDB	0x1051
 #define PCI_DEVICE_ID_ACCESIO_MPCIE_COM_2S	0x1053
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 14baae112a54..c0dd2f749d3f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1833,6 +1833,12 @@
 #define PCI_VENDOR_ID_NVIDIA_SGS	0x12d2
 #define PCI_DEVICE_ID_NVIDIA_SGS_RIVA128 0x0018
 
+#define PCI_VENDOR_ID_PERICOM			0x12D8
+#define PCI_DEVICE_ID_PERICOM_PI7C9X7951	0x7951
+#define PCI_DEVICE_ID_PERICOM_PI7C9X7952	0x7952
+#define PCI_DEVICE_ID_PERICOM_PI7C9X7954	0x7954
+#define PCI_DEVICE_ID_PERICOM_PI7C9X7958	0x7958
+
 #define PCI_SUBVENDOR_ID_CHASE_PCIFAST		0x12E0
 #define PCI_SUBDEVICE_ID_CHASE_PCIFAST4		0x0031
 #define PCI_SUBDEVICE_ID_CHASE_PCIFAST8		0x0021
-- 
2.25.1



