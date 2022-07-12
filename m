Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07DA571B8E
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 15:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbiGLNmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 09:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbiGLNmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 09:42:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26B30B96B9
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 06:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657633296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LtXyCz0IEfDkRQV6tTiEfKs8tnmrH7wPrOPUpSOgUsI=;
        b=VYUw4EwWgGlhedwsXNJvIHW8kHuOLJtCiLnBHh4wyDmdMmBL1rq+wcsyAW/VLgYjUCdl25
        YGU1dilfjbUNZSJZTiVzbpyWrX4Ac6oCBEFSSkYuMi17fPf8x0iio4xkU/l/wyYSHXza+4
        aSwGesKnZaepy0NDgYEUfBTQPBTRkvI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-djdVUZgSPDed2VTzSY96KQ-1; Tue, 12 Jul 2022 09:41:35 -0400
X-MC-Unique: djdVUZgSPDed2VTzSY96KQ-1
Received: by mail-qt1-f198.google.com with SMTP id fx12-20020a05622a4acc00b0031e98cb703cso6874353qtb.18
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 06:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LtXyCz0IEfDkRQV6tTiEfKs8tnmrH7wPrOPUpSOgUsI=;
        b=dLQ0A1iwc1lUw6Bwmeihg8vUWfRqEG6vlXqXFqY7pxLWjyagSGPzvhC3xmBTSgOmLd
         HWe8prn1nQuCAjlvafnHDr4oi5QwBOyRPPH0vna1vRiHRvN6UbtN2lAYnCoHd/J1FSLO
         gP0USYTH1ERF5hKN+58gyQ6i9ap76kEt359EmUqL5qys6sOkHdNdxe8fykTRpY5kXZPI
         CIaJBWf4CZqesptUrM6a1mrz31OEar2zEqnk5ThlUpySzyUU1ShlRZocYyPbECj4iWJi
         1DRvTDUxljEYY9hWCbUTlbO13FTq1uXBzo6EknHT3WHXoTb5TV8Z37LSIUyP2Yax2DSe
         0CeA==
X-Gm-Message-State: AJIora/r9qm1yITn89Kbt4KpCPg4sUpDuqD7MVr2bky6z0wAv4tVniFf
        +mzcCSJ3vkMJ474sXu4IVs/BBuq15itzhD2BxQ1rTKD3PtnpMTH7TzVEIUjVRErTSY5XyzfuZ1W
        ztTvvuCuoZbtjmn+i
X-Received: by 2002:a05:620a:40cf:b0:6b1:41dd:9710 with SMTP id g15-20020a05620a40cf00b006b141dd9710mr14646815qko.727.1657633294702;
        Tue, 12 Jul 2022 06:41:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v61v1x/bKlX35n737dVpDCn8PCMlVt2a+QFdLNlNJ3XN++zxJMZHXLCeAUxahcb5Un9igiKQ==
X-Received: by 2002:a05:620a:40cf:b0:6b1:41dd:9710 with SMTP id g15-20020a05620a40cf00b006b141dd9710mr14646786qko.727.1657633294359;
        Tue, 12 Jul 2022 06:41:34 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id l10-20020a05620a28ca00b006b59f02224asm2379927qkp.60.2022.07.12.06.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 06:41:33 -0700 (PDT)
Message-ID: <6dcd11aefcd817ee0f8603328886df3023a98fa5.camel@redhat.com>
Subject: Re: [PATCH v3] KVM: x86: Send EOI to SynIC vectors on accelerated
 EOI-induced VM-Exits
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wang Guangju <wangguangju@baidu.com>, seanjc@google.com,
        pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        wanpengli@tencent.com, bp@alien8.de, joro@8bytes.org,
        suravee.suthikulpanit@amd.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        lirongqing@baidu.com
Date:   Tue, 12 Jul 2022 16:41:28 +0300
In-Reply-To: <20220712123210.89-1-wangguangju@baidu.com>
References: <20220712123210.89-1-wangguangju@baidu.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-07-12 at 20:32 +0800, Wang Guangju wrote:
> When EOI virtualization is performed on VMX, kvm_apic_set_eoi_accelerated()
> is called upon EXIT_REASON_EOI_INDUCED but unlike its non-accelerated
> apic_set_eoi() sibling, Hyper-V SINT vectors are left unhandled.
> 
> Send EOI to Hyper-V SINT vectors when handling acclerated EOI-induced
> VM-Exits. KVM Hyper-V needs to handle the SINT EOI irrespective of whether
> the EOI is acclerated or not.

