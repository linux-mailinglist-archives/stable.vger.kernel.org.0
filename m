Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBBF35EC09
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 06:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243138AbhDNEwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 00:52:35 -0400
Received: from mga06.intel.com ([134.134.136.31]:49534 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230249AbhDNEwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 00:52:34 -0400
IronPort-SDR: 2qg1xaUUbKJo2YTJYp7WHSh47BaoDiTh/TULRisj6pWdMDVXWn203io8run5nSRs3iKG6BSe05
 P4GJ/7VnQy6A==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="255883474"
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="255883474"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 21:52:13 -0700
IronPort-SDR: hD7jZmxvV4oQS+zzYg876CkhM3Jzhj6SACLcZkWLM+ON8C8EIqi1iEETR/3EfYOfWmPoF40MXE
 taL+Tpuf7dyA==
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="418148853"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.138])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 21:52:11 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>, stable@vger.kernel.org
Subject: [char-misc-next] mei: me: add Alder Lake P device id.
Date:   Wed, 14 Apr 2021 07:52:00 +0300
Message-Id: <20210414045200.3498241-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add Alder Lake P device ID.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h | 1 +
 drivers/misc/mei/pci-me.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 14be76d4c2e6..cb34925e10f1 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -105,6 +105,7 @@
 
 #define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
 #define MEI_DEV_ID_ADP_LP     0x7A60  /* Alder Lake Point LP */
+#define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
 
 /*
  * MEI HW Section
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a7e179626b63..c3393b383e59 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -111,6 +111,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_LP, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }
-- 
2.26.3

