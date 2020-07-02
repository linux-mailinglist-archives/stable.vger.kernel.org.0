Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A7A213046
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 01:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgGBXzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 19:55:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56692 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726015AbgGBXzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 19:55:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593734148;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=+ftIgISrQQoJcDv2R/LS9YcKQ3ZdQs2UrwLyikN4zm0=;
        b=Y/HLi9aEuqZ+XShaGDkDbSLVTkn5WqOcSzP/G5nREaydwKM9CI+GE6sMsHqBCkV2brrlyg
        33btNropB1ngFtjROKV9dECXVdZNLVcI1eE7djj11k9ZM7DLxKTQbdW5IfxAREuxjdcOYa
        WVb3vjE5ai0l+xgC6dcAe6EWz+rnq30=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-nBIdnEByMfS0US29zTVamw-1; Thu, 02 Jul 2020 19:55:47 -0400
X-MC-Unique: nBIdnEByMfS0US29zTVamw-1
Received: by mail-qv1-f69.google.com with SMTP id ed5so3205012qvb.9
        for <stable@vger.kernel.org>; Thu, 02 Jul 2020 16:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=+ftIgISrQQoJcDv2R/LS9YcKQ3ZdQs2UrwLyikN4zm0=;
        b=Mf/S5H5s3+1RCDLs9xi5UPBYrKMPwFs6r7e15tLf48dRzujvq4CNCc1nMHTliE+/Xf
         jkJsg4vdDtpZ7kRFX2T0I42Q7Env4VAQZqHWhHbKwmS2qOISrwg+fixLIgQtFZskGbXg
         FnMsdHnTAKF+p2L2V6sCM1agPW/vYSAHOh73x4Rp/CuSZdQ/6bIdCt74L65vWd+U8oVH
         ASF4jMND1qG2u0ECSG8FlRSz7oifn7MEnByzMotiLEqBZ/iR3EbNmi1xPMiUbC94sIq4
         qJDRr33kepp2YWW5jqXsrMsnziiiZCAiOnIUvTQaEQB+3dE8euaJnoLWaCNq5m2h6tsD
         jyPg==
X-Gm-Message-State: AOAM530RXYRvZnst/YGlqirkAS8cxmtE6IrQZIZyM/1yVXYacEEysVgW
        mL8AiqK+MPnVDWPBvhkgar/CHOTjkjRBGOPTtRGhKUk0YoAeXOmR5JJbV3rh4oWndX/TIBRu9B1
        Ortp/umWsyqqtmtwe
X-Received: by 2002:aed:3904:: with SMTP id l4mr30326218qte.370.1593734146746;
        Thu, 02 Jul 2020 16:55:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzye5HUiv8TSz4Fdr0d5NIM9B7qAJXuk34Oq1wxdW9/2ExxHXdthkxzzs7D43ntVNWPMWYFNQ==
X-Received: by 2002:aed:3904:: with SMTP id l4mr30326201qte.370.1593734146487;
        Thu, 02 Jul 2020 16:55:46 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id o50sm10214519qtc.64.2020.07.02.16.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 16:55:45 -0700 (PDT)
Date:   Thu, 2 Jul 2020 16:55:44 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alexey Klimov <aklimov@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm: Define TPM2_SPACE_BUFFER_SIZE to replace the use of
 PAGE_SIZE
Message-ID: <20200702235544.4o7dbgvlq3br2x7e@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alexey Klimov <aklimov@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20200702225603.293122-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20200702225603.293122-1-jarkko.sakkinen@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri Jul 03 20, Jarkko Sakkinen wrote:
>The size of the buffers for storing context's and sessions can vary from
>arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
>maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
>enough for most use with three handles (that is how many we allow at the
>moment). Parametrize the buffer size while doing this, so that it is easier
>to revisit this later on if required.
>
>Reported-by: Stefan Berger <stefanb@linux.ibm.com>
>Cc: stable@vger.kernel.org
>Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
>Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

