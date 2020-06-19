Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF3A201051
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391202AbgFSP3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404550AbgFSP26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95C8A21974;
        Fri, 19 Jun 2020 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580537;
        bh=ZZ/7u0dRUYQq7xXRqXJkbOWOoUv7KUK/GPWk8+8zg7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udmLIp9DwMTl21BIJ6dGBdhUV/cQsvjSNMhrGTsSRfePKcYs6OslkA9uu7puvPQHq
         d+DXqiWCFRpWVscbuQKshEbuHfS26/vkoEwLQL5GAvRVWv+MeuCzjdNRc8zA1wIRA1
         7R68RGOpgV7LCZFUxlIj48tCWRdtpsknn5ovP9C4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 288/376] serial: 8250_pci: Move Pericom IDs to pci_ids.h
Date:   Fri, 19 Jun 2020 16:33:26 +0200
Message-Id: <20200619141723.969439583@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
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
index 0804469ff052..1a74d511b02a 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1869,12 +1869,6 @@ pci_moxa_setup(struct serial_private *priv,
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
index 1dfc4e1dcb94..9a57e6717e5c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1832,6 +1832,12 @@
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



