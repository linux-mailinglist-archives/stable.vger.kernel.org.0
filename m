Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B535413AA7
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 21:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhIUTXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 15:23:08 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:60538
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229915AbhIUTXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 15:23:07 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CE5B93F226
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632252097;
        bh=qmARoOxotWCp+s1/u/VWZI2RoTZae8SIB5BQKHCc438=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=iNjk71EvMLotZIuVD5FVDy3nybgiwG1jgIkv8LSQIAtpWZ3riRp7jOuRMTU0oI8L9
         jKIE/ivmlC6Nkvc31FS3pkklYDnRoEi8CoDxNljbPji2VHpbeFPzQHqqLb4NmR/W4P
         Tg5DB4M38G9pLaJQ/rhY9fQ6tc1WI8Kv4NSQ3eNpb65/IPD/xNtnMgTEc6KipUKMK2
         UGzdpUvSheJCBKjYXnmoQnHAqzI2rf0tT+XeutAB4fW+c9JndInSMPcz5x/mBgQ86o
         rgprcxHdAmMZO7mxH5S3BnrGB7ucSrNJ06tF+KUOSxvjr9wrnktd9Bwj3RQ4BysIe5
         z2tYBZxhugqzg==
Received: by mail-io1-f69.google.com with SMTP id s12-20020a056602168c00b005d611510e15so189071iow.1
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 12:21:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qmARoOxotWCp+s1/u/VWZI2RoTZae8SIB5BQKHCc438=;
        b=VOaUhTB+ksJx8/rxjJI8FshYaPobxuhB2XHzUaw/bEcSnxAUmqjJAt0guMLA/Am9/i
         oz7SU2z9mPptMU4dLBLDeZ+9Ixffmr2sHh5oZ+Rjye5OP3tq+XWcLBfY4gz1j2AekQZe
         C0b3H0Dq0336WrxALfwvqeqgRt5A4WZQj4wCkKPpvK/29xM0nSyxQC9JyoZj59o7mIcX
         cpOIERYx0jKONkUqpoW1UCbyOcNs1c3Egr9J/pUygkkNsKQra8cQE085zYZryXtfyG0U
         XwhcCKAqq5n7vr4Zoge2C8n0h4uRsgTDtApdw8r3RnBlCLszEy4yC80K3TKM5Md9H7Wd
         STJA==
X-Gm-Message-State: AOAM530xjoGK+mHbw3A/gKiTNOo3052QVQPF85uVv89OouD46P0RCDVL
        UgK8qJkOoLKELdpDkCtr1Tz5tbCN6Ur12Tj1n75PDNgRgjXdXvjETIqhXdwo1fmYCfxT1L5r0Im
        M05amBHpCXZ62qVXmtZI6+3bTPZhzuK3y+w==
X-Received: by 2002:a92:650c:: with SMTP id z12mr23441180ilb.87.1632252096059;
        Tue, 21 Sep 2021 12:21:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYY9Pdd8xLbmRlz9tMlODYXAZfgIchv3uU411Zb7nCNWH9oVo8GKJD/Fj9iaz3U2Zuuo2eBA==
X-Received: by 2002:a92:650c:: with SMTP id z12mr23441168ilb.87.1632252095794;
        Tue, 21 Sep 2021 12:21:35 -0700 (PDT)
Received: from localhost (c-71-56-235-36.hsd1.co.comcast.net. [71.56.235.36])
        by smtp.gmail.com with ESMTPSA id o1sm1024850ilj.41.2021.09.21.12.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 12:21:34 -0700 (PDT)
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org
Cc:     Tuan Phan <tuanphan@os.amperecomputing.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4] PCI/ACPI: Add Ampere Altra SOC MCFG quirk
Date:   Tue, 21 Sep 2021 13:20:38 -0600
Message-Id: <20210921192038.3024844-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuan Phan <tuanphan@os.amperecomputing.com>

commit 877c1a5f79c6984bbe3f2924234c08e2f4f1acd5 upstream.

Ampere Altra SOC supports only 32-bit ECAM reads.  Add an MCFG quirk for
the platform.