>---
>v2: Also use the new buffer size for chip->work_buffer (reported by stefanb)
> drivers/char/tpm/tpm-chip.c   |  9 ++-------
> drivers/char/tpm/tpm.h        |  5 ++++-
> drivers/char/tpm/tpm2-space.c | 26 ++++++++++++++++----------
> drivers/char/tpm/tpmrm-dev.c  |  2 +-
> include/linux/tpm.h           |  5 +++--
> 5 files changed, 26 insertions(+), 21 deletions(-)
>
>diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>index 8c77e88012e9..ddaeceb7e109 100644
>--- a/drivers/char/tpm/tpm-chip.c
>+++ b/drivers/char/tpm/tpm-chip.c
>@@ -386,13 +386,8 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
> 	chip->cdev.owner = THIS_MODULE;
> 	chip->cdevs.owner = THIS_MODULE;
>
>-	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
>-	if (!chip->work_space.context_buf) {
>-		rc = -ENOMEM;
>-		goto out;
>-	}
>-	chip->work_space.session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
>-	if (!chip->work_space.session_buf) {
>+	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
>+	if (rc) {
> 		rc = -ENOMEM;
> 		goto out;
> 	}
>diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>index 0fbcede241ea..947d1db0a5cc 100644
>--- a/drivers/char/tpm/tpm.h
>+++ b/drivers/char/tpm/tpm.h
>@@ -59,6 +59,9 @@ enum tpm_addr {
>
> #define TPM_TAG_RQU_COMMAND 193
>
>+/* TPM2 specific constants. */
>+#define TPM2_SPACE_BUFFER_SIZE		16384 /* 16 kB */
>+
> struct	stclear_flags_t {
> 	__be16	tag;
> 	u8	deactivated;
>@@ -228,7 +231,7 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
> int tpm2_probe(struct tpm_chip *chip);
> int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip);
> int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
>-int tpm2_init_space(struct tpm_space *space);
>+int tpm2_init_space(struct tpm_space *space, unsigned int buf_size);
> void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space);
> void tpm2_flush_space(struct tpm_chip *chip);
> int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
>diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
>index 982d341d8837..784b8b3cb903 100644
>--- a/drivers/char/tpm/tpm2-space.c
>+++ b/drivers/char/tpm/tpm2-space.c
>@@ -38,18 +38,21 @@ static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
> 	}
> }
>
>-int tpm2_init_space(struct tpm_space *space)
>+int tpm2_init_space(struct tpm_space *space, unsigned int buf_size)
> {
>-	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
>+	space->context_buf = kzalloc(buf_size, GFP_KERNEL);
> 	if (!space->context_buf)
> 		return -ENOMEM;
>
>-	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
>+	space->session_buf = kzalloc(buf_size, GFP_KERNEL);
> 	if (space->session_buf == NULL) {
> 		kfree(space->context_buf);
>+		/* Prevent caller getting a dangling pointer. */
>+		space->context_buf = NULL;
> 		return -ENOMEM;
> 	}
>
>+	space->buf_size = buf_size;
> 	return 0;
> }
>
>@@ -311,8 +314,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
> 	       sizeof(space->context_tbl));
> 	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
> 	       sizeof(space->session_tbl));
>-	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
>-	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
>+	memcpy(chip->work_space.context_buf, space->context_buf,
>+	       space->buf_size);
>+	memcpy(chip->work_space.session_buf, space->session_buf,
>+	       space->buf_size);
>
> 	rc = tpm2_load_space(chip);
> 	if (rc) {
>@@ -492,7 +497,7 @@ static int tpm2_save_space(struct tpm_chip *chip)
> 			continue;
>
> 		rc = tpm2_save_context(chip, space->context_tbl[i],
>-				       space->context_buf, PAGE_SIZE,
>+				       space->context_buf, space->buf_size,
> 				       &offset);
> 		if (rc == -ENOENT) {
> 			space->context_tbl[i] = 0;
>@@ -509,9 +514,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
> 			continue;
>
> 		rc = tpm2_save_context(chip, space->session_tbl[i],
>-				       space->session_buf, PAGE_SIZE,
>+				       space->session_buf, space->buf_size,
> 				       &offset);
>-
> 		if (rc == -ENOENT) {
> 			/* handle error saving session, just forget it */
> 			space->session_tbl[i] = 0;
>@@ -557,8 +561,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
> 	       sizeof(space->context_tbl));
> 	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
> 	       sizeof(space->session_tbl));
>-	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
>-	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
>+	memcpy(space->context_buf, chip->work_space.context_buf,
>+	       space->buf_size);
>+	memcpy(space->session_buf, chip->work_space.session_buf,
>+	       space->buf_size);
>
> 	return 0;
> out:
>diff --git a/drivers/char/tpm/tpmrm-dev.c b/drivers/char/tpm/tpmrm-dev.c
>index 7a0a7051a06f..eef0fb06ea83 100644
>--- a/drivers/char/tpm/tpmrm-dev.c
>+++ b/drivers/char/tpm/tpmrm-dev.c
>@@ -21,7 +21,7 @@ static int tpmrm_open(struct inode *inode, struct file *file)
> 	if (priv == NULL)
> 		return -ENOMEM;
>
>-	rc = tpm2_init_space(&priv->space);
>+	rc = tpm2_init_space(&priv->space, TPM2_SPACE_BUFFER_SIZE);
> 	if (rc) {
> 		kfree(priv);
> 		return -ENOMEM;
>diff --git a/include/linux/tpm.h b/include/linux/tpm.h
>index 03e9b184411b..d501156fedda 100644
>--- a/include/linux/tpm.h
>+++ b/include/linux/tpm.h
>@@ -93,9 +93,10 @@ enum tpm_duration {
>
> struct tpm_space {
> 	u32 context_tbl[3];
>-	u8 *context_buf;
>+	u8  *context_buf;
> 	u32 session_tbl[3];
>-	u8 *session_buf;
>+	u8  *session_buf;
>+	u32 buf_size;
> };
>
> struct tpm_bios_log {
>-- 
>2.25.1
>

