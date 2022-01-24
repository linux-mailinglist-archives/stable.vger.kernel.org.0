Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC79D499FC0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842115AbiAXXA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836494AbiAXWjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:37 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED314C054877
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:02:05 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id a8so11894235pfa.6
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=/8Jvy8+1AuSUSSjcQD4uSaNlO4M4Keg7QcOQU8Y4XpA=;
        b=tLG6UpcA+QIhV7xwfL2OCYZfAdJzxl/Is7oKQ8wwtJ/wv/i/jwC2SoW+DZ0MOnJDT2
         9Lz0UXFimK8dPdE4pf9Td9W9k4JuKGUvwjOrEYbMae9UTgwaOehK1bOC8gq+EmPWYMFP
         ANfst1slk+YJ/HPofdTj9YqN+ffGVQqBXIDqAINONdHwTKmPRQnDw/pzrTBxtDLaBM2O
         OE+FEeVuJmjK6uiU4u8QVvlqBqcNvKWNAvDFr+8lDGUDR1Q67fhJrneR7OcQ2wS1vD3x
         mQNgPazkrsfmLFzo64v3bRAAoLqO3/wxQ9wYKVQlBCKvgfY8/N2FKqpI0HSD+FB+k2ZK
         rXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=/8Jvy8+1AuSUSSjcQD4uSaNlO4M4Keg7QcOQU8Y4XpA=;
        b=YmSInzqxe3nKxXNuTCUXqBww/OQmlJY3EnS7szJOi4CL33lMcO4h0TbZ4FrI3uoe8X
         xvSOkv5CCVSzLhtHw1qEQuELPx7RbWo66EHglTzmxyFkoecfDbLjfWGKnTfJHuUAA5OT
         QM+p+4lzCLutgUWtHwmyPFcFOU2QlCAM+C6jp+rG37LGr50KYZn+baubFxIys2EsUHZ3
         mTd4irRbp61yd3ryWsUHQbrV9xjCe1gdIpScXxRiS8oxPcLITSwe20CYV2n99kGgsziX
         quD2YA3o0SwYKh563VbGREKhJaVsN9eAkfuce2CkqJENbPNuDhKFs1QqYfzoXI4GNh+X
         JZTg==
X-Gm-Message-State: AOAM530ykTSH/TCxBRDSz9XsKh+pYeukTxWN5gEyNW42G0dhmZ3wjfqB
        u48WeZsb3W2s2iQOE9J3vW1CYA==
X-Google-Smtp-Source: ABdhPJxcTx8kUjf6Cuqtq7b4/bi8NnbieAj80mLDsJsk0VWY240X8+odxCxofttu1DpdmoN4jlRQJg==
X-Received: by 2002:a63:8443:: with SMTP id k64mr8838913pgd.127.1643058125435;
        Mon, 24 Jan 2022 13:02:05 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id u10sm12806530pgl.68.2022.01.24.13.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 13:02:05 -0800 (PST)
Message-ID: <a806f5e1-9247-679c-4990-0bbf6c8de9d9@linaro.org>
Date:   Mon, 24 Jan 2022 13:02:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
References: <20220124172633.103323-1-tadeusz.struk@linaro.org>
 <6fd96538-b767-41e8-0cca-5b9be1dbb1c9@redhat.com>
 <Ye7wCbRpcbU2G4qH@google.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH RESEND] KVM: x86/mmu: fix UAF in
 paging_update_accessed_dirty_bits
In-Reply-To: <Ye7wCbRpcbU2G4qH@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 10:29, Sean Christopherson wrote:
> On Mon, Jan 24, 2022, Paolo Bonzini wrote:
>> On 1/24/22 18:26, Tadeusz Struk wrote:
>>> Syzbot reported an use-after-free bug in update_accessed_dirty_bits().
>>> Fix this by checking if the memremap'ed pointer is still valid.
>> access_ok only checks that the pointer is in the userspace range.  Is this
>> correct?  And if so, what are the exact circumstances in which access_ok
>> returns a non-NULL but also non-userspace address?
> I "objected" to this patch in its initial posting[*].  AFAICT adding access_ok()
> is just masking a more egregious bug where interpretation of vm_pgoff as a PFN
> base is flat out wrong except for select backing stores that use VM_PFNMAP.  In
> other words, the vm_pgoff hack works for the /dev/mem use case, but it is wrong
> in general.
> 

The issue here is not related to /dev/mem, but binder allocated memory, which is
yet another special mapping use case. In this case the condition

if (!vma || !(vma->vm_flags & VM_PFNMAP))

doesn't cover this special mappings. Adding the access_ok() was my something
that fixed the use-after-free issue for me, and since I didn't have anything
better I thought I will send an RFC to start some discussion.
After some more debugging I came up with the bellow.
Will that be more acceptable?


diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5b5bdac97c7b..0f03e5401a98 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -167,7 +167,7 @@ static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct 
kvm_mmu *mmu,

                 mmap_read_lock(current->mm);
                 vma = find_vma_intersection(current->mm, vaddr, vaddr + PAGE_SIZE);
-               if (!vma || !(vma->vm_flags & VM_PFNMAP)) {
+               if (!vma || !(vma->vm_flags & VM_MIXEDMAP)) {
                         mmap_read_unlock(current->mm);
                         return -EFAULT;
                 }

-- 
Thanks,
Tadeusz
