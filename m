Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5060B3291C5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243397AbhCAUck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242826AbhCAUZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:25:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A646464FC4;
        Mon,  1 Mar 2021 18:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621994;
        bh=TCfziAUs93QysWgA7MipDrigXY6pBu0AXFqcZJIpM2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqXIA7efGGrSeyz8AuZ0DAk5ieutPfz6JN3CyhOUxPUjTG16kWfSZvHLGK/4TtEsL
         2VLE5YeaTVOV8AYWPsPMlZY3VSy52wWamzCIrXLHuQnku/MJ6LP27zumfXa5sjOu0M
         z2QNBVOns4BiLtUMRMLmYjjQO1Fx0+hTL/sfSrBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.11 718/775] mei: me: emmitsburg workstation DID
Date:   Mon,  1 Mar 2021 17:14:46 +0100
Message-Id: <20210301161236.828142127@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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


