Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373CE328ADD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbhCASYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:24:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232842AbhCASSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:18:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2B176528B;
        Mon,  1 Mar 2021 17:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619880;
        bh=o/iPQqXgPIe4EaS1C+2WRJdewcdD+J5paiBynHGnFV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzVfVV5IRnsBxM23BZCbaMyHHCokHoZUkMDw8Je9eH1R0pQS2VdNIqTzDwU/RyjlH
         E36uKCo+yqbU7ZDTE6mtzZDDWxj4jv+PWGo9O7ZzvcnA3F+j/sXQl4XGxoiUBE8Y8Y
         KuKxpCNka/dCDwic4am9Otvvs6AagOXUMIN8aiVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.10 614/663] mei: me: add adler lake point LP DID
Date:   Mon,  1 Mar 2021 17:14:22 +0100
Message-Id: <20210301161212.225117197@linuxfoundation.org>
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

commit 930c922a987a02936000f15ea62988b7a39c27f5 upstream.

Add Adler Lake LP device id.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210129120752.850325-7-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -104,6 +104,7 @@
 #define MEI_DEV_ID_EBG        0x1BE0  /* Emmitsburg WS */
 
 #define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
+#define MEI_DEV_ID_ADP_LP     0x7A60  /* Alder Lake Point LP */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -110,6 +110,7 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_EBG, MEI_ME_PCH15_SPS_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_LP, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


