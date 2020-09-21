Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BAF272464
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgIUMzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgIUMy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:58 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1233218AC;
        Mon, 21 Sep 2020 12:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692898;
        bh=k+nkHRfiy3QoeQ8hlTf38c0QtOJyAtTVdYYgNAT9Dqc=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Xj6PCgVGcvpPpi0zYJsodJ+mb4FV34kZk2pAXGc7hAJgHUggmLnEqTgnLfeEvpLyb
         eXBzDs/p/8o8kZteu3+Zn4O5kqU6cOwYUEHC4rU6gkHcRO9wqgvYmcqj06HiShGiHV
         YVrzdkZrSIcsFxtZ4+hzg2ZZS6bOmID2s1RgDQ7E=
Date:   Mon, 21 Sep 2020 12:54:57 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Rustam Kovhaev <rkovhaev@gmail.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, gustavoars@kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] KVM: use struct_size() and flex_array_size() helpers in kvm_io_bus_unregister_dev()
In-Reply-To: <20200918120500.954436-1-rkovhaev@gmail.com>
References: <20200918120500.954436-1-rkovhaev@gmail.com>
Message-Id: <20200921125457.E1233218AC@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Build OK!
v5.4.66: Build failed! Errors:
    virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function ‘flex_array_size’; did you mean ‘array_size’? [-Werror=implicit-function-declaration]
    virt/kvm/kvm_main.c:4034:30: error: ‘range’ undeclared (first use in this function)
    virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function ‘flex_array_size’; did you mean ‘array_size’? [-Werror=implicit-function-declaration]
    virt/kvm/kvm_main.c:4034:30: error: ‘range’ undeclared (first use in this function)
    arch/s390/kvm/../../../virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function 'flex_array_size'; did you mean 'array_size'? [-Werror=implicit-function-declaration]
    arch/s390/kvm/../../../virt/kvm/kvm_main.c:4034:30: error: 'range' undeclared (first use in this function)
    virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function ‘flex_array_size’; did you mean ‘array_size’? [-Werror=implicit-function-declaration]
    virt/kvm/kvm_main.c:4034:30: error: ‘range’ undeclared (first use in this function)
    virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function ‘flex_array_size’; did you mean ‘array_size’? [-Werror=implicit-function-declaration]
    virt/kvm/kvm_main.c:4034:30: error: ‘range’ undeclared (first use in this function)
    arch/s390/kvm/../../../virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function 'flex_array_size'; did you mean 'array_size'? [-Werror=implicit-function-declaration]
    arch/s390/kvm/../../../virt/kvm/kvm_main.c:4034:30: error: 'range' undeclared (first use in this function)
    virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function ‘flex_array_size’; did you mean ‘array_size’? [-Werror=implicit-function-declaration]
    virt/kvm/kvm_main.c:4034:30: error: ‘range’ undeclared (first use in this function)
    virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function ‘flex_array_size’; did you mean ‘array_size’? [-Werror=implicit-function-declaration]
    virt/kvm/kvm_main.c:4034:30: error: ‘range’ undeclared (first use in this function)
    arch/s390/kvm/../../../virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function 'flex_array_size'; did you mean 'array_size'? [-Werror=implicit-function-declaration]
    arch/s390/kvm/../../../virt/kvm/kvm_main.c:4034:30: error: 'range' undeclared (first use in this function)
    virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function ‘flex_array_size’; did you mean ‘array_size’? [-Werror=implicit-function-declaration]
    virt/kvm/kvm_main.c:4034:30: error: ‘range’ undeclared (first use in this function)
    virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function ‘flex_array_size’; did you mean ‘array_size’? [-Werror=implicit-function-declaration]
    virt/kvm/kvm_main.c:4034:30: error: ‘range’ undeclared (first use in this function)
    arch/s390/kvm/../../../virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function 'flex_array_size'; did you mean 'array_size'? [-Werror=implicit-function-declaration]
    arch/s390/kvm/../../../virt/kvm/kvm_main.c:4034:30: error: 'range' undeclared (first use in this function)
    arch/arm64/kvm/../../../virt/kvm/kvm_main.c:4034:5: error: implicit declaration of function 'flex_array_size'; did you mean 'array_size'? [-Werror=implicit-function-declaration]
    arch/arm64/kvm/../../../virt/kvm/kvm_main.c:4034:30: error: 'range' undeclared (first use in this function)

v4.19.146: Failed to apply! Possible dependencies:
    0804c849f1df ("kvm/x86 : add coalesced pio support")
    360cae313702 ("KVM: PPC: Book3S HV: Nested guest entry via hypercall")
    41f4e631daf8 ("KVM: PPC: Book3S HV: Extract PMU save/restore operations as C-callable functions")
    89329c0be8bd ("KVM: PPC: Book3S HV: Clear partition table entry on vm teardown")
    8e3f5fc1045d ("KVM: PPC: Book3S HV: Framework and hcall stubs for nested virtualization")
    90952cd38859 ("kvm: Use struct_size() in kmalloc()")
    95a6432ce903 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
    9943450b7b88 ("kvm/x86 : add document for coalesced mmio")
    aa069a996951 ("KVM: PPC: Book3S HV: Add a VM capability to enable nested virtualization")
    b12ce36a43f2 ("kvm: Add memcg accounting to KVM allocations")
    df709a296ef7 ("KVM: PPC: Book3S HV: Simplify real-mode interrupt handling")
    f7035ce9f1df ("KVM: PPC: Book3S HV: Move interrupt delivery on guest entry to C code")

v4.14.198: Failed to apply! Possible dependencies:
    0804c849f1df ("kvm/x86 : add coalesced pio support")
    7bf14c28ee77 ("Merge branch 'x86/hyperv' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")
    90952cd38859 ("kvm: Use struct_size() in kmalloc()")
    b12ce36a43f2 ("kvm: Add memcg accounting to KVM allocations")
    d4c67a7a54f1 ("kvm: use insert sort in kvm_io_bus_register_dev function")

v4.9.236: Failed to apply! Possible dependencies:
    0804c849f1df ("kvm/x86 : add coalesced pio support")
    4a12f9517728 ("KVM: mark kvm->busses as rcu protected")
    7bf14c28ee77 ("Merge branch 'x86/hyperv' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")
    90952cd38859 ("kvm: Use struct_size() in kmalloc()")
    b12ce36a43f2 ("kvm: Add memcg accounting to KVM allocations")
    d4c67a7a54f1 ("kvm: use insert sort in kvm_io_bus_register_dev function")

v4.4.236: Failed to apply! Possible dependencies:
    4a12f9517728 ("KVM: mark kvm->busses as rcu protected")
    5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")
    6308630bd3db ("kvm/x86: split ioapic-handled and EOI exit bitmaps")
    765eaa0f70ea ("kvm/x86: Hyper-V SynIC message slot pending clearing at SINT ack")
    90952cd38859 ("kvm: Use struct_size() in kmalloc()")
    d4c67a7a54f1 ("kvm: use insert sort in kvm_io_bus_register_dev function")
    d62caabb41f3 ("kvm/x86: per-vcpu apicv deactivation support")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
