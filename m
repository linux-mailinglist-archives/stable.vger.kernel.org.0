Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C147A201424
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391084AbgFSPEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391075AbgFSPD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:03:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79E8221941;
        Fri, 19 Jun 2020 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579039;
        bh=3+n/+0GpUrWUOoVO5jpYcAcrIt9OUq9XsUzcT8TPeac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1ODGQEHSbvK81D9f9bwBWVfcYOUju3kYn/yGnYxVRLJRLw/RbkK5bqNfR5xn2fJJ
         00wGcyWlcd0fBrKtVDkxX5qnx0M4gWuD3HGQStas7vVAY9m9vIquxShAMIJPgueL2L
         SEeTaB5N9fMvei16D5+K0B8L87wcV/HZrY/LkHMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 222/267] x86/amd_nb: Add Family 19h PCI IDs
Date:   Fri, 19 Jun 2020 16:33:27 +0200
Message-Id: <20200619141659.361444741@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit b3f79ae45904ae987a7c06a9e8d6084d7b73e67f ]

Add the new PCI Device 18h IDs for AMD Family 19h systems. Note that
Family 19h systems will not have a new PCI root device ID.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200110015651.14887-4-Yazen.Ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/amd_nb.c | 3 +++
 include/linux/pci_ids.h  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index be1d15a27079..923b4bac9613 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -21,6 +21,7 @@
 #define PCI_DEVICE_ID_AMD_17H_M10H_DF_F4 0x15ec
 #define PCI_DEVICE_ID_AMD_17H_M30H_DF_F4 0x1494
 #define PCI_DEVICE_ID_AMD_17H_M70H_DF_F4 0x1444
+#define PCI_DEVICE_ID_AMD_19H_DF_F4	0x1654
 
 /* Protect the PCI config register pairs used for SMN and DF indirect access. */
 static DEFINE_MUTEX(smn_mutex);
@@ -51,6 +52,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M30H_DF_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M70H_DF_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_DF_F3) },
 	{}
 };
 EXPORT_SYMBOL_GPL(amd_nb_misc_ids);
@@ -65,6 +67,7 @@ static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M10H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M30H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M70H_DF_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CNB17H_F4) },
 	{}
 };
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 8d3b39028968..a81fcb2f2cb7 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -549,6 +549,7 @@
 #define PCI_DEVICE_ID_AMD_17H_M10H_DF_F3 0x15eb
 #define PCI_DEVICE_ID_AMD_17H_M30H_DF_F3 0x1493
 #define PCI_DEVICE_ID_AMD_17H_M70H_DF_F3 0x1443
+#define PCI_DEVICE_ID_AMD_19H_DF_F3	0x1653
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
-- 
2.25.1



