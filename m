Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE164C84B0
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 08:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiCAHMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 02:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiCAHMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 02:12:13 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1CD7A996;
        Mon, 28 Feb 2022 23:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646118693; x=1677654693;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4V2cHjGMTWIff+0LFt6tojJMgcLMmFxrlr9mQKzw2QY=;
  b=FXXVqjjIRHDAB1cH3tlq17FRavg9WCnvsVLS9+iIsx3by8X2l/COzR2Y
   n50AAXGW41vRE4s6Quzs0kB4mk/tLxRT9Iyd1UJitow7y/iW22o1aqtG9
   OhrL9GbSOVlkRwCdOUAvMVnONtFyZZJPVpwkHgh3H+BYKDwKECqd2eFm6
   UAB1QqW7doTNHR3G3FHHn6uwSqkFeuEvS4S38S+runWtKWkFnzmG0uM5/
   hFCT/7XVHgSCd+gQD74ILN6vd3FUPOyPzTUaZ7RM1vOUsh2bQfnD86wIk
   P3ZUWGpqzqgs6O48tIBtbjLfN0YQBszH6Ex8R9TeONE4ixSSQbcg6OVCz
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="252807220"
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="252807220"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 23:11:32 -0800
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="510406873"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.43])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 23:11:30 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Vitaly Lubart <vitaly.lubart@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc] mei: me: add Alder Lake N device id.
Date:   Tue,  1 Mar 2022 09:11:15 +0200
Message-Id: <20220301071115.96145-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add Alder Lake N device ID.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h | 1 +
 drivers/misc/mei/pci-me.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 888c27bc3f1a..64ce3f830262 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -107,6 +107,7 @@
 #define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
 #define MEI_DEV_ID_ADP_LP     0x7A60  /* Alder Lake Point LP */
 #define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
+#define MEI_DEV_ID_ADP_N      0x54E0  /* Alder Lake Point N */
 
 /*
  * MEI HW Section
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a05cdb25d0c4..33e58821e478 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -114,6 +114,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_LP, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_N, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }
-- 
2.34.1

