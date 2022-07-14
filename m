Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCE8574F65
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 15:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239825AbiGNNk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 09:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239229AbiGNNkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 09:40:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42C0161108
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 06:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657806053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aiVvGqWued69KlQMltHUGXgLkEsQEsLtjAg7jnmKF7w=;
        b=AKuYbaEW0LPIDjf1AwQvp6BQTWIUXFo9SF9ht4Of9UdjIJfdA694QcinAGONZN/BTkUztv
        5cE3ktn3DPp4qk3ZP3rm7dPP7TK35/s+zpRgiUg5Yt1MqNERqDwU6OCcpbCo1axUSe17tr
        oEkXRuK8QjuUriNP/SVOQQ3Zefq2ZGQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-wVx4bN3xOuSbvsaPEeSTrA-1; Thu, 14 Jul 2022 09:40:46 -0400
X-MC-Unique: wVx4bN3xOuSbvsaPEeSTrA-1
Received: by mail-pg1-f197.google.com with SMTP id e5-20020a636905000000b004119d180b54so1247649pgc.14
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 06:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aiVvGqWued69KlQMltHUGXgLkEsQEsLtjAg7jnmKF7w=;
        b=PmLw05oFxpGzhpdlHXC1L5RsNUz9ueaW059Myjf+fyy9T+/GlYdrenbP4rq2v7tgNs
         zxeu2fTsA2wdIpxRfUFcourSdyv7faQlW1OVWp0pUot97baxCSFBljV4EYJwTjMxAQZb
         Csy5Sa8VrUj1i2T/hcE2qpnS4bPUDCogGpXGCYUmmz3R7dG5ePx5WI1BW1pPHwLqrbfx
         aWfuuV1LdqAfHCLBc04Om31eiqLARlZjuDwTodo7LVNpCsMlqCaIfSj+qc4sRivmE68V
         rwiDvwdA02yhN5DTFH2dro/lcE5murBLDR8kdNuhfjeJY0sBOSINwvIs8/u/J1Hyfv5A
         I71Q==
X-Gm-Message-State: AJIora/b4boXL5nQPOofIpO7gESsGc8JhqvU982XvZVWVmc72Kp4Cpb4
        1Q920cJLOrvoozmMbyDm/b80RABPUEySRRryivbzZQDSOBRm0xNdxnU7r8cUHQkkAw1c1F1o40E
        YI0JHA9CFv2AriHpE
X-Received: by 2002:a17:903:2310:b0:16c:1546:19ba with SMTP id d16-20020a170903231000b0016c154619bamr8463333plh.57.1657806045387;
        Thu, 14 Jul 2022 06:40:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vR6P1tHGe2AUAKkpHoPoHZ3qPv099U+d+IUX/aj3wmn46jrsJ1Kfs8MRjpFEQ0YAvbKCgu6w==
X-Received: by 2002:a17:903:2310:b0:16c:1546:19ba with SMTP id d16-20020a170903231000b0016c154619bamr8463303plh.57.1657806045096;
        Thu, 14 Jul 2022 06:40:45 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o21-20020a170902779500b0016be24e3668sm1425461pll.291.2022.07.14.06.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 06:40:44 -0700 (PDT)
From:   Coiby Xu <coxu@redhat.com>
To:     kexec@lists.infradead.org, linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org,
        Michal Suchanek <msuchanek@suse.de>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Chun-Yi Lee <jlee@suse.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v10 1/4] kexec: clean up arch_kexec_kernel_verify_sig
Date:   Thu, 14 Jul 2022 21:40:24 +0800
Message-Id: <20220714134027.394370-2-coxu@redhat.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220714134027.394370-1-coxu@redhat.com>
References: <20220714134027.394370-1-coxu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before commit 105e10e2cf1c ("kexec_file: drop weak attribute from
functions"), there was already no arch-specific implementation
of arch_kexec_kernel_verify_sig. With weak attribute dropped by that
commit, arch_kexec_kernel_verify_sig is completely useless. So clean it
up.

Note this patch is dependent by later patches so it should backported to
the stable tree as well.

Cc: stable@vger.kernel.org
Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Reviewed-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 include/linux/kexec.h |  5 -----
 kernel/kexec_file.c   | 33 +++++++++++++--------------------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 6958c6b471f4..6e7510f39368 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -212,11 +212,6 @@ static inline void *arch_kexec_kernel_image_load(struct kimage *image)
 }
 #endif
 
-#ifdef CONFIG_KEXEC_SIG
-int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
-				 unsigned long buf_len);
-#endif
-
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
 
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 0c27c81351ee..6dc1294c90fc 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -81,24 +81,6 @@ int kexec_image_post_load_cleanup_default(struct kimage *image)
 	return image->fops->cleanup(image->image_loader_data);
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
-int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf, unsigned long buf_len)
-{
-	return kexec_image_verify_sig_default(image, buf, buf_len);
-}
-#endif
-
 /*
  * Free up memory used by kernel, initrd, and command line. This is temporary
  * memory allocation which is not needed any more after these buffers have
@@ -141,13 +123,24 @@ void kimage_file_post_load_cleanup(struct kimage *image)
 }
 
 #ifdef CONFIG_KEXEC_SIG
+static int kexec_image_verify_sig(struct kimage *image, void *buf,
+				  unsigned long buf_len)
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
+				     image->kernel_buf_len);
 	if (ret) {
 
 		if (sig_enforce) {
-- 
2.35.3

