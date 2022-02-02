Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43D14A6C46
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 08:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiBBHXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 02:23:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229813AbiBBHXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 02:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643786617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lS6VclXUcneOjC3oStQbwdBD5or1Egv5MK+etEu+Ej4=;
        b=DGdXidtWUnLN2TfdsEoP08ldmfJIMqw+xl/KqtRCJPArzpGTE9kzLqLez28xqthK+lZJPu
        ST61uKLlEIatuKkkGRUKahy/S4FJaljJyb6PbcQuDOL83RDL2nh2o8Nsu3cmkGUgE21pdI
        wpAKtwq4KI6B6aor0Zr4EeyAyu34DHQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-CAm_PN-LMbOZ2zHRWqjFgw-1; Wed, 02 Feb 2022 02:23:36 -0500
X-MC-Unique: CAm_PN-LMbOZ2zHRWqjFgw-1
Received: by mail-ej1-f70.google.com with SMTP id q21-20020a17090622d500b006bb15a59a68so5763472eja.18
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 23:23:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lS6VclXUcneOjC3oStQbwdBD5or1Egv5MK+etEu+Ej4=;
        b=o81rkeZE6RI00acHP6yHjjl3q0HKhxu/HUJm0VVmIvMNpqLSB1z9ngajSICPpTADV/
         Gem412+SYpqwLOWbeZsl837A6QIDt2L7tHugx8dmS42JKNXpx8DJ46beR++jc/Qvhvyc
         bj5ZJJAzsrTrjtGrCw1DESxPfRcatKg8yFeAJalD88oLVV+wsTfz6pwfWpaT/ytMaz26
         HSMzA2Z6TuErJFRmjWqz/qIiNj/JHj4EtiG7ChLT2SnJ8hjebd7keLk7jFBErzlZbAtE
         0R9Gi4JRjU48K7c9OqLyb7rbWyseT9TRqN9iUQLY4bIJzEUdM5hAEwV+nl5TqWgKXYVu
         NQiw==
X-Gm-Message-State: AOAM5333ycYAIECRF9UtyB6TSUHJN9ynuXaex9LML7C6T12L/mMhIClh
        6Xd5m3uk9H866VlNkGe4YudXeaY3s4W5jx3PbUhKNDlJXPYqYKxPDw4thOkI+Ts3TCsx81FtQgE
        npJaSjWtghgKO0tIi
X-Received: by 2002:a17:906:6a19:: with SMTP id qw25mr24349260ejc.558.1643786614740;
        Tue, 01 Feb 2022 23:23:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzagIl3d9kQo4OnIQYwllq35vwl2W8Kb/G1VNqSRNdeleQrKWx8UmZQ09Ky+iZpOYp6/cz01Q==
X-Received: by 2002:a17:906:6a19:: with SMTP id qw25mr24349241ejc.558.1643786614459;
        Tue, 01 Feb 2022 23:23:34 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id h15sm15530665ejg.144.2022.02.01.23.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 23:23:33 -0800 (PST)
