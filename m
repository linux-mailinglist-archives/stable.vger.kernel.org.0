Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0982F13CF
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbhAKNPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732236AbhAKNPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD588229C4;
        Mon, 11 Jan 2021 13:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370892;
        bh=YQOJNdmN8UKA8S5yRZrLJPP2IKumIAkbyc0e58uf+u0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcGcNuuCD035utPhk5bPpcXrngSElwEgQMu8TSdipLh+e4VtBdR88c742kaJMH1Ku
         Ln4TF55PeNwt9VXE1d1yVCI7iuEPmvt4EOi6uNhFuTfnw1gCklGgYSfcH1n1GLqCk5
         deOgtlqyYKGS5Ls8HSL03s4vRRWrkTuy8+Mu5PQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 049/145] stmmac: intel: Add PCI IDs for TGL-H platform
Date:   Mon, 11 Jan 2021 14:01:13 +0100
Message-Id: <20210111130050.880647166@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>

[ Upstream commit 8450e23f142f629e40bd67afc8375c86c7fbf8f1 ]

Add TGL-H PCI info and PCI IDs for the new TSN Controller to the list
of supported devices.

Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Link: https://lore.kernel.org/r/20201222160337.30870-1-muhammad.husaini.zulkifli@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -725,6 +725,8 @@ static SIMPLE_DEV_PM_OPS(intel_eth_pm_op
 #define PCI_DEVICE_ID_INTEL_EHL_PSE1_RGMII1G_ID		0x4bb0
 #define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII1G_ID		0x4bb1
 #define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII2G5_ID	0x4bb2
+#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_0_ID		0x43ac
+#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_1_ID		0x43a2
 #define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID		0xa0ac
 
 static const struct pci_device_id intel_eth_pci_id_table[] = {
@@ -739,6 +741,8 @@ static const struct pci_device_id intel_
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII1G_ID, &ehl_pse1_sgmii1g_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII2G5_ID, &ehl_pse1_sgmii1g_info) },
 	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_0_ID, &tgl_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_1_ID, &tgl_sgmii1g_info) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, intel_eth_pci_id_table);


