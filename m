Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAFB640D30
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 19:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiLBS3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 13:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbiLBS3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 13:29:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E482E5AB5
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 10:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670005713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZre19y9mqtRbVmthm+1akdsq6EMwOffWFy6wUyZzJw=;
        b=SGGzGPuo3t+oA2bNrR9ZnwFWus8Mq3jChci4HS7UNMDjhwDuhp5sTUcdl3vVvhqGM9LovH
        AgMVargCDXB8CKD3OGBMKA3vREWGSPRGdReItptz3uZYYCuAhPptZUgHrn0Sl581rV8sDZ
        hyapv36vrFCbnJvZIhdhI7qr/nfLY5Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-416-T7wzPwGuNSC7iD0i8CD2jg-1; Fri, 02 Dec 2022 13:28:31 -0500
X-MC-Unique: T7wzPwGuNSC7iD0i8CD2jg-1
Received: by mail-wm1-f71.google.com with SMTP id n2-20020a05600c3b8200b003d07aea2209so1896419wms.1
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 10:28:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZre19y9mqtRbVmthm+1akdsq6EMwOffWFy6wUyZzJw=;
        b=2B/IGIvBc6j1ypq6I9iLZitcpqWMelJkKbuKGW2CjBdGU32oSbIoM8QT/sy/DinsdL
         Vbmi/gWMBeiPTaANEHNQy5cVQlVHrU+cM56/cgVBHuweguMdEDcH2YNy5ZXvhFMMahw1
         t5MYS5EvpZw7uSIDsk/1pVXr+kYdigdccqVWD70lW5azx0GeUMjCp1o4sb0v3vzFu33C
         xoHtaQ4Mxj7zHyTKVIYhhTAX1Id2MX8cbOqdwOJ/AWjabDTaMA8F0B0jts/5NnperVF1
         z0sdj2mVk9pMJuV7uhXYdtskIEardeXQVrkttJBKbEwj1ausRRqKi7eqc2Fho7Xh5r+5
         t57Q==
X-Gm-Message-State: ANoB5pmKW5wmPxPpPBiPDzJQBSJ+yFVIUwbGsuO4KdUkMPZvBK5yD7D1
        z+5dQ72uR1Pkgd1EyqZR2JWo4dpuMIV1eBs77m470LPN8Ybra2lrdQgBop0bAMrR3L0Tz8uwgxT
        Ti5El8fnkgOJjPguQ
X-Received: by 2002:a5d:67d0:0:b0:241:781e:606 with SMTP id n16-20020a5d67d0000000b00241781e0606mr44737762wrw.216.1670005710015;
        Fri, 02 Dec 2022 10:28:30 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4ke/T3J+7N2wW5wzi4t1D5YvQTlYlii98nH9ShpFJumVUthsjptoFP4ClC3Br2BJsEQMK/MA==
X-Received: by 2002:a5d:67d0:0:b0:241:781e:606 with SMTP id n16-20020a5d67d0000000b00241781e0606mr44737754wrw.216.1670005709683;
        Fri, 02 Dec 2022 10:28:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h12-20020a05600c314c00b003cfa81e2eb4sm10750865wmo.38.2022.12.02.10.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 10:28:29 -0800 (PST)
Message-ID: <cf28e122-01b5-d4c0-b050-d039f0280aea@redhat.com>
Date:   Fri, 2 Dec 2022 19:28:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 5.15] KVM: x86/mmu: Fix race condition in
 direct_page_fault
Content-Language: en-US
To:     Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>,
        stable@vger.kernel.org