Link: https://lore.kernel.org/r/1596751055-12316-1-git-send-email-tuanphan@os.amperecomputing.com
Signed-off-by: Tuan Phan <tuanphan@os.amperecomputing.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
[ dannf: backport drops const qualifier from pci_32b_read_ops for
  consistency with the other quirks that weren't yet constified in v5.4 ]
Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 drivers/acpi/pci_mcfg.c  | 20 ++++++++++++++++++++
 drivers/pci/ecam.c       | 10 ++++++++++
 include/linux/pci-ecam.h |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/acpi/pci_mcfg.c b/drivers/acpi/pci_mcfg.c
index 6b347d9920cc..47e43c949825 100644
--- a/drivers/acpi/pci_mcfg.c
+++ b/drivers/acpi/pci_mcfg.c
@@ -142,6 +142,26 @@ static struct mcfg_fixup mcfg_quirks[] = {
 	XGENE_V2_ECAM_MCFG(4, 0),
 	XGENE_V2_ECAM_MCFG(4, 1),
 	XGENE_V2_ECAM_MCFG(4, 2),
+
+#define ALTRA_ECAM_QUIRK(rev, seg) \
+	{ "Ampere", "Altra   ", rev, seg, MCFG_BUS_ANY, &pci_32b_read_ops }
+
+	ALTRA_ECAM_QUIRK(1, 0),
+	ALTRA_ECAM_QUIRK(1, 1),
+	ALTRA_ECAM_QUIRK(1, 2),
+	ALTRA_ECAM_QUIRK(1, 3),
+	ALTRA_ECAM_QUIRK(1, 4),
+	ALTRA_ECAM_QUIRK(1, 5),
+	ALTRA_ECAM_QUIRK(1, 6),
+	ALTRA_ECAM_QUIRK(1, 7),
+	ALTRA_ECAM_QUIRK(1, 8),
+	ALTRA_ECAM_QUIRK(1, 9),
+	ALTRA_ECAM_QUIRK(1, 10),
+	ALTRA_ECAM_QUIRK(1, 11),
+	ALTRA_ECAM_QUIRK(1, 12),
+	ALTRA_ECAM_QUIRK(1, 13),
+	ALTRA_ECAM_QUIRK(1, 14),
+	ALTRA_ECAM_QUIRK(1, 15),
 };
 
 static char mcfg_oem_id[ACPI_OEM_ID_SIZE];
diff --git a/drivers/pci/ecam.c b/drivers/pci/ecam.c
index 1a81af0ba961..9765d2eb79d2 100644
--- a/drivers/pci/ecam.c
+++ b/drivers/pci/ecam.c
@@ -164,4 +164,14 @@ struct pci_ecam_ops pci_32b_ops = {
 		.write		= pci_generic_config_write32,
 	}
 };
+
+/* ECAM ops for 32-bit read only (non-compliant) */
+struct pci_ecam_ops pci_32b_read_ops = {
+	.bus_shift	= 20,
+	.pci_ops	= {
+		.map_bus	= pci_ecam_map_bus,
+		.read		= pci_generic_config_read32,
+		.write		= pci_generic_config_write,
+	}
+};
 #endif
diff --git a/include/linux/pci-ecam.h b/include/linux/pci-ecam.h
index a73164c85e78..75456a66024a 100644
--- a/include/linux/pci-ecam.h
+++ b/include/linux/pci-ecam.h
@@ -51,6 +51,7 @@ extern struct pci_ecam_ops pci_generic_ecam_ops;
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_PCI_QUIRKS)
 extern struct pci_ecam_ops pci_32b_ops;		/* 32-bit accesses only */
+extern struct pci_ecam_ops pci_32b_read_ops; /* 32-bit read only */
 extern struct pci_ecam_ops hisi_pcie_ops;	/* HiSilicon */
 extern struct pci_ecam_ops thunder_pem_ecam_ops; /* Cavium ThunderX 1.x & 2.x */
 extern struct pci_ecam_ops pci_thunder_ecam_ops; /* Cavium ThunderX 1.x */
-- 
2.25.1

