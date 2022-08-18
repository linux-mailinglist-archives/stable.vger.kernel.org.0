Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F847597D52
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 06:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243213AbiHREVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 00:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243217AbiHREVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 00:21:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CB6266E
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 21:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660796445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SMrl9R9Na006+oVqKBRzVE6TL1iKkeMxduae8kp14pQ=;
        b=FRnFeOTxJ9b18KKFhQvo6CYZsOZhZ5mqn8iPKs9QgwMmDhdpQPpvMLo02J8He9b1oHXlRc
        Xbu8JfesElmDb25VbGmlYJceDb6R62ykJjvRj6YZEzVpvxYwJ3CwzfzMK1PkfmOS8/J+la
        GWzbXbnBeNJbcr1WblEOrsLzMbhNtQI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-325-sTANOX8pPuSsfALskYlBTQ-1; Thu, 18 Aug 2022 00:20:44 -0400
X-MC-Unique: sTANOX8pPuSsfALskYlBTQ-1
Received: by mail-pj1-f72.google.com with SMTP id on14-20020a17090b1d0e00b001f842dd5e90so2225160pjb.5
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 21:20:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=SMrl9R9Na006+oVqKBRzVE6TL1iKkeMxduae8kp14pQ=;
        b=eTWn9BjaTrYfAbFC/AgNcUhSvWhFo9OJybZgMQwbBtvKu9bvukqzIrmiv47Kfj9ahh
         Yjd/UiDcqMq7gaBP6FuUzOltEGkMX+YE2qXJ/RjpHF1a1oVahKSDRK43+Sy8tH58G8hN
         lTgN609D7zGFfUj3mdfagN2K5a1dSwS98xPHdx9eWWAq02VLNnSSInPGxcnxz3O5BDfh
         1zrqwlHbAA5ktgPwERDssXaueVyq+YqktFDXEq/2zWWduhkjXMFMxRnZhTIYrLJV8yI7
         8pSNNIcIOwWAneVwUY4hX/zCEkMqNPSC3Amwftjv5jCG4ae9jGjU/ciuWNyLX/OQiGnF
         QdwA==
X-Gm-Message-State: ACgBeo0nBgrWnpRCwVlF8JGG5nDccOBO+pV6YIih8rFHlZb5lIwFV7MR
        JPeN5/3DbVu8JcCwV8Ize077k0WB8atwOX6OJTaez8pg5+AnxAG2eDOr+wN5RwoaFCDOkZKsGMZ
        Rbw/B/XUFFGhPPg+x
X-Received: by 2002:a63:cc42:0:b0:41d:c915:ffd with SMTP id q2-20020a63cc42000000b0041dc9150ffdmr1086407pgi.161.1660796443297;
        Wed, 17 Aug 2022 21:20:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7keLsnIoXwE9vTJyTddTTtmnZZ+tVH+E/mplogkoJx3E/5W0hQoTNUKzdujf8ngXOD9pwZ6w==
X-Received: by 2002:a63:cc42:0:b0:41d:c915:ffd with SMTP id q2-20020a63cc42000000b0041dc9150ffdmr1086396pgi.161.1660796443044;
        Wed, 17 Aug 2022 21:20:43 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902684700b0016d93c84049sm278876pln.54.2022.08.17.21.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 21:20:42 -0700 (PDT)
Date:   Thu, 18 Aug 2022 12:15:36 +0800
From:   Coiby Xu <coxu@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.10-stable tree
Message-ID: <20220818041536.5urxrunzmdawkdh7@Rk>
References: <166057758686253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166057758686253@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,


This patch depends on three prerequisites. This full list of commit ids
should be backported is shown below,

1. 65d9a9a60fd7 ("kexec_file: drop weak attribute from functions")
2. 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
3. c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
4. 0d519cadf751 ("arm64: kexec_file: use more system keyrings to verify kernel image signature")

$ git checkout -b arm_key_5.10.y stable/linux-5.10.y
Updating files: 100% (33255/33255), done.
branch 'arm_key_5.10.y' set up to track 'stable/linux-5.10.y'.
Switched to a new branch 'arm_key_5.10.y'
$ git cherry-pick 65d9a9a60fd7 689a71493bd2 c903dae8941d 0d519cadf751
Auto-merging arch/arm64/include/asm/kexec.h
Auto-merging arch/powerpc/include/asm/kexec.h
Auto-merging arch/s390/include/asm/kexec.h
Auto-merging arch/x86/include/asm/kexec.h
Auto-merging include/linux/kexec.h
Auto-merging kernel/kexec_file.c
[arm_key_5.10.y 624dfcf3b8de] kexec_file: drop weak attribute from functions
  Author: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
  Date: Fri Jul 1 13:04:04 2022 +0530
  6 files changed, 61 insertions(+), 40 deletions(-)
