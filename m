Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA49589CA4
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 15:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239625AbiHDN2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 09:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiHDN2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 09:28:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D9EE15737
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 06:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659619716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8mI2K9LPqJgaRLMP248bErw8NzNZESg05xXXJKMcom4=;
        b=EynKG9h6I5+Eb2m59TfswR/DOJVGuVxc0DoOJ3oWYqEEv46MSp/YTo4hsJRrqOZf0JgcKw
        Hg1cwn5qDuH3myCSuUa4yBYAg6nt2i36iwzk3BK4h/vI67hhSPnZXzjQJR05L/LkrV9mXx
        G8tiIuIh5fFGfT39ix/YpNw37gH2y7s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-HWZObBxFMVSJBh_rilcsmg-1; Thu, 04 Aug 2022 09:28:35 -0400
X-MC-Unique: HWZObBxFMVSJBh_rilcsmg-1
Received: by mail-wr1-f72.google.com with SMTP id u17-20020adfa191000000b0021ed2209fccso4811364wru.16
        for <stable@vger.kernel.org>; Thu, 04 Aug 2022 06:28:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=8mI2K9LPqJgaRLMP248bErw8NzNZESg05xXXJKMcom4=;
        b=pdbaW3QfvGDcedKFeU5DSMEYaxP2HG71VS9ev2dr8JSc8CBKhWRCqKnc2s+oWOHqcD
         8yMd2TkBCw2zXxV0OqaZCYbliioM3ne6xjyrILfX74z1CpsOWz70yumurUNQ+KhvVF6f
         KCABU1UbH7LvghQuDDKC5UvcCjohrzkUl0XU+1pUFoq5EXEWbKx+OegAFUCvilVqKkh0
         Ubrms5+q57OTIf2j02kkPT7O+TLDD1dQCluXNV0O8jYrj3ZPvuppg8gjfsABzG2pqubs
         zHgV7dVsalt5mDsxaO1SskCXDsyqXY3G9eqPjE73CkAzVfUr4QELnNjc7DQuWyHMhgEn
         3/nw==
X-Gm-Message-State: ACgBeo1fY7Z6tnSthSWLB4+puOAz++IlsNMj7rxhChyRIAEEyr/WA9N+
        QhsYtT+8vS7z94/yhDJrDPbxoDe6HTWqNvL0yYiuWOtXRMkF/ldaPD+kwDMIV/2wtJDUbPFKRHD
        svgUpu1Nhrgoy55Tc
X-Received: by 2002:a5d:50c6:0:b0:220:7a2a:bbd1 with SMTP id f6-20020a5d50c6000000b002207a2abbd1mr1428195wrt.471.1659619714284;
        Thu, 04 Aug 2022 06:28:34 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4+8brnDHpYm4si+9l3eNr2bcRsITNVeDi/VDvPQkPJPDf5a2PIGRTwY4bQ1YtD2eHppADynw==
X-Received: by 2002:a5d:50c6:0:b0:220:7a2a:bbd1 with SMTP id f6-20020a5d50c6000000b002207a2abbd1mr1428182wrt.471.1659619714056;
        Thu, 04 Aug 2022 06:28:34 -0700 (PDT)
Received: from goa-sendmail ([93.56.169.144])
        by smtp.gmail.com with ESMTPSA id q3-20020a056000136300b0021b956da1dcsm1142942wrz.113.2022.08.04.06.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 06:28:33 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Dave Young <ruyang@redhat.com>, Xiaoying Yan <yiyan@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>, stable@vger.kernel.org
Subject: [PATCH] KVM: x86: revalidate steal time cache if MSR value changes
Date:   Thu,  4 Aug 2022 15:28:32 +0200
Message-Id: <20220804132832.420648-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time
/ preempted status", 2021-11-11) open coded the previous call to
kvm_map_gfn, but in doing so it dropped the comparison between the cached
guest physical address and the one in the MSR.  This cause an incorrect
cache hit if the guest modifies the steal time address while the memslots
remain the same.  This can happen with kexec, in which case the steal
time data is written at the address used by the old kernel instead of
the old one.

While at it, rename the variable from gfn to gpa since it is a plain
physical address and not a right-shifted one.

Reported-by: Dave Young <ruyang@redhat.com>
Reported-by: Xiaoying Yan  <yiyan@redhat.com>
Analyzed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
Fixes: 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5fa335a4ea7..36dcf18b04bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3380,6 +3380,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
 	struct kvm_steal_time __user *st;
 	struct kvm_memslots *slots;
+	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
 	u64 steal;
 	u32 version;
 
@@ -3397,13 +3398,12 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	slots = kvm_memslots(vcpu->kvm);
 
 	if (unlikely(slots->generation != ghc->generation ||
+		     gpa != ghc->gpa ||
 		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
-		gfn_t gfn = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
-
 		/* We rely on the fact that it fits in a single page. */
 		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
 
-		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gfn, sizeof(*st)) ||
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof(*st)) ||
 		    kvm_is_error_hva(ghc->hva) || !ghc->memslot)
 			return;
 	}
-- 
2.37.1

