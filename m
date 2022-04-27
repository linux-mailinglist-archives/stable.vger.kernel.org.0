Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447E8511E02
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242592AbiD0QU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 12:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243866AbiD0QT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 12:19:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90F96522F8
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XwzMaPClFelWBj+M1/FlaJtyKAavIIdtNAVgltrSGwE=;
        b=Nbdto1VOuywR+U1zX4cc9wfnQuYiZkZQxgUr53SlVKESdbq2rx73FO4Ccrt6XrzSIGTwfB
        0tk0r933fkkJBWE2qTRvnIPdcbzXDyABxGig4c/fr6O7SD0G4OaLHRtlSL9mW2XPGPqgn0
        e87219TQj43RrSpCC0XfNUUj7PFJdiM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-ZQfQns6XO7-uSFpLBkA03A-1; Wed, 27 Apr 2022 12:16:07 -0400
X-MC-Unique: ZQfQns6XO7-uSFpLBkA03A-1
Received: by mail-ej1-f70.google.com with SMTP id i14-20020a17090639ce00b006dabe6a112fso1422171eje.13
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:16:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XwzMaPClFelWBj+M1/FlaJtyKAavIIdtNAVgltrSGwE=;
        b=qhvldHMnIZfHRfOf5HAE2DAAj2uiEgsi1zqXlsIghNABgdoS7HrOza8n6PWrW9rtAo
         BaeAxsDbCavc1b4k+c1WrtZOMBipa87Vcl7IDWTSgDVDC9sN3DzZA8Z6xyLKHomJt5MY
         ca5DUp1qoOu/d1cA7HxV8XBr2FqAxo7/Ip+DE7igMnSKenZVAGWS1SkRULgx0GXJ5xE5
         YFTKTX0wnNdwmyQ/Gnbcub/m5JbJ0Iag7LWMNvzwgPmsDO8S+tnDKJTueQsRy29cUUZD
         TBwB+kLkmSsziqNYCa6cl+Qy0F4wtrpXjRMDq0ivvl95vFvnEhCMjo0S1KHyKQ9EYU0L
         QtOw==
X-Gm-Message-State: AOAM531sf/o2iON4PgoH6s/7axVNI0/QckZ1rKkTfSlCYXorDirFpRk9
        rbhdjPDPsWyJJ3ZH+Edq4mVTTqAQpcs1FjFEes3TL2326KFgVrRDMW6htq4mTiSLhSQzuL9dEMV
        ywFyqBx1gIxCR/lR3
X-Received: by 2002:a50:ba8a:0:b0:423:bdf5:41d6 with SMTP id x10-20020a50ba8a000000b00423bdf541d6mr31204240ede.204.1651076166096;
        Wed, 27 Apr 2022 09:16:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwulvD8m9SPOwH8M5hEDhBATWqPusNqnumcNmDWp0DqCiaZlLyHFZbEtVTqmkld18Ve3VjXfg==
X-Received: by 2002:a50:ba8a:0:b0:423:bdf5:41d6 with SMTP id x10-20020a50ba8a000000b00423bdf541d6mr31204191ede.204.1651076165723;
        Wed, 27 Apr 2022 09:16:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id su22-20020a17090703d600b006f3a97cda9esm3257789ejb.18.2022.04.27.09.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:16:04 -0700 (PDT)
Message-ID: <26ed111b-aab4-a596-dbfb-d561d1e13eb7@redhat.com>
Date:   Wed, 27 Apr 2022 18:16:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.17 1/7] kvm: selftests: do not use bitfields
 larger than 32-bits for PTEs
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Nana Liu <nanliu@redhat.com>, Peter Xu <peterx@redhat.com>,
        shuah@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        jmattson@google.com, oupton@google.com, seanjc@google.com,
        ricarkol@google.com, yang.zhong@intel.com, aaronlewis@google.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, llvm@lists.linux.dev