Message-ID: <817092d5-5af2-126d-7e1b-0dce2b82d7a5@redhat.com>
Date:   Wed, 2 Feb 2022 08:23:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10] KVM: x86: Forcibly leave nested virt when SMM state
 is toggled
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org
References: <20220201230427.2311393-1-tadeusz.struk@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220201230427.2311393-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/2/22 00:04, Tadeusz Struk wrote:
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
>    WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
>    WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
>    Modules linked in:
>    CPU: 1 PID: 3606 Comm: syz-executor725 Not tainted 5.17.0-rc1-syzkaller #0
>    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>    RIP: 0010:free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
>    RIP: 0010:free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
>    Code: <0f> 0b eb b3 e8 8f 4d 9f 00 e9 f7 fe ff ff 48 89 df e8 92 4d 9f 00
>    Call Trace:
>     <TASK>
>     kvm_arch_vcpu_destroy+0x72/0x2f0 arch/x86/kvm/x86.c:11123
>     kvm_vcpu_destroy arch/x86/kvm/../../../virt/kvm/kvm_main.c:441 [inline]
>     kvm_destroy_vcpus+0x11f/0x290 arch/x86/kvm/../../../virt/kvm/kvm_main.c:460
>     kvm_free_vcpus arch/x86/kvm/x86.c:11564 [inline]
>     kvm_arch_destroy_vm+0x2e8/0x470 arch/x86/kvm/x86.c:11676
>     kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1217 [inline]
>     kvm_put_kvm+0x4fa/0xb00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1250
>     kvm_vm_release+0x3f/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1273
>     __fput+0x286/0x9f0 fs/file_table.c:311
>     task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>     exit_task_work include/linux/task_work.h:32 [inline]
>     do_exit+0xb29/0x2a30 kernel/exit.c:806
>     do_group_exit+0xd2/0x2f0 kernel/exit.c:935
>     get_signal+0x4b0/0x28c0 kernel/signal.c:2862
>     arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
>     handle_signal_work kernel/entry/common.c:148 [inline]
>     exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>     exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
>     __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>     syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>     do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>     </TASK>
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: <stable@vger.kernel.org>
> Cc: <x86@kernel.org>
> Cc: <kvm@vger.kernel.org>
> 
> Backported-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm/nested.c       | 10 ++++++++--
>   arch/x86/kvm/svm/svm.c          |  2 +-
>   arch/x86/kvm/svm/svm.h          |  2 +-
>   arch/x86/kvm/vmx/nested.c       |  1 +
>   arch/x86/kvm/x86.c              |  2 ++
>   6 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b1cd8334db11..078494401046 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1285,6 +1285,7 @@ struct kvm_x86_ops {
>   };
>   
>   struct kvm_x86_nested_ops {
> +	void (*leave_nested)(struct kvm_vcpu *vcpu);
>   	int (*check_events)(struct kvm_vcpu *vcpu);
>   	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
>   	int (*get_state)(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f0946872f5e6..23910e6a3f01 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -783,8 +783,10 @@ void svm_free_nested(struct vcpu_svm *svm)
>   /*
>    * Forcibly leave nested mode in order to be able to reset the VCPU later on.
>    */
> -void svm_leave_nested(struct vcpu_svm *svm)
> +void svm_leave_nested(struct kvm_vcpu *vcpu)
>   {
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
>   	if (is_guest_mode(&svm->vcpu)) {
>   		struct vmcb *hsave = svm->nested.hsave;
>   		struct vmcb *vmcb = svm->vmcb;
> @@ -1185,7 +1187,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   		return -EINVAL;
>   
>   	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
> -		svm_leave_nested(svm);
> +		svm_leave_nested(vcpu);
>   		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
>   		return 0;
>   	}
> @@ -1238,6 +1240,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
>   	hsave->save = *save;
>   
> +	if (is_guest_mode(vcpu))
> +		svm_leave_nested(vcpu);
> +
>   	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
>   	load_nested_vmcb_control(svm, ctl);
>   	nested_prepare_vmcb_control(svm);
> @@ -1252,6 +1257,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   }
>   
>   struct kvm_x86_nested_ops svm_nested_ops = {
> +	.leave_nested = svm_leave_nested,
>   	.check_events = svm_check_nested_events,
>   	.get_nested_state_pages = svm_get_nested_state_pages,
>   	.get_state = svm_get_nested_state,
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5e1d7396a6b8..b4f4ce5ace6b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -279,7 +279,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>   
>   	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
>   		if (!(efer & EFER_SVME)) {
> -			svm_leave_nested(svm);
> +			svm_leave_nested(vcpu);
>   			svm_set_gif(svm, true);
>   
>   			/*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index be74e22b82ea..2c007241fbf5 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -393,7 +393,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
>   
>   int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   			 struct vmcb *nested_vmcb);
> -void svm_leave_nested(struct vcpu_svm *svm);
> +void svm_leave_nested(struct kvm_vcpu *vcpu);
>   void svm_free_nested(struct vcpu_svm *svm);
>   int svm_allocate_nested(struct vcpu_svm *svm);
>   int nested_svm_vmrun(struct vcpu_svm *svm);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d5f24a2f3e91..6a4b91b77cde 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6614,6 +6614,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
>   }
>   
>   struct kvm_x86_nested_ops vmx_nested_ops = {
> +	.leave_nested = vmx_leave_nested,
>   	.check_events = vmx_check_nested_events,
>   	.hv_timer_pending = nested_vmx_preemption_timer_pending,
>   	.get_state = vmx_get_nested_state,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b885063dc393..ab31745c04d0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4390,6 +4390,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>   				vcpu->arch.hflags |= HF_SMM_MASK;
>   			else
>   				vcpu->arch.hflags &= ~HF_SMM_MASK;
> +
> +			kvm_x86_ops.nested_ops->leave_nested(vcpu);
>   			kvm_smm_changed(vcpu);
>   		}
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

