Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B251931DFFD
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 21:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhBQULJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 15:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbhBQULJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 15:11:09 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DAAC061756
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 12:10:28 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id m1so4861315wml.2
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 12:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dHKUONxby2mQUk6kLOSv1UCnndBYEWnjqF8SYWxhSEg=;
        b=bULlhzqMDGlpxTKuX7jPU9wYmc/FwA5cGAA848DZdVWG0OYaTmvdg4jPgDMk90DVj8
         42xDjmfP/z3vGgzB/S9Q5r1PMpipEOy1KX/vykeegksO3p7AIOZ9TuTREj8rFdhBId5B
         vmUe+pFNCPs6Ui9lLys2n04L4dVuTUU0Mbn2E0T0gMxnUpDtOf0kv8AmmZPWG9cWbFfc
         mEO0k8U2Mg43oc9u4JJbYbhgo292uSlPfOBdVd3+TOagiAlDNUd5e3FN1KPFed49af31
         9RojMRXzn5EvNNLGnBIMO8BOUAoYLQBQV8IFyuA80v8dUk7TmFszKT4pAOaEMDX6NmAC
         i0dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dHKUONxby2mQUk6kLOSv1UCnndBYEWnjqF8SYWxhSEg=;
        b=NJbV1FdZcKSoIlDRpojAz2xYxFQueSlCFV9XZmwcVLZ3PPozHBrstaPUA/P0K4Av4e
         GAfx0YzMqWnZ1C+0LEjuNypGC9htuEjioWMTDAh+cv1/LAjt4fd2qen789tBOLVvYB98
         6lDHRNylxmbIERrJXDFmlP2jRPsg1ZjanHBdREpjGveBn4aZh9f2krUwDEdJIvmSCDYb
         nRNy1GjlEW/bdgNXHN8sKKzM7Ndr/zcx3RTp8rWCe0uMMkv2FMtIOS//PEp0/Bcvo+FR
         TJwgcDD+KtcbiXXn7VVZhs/k74T1CGAs/DSuSyMnPw3isrMOIUQJ6UBnHgr+IzWFooTI
         ctwQ==
X-Gm-Message-State: AOAM5333BOUNjubgQqjHtoBlFKt44iHjUsvAYzKgqXyhQCMBwd0BKyQ4
        tex1tL74yJeCBW7Sb1OXRHU=
X-Google-Smtp-Source: ABdhPJx0wey4k9kV7WlOQ6fo6bbptQw8GbfQR9qpeJFNkyXdlXMm915MHG/Tf7RB8RT8wIudTUlFFQ==
X-Received: by 2002:a1c:a795:: with SMTP id q143mr469511wme.113.1613592627341;
        Wed, 17 Feb 2021 12:10:27 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id q2sm5260270wrx.79.2021.02.17.12.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 12:10:26 -0800 (PST)
Date:   Wed, 17 Feb 2021 20:10:24 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     aeasi@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: qla2xxx: Fix crash during driver
 load on big endian" failed to apply to 4.19-stable tree
Message-ID: <YC14MEZz+sssmM5A@debian>
References: <160915383115474@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MI+P8peXE1SBReUP"
Content-Disposition: inline
In-Reply-To: <160915383115474@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MI+P8peXE1SBReUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:10:31PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will apply to all branches till 4.4-stable.

--
Regards
Sudip

--MI+P8peXE1SBReUP
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-scsi-qla2xxx-Fix-crash-during-driver-load-on-big-end.patch"

From 3037a413f74ec78abdbd68ffb5576d9289b5ad41 Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Wed, 2 Dec 2020 05:23:04 -0800
Subject: [PATCH] scsi: qla2xxx: Fix crash during driver load on big endian
 machines

commit 8de309e7299a00b3045fb274f82b326f356404f0 upstream

