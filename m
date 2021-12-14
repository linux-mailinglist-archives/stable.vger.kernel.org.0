Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EC4474E7F
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 00:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbhLNXVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 18:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhLNXVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 18:21:16 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A60C06173E
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 15:21:16 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id r130so19146974pfc.1
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 15:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DWjZjRsv4tD+w9qRLUX1i2B9Ki8I9AN3kx6gj18PMRk=;
        b=hxq0YmLTGRzBkQPvIN58iLvyz1qg/qdOQe31/HnpNXBC2aUE5t2N58pyn5KazeA8rb
         KnsIA83Xs2BVGw/A0EJTHIKrfUZyLck9o3PqFny6a6rqK6EGG5LWDiYbXrcGUSQC+4Cb
         Rw8Rhfu114Yl8MkV96U5NwkbYfjr16KqTVMWI/qOjeGiYfZuKzgZo7MdXJ7dyjR107Wy
         KDunVQME6nw0IYYuz6N+IagVGAk19eYkvk7i7nqDoh2agpEDPolfKltDDn4vS4aTCK4+
         mmfJuQoSqVZTWUWpQ5G6WU6kdfWsZ5iNfYF4kLC6URO4q70TGd3wEreon6mznJRlU8HX
         1PWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DWjZjRsv4tD+w9qRLUX1i2B9Ki8I9AN3kx6gj18PMRk=;
        b=DzSxf9fA+E9JeIkGPp56kwAWMy8tmiqnkgsXfedp8sPqCMkh2DfzJZ6ux95rNtUgZx
         4MGkLWvpDWb/lxzEE79IzAvPqyPP331B29qcRNwLN/uzBc8R7dwdQ0qTLY+MTRuiBRGK
         XTip3pWpkyOZw18y4uY2ueY55jwUFpheDhjUmvD7N+u/+xWyUf92lzMlEoExiSHg4Igc
         tI6I5JZzrBj6aKyUUoCIKc5+Q8AQG1XMWMYVtus32uTBqd7QWD7fF6Hb1Ah4OL37mrKg
         oBsdddWLjVxFQNF5BXmOORy/5yOgZYPdFIeEf1RqCM86S2TjMoJZHOS/2Bhxef/tU734
         Oqfg==
X-Gm-Message-State: AOAM5327h5pHDP3zdGVw5Bkd/686SKgGVbroGvtY9FOojNn2i5NQW1Gy
        fMZShr8nT62k6xqDopA/qe+e4Q==
X-Google-Smtp-Source: ABdhPJwQ2yMvsmOkmjBGk1RNf+ZtdAyFRBbCtE4QFFxzuNQPc/YA+n/Dc1l17R+DDv+4nNVGNwX7BQ==
X-Received: by 2002:a65:44c4:: with SMTP id g4mr5704209pgs.103.1639524075943;
        Tue, 14 Dec 2021 15:21:15 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id l26sm103826pgm.67.2021.12.14.15.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 15:21:15 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Subject: [PATCH RFC] KVM: x86/mmu: fix UAF in paging_update_accessed_dirty_bits
Date:   Tue, 14 Dec 2021 15:20:39 -0800
Message-Id: <20211214232039.851405-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.33.1
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
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
Cc: <kvm@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
Link: https://syzkaller.appspot.com/bug?id=6cb6102a0a7b0c52060753dd62d070a1d1e71347
Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 708a5d297fe1..5cf4815d1c45 100644
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
2.33.1

