Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC824597D48
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 06:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243312AbiHREV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 00:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242778AbiHREVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 00:21:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F25101EF
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 21:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660796457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I36rna5FAOQJp13ieaNi3Ban/4Cqm3eLfl9zIMannec=;
        b=PSIZUDs7vT0h498fdkk+U2M15spBCZ5g+H3zm7f7JePmFaWuBRf7HuCcuM4jT8BpfKtakd
        H/ruDSJVrlKY8H/oWGu606WyNKbLqYGbnAX7NR9g4RPLQsF6tM0ItyuOhn1EPQmwH0XRGf
        vWroSOwCe7wAHGVEj0rz0KUkA9/XCvM=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-pQFQmuSiM-CRq_hPoV4EBQ-1; Thu, 18 Aug 2022 00:20:56 -0400
X-MC-Unique: pQFQmuSiM-CRq_hPoV4EBQ-1
Received: by mail-pg1-f199.google.com with SMTP id h5-20020a636c05000000b00429fa12cb65so254124pgc.21
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 21:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=I36rna5FAOQJp13ieaNi3Ban/4Cqm3eLfl9zIMannec=;
        b=gTeRP6w0r1ZZHVKLi6c7czstiJ/UFZlRQbLdWF3W33VMDtkcsbUylzxkOrS620ejpd
         8keSibLhFZAZ0H6lMNbQ/7E4UvA5pwjsqyiDs6NlHgsFXoy13MZadmeRfLr14CC0AR4f
         ix4UsfnQ6bRTArGOcM0t5FiBcZvefcdhU/n7BqrP6u6J0E8GjhfaOIQKdi4pkRfro/VE
         pKdOElS8V1b1i2NCVBSKZ0bHKhehs08sjJ49i2dM+b3wLN4vmfwZooGdXD1PweZbrRzk
         tdekOnVyf89mrm40suuIdJE/8CmAF+uT2Afd5Nd40L8rXiOwc6jkZgyDJqSQegiLfbr8
         fqfQ==
X-Gm-Message-State: ACgBeo2cpPuYI61r9kkE4E3dG2YL6NhCjucFeCjzWu8ZQcxMO7dvPRQR
        IZYFyKzY9KeZiaoefTIn1v3MxBYvvmzMX/XA5ouylzmoJG4cqReOsm62VrSiIGeccB6/iaIu0K6
        HGIWM0Z6choTNxCtm
X-Received: by 2002:a63:6e81:0:b0:419:f7b1:4b12 with SMTP id j123-20020a636e81000000b00419f7b14b12mr1114070pgc.406.1660796454941;
        Wed, 17 Aug 2022 21:20:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6okgOp4ilGxDUMEF+vSalV2XJOVgSBeXWiP56zVFUZj+B7r7PYurrbMqDxAOly55NP2L4oCQ==
X-Received: by 2002:a63:6e81:0:b0:419:f7b1:4b12 with SMTP id j123-20020a636e81000000b00419f7b14b12mr1114062pgc.406.1660796454728;
        Wed, 17 Aug 2022 21:20:54 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u64-20020a627943000000b005346d61402csm384106pfc.50.2022.08.17.21.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 21:20:54 -0700 (PDT)
Date:   Thu, 18 Aug 2022 12:19:06 +0800
From:   Coiby Xu <coxu@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.18-stable tree
Message-ID: <20220818041906.dgj4eqrpropved4e@Rk>
References: <16605775842425@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <16605775842425@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This patch depends on three prerequisites but 5.18-stable tree has two
prerequisites backported. So the full list of commit ids should be
backported is shown below,
1. c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
2. 0d519cadf751 ("arm64: kexec_file: use more system keyrings to verify kernel image signature")

$ git checkout -b arm_key_5.18.y stable/linux-5.18.y                
Updating files: 100% (43489/43489), done.
branch 'arm_key_5.18.y' set up to track 'stable/linux-5.18.y'.
Switched to a new branch 'arm_key_5.18.y'

$ git cherry-pick c903dae8941d 0d519cadf751 
Auto-merging include/linux/kexec.h
Auto-merging kernel/kexec_file.c
[arm_key_5.18.y f3c9c5542700] kexec, KEYS: make the code in bzImage64_verify_sig generic
  Date: Thu Jul 14 21:40:25 2022 +0800
  3 files changed, 25 insertions(+), 19 deletions(-)
[arm_key_5.18.y 532854860941] arm64: kexec_file: use more system keyrings to verify kernel image signature
  Date: Thu Jul 14 21:40:26 2022 +0800
  1 file changed, 1 insertion(+), 10 deletions(-)

On Mon, Aug 15, 2022 at 05:33:04PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.18-stable tree.
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

