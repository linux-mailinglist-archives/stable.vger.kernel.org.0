Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E94675450
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 13:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjATMWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 07:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjATMWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 07:22:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A5B4C6F6
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 04:22:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AD2C61DEA
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 12:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8351DC433D2;
        Fri, 20 Jan 2023 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674217368;
        bh=S8K2qTBB9t4M10FNqMXxQDVdni5qWIXW+RiiKdiBdwI=;
        h=Subject:To:From:Date:From;
        b=in3Zk+UIhbzUCVRHPe8amdWiQxW9mfjZl3P6/5ZgEWAut3F5Ag5jpL/4agBuBnD6e
         SLmengrRn3o78L4XjxFPZ/4Et7uszali/A3TPtvh8fVhdTaHVQPrUiwZraaB/2THs2
         yXTA++QEBUB4B3qc0Y9r0EJrXj+TjYzlNckARiSY=
Subject: patch "mei: me: add meteor lake point M DID" added to char-misc-linus
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 20 Jan 2023 13:22:35 +0100
Message-ID: <167421735515948@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add meteor lake point M DID

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0c4d68261717f89fa8c4f98a6967c3832fcb3ad0 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Tue, 13 Dec 2022 00:02:47 +0200
Subject: mei: me: add meteor lake point M DID

Add Meteor Lake Point M device id.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20221212220247.286019-2-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.39.1