References: <20221202030843.1777127-1-takiguchi.kazuki171@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221202030843.1777127-1-takiguchi.kazuki171@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/2/22 04:08, Kazuki Takiguchi wrote:
> commit 47b0c2e4c220f2251fd8dcfbb44479819c715e15 upstream.
> 
> make_mmu_pages_available() must be called with mmu_lock held for write.
> However, if the TDP MMU is used, it will be called with mmu_lock held for
> read.
> This function does nothing unless shadow pages are used, so there is no
> race unless nested TDP is used.
> Since nested TDP uses shadow pages, old shadow pages may be zapped by this
> function even when the TDP MMU is enabled.
> Since shadow pages are never allocated by kvm_tdp_mmu_map(), a race
> condition can be avoided by not calling make_mmu_pages_available() if the
> TDP MMU is currently in use.
> 
> I encountered this when repeatedly starting and stopping nested VM.
> It can be artificially caused by allocating a large number of nested TDP
> SPTEs.
> 
> For example, the following BUG and general protection fault are caused in
> the host kernel.
> 
> pte_list_remove: 00000000cd54fc10 many->many
> ------------[ cut here ]------------
> kernel BUG at arch/x86/kvm/mmu/mmu.c:963!
> invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> RIP: 0010:pte_list_remove.cold+0x16/0x48 [kvm]
> Call Trace:
>   <TASK>
>   drop_spte+0xe0/0x180 [kvm]
>   mmu_page_zap_pte+0x4f/0x140 [kvm]
>   __kvm_mmu_prepare_zap_page+0x62/0x3e0 [kvm]
>   kvm_mmu_zap_oldest_mmu_pages+0x7d/0xf0 [kvm]
>   direct_page_fault+0x3cb/0x9b0 [kvm]
>   kvm_tdp_page_fault+0x2c/0xa0 [kvm]
>   kvm_mmu_page_fault+0x207/0x930 [kvm]
>   npf_interception+0x47/0xb0 [kvm_amd]
>   svm_invoke_exit_handler+0x13c/0x1a0 [kvm_amd]
>   svm_handle_exit+0xfc/0x2c0 [kvm_amd]
>   kvm_arch_vcpu_ioctl_run+0xa79/0x1780 [kvm]
>   kvm_vcpu_ioctl+0x29b/0x6f0 [kvm]
>   __x64_sys_ioctl+0x95/0xd0
>   do_syscall_64+0x5c/0x90
> 
> general protection fault, probably for non-canonical address
> 0xdead000000000122: 0000 [#1] PREEMPT SMP NOPTI
> RIP: 0010:kvm_mmu_commit_zap_page.part.0+0x4b/0xe0 [kvm]
> Call Trace:
>   <TASK>
>   kvm_mmu_zap_oldest_mmu_pages+0xae/0xf0 [kvm]
>   direct_page_fault+0x3cb/0x9b0 [kvm]
>   kvm_tdp_page_fault+0x2c/0xa0 [kvm]
>   kvm_mmu_page_fault+0x207/0x930 [kvm]
>   npf_interception+0x47/0xb0 [kvm_amd]
> 
> CVE: CVE-2022-45869
> Fixes: a2855afc7ee8 ("KVM: x86/mmu: Allow parallel page faults for the TDP MMU")
> Signed-off-by: Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ba1749a770eb..4724289c8a7f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2357,6 +2357,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>   {
>   	bool list_unstable;
>   
> +	lockdep_assert_held_write(&kvm->mmu_lock);
>   	trace_kvm_mmu_prepare_zap_page(sp);
>   	++kvm->stat.mmu_shadow_zapped;
>   	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
> @@ -4007,16 +4008,17 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>   
>   	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
>   		goto out_unlock;
> -	r = make_mmu_pages_available(vcpu);
> -	if (r)
> -		goto out_unlock;
>   
> -	if (is_tdp_mmu_fault)
> +	if (is_tdp_mmu_fault) {
>   		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
>   				    pfn, prefault);
> -	else
> +	} else {
> +		r = make_mmu_pages_available(vcpu);
> +		if (r)
> +			goto out_unlock;
>   		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
>   				 prefault, is_tdp);
> +	}
>   
>   out_unlock:
>   	if (is_tdp_mmu_fault)

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

