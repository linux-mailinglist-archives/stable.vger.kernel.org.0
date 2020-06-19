Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23718200DE7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390888AbgFSPCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390881AbgFSPCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEFF021582;
        Fri, 19 Jun 2020 15:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578965;
        bh=efr4F5l8E5T54xKaxuUYJ3rAEcKcuyWv6c6byuZfwpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQutwUwytduWBmuUqcw0UJhbJCRmfwGs9Xuyiw3cFUvc4BMEU3Q9kY0tneg5Xg9a9
         pwnK9ZdrjK/zN8lmqwaP/3B/9s0EvAOcyBVZMMocSfg4Lmn0O5H7sG+95CKzdRHZjx
         eM/eJfEXfpxh1cx892Q1N7+jnXrusAzWk2Oknb9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vicki Pfau <vi@endrift.com>,
        Marcel Bocu <marcel.p.bocu@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brian Woods <brian.woods@amd.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Woods, Brian" <Brian.Woods@amd.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-hwmon@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.19 217/267] x86/amd_nb: Add PCI device IDs for family 17h, model 70h
Date:   Fri, 19 Jun 2020 16:33:22 +0200
Message-Id: <20200619141659.132768385@linuxfoundation.org>
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

From: Marcel Bocu <marcel.p.bocu@gmail.com>

[ Upstream commit af4e1c5eca95bed1192d8dc45c8ed63aea2209e8 ]

The AMD Ryzen gen 3 processors came with a different PCI IDs for the
function 3 & 4 which are used to access the SMN interface. The root
PCI address however remained at the same address as the model 30h.

Adding the F3/F4 PCI IDs respectively to the misc and link ids appear
to be sufficient for k10temp, so let's add them and follow up on the
patch if other functions need more tweaking.

Vicki Pfau sent an identical patch after I checked that no-one had
written this patch. I would have been happy about dropping my patch but
unlike for his patch series, I had already Cc:ed the x86 people and
they already reviewed the changes. Since Vicki has not answered to
any email after his initial series, let's assume she is on vacation
and let's avoid duplication of reviews from the maintainers and merge
my series. To acknowledge Vicki's anteriority, I added her S-o-b to
the patch.

v2, suggested by Guenter Roeck and Brian Woods:
 - rename from 71h to 70h

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Marcel Bocu <marcel.p.bocu@gmail.com>
Tested-by: Marcel Bocu <marcel.p.bocu@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Brian Woods <brian.woods@amd.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>	# pci_ids.h

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: "Woods, Brian" <Brian.Woods@amd.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org
Link: https://lore.kernel.org/r/20190722174510.2179-1-marcel.p.bocu@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/amd_nb.c | 3 +++
 include/linux/pci_ids.h  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index b95db8ce83bf..be1d15a27079 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -20,6 +20,7 @@
 #define PCI_DEVICE_ID_AMD_17H_DF_F4	0x1464
 #define PCI_DEVICE_ID_AMD_17H_M10H_DF_F4 0x15ec
 #define PCI_DEVICE_ID_AMD_17H_M30H_DF_F4 0x1494
+#define PCI_DEVICE_ID_AMD_17H_M70H_DF_F4 0x1444
 
 /* Protect the PCI config register pairs used for SMN and DF indirect access. */
 static DEFINE_MUTEX(smn_mutex);
@@ -49,6 +50,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M10H_DF_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M30H_DF_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M70H_DF_F3) },
 	{}
 };
 EXPORT_SYMBOL_GPL(amd_nb_misc_ids);
@@ -62,6 +64,7 @@ static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M10H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M30H_DF_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M70H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CNB17H_F4) },
 	{}
 };
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index a7abaaa9bc27..81ddbd891202 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -548,6 +548,7 @@
 #define PCI_DEVICE_ID_AMD_17H_DF_F3	0x1463
 #define PCI_DEVICE_ID_AMD_17H_M10H_DF_F3 0x15eb
 #define PCI_DEVICE_ID_AMD_17H_M30H_DF_F3 0x1493
+#define PCI_DEVICE_ID_AMD_17H_M70H_DF_F3 0x1443
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
-- 
2.25.1