References: <20220427155408.19352-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155408.19352-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/22 17:53, Sasha Levin wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit f18b4aebe107d092e384b1ae680b1e1de7a0196d ]
> 
> Red Hat's QE team reported test failure on access_tracking_perf_test:
> 
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0x3fffbffff000
> 
> Populating memory             : 0.684014577s
> Writing to populated memory   : 0.006230175s
> Reading from populated memory : 0.004557805s
> ==== Test Assertion Failure ====
>    lib/kvm_util.c:1411: false
>    pid=125806 tid=125809 errno=4 - Interrupted system call
>       1  0x0000000000402f7c: addr_gpa2hva at kvm_util.c:1411
>       2   (inlined by) addr_gpa2hva at kvm_util.c:1405
>       3  0x0000000000401f52: lookup_pfn at access_tracking_perf_test.c:98
>       4   (inlined by) mark_vcpu_memory_idle at access_tracking_perf_test.c:152
>       5   (inlined by) vcpu_thread_main at access_tracking_perf_test.c:232
>       6  0x00007fefe9ff81ce: ?? ??:0
>       7  0x00007fefe9c64d82: ?? ??:0
>    No vm physical memory at 0xffbffff000
> 
> I can easily reproduce it with a Intel(R) Xeon(R) CPU E5-2630 with 46 bits
> PA.
> 
> It turns out that the address translation for clearing idle page tracking
> returned a wrong result; addr_gva2gpa()'s last step, which is based on
> "pte[index[0]].pfn", did the calculation with 40 bits length and the
> high 12 bits got truncated.  In above case the GPA address to be returned
> should be 0x3fffbffff000 for GVA 0xc0000000, but it got truncated into
> 0xffbffff000 and the subsequent gpa2hva lookup failed.
> 
> The width of operations on bit fields greater than 32-bit is
> implementation defined, and differs between GCC (which uses the bitfield
> precision) and clang (which uses 64-bit arithmetic), so this is a
> potential minefield.  Remove the bit fields and using manual masking
> instead.
> 
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2075036
> Reported-by: Nana Liu <nanliu@redhat.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Tested-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   .../selftests/kvm/include/x86_64/processor.h  |  15 ++
>   .../selftests/kvm/lib/x86_64/processor.c      | 192 +++++++-----------
>   2 files changed, 92 insertions(+), 115 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 8a470da7b71a..15a2875698b5 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -60,6 +60,21 @@
>   /* CPUID.0x8000_0001.EDX */
>   #define CPUID_GBPAGES		(1ul << 26)
>   
> +/* Page table bitfield declarations */
> +#define PTE_PRESENT_MASK        BIT_ULL(0)
> +#define PTE_WRITABLE_MASK       BIT_ULL(1)
> +#define PTE_USER_MASK           BIT_ULL(2)
> +#define PTE_ACCESSED_MASK       BIT_ULL(5)
> +#define PTE_DIRTY_MASK          BIT_ULL(6)
> +#define PTE_LARGE_MASK          BIT_ULL(7)
> +#define PTE_GLOBAL_MASK         BIT_ULL(8)
> +#define PTE_NX_MASK             BIT_ULL(63)
> +
> +#define PAGE_SHIFT		12
> +
> +#define PHYSICAL_PAGE_MASK      GENMASK_ULL(51, 12)
> +#define PTE_GET_PFN(pte)        (((pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
> +
>   /* General Registers in 64-Bit Mode */
>   struct gpr64_regs {
>   	u64 rax;
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 9f000dfb5594..0dd442c26015 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -19,38 +19,6 @@
>   
>   vm_vaddr_t exception_handlers;
>   
> -/* Virtual translation table structure declarations */
> -struct pageUpperEntry {
> -	uint64_t present:1;
> -	uint64_t writable:1;
> -	uint64_t user:1;
> -	uint64_t write_through:1;
> -	uint64_t cache_disable:1;
> -	uint64_t accessed:1;
> -	uint64_t ignored_06:1;
> -	uint64_t page_size:1;
> -	uint64_t ignored_11_08:4;
> -	uint64_t pfn:40;
> -	uint64_t ignored_62_52:11;
> -	uint64_t execute_disable:1;
> -};
> -
> -struct pageTableEntry {
> -	uint64_t present:1;
> -	uint64_t writable:1;
> -	uint64_t user:1;
> -	uint64_t write_through:1;
> -	uint64_t cache_disable:1;
> -	uint64_t accessed:1;
> -	uint64_t dirty:1;
> -	uint64_t reserved_07:1;
> -	uint64_t global:1;
> -	uint64_t ignored_11_09:3;
> -	uint64_t pfn:40;
> -	uint64_t ignored_62_52:11;
> -	uint64_t execute_disable:1;
> -};
> -
>   void regs_dump(FILE *stream, struct kvm_regs *regs,
>   	       uint8_t indent)
>   {
> @@ -195,23 +163,21 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t pt_pfn, uint64_t vaddr,
>   	return &page_table[index];
>   }
>   
> -static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
> -						    uint64_t pt_pfn,
> -						    uint64_t vaddr,
> -						    uint64_t paddr,
> -						    int level,
> -						    enum x86_page_size page_size)
> +static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
> +				       uint64_t pt_pfn,
> +				       uint64_t vaddr,
> +				       uint64_t paddr,
> +				       int level,
> +				       enum x86_page_size page_size)
>   {
> -	struct pageUpperEntry *pte = virt_get_pte(vm, pt_pfn, vaddr, level);
> -
> -	if (!pte->present) {
> -		pte->writable = true;
> -		pte->present = true;
> -		pte->page_size = (level == page_size);
> -		if (pte->page_size)
> -			pte->pfn = paddr >> vm->page_shift;
> +	uint64_t *pte = virt_get_pte(vm, pt_pfn, vaddr, level);
> +
> +	if (!(*pte & PTE_PRESENT_MASK)) {
> +		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
> +		if (level == page_size)
> +			*pte |= PTE_LARGE_MASK | (paddr & PHYSICAL_PAGE_MASK);
>   		else
> -			pte->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
> +			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
>   	} else {
>   		/*
>   		 * Entry already present.  Assert that the caller doesn't want
> @@ -221,7 +187,7 @@ static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
>   		TEST_ASSERT(level != page_size,
>   			    "Cannot create hugepage at level: %u, vaddr: 0x%lx\n",
>   			    page_size, vaddr);
> -		TEST_ASSERT(!pte->page_size,
> +		TEST_ASSERT(!(*pte & PTE_LARGE_MASK),
>   			    "Cannot create page table at level: %u, vaddr: 0x%lx\n",
>   			    level, vaddr);
>   	}
> @@ -232,8 +198,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>   		   enum x86_page_size page_size)
>   {
>   	const uint64_t pg_size = 1ull << ((page_size * 9) + 12);
> -	struct pageUpperEntry *pml4e, *pdpe, *pde;
> -	struct pageTableEntry *pte;
> +	uint64_t *pml4e, *pdpe, *pde;
> +	uint64_t *pte;
>   
>   	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K,
>   		    "Unknown or unsupported guest mode, mode: 0x%x", vm->mode);
> @@ -257,24 +223,22 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>   	 */
>   	pml4e = virt_create_upper_pte(vm, vm->pgd >> vm->page_shift,
>   				      vaddr, paddr, 3, page_size);
> -	if (pml4e->page_size)
> +	if (*pml4e & PTE_LARGE_MASK)
>   		return;
>   
> -	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, 2, page_size);
> -	if (pdpe->page_size)
> +	pdpe = virt_create_upper_pte(vm, PTE_GET_PFN(*pml4e), vaddr, paddr, 2, page_size);
> +	if (*pdpe & PTE_LARGE_MASK)
>   		return;
>   
> -	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, 1, page_size);
> -	if (pde->page_size)
> +	pde = virt_create_upper_pte(vm, PTE_GET_PFN(*pdpe), vaddr, paddr, 1, page_size);
> +	if (*pde & PTE_LARGE_MASK)
>   		return;
>   
>   	/* Fill in page table entry. */
> -	pte = virt_get_pte(vm, pde->pfn, vaddr, 0);
> -	TEST_ASSERT(!pte->present,
> +	pte = virt_get_pte(vm, PTE_GET_PFN(*pde), vaddr, 0);
> +	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
>   		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
> -	pte->pfn = paddr >> vm->page_shift;
> -	pte->writable = true;
> -	pte->present = 1;
> +	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
>   }
>   
>   void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
> @@ -282,12 +246,12 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
>   	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K);
>   }
>   
> -static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
> +static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
>   						       uint64_t vaddr)
>   {
>   	uint16_t index[4];
> -	struct pageUpperEntry *pml4e, *pdpe, *pde;
> -	struct pageTableEntry *pte;
> +	uint64_t *pml4e, *pdpe, *pde;
> +	uint64_t *pte;
>   	struct kvm_cpuid_entry2 *entry;
>   	struct kvm_sregs sregs;
>   	int max_phy_addr;
> @@ -329,30 +293,29 @@ static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vc
>   	index[3] = (vaddr >> 39) & 0x1ffu;
>   
>   	pml4e = addr_gpa2hva(vm, vm->pgd);
> -	TEST_ASSERT(pml4e[index[3]].present,
> +	TEST_ASSERT(pml4e[index[3]] & PTE_PRESENT_MASK,
>   		"Expected pml4e to be present for gva: 0x%08lx", vaddr);
> -	TEST_ASSERT((*(uint64_t*)(&pml4e[index[3]]) &
> -		(rsvd_mask | (1ull << 7))) == 0,
> +	TEST_ASSERT((pml4e[index[3]] & (rsvd_mask | PTE_LARGE_MASK)) == 0,
>   		"Unexpected reserved bits set.");
>   
> -	pdpe = addr_gpa2hva(vm, pml4e[index[3]].pfn * vm->page_size);
> -	TEST_ASSERT(pdpe[index[2]].present,
> +	pdpe = addr_gpa2hva(vm, PTE_GET_PFN(pml4e[index[3]]) * vm->page_size);
> +	TEST_ASSERT(pdpe[index[2]] & PTE_PRESENT_MASK,
>   		"Expected pdpe to be present for gva: 0x%08lx", vaddr);
> -	TEST_ASSERT(pdpe[index[2]].page_size == 0,
> +	TEST_ASSERT(!(pdpe[index[2]] & PTE_LARGE_MASK),
>   		"Expected pdpe to map a pde not a 1-GByte page.");
> -	TEST_ASSERT((*(uint64_t*)(&pdpe[index[2]]) & rsvd_mask) == 0,
> +	TEST_ASSERT((pdpe[index[2]] & rsvd_mask) == 0,
>   		"Unexpected reserved bits set.");
>   
> -	pde = addr_gpa2hva(vm, pdpe[index[2]].pfn * vm->page_size);
> -	TEST_ASSERT(pde[index[1]].present,
> +	pde = addr_gpa2hva(vm, PTE_GET_PFN(pdpe[index[2]]) * vm->page_size);
> +	TEST_ASSERT(pde[index[1]] & PTE_PRESENT_MASK,
>   		"Expected pde to be present for gva: 0x%08lx", vaddr);
> -	TEST_ASSERT(pde[index[1]].page_size == 0,
> +	TEST_ASSERT(!(pde[index[1]] & PTE_LARGE_MASK),
>   		"Expected pde to map a pte not a 2-MByte page.");
> -	TEST_ASSERT((*(uint64_t*)(&pde[index[1]]) & rsvd_mask) == 0,
> +	TEST_ASSERT((pde[index[1]] & rsvd_mask) == 0,
>   		"Unexpected reserved bits set.");
>   
> -	pte = addr_gpa2hva(vm, pde[index[1]].pfn * vm->page_size);
> -	TEST_ASSERT(pte[index[0]].present,
> +	pte = addr_gpa2hva(vm, PTE_GET_PFN(pde[index[1]]) * vm->page_size);
> +	TEST_ASSERT(pte[index[0]] & PTE_PRESENT_MASK,
>   		"Expected pte to be present for gva: 0x%08lx", vaddr);
>   
>   	return &pte[index[0]];
> @@ -360,7 +323,7 @@ static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vc
>   
>   uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr)
>   {
> -	struct pageTableEntry *pte = _vm_get_page_table_entry(vm, vcpuid, vaddr);
> +	uint64_t *pte = _vm_get_page_table_entry(vm, vcpuid, vaddr);
>   
>   	return *(uint64_t *)pte;
>   }
> @@ -368,18 +331,17 @@ uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr)
>   void vm_set_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr,
>   			     uint64_t pte)
>   {
> -	struct pageTableEntry *new_pte = _vm_get_page_table_entry(vm, vcpuid,
> -								  vaddr);
> +	uint64_t *new_pte = _vm_get_page_table_entry(vm, vcpuid, vaddr);
>   
>   	*(uint64_t *)new_pte = pte;
>   }
>   
>   void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>   {
> -	struct pageUpperEntry *pml4e, *pml4e_start;
> -	struct pageUpperEntry *pdpe, *pdpe_start;
> -	struct pageUpperEntry *pde, *pde_start;
> -	struct pageTableEntry *pte, *pte_start;
> +	uint64_t *pml4e, *pml4e_start;
> +	uint64_t *pdpe, *pdpe_start;
> +	uint64_t *pde, *pde_start;
> +	uint64_t *pte, *pte_start;
>   
>   	if (!vm->pgd_created)
>   		return;
> @@ -389,58 +351,58 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>   	fprintf(stream, "%*s      index hvaddr         gpaddr         "
>   		"addr         w exec dirty\n",
>   		indent, "");
> -	pml4e_start = (struct pageUpperEntry *) addr_gpa2hva(vm, vm->pgd);
> +	pml4e_start = (uint64_t *) addr_gpa2hva(vm, vm->pgd);
>   	for (uint16_t n1 = 0; n1 <= 0x1ffu; n1++) {
>   		pml4e = &pml4e_start[n1];
> -		if (!pml4e->present)
> +		if (!(*pml4e & PTE_PRESENT_MASK))
>   			continue;
> -		fprintf(stream, "%*spml4e 0x%-3zx %p 0x%-12lx 0x%-10lx %u "
> +		fprintf(stream, "%*spml4e 0x%-3zx %p 0x%-12lx 0x%-10llx %u "
>   			" %u\n",
>   			indent, "",
>   			pml4e - pml4e_start, pml4e,
> -			addr_hva2gpa(vm, pml4e), (uint64_t) pml4e->pfn,
> -			pml4e->writable, pml4e->execute_disable);
> +			addr_hva2gpa(vm, pml4e), PTE_GET_PFN(*pml4e),
> +			!!(*pml4e & PTE_WRITABLE_MASK), !!(*pml4e & PTE_NX_MASK));
>   
> -		pdpe_start = addr_gpa2hva(vm, pml4e->pfn * vm->page_size);
> +		pdpe_start = addr_gpa2hva(vm, *pml4e & PHYSICAL_PAGE_MASK);
>   		for (uint16_t n2 = 0; n2 <= 0x1ffu; n2++) {
>   			pdpe = &pdpe_start[n2];
> -			if (!pdpe->present)
> +			if (!(*pdpe & PTE_PRESENT_MASK))
>   				continue;
> -			fprintf(stream, "%*spdpe  0x%-3zx %p 0x%-12lx 0x%-10lx "
> +			fprintf(stream, "%*spdpe  0x%-3zx %p 0x%-12lx 0x%-10llx "
>   				"%u  %u\n",
>   				indent, "",
>   				pdpe - pdpe_start, pdpe,
>   				addr_hva2gpa(vm, pdpe),
> -				(uint64_t) pdpe->pfn, pdpe->writable,
> -				pdpe->execute_disable);
> +				PTE_GET_PFN(*pdpe), !!(*pdpe & PTE_WRITABLE_MASK),
> +				!!(*pdpe & PTE_NX_MASK));
>   
> -			pde_start = addr_gpa2hva(vm, pdpe->pfn * vm->page_size);
> +			pde_start = addr_gpa2hva(vm, *pdpe & PHYSICAL_PAGE_MASK);
>   			for (uint16_t n3 = 0; n3 <= 0x1ffu; n3++) {
>   				pde = &pde_start[n3];
> -				if (!pde->present)
> +				if (!(*pde & PTE_PRESENT_MASK))
>   					continue;
>   				fprintf(stream, "%*spde   0x%-3zx %p "
> -					"0x%-12lx 0x%-10lx %u  %u\n",
> +					"0x%-12lx 0x%-10llx %u  %u\n",
>   					indent, "", pde - pde_start, pde,
>   					addr_hva2gpa(vm, pde),
> -					(uint64_t) pde->pfn, pde->writable,
> -					pde->execute_disable);
> +					PTE_GET_PFN(*pde), !!(*pde & PTE_WRITABLE_MASK),
> +					!!(*pde & PTE_NX_MASK));
>   
> -				pte_start = addr_gpa2hva(vm, pde->pfn * vm->page_size);
> +				pte_start = addr_gpa2hva(vm, *pde & PHYSICAL_PAGE_MASK);
>   				for (uint16_t n4 = 0; n4 <= 0x1ffu; n4++) {
>   					pte = &pte_start[n4];
> -					if (!pte->present)
> +					if (!(*pte & PTE_PRESENT_MASK))
>   						continue;
>   					fprintf(stream, "%*spte   0x%-3zx %p "
> -						"0x%-12lx 0x%-10lx %u  %u "
> +						"0x%-12lx 0x%-10llx %u  %u "
>   						"    %u    0x%-10lx\n",
>   						indent, "",
>   						pte - pte_start, pte,
>   						addr_hva2gpa(vm, pte),
> -						(uint64_t) pte->pfn,
> -						pte->writable,
> -						pte->execute_disable,
> -						pte->dirty,
> +						PTE_GET_PFN(*pte),
> +						!!(*pte & PTE_WRITABLE_MASK),
> +						!!(*pte & PTE_NX_MASK),
> +						!!(*pte & PTE_DIRTY_MASK),
>   						((uint64_t) n1 << 27)
>   							| ((uint64_t) n2 << 18)
>   							| ((uint64_t) n3 << 9)
> @@ -558,8 +520,8 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
>   vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>   {
>   	uint16_t index[4];
> -	struct pageUpperEntry *pml4e, *pdpe, *pde;
> -	struct pageTableEntry *pte;
> +	uint64_t *pml4e, *pdpe, *pde;
> +	uint64_t *pte;
>   
>   	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
>   		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
> @@ -572,22 +534,22 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>   	if (!vm->pgd_created)
>   		goto unmapped_gva;
>   	pml4e = addr_gpa2hva(vm, vm->pgd);
> -	if (!pml4e[index[3]].present)
> +	if (!(pml4e[index[3]] & PTE_PRESENT_MASK))
>   		goto unmapped_gva;
>   
> -	pdpe = addr_gpa2hva(vm, pml4e[index[3]].pfn * vm->page_size);
> -	if (!pdpe[index[2]].present)
> +	pdpe = addr_gpa2hva(vm, PTE_GET_PFN(pml4e[index[3]]) * vm->page_size);
> +	if (!(pdpe[index[2]] & PTE_PRESENT_MASK))
>   		goto unmapped_gva;
>   
> -	pde = addr_gpa2hva(vm, pdpe[index[2]].pfn * vm->page_size);
> -	if (!pde[index[1]].present)
> +	pde = addr_gpa2hva(vm, PTE_GET_PFN(pdpe[index[2]]) * vm->page_size);
> +	if (!(pde[index[1]] & PTE_PRESENT_MASK))
>   		goto unmapped_gva;
>   
> -	pte = addr_gpa2hva(vm, pde[index[1]].pfn * vm->page_size);
> -	if (!pte[index[0]].present)
> +	pte = addr_gpa2hva(vm, PTE_GET_PFN(pde[index[1]]) * vm->page_size);
> +	if (!(pte[index[0]] & PTE_PRESENT_MASK))
>   		goto unmapped_gva;
>   
> -	return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
> +	return (PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & 0xfffu);
>   
>   unmapped_gva:
>   	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

