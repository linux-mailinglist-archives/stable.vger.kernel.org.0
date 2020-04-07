Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E054B1A0B42
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgDGKYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbgDGKYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:24:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D0A220644;
        Tue,  7 Apr 2020 10:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255092;
        bh=TcTIBYPO0IsFQBu/ex/IOcdF3ZlY9TxybumNre7+ifU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPF8UgC5rmFHpUWBUwSwFCvYvVL8giYQ993nDWr2Kqrlg6bsW08kFZhDYtBzGUuJh
         uc4UHnacoZY00Hqw/TycpUOnYZvva3oep/d+vp9/gGEBdDwJ/uUQS3+KbFoa7nzDRX
         HwjMHP0W3GDzCTJEd/zYqySnuPwcpY9DTgoFtqTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.5 26/46] mei: me: add cedar fork device ids
Date:   Tue,  7 Apr 2020 12:21:57 +0200
Message-Id: <20200407101502.322530546@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
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
@@ -87,6 +87,8 @@
 #define MEI_DEV_ID_CMP_H      0x06e0  /* Comet Lake H */
 #define MEI_DEV_ID_CMP_H_3    0x06e4  /* Comet Lake H 3 (iTouch) */
 
+#define MEI_DEV_ID_CDF        0x18D3  /* Cedar Fork */
+
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
 #define MEI_DEV_ID_JSP_N      0x4DE0  /* Jasper Lake Point N */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -111,6 +111,8 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC_4, MEI_ME_PCH8_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CDF, MEI_ME_PCH8_CFG)},
+
 	/* required last entry */
 	{0, }
 };


