Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECC22014D1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390755AbgFSPB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390753AbgFSPB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:01:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9672D2193E;
        Fri, 19 Jun 2020 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578916;
        bh=xxUjlhi8/WByqG1Pmjnz44v+8zF0P2hZJkQQenoOhaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knxf76yKaJjCrk1DO2t3RVaAlMPVGZxn2qDSqRsFFx0hRpeBhre6WLe7oKuQhNFqY
         QPSr7QWqytibyR8yrFe6HbL7Aij3olGixui4YmwbpZnnjSBnAK6Wsa54wP7S9aec4x
         mps58hYWuiB97eJ1XBfO3WIeDSt4xVDR1A2m0F0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corey Minyard <cminyard@mvista.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 205/267] pci:ipmi: Move IPMI PCI class id defines to pci_ids.h
Date:   Fri, 19 Jun 2020 16:33:10 +0200
Message-Id: <20200619141658.569061824@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 05c3d056086a6217a77937b7fa0df35ec75715e6 ]

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_si_pci.c | 5 -----
 include/linux/pci_ids.h         | 4 ++++
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_pci.c b/drivers/char/ipmi/ipmi_si_pci.c
index 022e03634ce2..9e9700b1a8e6 100644
--- a/drivers/char/ipmi/ipmi_si_pci.c
+++ b/drivers/char/ipmi/ipmi_si_pci.c
@@ -18,11 +18,6 @@ module_param_named(trypci, si_trypci, bool, 0);
 MODULE_PARM_DESC(trypci, "Setting this to zero will disable the"
 		 " default scan of the interfaces identified via pci");
 
-#define PCI_CLASS_SERIAL_IPMI		0x0c07
-#define PCI_CLASS_SERIAL_IPMI_SMIC	0x0c0700
-#define PCI_CLASS_SERIAL_IPMI_KCS	0x0c0701
-#define PCI_CLASS_SERIAL_IPMI_BT	0x0c0702
-
 #define PCI_DEVICE_ID_HP_MMC 0x121A
 
 static void ipmi_pci_cleanup(struct si_sm_io *io)
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f4e278493f5b..861ee391dc33 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -117,6 +117,10 @@
 #define PCI_CLASS_SERIAL_USB_DEVICE	0x0c03fe
 #define PCI_CLASS_SERIAL_FIBER		0x0c04
 #define PCI_CLASS_SERIAL_SMBUS		0x0c05
+#define PCI_CLASS_SERIAL_IPMI		0x0c07
+#define PCI_CLASS_SERIAL_IPMI_SMIC	0x0c0700
+#define PCI_CLASS_SERIAL_IPMI_KCS	0x0c0701
+#define PCI_CLASS_SERIAL_IPMI_BT	0x0c0702
 
 #define PCI_BASE_CLASS_WIRELESS			0x0d
 #define PCI_CLASS_WIRELESS_RF_CONTROLLER	0x0d10
-- 
2.25.1



