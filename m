Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050DC64A9E5
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 23:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbiLLWDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 17:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiLLWDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 17:03:05 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814F3FACF;
        Mon, 12 Dec 2022 14:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670882585; x=1702418585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ssIENlGqHsIAknP2xjieLOntmBJmIEYs7AD+cX+4WsQ=;
  b=gwiTsGvSy0aJJZkdlutTF8RQhzr4PacA/gzGfAHBZyLEDJ0r2WAApjkG
   IXZc6gMJ3DijResESenFGrpqv8+GxOIAwQAz0KIu0mOQsxTvGTPhRtBiK
   RBSdSh3bSGEuYScMF23eyUKORaOTffp9dpya4BA1bO72C3e69c/jhSnKj
   Jss81MXvdAMBBTEo0Q82/diTU5/BXnewpZt6zqEku5YNavpBg+prvKLT7
   IURgpYy0kkcf/V3IHXySSI/8XWJ2eekygU5QjTFRda6j/qxspj72e8Dru
   yidtpbsWEfyfd+bvPAdmpu2L9qzrQDZQ4TzudI/EVxWEwG9ka8lsiCZCX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="297653650"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="297653650"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 14:03:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="772749668"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="772749668"
Received: from twinkler-lnx.jer.intel.com ([10.12.87.42])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 14:03:01 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Vitaly Lubart <vitaly.lubart@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 2/2] mei: me: add meteor lake point M DID
Date:   Tue, 13 Dec 2022 00:02:47 +0200
Message-Id: <20221212220247.286019-2-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212220247.286019-1-tomas.winkler@intel.com>
References: <20221212220247.286019-1-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add Meteor Lake Point M device id.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h | 2 ++
 drivers/misc/mei/pci-me.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 99966cd3e7d8..bdc65d50b945 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -111,6 +111,8 @@
 
 #define MEI_DEV_ID_RPL_S      0x7A68  /* Raptor Lake Point S */
 
+#define MEI_DEV_ID_MTL_M      0x7E70  /* Meteor Lake Point M */
+
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 704cd0caa172..5bf0d50d55a0 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -118,6 +118,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };
-- 
2.38.1

