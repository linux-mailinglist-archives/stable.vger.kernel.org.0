Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4898B319D13
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 12:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhBLLHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 06:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbhBLLHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 06:07:25 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C8CC061756
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 03:06:44 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id b2so12560521lfq.0
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 03:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p2xh5jdgGHTIrdu5lQXA6yzf53MI3dqdPEuKDN8QxP0=;
        b=awaLbyc7oZphZTpAspqt8g3EyUJFSVCH+NnR7m4d9Y2ufof0nl9DcCoSrdtbdTjIYg
         nMfDqMu5IywKsfxUoBTMyB6hpb0m4xElIcZ15V5gQWZSDJL1dQsfSKnLGe6TZcZaiwEu
         uzr3aMd+WvW5IF2efECaWAHlRZoLF/xfUlB9jlSBhPAL2RntxlfZ19Bxr4nncKnTA99A
         zuLVvv+BKY9mt3MfUzKosAqlJ6Wc9PolxjxGQrtYX0v1Uofu8cX3d4yRSzab9MVQ6/dc
         vIINbKeQtNzf6Zc6IrhVZZt9ilBsrbtYuAghUByZeFJQAtJ+aBlW/KtoNGUltUWonx+Z
         J/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p2xh5jdgGHTIrdu5lQXA6yzf53MI3dqdPEuKDN8QxP0=;
        b=g09B1MLi2b2z6+rbkOW0sDEzKSAGlJBvZFDRHKCb6ac8PF7Im1y9iLzlKO8jiCSU7L
         2mR0OaDxg5VOVxXf8lvya/gAgJPHur6onMZS0WnzqfDMg7bYdhlRm3W+MurK2osd6ufg
         S4rH7Z0StVmy0l5r0qHD9j9bYkckBk8T5ZwsZrwg8kPNyQu/c5LdglXTGSuyecwMuNMM
         BD49Wrr9+lGuNRmJoeJjxUqtPyXi0vPQW8Rkujvf+GC4peo7AH8JmBE1lLLgVvbo+iWT
         lXuBVOhb8Mv0+pw54uhPT7zXt4Y+SstNRuLyysSL25QjAQ/XghWgMmdVKrSnl05zye+l
         r9SA==
X-Gm-Message-State: AOAM532zco6qZoYP3dzk+E7evEtvf/gUWpvYg1AFD4FlzDtsPy5F+feA
        W7XQ6yjTaPYb75QSnPkCml1ztQ==
X-Google-Smtp-Source: ABdhPJw2RGg+jzJ/1l9de132plS/H1uvlpJ+LcoAaY6k+yoJV0lJ2JWSK9cvc/5Qbf0KuRj1KohNdw==
X-Received: by 2002:a05:6512:11e2:: with SMTP id p2mr1280262lfs.321.1613128003337;
        Fri, 12 Feb 2021 03:06:43 -0800 (PST)
Received: from localhost.localdomain (89-70-221-122.dynamic.chello.pl. [89.70.221.122])
        by smtp.gmail.com with ESMTPSA id 84sm937488lfd.131.2021.02.12.03.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 03:06:42 -0800 (PST)
From:   Lukasz Majczak <lma@semihalf.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Tj <ml.linux@elloe.vision>, Dirk Gouders <dirk@gouders.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Radoslaw Biernacki <rad@semihalf.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Alex Levin <levinale@google.com>, upstream@semihalf.com
Subject: [PATCH v5] tpm_tis: Add missing tpm_request/relinquish_locality() calls
Date:   Fri, 12 Feb 2021 12:06:00 +0100
Message-Id: <20210212110600.19216-1-lma@semihalf.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are missing calls to tpm_request_locality() before the calls to
the tpm_get_timeouts() and tpm_tis_probe_irq_single() - both functions
internally send commands to the tpm using tpm_tis_send_data()
which in turn, at the very beginning, calls the tpm_tis_status().
This one tries to read TPM_STS register, what fails and propagates
this error upward. The read fails due to lack of acquired locality,
as it is described in
TCG PC Client Platform TPM Profile (PTP) Specification,
paragraph 6.1 FIFO Interface Locality Usage per Register,
Table 39 Register Behavior Based on Locality Setting for FIFO
- a read attempt to TPM_STS_x Registers returns 0xFF in case of lack
of locality. The described situation manifests itself with
the following warning trace:

