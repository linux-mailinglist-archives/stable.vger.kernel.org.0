Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FED136FC2F
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhD3OWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233217AbhD3OVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB11661459;
        Fri, 30 Apr 2021 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792464;
        bh=tpdLc4WQkUvcuQNKlcZnaDSVARBfAAiL2iJHmhS5k3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwU6+cZhhZklUdhIGD0y9DlieGIpQuZdyOJfGF88Bd5v0eQkvwN9I7O7a8F8sLHu1
         VAJM9LTZ9HFqkXQGsX+xghp0TI96m6g9pmMV7c6dn8Uk/AMyBUQVxNIyJwfsl+DbBy
         g241CSAQL4dSshXNbLMGwde0BnaSCIV7Aa9XQhWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.11 3/3] mei: me: add Alder Lake P device id.
Date:   Fri, 30 Apr 2021 16:20:52 +0200
Message-Id: <20210430141910.800581064@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210430141910.693887691@linuxfoundation.org>
References: <20210430141910.693887691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

commit 0df74278faedf20f9696bf2755cf0ce34afa4c3a upstream.

Add Alder Lake P device ID.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210414045200.3498241-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -105,6 +105,7 @@
 
 #define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
 #define MEI_DEV_ID_ADP_LP     0x7A60  /* Alder Lake Point LP */
+#define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -111,6 +111,7 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_LP, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


