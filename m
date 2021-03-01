Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E418E328AB7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbhCASWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:22:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239532AbhCASRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4015F64F50;
        Mon,  1 Mar 2021 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619877;
        bh=7JkhFDWfXH9UY1P5WrPSTBQu5B61e53Um7n6konFoSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15DsY7tBTwXc1HoJZOjfkrZJu/N5/8UudoFEaNVltgE1Nw1xy8VlSTKhuE24wG2aW
         di8DkwluAvHlLFfrUTjKy64OqoYx02GzqpGHTBUFgEjFn62hVcvADHMn3pHW+68533
         Aw86ZAAgl3iqn6LjmJt6d9Px2d6LY5dwE/S51ihg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.10 613/663] mei: me: add adler lake point S DID
Date:   Mon,  1 Mar 2021 17:14:21 +0100
Message-Id: <20210301161212.174065336@linuxfoundation.org>
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


