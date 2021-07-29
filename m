Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1073D9FB0
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 10:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhG2Ih6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 04:37:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235035AbhG2Ih6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 04:37:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627547875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJOvk30RdqDoxmiolIJ/7DEJM5IEQIj3jm3w86VUdMg=;
        b=fpsd2C9jfE8G92qixd4/Rwp5mOpz/em03h9251dtbP73wP9ziRKAyxXa4ja45n1Jd3guCm
        HCWNhRNET2QpP+0uWk9bvdWEnYRp9XrZDxa6v5uPg25IIHr97LhZ0uiEW1rrOTu1nSTJa3
        LjFL44qXcY6Ofm5DAhQlwLVcBiPEcUg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-MUUPY6pEOy2iXmhAQK9YAw-1; Thu, 29 Jul 2021 04:37:53 -0400
X-MC-Unique: MUUPY6pEOy2iXmhAQK9YAw-1
Received: by mail-ej1-f71.google.com with SMTP id e8-20020a1709060808b02904f7606bd58fso1730618ejd.11
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 01:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BJOvk30RdqDoxmiolIJ/7DEJM5IEQIj3jm3w86VUdMg=;
        b=QN06gVSn1ilnXl65Bx+PO7qdtJ18ZKWuYOwn9jEZ6TGCi9sRZtXhbWobww0R8PGIAX
         bnJXwtjLSwNxg54pY3XDuvWCvFBzfbC1GZdVEe1Ekm1P8IUjh6g2asa8OhpmBkTPy3Bg
         5QK0mC1g5AoLL3T2naKgW+6yU5Z/3M8jH7GRWKCh+TyHz6AsdSJ1jP7ZqO7vhtRuO/TO
         av8hYadzb1yq3hqv/8duBgdoP5udrdgzX217LWo13A9dhCL57CFGICxrohRP7QYSZ2wV
         cWLOPY4GaUmKfzL4+ly4suqmQVTqeWy/W05ojfyj8SolboFeSpIQlHufhEsLlbTntnus
         OAjg==
X-Gm-Message-State: AOAM5302fFyTyMXeAymT04rvTA4NWmxdbKs+GOnT82GziDEIix84CclC
        dVWJBu72QbZDjvPjnxa3U7g8Y8EgDLILHpz5YRYUNx0SW3i3DVjTQSPwQtWW8baDZXgyf7MtHGC
        CGZUqZkYNMcO1t/VS
X-Received: by 2002:a50:8713:: with SMTP id i19mr4771038edb.310.1627547872287;
        Thu, 29 Jul 2021 01:37:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNA0ND1CYTtKRsnyCRRMiKxU0cqIKrPeN7442F3LzUdf3dP+pbe2o6IbbLjvr6TUFyvbm4jQ==
X-Received: by 2002:a50:8713:: with SMTP id i19mr4771021edb.310.1627547872129;
        Thu, 29 Jul 2021 01:37:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id kk18sm713390ejc.114.2021.07.29.01.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 01:37:51 -0700 (PDT)
Subject: Re: [linux-4.19.y] KVM: x86: determine if an exception has an error
 code only when injecting it.
To:     Zubin Mithra <zsm@chromium.org>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        mlevitsk@redhat.com
References: <20210728230824.1762363-1-zsm@chromium.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6bd11006-0c48-05b8-852e-3e0a60b4d29a@redhat.com>
Date:   Thu, 29 Jul 2021 10:37:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728230824.1762363-1-zsm@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/07/21 01:08, Zubin Mithra wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> commit b97f074583736c42fb36f2da1164e28c73758912 upstream.
> 
> A page fault can be queued while vCPU is in real paged mode on AMD, and
> AMD manual asks the user to always intercept it
> (otherwise result is undefined).
> The resulting VM exit, does have an error code.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20210225154135.405125-2-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Zubin Mithra <zsm@chromium.org>
> ---
> Backport Note:
> * Syzkaller triggered a WARNING with the following stacktrace:
>   WARNING: CPU: 3 PID: 3489 at arch/x86/kvm/x86.c:8097 kvm_arch_vcpu_ioctl_run+0x42b/0x33d7
>   Kernel panic - not syncing: panic_on_warn set ...
> 
>   CPU: 3 PID: 3489 Comm: poc Not tainted 4.19.199-00120-ga89b48fe9308 #5
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>   Call Trace:
>    dump_stack+0x11b/0x19a
>    panic+0x188/0x2f1
>    ? __warn_printk+0xee/0xee
>    ? __probe_kernel_read+0xad/0xc8
>    ? kvm_arch_vcpu_ioctl_run+0x42b/0x33d7
>    ? kvm_arch_vcpu_ioctl_run+0x42b/0x33d7
>    __warn+0xe9/0x12a
>    ? kvm_arch_vcpu_ioctl_run+0x42b/0x33d7
>    report_bug+0x93/0xdd
>    fixup_bug+0x28/0x4b
>    do_error_trap+0xd1/0x1f5
>    ? fixup_bug+0x4b/0x4b
>    ? tick_nohz_tick_stopped+0x2e/0x39
>    ? __irq_work_queue_local+0x50/0x96
>    ? preempt_count_sub+0xf/0xbf
>    ? lockdep_hardirqs_off+0x10c/0x115
>    ? error_entry+0x72/0xd0
>    ? trace_hardirqs_off_caller+0x56/0x116
>    ? trace_hardirqs_off_thunk+0x1a/0x1c
>    invalid_op+0x14/0x20
>   RIP: 0010:kvm_arch_vcpu_ioctl_run+0x42b/0x33d7
> 
> * This commit is present in linux-5.13.y.
> 
> * Conflict arises as the following commit is is not present in
> linux-5.10.y and older.
> - b3646477d458 ("KVM: x86: use static calls to reduce kvm_x86_ops overhead")
> 
> * Tests run: syzkaller reproducer, Chrome OS tryjobs
> 
>   arch/x86/kvm/x86.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43fb4e296d8d..9cfc669b4a24 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -416,8 +416,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>   
>   	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
>   	queue:
> -		if (has_error && !is_protmode(vcpu))
> -			has_error = false;
>   		if (reinject) {
>   			/*
>   			 * On vmentry, vcpu->arch.exception.pending is only
> @@ -7114,6 +7112,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
>   	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
>   }
>   
> +static void kvm_inject_exception(struct kvm_vcpu *vcpu)
> +{
> +       if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
> +               vcpu->arch.exception.error_code = false;
> +       kvm_x86_ops->queue_exception(vcpu);
> +}
> +
>   static int inject_pending_event(struct kvm_vcpu *vcpu)
>   {
>   	int r;
> @@ -7121,7 +7126,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>   	/* try to reinject previous events if any */
>   
>   	if (vcpu->arch.exception.injected)
> -		kvm_x86_ops->queue_exception(vcpu);
> +		kvm_inject_exception(vcpu);
>   	/*
>   	 * Do not inject an NMI or interrupt if there is a pending
>   	 * exception.  Exceptions and interrupts are recognized at
> @@ -7175,7 +7180,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>   			kvm_update_dr7(vcpu);
>   		}
>   
> -		kvm_x86_ops->queue_exception(vcpu);
> +		kvm_inject_exception(vcpu);
>   	}
>   
>   	/* Don't consider new event if we re-injected an event */
> 


Acked-by: Paolo Bonzini <pbonzini@redhat.com>