How does this relate to the AutoEOI feature, and the fact that on AVIC,
it can't intercept EOI at all (*)?

Best regards,
	Maxim Levitsky


(*) AVIC does intercept EOI write but only for level triggered interrupts.

> 
> Rename kvm_apic_set_eoi_accelerated() to kvm_apic_set_eoi() and let the
> non-accelerated helper call the "acclerated" version. That will document
> the delta between the non-accelerated path and the accelerated path.
> In addition, guarantee to trace even if there's no valid vector to EOI in
> the non-accelerated path in order to keep the semantics of the function
> intact.
> 
> Fixes: 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")
> Cc: <stable@vger.kernel.org>
> Tested-by: Wang Guangju <wangguangju@baidu.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Co-developed-by: Li Rongqing <lirongqing@baidu.com>
> Signed-off-by: Wang Guangju <wangguangju@baidu.com>
> ---
>  v1 -> v2: Updated the commit message and implement a new inline function
>  of apic_set_eoi_vector()
> 
>  v2 -> v3: Updated the subject and commit message, drop func 
>  apic_set_eoi_vector() and rename kvm_apic_set_eoi_accelerated() 
>  to kvm_apic_set_eoi()
> 
>  arch/x86/kvm/lapic.c   | 45 ++++++++++++++++++++++-----------------------
>  arch/x86/kvm/lapic.h   |  2 +-
>  arch/x86/kvm/vmx/vmx.c |  3 ++-
>  3 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f03facc..b2e72ab 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1269,46 +1269,45 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
>         kvm_ioapic_update_eoi(apic->vcpu, vector, trigger_mode);
>  }
>  
> +/*
> + * Send EOI for a valid vector.  The caller, or hardware when this is invoked
> + * after an accelerated EOI VM-Exit, is responsible for updating the vISR and
> + * vPPR.
> + */
> +void kvm_apic_set_eoi(struct kvm_lapic *apic, int vector)
> +{
> +       trace_kvm_eoi(apic, vector);
> +
> +       if (to_hv_vcpu(apic->vcpu) &&
> +           test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
> +               kvm_hv_synic_send_eoi(apic->vcpu, vector);
> +
> +       kvm_ioapic_send_eoi(apic, vector);
> +       kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
> +}
> +EXPORT_SYMBOL_GPL(kvm_apic_set_eoi);
> +
>  static int apic_set_eoi(struct kvm_lapic *apic)
>  {
>         int vector = apic_find_highest_isr(apic);
>  
> -       trace_kvm_eoi(apic, vector);
> -
>         /*
>          * Not every write EOI will has corresponding ISR,
>          * one example is when Kernel check timer on setup_IO_APIC
>          */
> -       if (vector == -1)
> +       if (vector == -1) {
> +               trace_kvm_eoi(apic, vector);
>                 return vector;
> +       }
>  
>         apic_clear_isr(vector, apic);
>         apic_update_ppr(apic);
>  
> -       if (to_hv_vcpu(apic->vcpu) &&
> -           test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
> -               kvm_hv_synic_send_eoi(apic->vcpu, vector);
> +       kvm_apic_set_eoi(apic, vector);
>  
> -       kvm_ioapic_send_eoi(apic, vector);
> -       kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
>         return vector;
>  }
>  
> -/*
> - * this interface assumes a trap-like exit, which has already finished
> - * desired side effect including vISR and vPPR update.
> - */
> -void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
> -{
> -       struct kvm_lapic *apic = vcpu->arch.apic;
> -
> -       trace_kvm_eoi(apic, vector);
> -
> -       kvm_ioapic_send_eoi(apic, vector);
> -       kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
> -}
> -EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
> -
>  void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
>  {
>         struct kvm_lapic_irq irq;
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 762bf61..48260fa 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -126,7 +126,7 @@ u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
>  void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data);
>  
>  void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset);
> -void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector);
> +void kvm_apic_set_eoi(struct kvm_lapic *apic, int vector);
>  
>  int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
>  void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9258468..f8b9eb1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5519,9 +5519,10 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
>  {
>         unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
>         int vector = exit_qualification & 0xff;
> +       struct kvm_lapic *apic = vcpu->arch.apic;
>  
>         /* EOI-induced VM exit is trap-like and thus no need to adjust IP */
> -       kvm_apic_set_eoi_accelerated(vcpu, vector);
> +       kvm_apic_set_eoi(apic, vector);
>         return 1;
>  }
>  


