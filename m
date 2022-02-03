Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1834B4A8A85
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353043AbiBCRps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:45:48 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41159 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353041AbiBCRpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 12:45:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 95A295801D6;
        Thu,  3 Feb 2022 12:45:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 03 Feb 2022 12:45:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=0IX3+OWg0QG3IIRK6BvjHe3DMt2yyMSk4nYD2c
        qXzNw=; b=fKBNONDvktX8XnxuxwDJ3a+C0H5CKA+zJXMjkqVmBOjeF2PvxDIrnB
        QQ5+qLPcsdZl559dQmDmOUHyNxyQteyxzJsH+tgbaQwwB1u3bLidaucIrg8RHSqC
        hEOx/ntBnPKIBvt40yEJD4LDG3D3Nb9qZEDiH/f9LsVEYavXZoS7+Q31nVa4U3BL
        5OMZ+tuU079A5UScV3Px7fM1xf7wO7NArYuJthpjbFuJpO5J4lZMV0PbRGiKRB7R
        2PFMX1qtVKHcj57o8f9nF1HvAmMU3MZsCOsQ7b+mqgH53qnhJcMJqmHlYF1cWPJS
        tXDOrLMKd/Y4py9Bfx7Gv12LP13vQybg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0IX3+OWg0QG3IIRK6
        BvjHe3DMt2yyMSk4nYD2cqXzNw=; b=BdTegrxWbSkRfT8jzUTOniSBaSwVSGuEN
        jJrSmT1juhWqEps7Gzq2WerNdfPZLy4hcb1v53B3UuLPhPaLQ2RSRyy5YTjmZIMp
        oxwezdIK1w0WrOOY/3yaOFYA2ePoIiWHL4+szXcSs3cbN6dPpE0Y+s3U+HvOTAwV
        deuUh5ovOLFFhbMRCrY3egB0wYrmzjfN/+JFW0I5aihBLdjeAufErGn8W4KHEdps
        L0z+b02sinD0ypiRwYFnqujnRaMRhatXH2+Q6yTCptInhhjUbWjedY6kLdht3cS9
        4txkRZAK22mnPLkS9q8yvDCf2lp2Y2NxMY1Rzm9uXLTdDZyNvkQ+Q==
X-ME-Sender: <xms:vRT8Yf6TK9zC5wTUqOv_tHcQhxP-wMc8NFDF9tae3eT1JlzdHfhfnA>
    <xme:vRT8YU5Tot8qRMaixYhMIF46SzUk4lGAAKcwPEyWXFKRsrMZhSpGueLsiZeAvEReI
    Zh82bVV4vrXrg>
X-ME-Received: <xmr:vRT8YWfkPXYGUViGPBE-xjIL952TvgSxGY-3cxBQG3sHYvViH3jliG76cMrRG_ro_1ry0v_vfrR9tFHq3BD68dYQKtYq4tQJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgeejgddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeejheehte
    evieffuedthfelkeekfeelvefgudefhedtjeegjefhvdffgefgudegfeenucffohhmrghi
    nhepshihiihkrghllhgvrhdrrghpphhsphhothdrtghomhenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:vRT8YQI2Zhl744JjHD7hlxx2eViiYCqVrm21VqbhlJpZcmiGWpujrg>
    <xmx:vRT8YTKPJmdVCEzcFY3lnTtfrYivmQ_B6l-_3bNMih-bFLajvtiGSg>
    <xmx:vRT8YZyAEG81lwrSa5nlLrLEZG0PGofpIUNtNMkbZYvqJOEjwwaY9g>
    <xmx:vRT8YQBS97AHssaqoqNGKliJMLV0_GM63no5ZEjxT_WmGm7R7mnSEQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Feb 2022 12:45:32 -0500 (EST)
Date:   Thu, 3 Feb 2022 18:45:30 +0100
From:   Greg KH <greg@kroah.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 5.10] KVM: x86: Forcibly leave nested virt when SMM state
 is toggled
