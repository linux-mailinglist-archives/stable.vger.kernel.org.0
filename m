Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5837148E57F
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbiANISf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239667AbiANISQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:18:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CEDC061574;
        Fri, 14 Jan 2022 00:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80B4061E1D;
        Fri, 14 Jan 2022 08:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577D0C36AEA;
        Fri, 14 Jan 2022 08:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148294;
        bh=+qerhA5SfrxeopT3nwRiYzi3V8dQZYT7LgR+OjPn0IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhtMTsF0hCFuWrYnJiIn3GXvrREobw93NTCyexjUbf16xeevtGNzBA+YwG70lwV2T
         IU94Xb1GcIO5Sa0rVAVaZF30NgVh8z4PlIzVbYQi8U97MXkKlp3hC8c7UqSy1VcpiR
         lZH3xLOYLhLj/YvFVbufv1u1hABrG7rsvYPieYj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 13/25] mmc: sdhci-pci: Add PCI ID for Intel ADL
Date:   Fri, 14 Jan 2022 09:16:21 +0100
Message-Id: <20220114081543.148515727@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit e53e97f805cb1abeea000a61549d42f92cb10804 upstream.

Add PCI ID for Intel ADL eMMC host controller.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211124094850.1783220-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-core.c |    1 +
 drivers/mmc/host/sdhci-pci.h      |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1932,6 +1932,7 @@ static const struct pci_device_id pci_id
 	SDHCI_PCI_DEVICE(INTEL, JSL_SD,    intel_byt_sd),
 	SDHCI_PCI_DEVICE(INTEL, LKF_EMMC,  intel_glk_emmc),
 	SDHCI_PCI_DEVICE(INTEL, LKF_SD,    intel_byt_sd),
+	SDHCI_PCI_DEVICE(INTEL, ADL_EMMC,  intel_glk_emmc),
 	SDHCI_PCI_DEVICE(O2, 8120,     o2),
 	SDHCI_PCI_DEVICE(O2, 8220,     o2),
 	SDHCI_PCI_DEVICE(O2, 8221,     o2),
--- a/drivers/mmc/host/sdhci-pci.h
+++ b/drivers/mmc/host/sdhci-pci.h
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_INTEL_JSL_SD	0x4df8
 #define PCI_DEVICE_ID_INTEL_LKF_EMMC	0x98c4
 #define PCI_DEVICE_ID_INTEL_LKF_SD	0x98f8
+#define PCI_DEVICE_ID_INTEL_ADL_EMMC	0x54c4
 
 #define PCI_DEVICE_ID_SYSKONNECT_8000	0x8000
 #define PCI_DEVICE_ID_VIA_95D0		0x95d0


