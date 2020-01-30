Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B54A14E1ED
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgA3Ssq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:48:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731603AbgA3Ssn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B66B205F4;
        Thu, 30 Jan 2020 18:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410121;
        bh=Nj3wNvbTSk3uUQLxRSO5ABbac/0d7g8YK7ewTTKdhSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuQiakrrnBwyt9EWvjN82MEK22Q6Qf2b90daaoBNrkjOHcNs1Qgi5GCq/v42i6eTS
         KhGJUNAU5hN9D1eeMHn3NtgNAWLzM9xdkQjgok3Xecc9g5iwVcbqg0SlsCE/E+CNLp
         T9tLpmOSu0uodf6xcaT1pegrwITOACo5CT8dardA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4.19 15/55] mei: me: add comet point (lake) H device ids
Date:   Thu, 30 Jan 2020 19:38:56 +0100
Message-Id: <20200130183611.634336644@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

commit 559e575a8946a6561dfe8880de341d4ef78d5994 upstream.

Add Comet Point device IDs for Comet Lake H platforms.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20200119094229.20116-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me-regs.h |    4 ++++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 6 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -141,8 +141,12 @@
 
 #define MEI_DEV_ID_CMP_LP     0x02e0  /* Comet Point LP */
 #define MEI_DEV_ID_CMP_LP_3   0x02e4  /* Comet Point LP 3 (iTouch) */
+
 #define MEI_DEV_ID_CMP_V      0xA3BA  /* Comet Point Lake V */
 
+#define MEI_DEV_ID_CMP_H      0x06e0  /* Comet Lake H */
+#define MEI_DEV_ID_CMP_H_3    0x06e4  /* Comet Lake H 3 (iTouch) */
+
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
 #define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -108,6 +108,8 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP, MEI_ME_PCH12_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP_3, MEI_ME_PCH8_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_V, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_H, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_H_3, MEI_ME_PCH8_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 


