Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE84C200DD2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390799AbgFSPCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390793AbgFSPCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A9D52193E;
        Fri, 19 Jun 2020 15:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578928;
        bh=INhRY3Oos2mJKymCZriRZ4iTs0rSo4VdvCTFl3hg/LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbCvxiFDtxmlgmRR+AjYzzgcv3mDpgad4MwhA2oNtrX2AmsPbtSZKkbsuIz66C9y7
         WAch6shWABxGC5CmK6nnaiEST42fiDBRyxoMhgPWwWT75XoCLc9jtbYcLJ/RGgvmOR
         n/wfy1jqmhg7JFpD48Gt9blZzIJdyTDuX6pUkQzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 210/267] PCI: Move Rohm Vendor ID to generic list
Date:   Fri, 19 Jun 2020 16:33:15 +0200
Message-Id: <20200619141658.808434176@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0ce26a1c31ca928df4dfc7504c8898b71ff9f5d5 ]

Move the Rohm Vendor ID to pci_ids.h instead of defining it in several
drivers.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pch_dma.c                                | 1 -
 drivers/gpio/gpio-ml-ioh.c                           | 2 --
 drivers/gpio/gpio-pch.c                              | 1 -
 drivers/i2c/busses/i2c-eg20t.c                       | 1 -
 drivers/misc/pch_phub.c                              | 1 -
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 7 ++-----
 drivers/spi/spi-topcliff-pch.c                       | 1 -
 drivers/tty/serial/pch_uart.c                        | 2 --
 drivers/usb/gadget/udc/pch_udc.c                     | 1 -
 include/linux/pci_ids.h                              | 2 ++
 10 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 6e91584c3677..47c6e3ceac4d 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -972,7 +972,6 @@ static void pch_dma_remove(struct pci_dev *pdev)
 }
 
 /* PCI Device ID of DMA device */
-#define PCI_VENDOR_ID_ROHM             0x10DB
 #define PCI_DEVICE_ID_EG20T_PCH_DMA_8CH        0x8810
 #define PCI_DEVICE_ID_EG20T_PCH_DMA_4CH        0x8815
 #define PCI_DEVICE_ID_ML7213_DMA1_8CH	0x8026
diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 51c7d1b84c2e..0c076dce9e17 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -31,8 +31,6 @@
 
 #define IOH_IRQ_BASE		0
 
-#define PCI_VENDOR_ID_ROHM             0x10DB
-
 struct ioh_reg_comn {
 	u32	ien;
 	u32	istatus;
diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index ffce0ab912ed..8c7f3d20e30e 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -524,7 +524,6 @@ static int pch_gpio_resume(struct pci_dev *pdev)
 #define pch_gpio_resume NULL
 #endif
 
-#define PCI_VENDOR_ID_ROHM             0x10DB
 static const struct pci_device_id pch_gpio_pcidev_id[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 835d54ac2971..231675b10376 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -177,7 +177,6 @@ static wait_queue_head_t pch_event;
 static DEFINE_MUTEX(pch_mutex);
 
 /* Definition for ML7213 by LAPIS Semiconductor */
-#define PCI_VENDOR_ID_ROHM		0x10DB
 #define PCI_DEVICE_ID_ML7213_I2C	0x802D
 #define PCI_DEVICE_ID_ML7223_I2C	0x8010
 #define PCI_DEVICE_ID_ML7831_I2C	0x8817
diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 540845651b8c..309703e9c42e 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -64,7 +64,6 @@
 #define CLKCFG_UARTCLKSEL			(1 << 18)
 
 /* Macros for ML7213 */
-#define PCI_VENDOR_ID_ROHM			0x10db
 #define PCI_DEVICE_ID_ROHM_ML7213_PHUB		0x801A
 
 /* Macros for ML7223 */
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 43c0c10dfeb7..3a4225837049 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -27,7 +27,6 @@
 #define DRV_VERSION     "1.01"
 const char pch_driver_version[] = DRV_VERSION;
 
-#define PCI_DEVICE_ID_INTEL_IOH1_GBE	0x8802		/* Pci device ID */
 #define PCH_GBE_MAR_ENTRIES		16
 #define PCH_GBE_SHORT_PKT		64
 #define DSC_INIT16			0xC000
@@ -37,11 +36,9 @@ const char pch_driver_version[] = DRV_VERSION;
 #define PCH_GBE_PCI_BAR			1
 #define PCH_GBE_RESERVE_MEMORY		0x200000	/* 2MB */
 
-/* Macros for ML7223 */
-#define PCI_VENDOR_ID_ROHM			0x10db
-#define PCI_DEVICE_ID_ROHM_ML7223_GBE		0x8013
+#define PCI_DEVICE_ID_INTEL_IOH1_GBE		0x8802
 
-/* Macros for ML7831 */
+#define PCI_DEVICE_ID_ROHM_ML7223_GBE		0x8013
 #define PCI_DEVICE_ID_ROHM_ML7831_GBE		0x8802
 
 #define PCH_GBE_TX_WEIGHT         64
diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index fa730a871d25..8a5966963834 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -92,7 +92,6 @@
 #define PCH_MAX_SPBR		1023
 
 /* Definition for ML7213/ML7223/ML7831 by LAPIS Semiconductor */
-#define PCI_VENDOR_ID_ROHM		0x10DB
 #define PCI_DEVICE_ID_ML7213_SPI	0x802c
 #define PCI_DEVICE_ID_ML7223_SPI	0x800F
 #define PCI_DEVICE_ID_ML7831_SPI	0x8816
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 3245cdbf9116..e5ff30544bd0 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -192,8 +192,6 @@ enum {
 #define PCH_UART_HAL_LOOP		(PCH_UART_MCR_LOOP)
 #define PCH_UART_HAL_AFE		(PCH_UART_MCR_AFE)
 
-#define PCI_VENDOR_ID_ROHM		0x10DB
-
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
 
 #define DEFAULT_UARTCLK   1843200 /*   1.8432 MHz */
diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
index 991184b8bb41..667011c99372 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -368,7 +368,6 @@ struct pch_udc_dev {
 #define PCI_DEVICE_ID_INTEL_QUARK_X1000_UDC	0x0939
 #define PCI_DEVICE_ID_INTEL_EG20T_UDC		0x8808
 
-#define PCI_VENDOR_ID_ROHM		0x10DB
 #define PCI_DEVICE_ID_ML7213_IOH_UDC	0x801D
 #define PCI_DEVICE_ID_ML7831_IOH_UDC	0x8808
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 05705d0b5689..5c395f52d681 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1140,6 +1140,8 @@
 #define PCI_VENDOR_ID_TCONRAD		0x10da
 #define PCI_DEVICE_ID_TCONRAD_TOKENRING	0x0508
 
+#define PCI_VENDOR_ID_ROHM		0x10db
+
 #define PCI_VENDOR_ID_NVIDIA			0x10de
 #define PCI_DEVICE_ID_NVIDIA_TNT		0x0020
 #define PCI_DEVICE_ID_NVIDIA_TNT2		0x0028
-- 
2.25.1



