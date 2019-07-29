Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E72A795A0
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388995AbfG2To3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389789AbfG2ToY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:44:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E00C205F4;
        Mon, 29 Jul 2019 19:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429463;
        bh=GMis9y1gp4dDNK5vH45Cc8rR7fF1kSsqr+SU/3x0DSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1OpDxBlY+s+1CPwhaJrvEtq2H7J76/BvpNof2RVOmOkHU62GiJlsodmVhNab48yb
         13crVvHrYh1VI8T7lqlmzKM8Yqj5S6KKC9IXyxfZmv2K7R8woVq7+za2Oqg24nRlNj
         qQdwp6FDSq4oBXHnPa64Xk4nhxXAdjKD6u6L4h1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4.19 105/113] mei: me: add mule creek canyon (EHL) device ids
Date:   Mon, 29 Jul 2019 21:23:12 +0200
Message-Id: <20190729190720.478175582@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 1be8624a0cbef720e8da39a15971e01abffc865b upstream.

Add Mule Creek Canyon (PCH) MEI device ids for Elkhart Lake (EHL) Platform.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190712095814.20746-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me-regs.h |    3 +++
 drivers/misc/mei/pci-me.c     |    3 +++
 2 files changed, 6 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -141,6 +141,9 @@
 
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
+#define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
+#define MEI_DEV_ID_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -107,6 +107,9 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC_4, MEI_ME_PCH8_CFG)},
+
 	/* required last entry */
 	{0, }
 };


