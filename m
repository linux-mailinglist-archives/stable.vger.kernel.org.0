Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73BD191BB6
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 22:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCXVHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 17:07:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:23594 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgCXVHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 17:07:37 -0400
IronPort-SDR: kAUG2FrGJFqMtGMfH4rBF2M4cd/wkBu1RHEDkZ2R1o3VtJNoiknoa91vLPUlyoE5oBYffyauSw
 YEt+266g7b7Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 14:07:36 -0700
IronPort-SDR: 4d1A11kMratSd7SKf0+PfLVh+dH0S4cIbjIlPUH/dfBkpcOL3ORNP/yEnLJ0gf2YgtJqClwukQ
 HJXcQKUCaUVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="448045780"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.155])
  by fmsmga006.fm.intel.com with ESMTP; 24 Mar 2020 14:07:34 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: me: add cedar fork device ids
Date:   Tue, 24 Mar 2020 23:07:30 +0200
Message-Id: <20200324210730.17672-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add Cedar Fork (CDF) device ids, those belongs to the cannon point family.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h | 2 ++
 drivers/misc/mei/pci-me.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index d2359aed79ae..9392934e3a06 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -87,6 +87,8 @@
 #define MEI_DEV_ID_CMP_H      0x06e0  /* Comet Lake H */
 #define MEI_DEV_ID_CMP_H_3    0x06e4  /* Comet Lake H 3 (iTouch) */
 
+#define MEI_DEV_ID_CDF        0x18D3  /* Cedar Fork */
+
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
 #define MEI_DEV_ID_JSP_N      0x4DE0  /* Jasper Lake Point N */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index ebdc2d6f8ddb..3d21c38e2dbb 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -102,6 +102,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC_4, MEI_ME_PCH8_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CDF, MEI_ME_PCH8_CFG)},
+
 	/* required last entry */
 	{0, }
 };
-- 
2.21.1