Crash stack:
	[576544.715489] Unable to handle kernel paging request for data at address 0xd00000000f970000
	[576544.715497] Faulting instruction address: 0xd00000000f880f64
	[576544.715503] Oops: Kernel access of bad area, sig: 11 [#1]
	[576544.715506] SMP NR_CPUS=2048 NUMA pSeries
	:
	[576544.715703] NIP [d00000000f880f64] .qla27xx_fwdt_template_valid+0x94/0x100 [qla2xxx]
	[576544.715722] LR [d00000000f7952dc] .qla24xx_load_risc_flash+0x2fc/0x590 [qla2xxx]
	[576544.715726] Call Trace:
	[576544.715731] [c0000004d0ffb000] [c0000006fe02c350] 0xc0000006fe02c350 (unreliable)
	[576544.715750] [c0000004d0ffb080] [d00000000f7952dc] .qla24xx_load_risc_flash+0x2fc/0x590 [qla2xxx]
	[576544.715770] [c0000004d0ffb170] [d00000000f7aa034] .qla81xx_load_risc+0x84/0x1a0 [qla2xxx]
	[576544.715789] [c0000004d0ffb210] [d00000000f79f7c8] .qla2x00_setup_chip+0xc8/0x910 [qla2xxx]
	[576544.715808] [c0000004d0ffb300] [d00000000f7a631c] .qla2x00_initialize_adapter+0x4dc/0xb00 [qla2xxx]
	[576544.715826] [c0000004d0ffb3e0] [d00000000f78ce28] .qla2x00_probe_one+0xf08/0x2200 [qla2xxx]

Link: https://lore.kernel.org/r/20201202132312.19966-8-njavali@marvell.com
Fixes: f73cb695d3ec ("[SCSI] qla2xxx: Add support for ISP2071.")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 9 +++++----
 drivers/scsi/qla2xxx/qla_tmpl.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 0ccd06f11f12..de3136294097 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -940,7 +940,8 @@ qla27xx_template_checksum(void *p, ulong size)
 static inline int
 qla27xx_verify_template_checksum(struct qla27xx_fwdt_template *tmp)
 {
-	return qla27xx_template_checksum(tmp, tmp->template_size) == 0;
+	return qla27xx_template_checksum(tmp,
+		le32_to_cpu(tmp->template_size)) == 0;
 }
 
 static inline int
@@ -956,7 +957,7 @@ qla27xx_execute_fwdt_template(struct scsi_qla_host *vha)
 	ulong len;
 
 	if (qla27xx_fwdt_template_valid(tmp)) {
-		len = tmp->template_size;
+		len = le32_to_cpu(tmp->template_size);
 		tmp = memcpy(vha->hw->fw_dump, tmp, len);
 		ql27xx_edit_template(vha, tmp);
 		qla27xx_walk_template(vha, tmp, tmp, &len);
@@ -972,7 +973,7 @@ qla27xx_fwdt_calculate_dump_size(struct scsi_qla_host *vha)
 	ulong len = 0;
 
 	if (qla27xx_fwdt_template_valid(tmp)) {
-		len = tmp->template_size;
+		len = le32_to_cpu(tmp->template_size);
 		qla27xx_walk_template(vha, tmp, NULL, &len);
 	}
 
@@ -984,7 +985,7 @@ qla27xx_fwdt_template_size(void *p)
 {
 	struct qla27xx_fwdt_template *tmp = p;
 
-	return tmp->template_size;
+	return le32_to_cpu(tmp->template_size);
 }
 
 ulong
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.h b/drivers/scsi/qla2xxx/qla_tmpl.h
index 141c1c5e73f4..2d3e1a8349b3 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.h
+++ b/drivers/scsi/qla2xxx/qla_tmpl.h
@@ -13,7 +13,7 @@
 struct __packed qla27xx_fwdt_template {
 	uint32_t template_type;
 	uint32_t entry_offset;
-	uint32_t template_size;
+	__le32 template_size;
 	uint32_t reserved_1;
 
 	uint32_t entry_count;
-- 
2.30.0


--MI+P8peXE1SBReUP--
