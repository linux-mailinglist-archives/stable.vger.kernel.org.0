Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A7F39E202
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbhFGQOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231617AbhFGQOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E7F861406;
        Mon,  7 Jun 2021 16:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082366;
        bh=Zz6lVfculsy0Ef24lMedqejwDUXaVODn45oG3Z33TNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZM0WZvPn755hPr3w5dN2Huz2gcFmsDLlmV0qKbN+l/0P6ySkHF/GQdJnBBDpLiTT2
         Cq2jwVTgS8jCQ3h7tTDAYD7zgAkY6jwUVJIZb90m7pUo9UwZgaDoM7dtmA8ns3IfoZ
         QdwpiNPZ2n8BLOFePmjHr86R0eA2ykznkF/lL1KXg/Pau/T+QFdG9utxlWCMb+nBS1
         sgp6l2N7DYxt8ZEdBAcWnRZ72JnF4W08vTBnh7+ShzucOAefa8PBNPYZ52MWfA7zFC
         4BCjXUfu0+YPuOb1NgPtCsJ5p24uH+6RHxnA+8EaIi3WwB7nanfjNRdxtrl6Do51GK
         NcaCiL7Ji/SPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Xiang <xiang.ye@intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 25/49] HID: intel-ish-hid: ipc: Add Alder Lake device IDs
Date:   Mon,  7 Jun 2021 12:11:51 -0400
Message-Id: <20210607161215.3583176-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Xiang <xiang.ye@intel.com>

[ Upstream commit 22db5e0003e1441cd829180cebb42f7a6b7a46b7 ]

Add Alder Lake PCI device IDs to the supported device list.

Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/hw-ish.h  | 2 ++
 drivers/hid/intel-ish-hid/ipc/pci-ish.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ipc/hw-ish.h b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
index 21b87e4003af..07e3cbc86bef 100644
--- a/drivers/hid/intel-ish-hid/ipc/hw-ish.h
+++ b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
@@ -28,6 +28,8 @@
 #define EHL_Ax_DEVICE_ID	0x4BB3
 #define TGL_LP_DEVICE_ID	0xA0FC
 #define TGL_H_DEVICE_ID		0x43FC
+#define ADL_S_DEVICE_ID		0x7AF8
+#define ADL_P_DEVICE_ID		0x51FC
 
 #define	REVISION_ID_CHT_A0	0x6
 #define	REVISION_ID_CHT_Ax_SI	0x0
diff --git a/drivers/hid/intel-ish-hid/ipc/pci-ish.c b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
index 06081cf9b85a..a6d5173ac003 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -39,6 +39,8 @@ static const struct pci_device_id ish_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, EHL_Ax_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, TGL_LP_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, TGL_H_DEVICE_ID)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, ADL_S_DEVICE_ID)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, ADL_P_DEVICE_ID)},
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, ish_pci_tbl);
-- 
2.30.2

