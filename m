Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC3054FE19
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 22:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiFQUGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 16:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbiFQUG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 16:06:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947E05B8BC
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 13:06:27 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id q15so2808554wmj.2
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 13:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CJ9ZXqWod3uOnMrH/weENeVr2PZmZPM3KEpkv+3XM6o=;
        b=Yg1pRHwNsLWEPmxt64Nbw67eGiGSD8g+Ya5Sr4aehFJPxjTAdBui6vyDayeqoD6p5a
         tlccNO7PoysQQ0zc4cYfKZ2EITowRz9Uc3bS2w9StGNQxrnTx5RH272uEHE1wa/cnPWa
         nAet2MTEqUE+alS8zh0oE98fHCg6nEIkMwII2pzcOKre0UxdjOWVwkaVIFH2O8ZClMyg
         PY4AmIsImnZ9P/j//MDros/RtHUrq0bPgkRuilldhW416zYdF+GHM4Et/n3QgFfQYBux
         rbLcL/GBhRH/YOO9G4qCPsy6f87icWGQNtYF8f2kVn50pAzIs6sXcfokVdEYpvMOYG1M
         a9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CJ9ZXqWod3uOnMrH/weENeVr2PZmZPM3KEpkv+3XM6o=;
        b=BoeL1+RQfELYYWuRbe7jKvuZe5hY31v1Oq9lP7Mk1k6ojz1a62zb6x11jQl5oKuJPG
         x07EqKuqRelaMZzkPnLtYcs+Js58Wae2rAeLDwyjQWDssm0xaum+0/zcSZyk4P41g991
         6fWRDfWUJpWXoBbXB4VohAUy9IUd89YDgHP0WWLG0RGZiEaVt8CPEghNS2PuMO++A746
         G1vZVfw60tgX9cL5ZRICRvPgLaW076w0cfOt2KTF7s0MsddeUHrpyG34ODJWlLqJt0o0
         zTDmkl9w9qTeW3AI90PWaH8Ayu92gdXQDb/t6pSXDvEtxSKDQJgxQiJYTqmUmvehahJ5
         Oxvg==
X-Gm-Message-State: AJIora8bGbwrMD+9m6p6HWIxL/Efm300elLikmZjdKVu7o8btELQfqsb
        /GP2Is/0WiSk13CvnIuDBhs=
X-Google-Smtp-Source: AGRyM1vF9lN3oTEDY+2YzkMKNMk8m151+J0thwVT3nvNjd6j7wkpXMfgVjJlLmUV3dGa/hFw62+M4Q==
X-Received: by 2002:a05:600c:4f08:b0:39c:9437:da06 with SMTP id l8-20020a05600c4f0800b0039c9437da06mr11651626wmq.181.1655496385825;
        Fri, 17 Jun 2022 13:06:25 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id k12-20020adfe3cc000000b0021b859a3d5asm22038wrm.78.2022.06.17.13.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 13:06:25 -0700 (PDT)
Date:   Fri, 17 Jun 2022 21:06:23 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ashish.kalra@amd.com, pbonzini@redhat.com, pgonda@google.com,
        rientjes@google.com, theflow@google.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: SVM: Use kzalloc for sev ioctl
 interfaces to prevent" failed to apply to 5.10-stable tree
Message-ID: <Yqzev3h3KHdBiuTB@debian>
References: <165426931519389@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a7sYPOD+bielTKlo"
Content-Disposition: inline
In-Reply-To: <165426931519389@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a7sYPOD+bielTKlo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Fri, Jun 03, 2022 at 05:15:15PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with eba04b20e486 ("KVM: x86: Account a variety
of miscellaneous allocations") which was needed for easier backporting.

--
Regards
Sudip

--a7sYPOD+bielTKlo
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-Account-a-variety-of-miscellaneous-allocatio.patch"

From a32f2e2d390d929a371ea7baef2bad7e42d2d3ee Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Mar 2021 19:30:25 -0700
Subject: [PATCH 1/2] KVM: x86: Account a variety of miscellaneous allocations

commit eba04b20e4861d9bdbd8470a13c0c6e824521a36 upstream.

Switch to GFP_KERNEL_ACCOUNT for a handful of allocations that are
clearly associated with a single task/VM.

Note, there are a several SEV allocations that aren't accounted, but
those can (hopefully) be fixed by using the local stack for memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210331023025.2485960-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 arch/x86/kvm/svm/sev.c    | 2 +-
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 23910e6a3f011..e7feaa7910ab3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1198,8 +1198,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	ret  = -ENOMEM;
-	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL);
-	save = kzalloc(sizeof(*save), GFP_KERNEL);
+	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL_ACCOUNT);
+	save = kzalloc(sizeof(*save), GFP_KERNEL_ACCOUNT);
 	if (!ctl || !save)
 		goto out_free;
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6c82ef22985d9..a0c4da5f7d7fe 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -537,7 +537,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		}
 
 		ret = -ENOMEM;
-		blob = kmalloc(params.len, GFP_KERNEL);
+		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			goto e_free;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e729f65c67600..cc647dcc228b7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -619,7 +619,7 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 	 * evmcs in singe VM shares same assist page.
 	 */
 	if (!*p_hv_pa_pg)
-		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
+		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
 
 	if (!*p_hv_pa_pg)
 		return -ENOMEM;
-- 
2.30.2


--a7sYPOD+bielTKlo
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-SVM-Use-kzalloc-for-sev-ioctl-interfaces-to-prev.patch"

From 7479eecc9a8955aac994cad3ee5e6e123f0b2059 Mon Sep 17 00:00:00 2001
From: Ashish Kalra <ashish.kalra@amd.com>
Date: Mon, 16 May 2022 15:43:10 +0000
Subject: [PATCH 2/2] KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent
 kernel data leak

commit d22d2474e3953996f03528b84b7f52cc26a39403 upstream.

For some sev ioctl interfaces, the length parameter that is passed maybe
less than or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data
that PSP firmware returns. In this case, kmalloc will allocate memory
that is the size of the input rather than the size of the data.
Since PSP firmware doesn't fully overwrite the allocated buffer, these
sev ioctl interface may return uninitialized kernel slab memory.

Reported-by: Andy Nguyen <theflow@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Suggested-by: Peter Gonda <pgonda@google.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Fixes: eaf78265a4ab3 ("KVM: SVM: Move SEV code to separate file")
Fixes: 2c07ded06427d ("KVM: SVM: add support for SEV attestation command")
Fixes: 4cfdd47d6d95a ("KVM: SVM: Add KVM_SEV SEND_START command")
Fixes: d3d1af85e2c75 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
Fixes: eba04b20e4861 ("KVM: x86: Account a variety of miscellaneous allocations")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Peter Gonda <pgonda@google.com>
Message-Id: <20220516154310.3685678-1-Ashish.Kalra@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a0c4da5f7d7fe..7397cc449e2fc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -537,7 +537,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		}
 
 		ret = -ENOMEM;
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			goto e_free;
 
@@ -676,7 +676,7 @@ static int __sev_dbg_decrypt_user(struct kvm *kvm, unsigned long paddr,
 	if (!IS_ALIGNED(dst_paddr, 16) ||
 	    !IS_ALIGNED(paddr,     16) ||
 	    !IS_ALIGNED(size,      16)) {
-		tpage = (void *)alloc_page(GFP_KERNEL);
+		tpage = (void *)alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!tpage)
 			return -ENOMEM;
 
-- 
2.30.2


--a7sYPOD+bielTKlo--
