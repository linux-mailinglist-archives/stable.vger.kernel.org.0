Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5770C585B54
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 19:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiG3REe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 13:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiG3REd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 13:04:33 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F8413F13
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:32 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id f5so605960eje.3
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=aaEle2Y+9h5QabMtHHW6QgGwF8ImVAx4a7F9Kq/rGWc=;
        b=JE7oGHIruK+r75t1tG7/Fzs957PvSsw2pex5TRP9Rn0lwya8Fb78X5I0B4szfjqgZh
         qXgspQCOtwegTyF53eZLca7sBXPrjNX1k3pP+HUkTK46aBMBNWibcn5ndE9IJF/F896C
         yWTFg58scHRoiARelhycmiGHMSnL+PVw9PxIWRmrOB89AMl/fZrg3ZiSRfDCt9fzYHMq
         IyU3hVJquKXSdLEpCRgiTru0bu19hyol20F4x4PU4LVy+kTLmc/OpIuxFT/Sz8blmrEw
         1llcAMF+LwBDodHy3Kz0fNvH7WcfwypU9+ifdByBqied+KnKTTQ+6UZaFAKHotkFa6gJ
         ey6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=aaEle2Y+9h5QabMtHHW6QgGwF8ImVAx4a7F9Kq/rGWc=;
        b=0lx5T7xDvJx2s0Bu5yRtXHKj/Hcae1ftY0XCZAZ4SSmnDK4EParCK6k04/gpYP/14s
         NZ/S4xRbr0gf+WPuxEXSgx17OQOak7+bGvKh11wOXdH1n+VMGeHNYKhSto3XeYatnS9+
         iieMNwM2jaJbXp74YKNEaAiOcTvVvjwdWMyjGD2sWQzfndvlSdoO+wH+DYSvSI/iguAw
         +ZaTVrqtpgLHxWMaGrmNxYosO2vKRj/gleYBG78/xRM9b3UvRw/Rkl651AsI8u3e1iCr
         nJ9Gt6kiVJvrQX5+0nXzVDV4p84WEWIvFwxuCZiLzq+vqHxpC46RrFPcwbtki9Pv78Bz
         hD6g==
X-Gm-Message-State: AJIora8UEZ/mjdoKk3MTQJo4chSvBlWKEhVa+GxCySM0gzzjr4PfOuFd
        3g/Dp08o6PewmrB7U4xXXovy4hEoO/t0Hw==
X-Google-Smtp-Source: AGRyM1sAiMtNPlZcm77TescW+SmKLVfuLZZm+EMZmk9Umuel0MP+Ve6hqTpiHqgP+lpVIb2qJCt+bQ==
X-Received: by 2002:a17:907:d26:b0:72b:8311:a167 with SMTP id gn38-20020a1709070d2600b0072b8311a167mr6659387ejc.89.1659200671413;
        Sat, 30 Jul 2022 10:04:31 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af2fc300f82d90934ef08f18.dip0.t-ipconnect.de. [2003:f6:af2f:c300:f82d:9093:4ef0:8f18])
        by smtp.googlemail.com with ESMTPSA id b8-20020aa7c908000000b0043af8007e7fsm4101868edt.3.2022.07.30.10.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 10:04:30 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 1/6] selinux: Minor cleanups
Date:   Sat, 30 Jul 2022 19:03:38 +0200
Message-Id: <20220730170343.11477-2-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220730170343.11477-1-theflamefire89@gmail.com>
References: <20220730170343.11477-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 420591128cb206201dc444c2d42fb6f299b2ecd0 upstream.

Fix the comment for function __inode_security_revalidate, which returns
an integer.

Use the LABEL_* constants consistently for isec->initialized.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
---
 security/selinux/hooks.c     | 3 ++-
 security/selinux/selinuxfs.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index eb503eccbacc..43f81db42169 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -237,6 +237,7 @@ static int inode_alloc_security(struct inode *inode)
 	isec->sid = SECINITSID_UNLABELED;
 	isec->sclass = SECCLASS_FILE;
 	isec->task_sid = sid;
+	isec->initialized = LABEL_INVALID;
 	inode->i_security = isec;
 
 	return 0;
@@ -247,7 +248,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 /*
  * Try reloading inode security labels that have been marked as invalid.  The
  * @may_sleep parameter indicates when sleeping and thus reloading labels is
- * allowed; when set to false, returns ERR_PTR(-ECHILD) when the label is
+ * allowed; when set to false, returns -ECHILD when the label is
  * invalid.  The @opt_dentry parameter should be set to a dentry of the inode;
  * when no dentry is available, set it to NULL instead.
  */
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index ef1226c1c3ad..a033306d14ee 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1301,7 +1301,7 @@ static int sel_make_bools(void)
 			goto out;
 
 		isec->sid = sid;
-		isec->initialized = 1;
+		isec->initialized = LABEL_INITIALIZED;
 		inode->i_fop = &sel_bool_ops;
 		inode->i_ino = i|SEL_BOOL_INO_OFFSET;
 		d_add(dentry, inode);
@@ -1835,7 +1835,7 @@ static int sel_fill_super(struct super_block *sb, void *data, int silent)
 	isec = (struct inode_security_struct *)inode->i_security;
 	isec->sid = SECINITSID_DEVNULL;
 	isec->sclass = SECCLASS_CHR_FILE;
-	isec->initialized = 1;
+	isec->initialized = LABEL_INITIALIZED;
 
 	init_special_inode(inode, S_IFCHR | S_IRUGO | S_IWUGO, MKDEV(MEM_MAJOR, 3));
 	d_add(dentry, inode);
-- 
2.25.1

