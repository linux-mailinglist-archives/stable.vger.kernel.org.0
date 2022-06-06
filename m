Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DAB53E86C
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240002AbiFFOmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239926AbiFFOmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:42:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B618237CE;
        Mon,  6 Jun 2022 07:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654526563; x=1686062563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A8DIPmcP5MQsnAFgyFurlYSbWxnYBHfx4uwY17G9HzA=;
  b=OUfU7Jx0pfWq4aAeIU2r5cFJkmN+fASLJ9YvIseFAPiLnNxr4OzCaSp/
   NBJbucVh6DEkkPDATWDjXycQ+Wf7iSc+RcLbQfSdVzn9dxQrQ443FX9Lh
   2uzessx+FbaNe8XhoZILyHt6wJWQcDeFCQHmI1Vp8ljDztchn8zYygSmq
   1c/l8IUTlQXIYM3QB+o9tI0ERf0fer2LVplLC9ApDku9/T+/mvwo9lJwQ
   RstSH2jMpjhddouc85/YvV1Lx4li6Q+N0I5ho6zMACp8wrMSu9ywtEJ2F
   +zqDHy8aDnhiyQF6ZW93anBFUqJhEmESsZHwmfLyeCsLLEvCVVP3QytoK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="256497764"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="256497764"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 07:42:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="906574485"
Received: from twinkler-lnx.jer.intel.com ([10.12.87.143])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 07:42:41 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Vitaly Lubart <vitaly.lubart@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3] mei: me: add raptor lake point S DID
Date:   Mon,  6 Jun 2022 17:42:25 +0300
Message-Id: <20220606144225.282375-3-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606144225.282375-1-tomas.winkler@intel.com>
References: <20220606144225.282375-1-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add Raptor (Point) Lake S device id.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h | 2 ++
 drivers/misc/mei/pci-me.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 64ce3f830262..15e8e2b322b1 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -109,6 +109,8 @@
 #define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
 #define MEI_DEV_ID_ADP_N      0x54E0  /* Alder Lake Point N */
 
+#define MEI_DEV_ID_RPL_S      0x7A68  /* Raptor Lake Point S */
+
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 33e58821e478..5435604327a7 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -116,6 +116,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_N, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };
-- 
2.35.3

