Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D98B214E1AD
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbgA3Sqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:46:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731242AbgA3Sqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:46:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D30A6205F4;
        Thu, 30 Jan 2020 18:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410003;
        bh=8EYe6y5wyOfEea0xvGBOkJ7h0WnL6V5YlGvBrH3c06k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ju2C3YTai5JqfoPQpbKz61TOdCa0Z/oGWvuo0cCANjDBqwhb48TKYt0lQ3iTvIh1d
         TECz74VlwvEOU6gbSxqD7JPhDaRL8wlkK79rAjqDYu01jB67EFnECUyy/L4hIuJ8Gp
         qNG2esry6acY2WL/ha5KACXOeM1dlwL4rzXEoXuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/110] mmc: sdhci-pci: Add support for Intel JSL
Date:   Thu, 30 Jan 2020 19:39:09 +0100
Message-Id: <20200130183625.059866694@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 315e3bd7ac19b18ba704d96cbb9b79bad485c01f ]

Add PCI Ids for Intel JSL.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-core.c | 2 ++
 drivers/mmc/host/sdhci-pci.h      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index 96a163f36a395..c9ea365c248c0 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1730,6 +1730,8 @@ static const struct pci_device_id pci_ids[] = {
 	SDHCI_PCI_DEVICE(INTEL, CML_EMMC,  intel_glk_emmc),
 	SDHCI_PCI_DEVICE(INTEL, CML_SD,    intel_byt_sd),
 	SDHCI_PCI_DEVICE(INTEL, CMLH_SD,   intel_byt_sd),
+	SDHCI_PCI_DEVICE(INTEL, JSL_EMMC,  intel_glk_emmc),
+	SDHCI_PCI_DEVICE(INTEL, JSL_SD,    intel_byt_sd),
 	SDHCI_PCI_DEVICE(O2, 8120,     o2),
 	SDHCI_PCI_DEVICE(O2, 8220,     o2),
 	SDHCI_PCI_DEVICE(O2, 8221,     o2),
diff --git a/drivers/mmc/host/sdhci-pci.h b/drivers/mmc/host/sdhci-pci.h
index 558202fe64c67..981bbbe63aff5 100644
--- a/drivers/mmc/host/sdhci-pci.h
+++ b/drivers/mmc/host/sdhci-pci.h
@@ -55,6 +55,8 @@
 #define PCI_DEVICE_ID_INTEL_CML_EMMC	0x02c4
 #define PCI_DEVICE_ID_INTEL_CML_SD	0x02f5
 #define PCI_DEVICE_ID_INTEL_CMLH_SD	0x06f5
+#define PCI_DEVICE_ID_INTEL_JSL_EMMC	0x4dc4
+#define PCI_DEVICE_ID_INTEL_JSL_SD	0x4df8
 
 #define PCI_DEVICE_ID_SYSKONNECT_8000	0x8000
 #define PCI_DEVICE_ID_VIA_95D0		0x95d0
-- 
2.20.1



