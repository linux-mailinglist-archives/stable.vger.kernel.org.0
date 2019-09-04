Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDFF6A9101
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389256AbfIDSNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390179AbfIDSNA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:13:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07F60206BA;
        Wed,  4 Sep 2019 18:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620779;
        bh=0y5+RMYohQRiIUOdlzRkT2PtPL2k/LFAN0Xo53QbJo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOECxLLkA/p3OIdGbscXl/sQueviVbw+4SODIXQBM1+Y4v4SHWrj/HzNyMLJr9rMm
         HGqhsUo0nAatzvxu9wURT4gqjLtOc0hdGvUgLF+Hplkwc51r6nK6Z44rxVvDuEgWgv
         6Fsm+pZl0NLtF+tbolMjUpifv0cGaWvF2RIpuTsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.2 091/143] mei: me: add Tiger Lake point LP device ID
Date:   Wed,  4 Sep 2019 19:53:54 +0200
Message-Id: <20190904175317.665919251@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

commit 587f17407741a5be07f8a2d1809ec946c8120962 upstream.

Add Tiger Lake Point device ID for TGP LP.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190819103210.32748-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -81,6 +81,8 @@
 
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
+#define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
+
 #define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
 #define MEI_DEV_ID_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
 
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -98,6 +98,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH12_CFG)},
+
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC, MEI_ME_PCH12_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC_4, MEI_ME_PCH8_CFG)},
 