Message-ID: <YfwUuiOPjiQ2/EH1@kroah.com>
References: <20220201230427.2311393-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201230427.2311393-1-tadeusz.struk@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 03:04:27PM -0800, Tadeusz Struk wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Commit f7e570780efc5cec9b2ed1e0472a7da14e864fdb upstream.
> 
> Please apply it to 5.10.y. It fixes the following syzbot issue:
> Link: https://syzkaller.appspot.com/bug?id=c46ee6f22a68171154cdd9217216b2a02cf4b71c
> 
> Forcibly leave nested virtualization operation if userspace toggles SMM
> state via KVM_SET_VCPU_EVENTS or KVM_SYNC_X86_EVENTS.  If userspace
> forces the vCPU out of SMM while it's post-VMXON and then injects an SMI,
> vmx_enter_smm() will overwrite vmx->nested.smm.vmxon and end up with both
> vmxon=false and smm.vmxon=false, but all other nVMX state allocated.
> 
> Don't attempt to gracefully handle the transition as (a) most transitions
> are nonsencial, e.g. forcing SMM while L2 is running, (b) there isn't
> sufficient information to handle all transitions, e.g. SVM wants access
> to the SMRAM save state, and (c) KVM_SET_VCPU_EVENTS must precede
> KVM_SET_NESTED_STATE during state restore as the latter disallows putting
> the vCPU into L2 if SMM is active, and disallows tagging the vCPU as
> being post-VMXON in SMM if SMM is not active.
> 
> Abuse of KVM_SET_VCPU_EVENTS manifests as a WARN and memory leak in nVMX
> due to failure to free vmcs01's shadow VMCS, but the bug goes far beyond
> just a memory leak, e.g. toggling SMM on while L2 is active puts the vCPU
> in an architecturally impossible state.
> 
>   WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
>   WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
>   Modules linked in:
>   CPU: 1 PID: 3606 Comm: syz-executor725 Not tainted 5.17.0-rc1-syzkaller #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   RIP: 0010:free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
>   RIP: 0010:free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
>   Code: <0f> 0b eb b3 e8 8f 4d 9f 00 e9 f7 fe ff ff 48 89 df e8 92 4d 9f 00
>   Call Trace:
>    <TASK>
>    kvm_arch_vcpu_destroy+0x72/0x2f0 arch/x86/kvm/x86.c:11123
>    kvm_vcpu_destroy arch/x86/kvm/../../../virt/kvm/kvm_main.c:441 [inline]
>    kvm_destroy_vcpus+0x11f/0x290 arch/x86/kvm/../../../virt/kvm/kvm_main.c:460
>    kvm_free_vcpus arch/x86/kvm/x86.c:11564 [inline]
>    kvm_arch_destroy_vm+0x2e8/0x470 arch/x86/kvm/x86.c:11676
>    kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1217 [inline]
>    kvm_put_kvm+0x4fa/0xb00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1250
>    kvm_vm_release+0x3f/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1273
>    __fput+0x286/0x9f0 fs/file_table.c:311
>    task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>    exit_task_work include/linux/task_work.h:32 [inline]
>    do_exit+0xb29/0x2a30 kernel/exit.c:806
>    do_group_exit+0xd2/0x2f0 kernel/exit.c:935
>    get_signal+0x4b0/0x28c0 kernel/signal.c:2862
>    arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
>    handle_signal_work kernel/entry/common.c:148 [inline]
>    exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>    exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
>    __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>    syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>    do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>    </TASK>
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: <stable@vger.kernel.org>
> Cc: <x86@kernel.org>
> Cc: <kvm@vger.kernel.org>
> 
> Backported-by: Tadeusz Struk <tadeusz.struk@linaro.org>

Nit, this should be "signed-off-by:" no need to make up new tags like
this.

thanks,

greg k-h
