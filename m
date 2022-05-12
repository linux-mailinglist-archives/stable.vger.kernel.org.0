Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B350B5242C3
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 04:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240794AbiELCeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 22:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiELCeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 22:34:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1C48134E36
        for <stable@vger.kernel.org>; Wed, 11 May 2022 19:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652322851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p1RM6J3uuTVxgrBSDhjonzu3khLVyy7UfT2z18Xr7/8=;
        b=CU2JrXKRzM3yVYdSqrGdd1bi2JhlNW/FzPyTNFm097pLH+bCOYwBT+HZheRi6JBIuy4U1d
        jeUvZCQhg8yStoERhz1woU66w6SmUXdZqs0qpTc4d9kyZxSZK4E5CbIZmWL8HQFZOgUzeG
        9J+gfkNCDON4Fo1LpozKl8cKBXpCGuE=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-VhBrZaULNQGaidzi6EZzMg-1; Wed, 11 May 2022 22:34:10 -0400
X-MC-Unique: VhBrZaULNQGaidzi6EZzMg-1
Received: by mail-pj1-f71.google.com with SMTP id i12-20020a17090a64cc00b001dccafbd493so3893870pjm.3
        for <stable@vger.kernel.org>; Wed, 11 May 2022 19:34:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p1RM6J3uuTVxgrBSDhjonzu3khLVyy7UfT2z18Xr7/8=;
        b=TOp8OBpUiuc/cF+ELx9JzAm8gPi4sBOVZYc5YZ6au+8dWjMVSfj/IKojgvzvWPeckt
         QEpGtZz2NSX4N2nyqcH5WMUXlh08+LFLZnFMriS+bkpV7ZpgKzjpzFhOUt3OpML7o4c3
         PrGVljB4opQA/BSFLilw1eqLXVg0LIQuy11h9XjhbM2cy5TXhTkIqbBBjoFUmZkmeGjA
         qEB3WD1ORskKH9d7jwuK4x9vZh6W0jQk/db6oiYeX9Fe5DltXQRfmikxDlPT0F0O7Lt9
         0LbwmeJlD+L+qlr7dm/8Y5F5+DWXfU+0X38CQJ+4gTPbxOxjqjVDRMIduaEVe/a9nzyr
         B1gA==
X-Gm-Message-State: AOAM5333i6dKvWT7nVKR90EUAoepvaalytmDqXO+ib+0epIDFnsVq4ev
        gAD1w0tF6Y70HApYJVh2JBS3KKDqZsX+W6rkS47he3/VFE63F7/IyxYUfFrTGnFZutMmKvtyNK3
        OOH3oBdn0QnQcH9ej
X-Received: by 2002:a17:903:230b:b0:15e:bc9c:18c7 with SMTP id d11-20020a170903230b00b0015ebc9c18c7mr28317285plh.29.1652322849331;
        Wed, 11 May 2022 19:34:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBLwmAnT3YjOM0+q7aOBCPUuYBD9cDVb22vSPfF5bLWDIiVaY+O2ApMQ8Fxd/8OpkQUf8EAA==
X-Received: by 2002:a17:903:230b:b0:15e:bc9c:18c7 with SMTP id d11-20020a170903230b00b0015ebc9c18c7mr28317266plh.29.1652322849104;
        Wed, 11 May 2022 19:34:09 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 7-20020a621507000000b0050dc762812asm2475053pfv.4.2022.05.11.19.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 19:34:08 -0700 (PDT)
From:   Coiby Xu <coxu@redhat.com>
To:     kexec@lists.infradead.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Michal Suchanek <msuchanek@suse.de>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Mimi Zohar <zohar@linux.ibm.com>, Chun-Yi Lee <jlee@suse.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 1/4] kexec: clean up arch_kexec_kernel_verify_sig
Date:   Thu, 12 May 2022 10:33:59 +0800
Message-Id: <20220512023402.9913-2-coxu@redhat.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220512023402.9913-1-coxu@redhat.com>
References: <20220512023402.9913-1-coxu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently there is no arch-specific implementation of
arch_kexec_kernel_verify_sig. Even if we want to add an implementation
for an architecture in the future, we can simply use "(struct
kexec_file_ops*)->verify_sig". So clean it up.

Note this patch is needed by later patches so Cc it to the stable tree
as well.

Cc: stable@vger.kernel.org
Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Reviewed-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 include/linux/kexec.h |  4 ----
 kernel/kexec_file.c   | 34 +++++++++++++---------------------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 58d1b58a971e..413235c6c797 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -202,10 +202,6 @@ int arch_kexec_apply_relocations(struct purgatory_info *pi,
 				 const Elf_Shdr *relsec,
 				 const Elf_Shdr *symtab);
 int arch_kimage_file_post_load_cleanup(struct kimage *image);
-#ifdef CONFIG_KEXEC_SIG
-int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
-				 unsigned long buf_len);
-#endif
 int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf);
 
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 8347fc158d2b..3720435807eb 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -89,25 +89,6 @@ int __weak arch_kimage_file_post_load_cleanup(struct kimage *image)
 	return kexec_image_post_load_cleanup_default(image);
 }
 
-#ifdef CONFIG_KEXEC_SIG
-static int kexec_image_verify_sig_default(struct kimage *image, void *buf,
-					  unsigned long buf_len)
-{
-	if (!image->fops || !image->fops->verify_sig) {
-		pr_debug("kernel loader does not support signature verification.\n");
-		return -EKEYREJECTED;
-	}
-
-	return image->fops->verify_sig(buf, buf_len);
-}
-
-int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
-					unsigned long buf_len)
-{
-	return kexec_image_verify_sig_default(image, buf, buf_len);
-}
-#endif
-
 /*
  * arch_kexec_apply_relocations_add - apply relocations of type RELA
  * @pi:		Purgatory to be relocated.
@@ -184,13 +165,24 @@ void kimage_file_post_load_cleanup(struct kimage *image)
 }
 
 #ifdef CONFIG_KEXEC_SIG
+static int kexec_image_verify_sig(struct kimage *image, void *buf,
+		unsigned long buf_len)
+{
+	if (!image->fops || !image->fops->verify_sig) {
+		pr_debug("kernel loader does not support signature verification.\n");
+		return -EKEYREJECTED;
+	}
+
+	return image->fops->verify_sig(buf, buf_len);
+}
+
 static int
 kimage_validate_signature(struct kimage *image)
 {
 	int ret;
 
-	ret = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
-					   image->kernel_buf_len);
+	ret = kexec_image_verify_sig(image, image->kernel_buf,
+			image->kernel_buf_len);
 	if (ret) {
 
 		if (IS_ENABLED(CONFIG_KEXEC_SIG_FORCE)) {
-- 
2.35.3