Auto-merging include/linux/kexec.h
Auto-merging kernel/kexec_file.c
[arm_key_5.10.y da8cfa52682e] kexec: clean up arch_kexec_kernel_verify_sig
  Date: Thu Jul 14 21:40:24 2022 +0800
  2 files changed, 13 insertions(+), 25 deletions(-)
Auto-merging arch/x86/kernel/kexec-bzimage64.c
Auto-merging include/linux/kexec.h
Auto-merging kernel/kexec_file.c
[arm_key_5.10.y 0bb032082ce6] kexec, KEYS: make the code in bzImage64_verify_sig generic
  Date: Thu Jul 14 21:40:25 2022 +0800
  3 files changed, 25 insertions(+), 19 deletions(-)
[arm_key_5.10.y fde64a36fa74] arm64: kexec_file: use more system keyrings to verify kernel image signature
  Date: Thu Jul 14 21:40:26 2022 +0800
  1 file changed, 1 insertion(+), 10 deletions(-)

On Mon, Aug 15, 2022 at 05:33:06PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.10-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 0d519cadf75184a24313568e7f489a7fc9b1be3b Mon Sep 17 00:00:00 2001
>From: Coiby Xu <coxu@redhat.com>
>Date: Thu, 14 Jul 2022 21:40:26 +0800
>Subject: [PATCH] arm64: kexec_file: use more system keyrings to verify kernel
> image signature
>
>Currently, when loading a kernel image via the kexec_file_load() system
>call, arm64 can only use the .builtin_trusted_keys keyring to verify
>a signature whereas x86 can use three more keyrings i.e.
>.secondary_trusted_keys, .machine and .platform keyrings. For example,
>one resulting problem is kexec'ing a kernel image  would be rejected
>with the error "Lockdown: kexec: kexec of unsigned images is restricted;
>see man kernel_lockdown.7".
>
>This patch set enables arm64 to make use of the same keyrings as x86 to
>verify the signature kexec'ed kernel image.
>
>Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")
>Cc: stable@vger.kernel.org # 105e10e2cf1c: kexec_file: drop weak attribute from functions
>Cc: stable@vger.kernel.org # 34d5960af253: kexec: clean up arch_kexec_kernel_verify_sig
>Cc: stable@vger.kernel.org # 83b7bb2d49ae: kexec, KEYS: make the code in bzImage64_verify_sig generic
>Acked-by: Baoquan He <bhe@redhat.com>
>Cc: kexec@lists.infradead.org
>Cc: keyrings@vger.kernel.org
>Cc: linux-security-module@vger.kernel.org
>Co-developed-by: Michal Suchanek <msuchanek@suse.de>
>Signed-off-by: Michal Suchanek <msuchanek@suse.de>
>Acked-by: Will Deacon <will@kernel.org>
>Signed-off-by: Coiby Xu <coxu@redhat.com>
>Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
>
>diff --git a/arch/arm64/kernel/kexec_image.c b/arch/arm64/kernel/kexec_image.c
>index 9ec34690e255..5ed6a585f21f 100644
>--- a/arch/arm64/kernel/kexec_image.c
>+++ b/arch/arm64/kernel/kexec_image.c
>@@ -14,7 +14,6 @@
> #include <linux/kexec.h>
> #include <linux/pe.h>
> #include <linux/string.h>
>-#include <linux/verification.h>
> #include <asm/byteorder.h>
> #include <asm/cpufeature.h>
> #include <asm/image.h>
>@@ -130,18 +129,10 @@ static void *image_load(struct kimage *image,
> 	return NULL;
> }
>
>-#ifdef CONFIG_KEXEC_IMAGE_VERIFY_SIG
>-static int image_verify_sig(const char *kernel, unsigned long kernel_len)
>-{
>-	return verify_pefile_signature(kernel, kernel_len, NULL,
>-				       VERIFYING_KEXEC_PE_SIGNATURE);
>-}
>-#endif
>-
> const struct kexec_file_ops kexec_image_ops = {
> 	.probe = image_probe,
> 	.load = image_load,
> #ifdef CONFIG_KEXEC_IMAGE_VERIFY_SIG
>-	.verify_sig = image_verify_sig,
>+	.verify_sig = kexec_kernel_verify_pe_sig,
> #endif
> };
>

-- 
Best regards,
Coiby

