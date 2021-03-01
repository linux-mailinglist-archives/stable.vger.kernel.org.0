Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473543291C7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243410AbhCAUcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:32:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243042AbhCAU0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:26:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8539D64FC6;
        Mon,  1 Mar 2021 18:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621997;
        bh=7JkhFDWfXH9UY1P5WrPSTBQu5B61e53Um7n6konFoSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYQ1h4Jm/j3VKdXzHDEdZ7FWnkZ3FcSiSB198UxRinVaSgxrledWROC0t0PAMDSLr
         wLFw2ZvaPepD8AW/4EFW+IPq1VcoJk4JVZ+7gqzyUv0rsCE8ZbagEiBQR//eKVof9a
         8S58FC7JPjlLGTTL84cBO4i29zyvDbKe05htGQE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.11 719/775] mei: me: add adler lake point S DID
Date:   Mon,  1 Mar 2021 17:14:47 +0100
Message-Id: <20210301161236.879187608@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit f7545efaf7950b240de6b8a20b9c3ffd7278538e upstream.

Add Adler Lake S device id.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210129120752.850325-6-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -103,6 +103,8 @@
 
 #define MEI_DEV_ID_EBG        0x1BE0  /* Emmitsburg WS */
 
+#define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -109,6 +109,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_EBG, MEI_ME_PCH15_SPS_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


