Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEF4328C8B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240746AbhCASxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234149AbhCASrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:47:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D5DF64EF8;
        Mon,  1 Mar 2021 17:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619875;
        bh=TCfziAUs93QysWgA7MipDrigXY6pBu0AXFqcZJIpM2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/iasVRJbg6Gw9uyGKnr+c0dg6x+20Dx7zE7JadcmTxPWo80600qvEbkq3SJ1Gk2W
         QTyMHn6i+sWQn2nvGr+cWCMixi5fta67bOrR4B3uyhtO0352t5d0dgMat6wq6sMGM0
         S2JJeCEVvfSmMO63/GONTFuFe5CL8xRR/6ZD0WwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.10 612/663] mei: me: emmitsburg workstation DID
Date:   Mon,  1 Mar 2021 17:14:20 +0100
Message-Id: <20210301161212.125484898@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

commit 372726cb3957dbd69ded9a4e3419d5c6c3bc648e upstream.

Add Emmitsburg workstation DID.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210129120752.850325-5-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -101,6 +101,8 @@
 #define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
 #define MEI_DEV_ID_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
 
+#define MEI_DEV_ID_EBG        0x1BE0  /* Emmitsburg WS */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -107,6 +107,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CDF, MEI_ME_PCH8_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_EBG, MEI_ME_PCH15_SPS_CFG)},
+
 	/* required last entry */
 	{0, }
 };


