Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9EA4986B6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 18:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244579AbiAXR07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 12:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244581AbiAXR05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 12:26:57 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB53C06173D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:26:56 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so475720pjb.1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pIG7bqbcrRfwBrBEO23YURvyZTmv6ER+4jcJH0n36TE=;
        b=SToeYmIp5JOQZbs5CH+J4vKLppCYfB2k8jqDvBOFCk1hMN2PXv35OH1H5lwqw+uNqi
         nRQqcavTP4IGkcz7GZfdP95rl4VuOeNztobrcsuzGuHwft2m/WsigI/0D8eoQ2bVykUT
         Hn5XmyBOSw+R8O7fIgfS8KjpNie9lfJDWI713MJ42Ow4uQ6H99yf0hTaaFy4yO/wMJRn
         kNMf/xSkpOnYOEdZPiwtlLhp8rpbjYUM6Ej5rlDARTfDU2l7NcT+QbPE2R/VxqdIOzoR
         2FlrGo1t8GvfJdj4GbPJBQbwzagclO5Gp4RMZVCOXMyNpnEnbD2Bu3sfcYQVZdmqS1hU
         1lPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pIG7bqbcrRfwBrBEO23YURvyZTmv6ER+4jcJH0n36TE=;
        b=3bAAIb1jiT9LRJYEIIh1/rz2KoW1uYZxklHjqnF6vXXHKMKylb/Fcwnn+nhmLQWwXY
         Y1QEdnbMRBVDdcynESdmpNEBiqeWJFScgyEFLkcBVQ8eIM8jcPxcoWGrajjS51hNfI0m
         dPgcv4XeL2WKYmVYuGA0HBerjraF3TZ79AOdGimdntfl7dmRWu6JaMmlUFeUDjsFgOHf
         g81tbHR/TbZfxWaJJCc8ocmoXVXieaHaK7s8W8bMvCICpUPqKd//M2U+Pt07NA3ya066
         NeufF1Yj8PvJghP1E8ZJXcrn2Zwcn1xf2YN4SCM6P/7hWOkWkG0x3ceg+jZWw1fjnXxu
         CB3Q==
X-Gm-Message-State: AOAM533B529k1HjG8TqpIOysusB1Jo9CHXIvTsPJrkLplvqIJaoQkKFR
        NwlO9Zf+JfwgrTtDUdpbvyZ5rkJfslLZsQ==
X-Google-Smtp-Source: ABdhPJytryBwKdTfdv8G9wIlxQA+n9LtZmSgH8yZNG/WYWUuLtc7P5j91jqQwsCp1BNbvmkx5NrmJA==
X-Received: by 2002:a17:902:bc82:b0:148:eb68:f6dd with SMTP id bb2-20020a170902bc8200b00148eb68f6ddmr15339136plb.98.1643045216267;
        Mon, 24 Jan 2022 09:26:56 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id pc7sm15194530pjb.0.2022.01.24.09.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:26:55 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     pbonzini@redhat.com
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Subject: [PATCH RESEND] KVM: x86/mmu: fix UAF in paging_update_accessed_dirty_bits
Date:   Mon, 24 Jan 2022 09:26:33 -0800
Message-Id: <20220124172633.103323-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzbot reported an use-after-free bug in update_accessed_dirty_bits().
Fix this by checking if the memremap'ed pointer is still valid.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Cc: <stable@vger.kernel.org>
Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
Link: https://syzkaller.appspot.com/bug?id=6cb6102a0a7b0c52060753dd62d070a1d1e71347
Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5b5bdac97c7b..d25b72d7b1b1 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -174,7 +174,7 @@ static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 		paddr = pfn << PAGE_SHIFT;
 		table = memremap(paddr, PAGE_SIZE, MEMREMAP_WB);
-		if (!table) {
+		if (!table || !access_ok(table, PAGE_SIZE)) {
 			mmap_read_unlock(current->mm);
 			return -EFAULT;
 		}
-- 
2.34.1

