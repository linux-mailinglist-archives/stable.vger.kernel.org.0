Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBE61A5178
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgDKMPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgDKMPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:15:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E451C20644;
        Sat, 11 Apr 2020 12:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607344;
        bh=rrbDaFkk5x61SHu+8pcRSj9/mqB+BAhYpLc3qf7eeyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3IxbQaBx+4dazJ+U7GSUj3Ehoao781fMUmMl40HtcTuD22hI8gYo3WEjGaJlClqT
         yVi2PKUcwEeW475cCFgKep4Xfh+QoKXqsm3H0WyCr6/eWY6+s/gki1/jYel1UoqJ4G
         nkTe0cNNX+WU+O4Uh1UYHtTkxXFw9TlIaLPJChHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4.19 18/54] mei: me: add cedar fork device ids
Date:   Sat, 11 Apr 2020 14:09:00 +0200
Message-Id: <20200411115510.275450839@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 99397d33b763dc554d118aaa38cc5abc6ce985de upstream.

Add Cedar Fork (CDF) device ids, those belongs to the cannon point family.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20200324210730.17672-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -147,6 +147,8 @@
 #define MEI_DEV_ID_CMP_H      0x06e0  /* Comet Lake H */
 #define MEI_DEV_ID_CMP_H_3    0x06e4  /* Comet Lake H 3 (iTouch) */
 
+#define MEI_DEV_ID_CDF        0x18D3  /* Cedar Fork */
+
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
 #define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -118,6 +118,8 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC, MEI_ME_PCH12_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC_4, MEI_ME_PCH8_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CDF, MEI_ME_PCH8_CFG)},
+
 	/* required last entry */
 	{0, }
 };