[    4.324298] TPM returned invalid status
[    4.324806] WARNING: CPU: 2 PID: 1 at drivers/char/tpm/tpm_tis_core.c:275 tpm_tis_status+0x86/0x8f

Tested on Samsung Chromebook Pro (Caroline), TPM 1.2 (SLB 9670)
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")

Signed-off-by: Lukasz Majczak <lma@semihalf.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Hi

I have tried to clean all the pointed issues, but decided to stay with 
tpm_request/relinquish_locality() calls instead of using tpm_chip_start/stop(),
the rationale behind this is that, in this case only locality is requested, there
is no need to enable/disable the clock, the similar case is present in
the probe_itpm() function.
One more clarification is that, the TPM present on my test machine is the SLB 9670
(not Cr50).

Best regards,
Lukasz

Changes:
v4->v5:
* Fixed style, typos, clarified commit message

 drivers/char/tpm/tpm-chip.c      |  6 ++++--
 drivers/char/tpm/tpm-interface.c | 13 ++++++++++---
 drivers/char/tpm/tpm.h           |  2 ++
 drivers/char/tpm/tpm_tis_core.c  | 14 +++++++++++---
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index ddaeceb7e109..ce9c2650fbe5 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -32,7 +32,7 @@ struct class *tpm_class;
 struct class *tpmrm_class;
 dev_t tpm_devt;
 
-static int tpm_request_locality(struct tpm_chip *chip)
+int tpm_request_locality(struct tpm_chip *chip)
 {
 	int rc;
 
@@ -46,8 +46,9 @@ static int tpm_request_locality(struct tpm_chip *chip)
 	chip->locality = rc;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(tpm_request_locality);
 
-static void tpm_relinquish_locality(struct tpm_chip *chip)
+void tpm_relinquish_locality(struct tpm_chip *chip)
 {
 	int rc;
 
@@ -60,6 +61,7 @@ static void tpm_relinquish_locality(struct tpm_chip *chip)
 
 	chip->locality = -1;
 }
+EXPORT_SYMBOL_GPL(tpm_relinquish_locality);
 
 static int tpm_cmd_ready(struct tpm_chip *chip)
 {
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1621ce818705..2a9001d329f2 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -241,10 +241,17 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	if (chip->flags & TPM_CHIP_FLAG_HAVE_TIMEOUTS)
 		return 0;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		return tpm2_get_timeouts(chip);
-	else
-		return tpm1_get_timeouts(chip);
+	} else {
+		ssize_t ret = tpm_request_locality(chip);
+
+		if (ret)
+			return ret;
+		ret = tpm1_get_timeouts(chip);
+		tpm_relinquish_locality(chip);
+		return ret;
+	}
 }
 EXPORT_SYMBOL_GPL(tpm_get_timeouts);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 947d1db0a5cc..8c13008437dd 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -193,6 +193,8 @@ static inline void tpm_msleep(unsigned int delay_msec)
 
 int tpm_chip_start(struct tpm_chip *chip);
 void tpm_chip_stop(struct tpm_chip *chip);
+int tpm_request_locality(struct tpm_chip *chip);
+void tpm_relinquish_locality(struct tpm_chip *chip);
 struct tpm_chip *tpm_find_get_ops(struct tpm_chip *chip);
 __must_check int tpm_try_get_ops(struct tpm_chip *chip);
 void tpm_put_ops(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 431919d5f48a..d4f381d6356e 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -708,11 +708,19 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
 	u32 cap2;
 	cap_t cap;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
-	else
-		return tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc,
+	} else {
+		ssize_t ret = tpm_request_locality(chip);
+
+		if (ret)
+			return ret;
+		ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc,
 				  0);
+		tpm_relinquish_locality(chip);
+		return ret;
+	}
+
 }
 
 /* Register the IRQ and issue a command that will cause an interrupt. If an
-- 
2.25.1

