Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4ED5970BF
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 16:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbiHQOLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 10:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbiHQOLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 10:11:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA5F2E69A
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 07:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660745465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G4PliwN29Vvo4kieOBvS43H35wk4LljjHLtEA4cokrk=;
        b=XGsk8yRa3tTfVSeewKp2+7/xdbYgtL00IuEBBvzN09CA+mfyATgTCpPpdjCinUIwda1YX6
        IrENmFF7FkFv8pvOqEqw24N4qroBJ9M08hrJruQthE24tGU9/eqiPK/dv3AeUwnwnFD3dq
        X8hWWRF04r/C8LyAjgpB0pB92z/9umY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-93-VUv6r6dnN9q5J-T3vUqf2w-1; Wed, 17 Aug 2022 10:11:04 -0400
X-MC-Unique: VUv6r6dnN9q5J-T3vUqf2w-1
Received: by mail-wm1-f71.google.com with SMTP id i132-20020a1c3b8a000000b003a537064611so6351602wma.4
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 07:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=G4PliwN29Vvo4kieOBvS43H35wk4LljjHLtEA4cokrk=;
        b=vK9PPY3jC0kXqWBsMkZC+3BpFIQpWkUwNJeG4fWyCNij1HkiHUXnkBwLwCv9bBchya
         xCQCrvRLbBLgsZBZyqnVlJSg6qndkqh5HDy5oIj5CzvE2+E+2gwMMbN8SJWY2+b8Mngt
         3fMq61DSA7h3LTmqd6l7uF7XOxlWdZtn9APgrsuETTkv9YxoZq+dtBEInC2z0LPA+Z8d
         GUPDo2/g8kSZP90Kt50NL0UxEk7ak2IQMhHNquCnB5oCaq38+UAQbwrNG40eYSlBYHwN
         qy9NtI0mklnTc2odTKTvMMiqyNnQk8VNNmGdUni77CLYWn4BLuPgEceaNXoGO1XFciK/
         jYmQ==
X-Gm-Message-State: ACgBeo0AfWDnRv2eV7gY5Fg5EUQQM8jkahtQcG7nycjy2ozpncce+aHh
        OFFXD8DSseC6aUBecoAACTbNs/fs00tWkp2lwbN8C1wNzL+EP+kD/XeITKof9LucL+fQp8Q2LXM
        R3UoeXSxMB5VKbWa2
X-Received: by 2002:a1c:f317:0:b0:3a5:e38f:46b with SMTP id q23-20020a1cf317000000b003a5e38f046bmr2303118wmq.98.1660745463164;
        Wed, 17 Aug 2022 07:11:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5cmXyxqS7tB971BG248cYu5aUKrMDYiFo/97QVTJu43t53rYRSlh0GSZ5NX1qKyM3OgvpZrQ==
X-Received: by 2002:a1c:f317:0:b0:3a5:e38f:46b with SMTP id q23-20020a1cf317000000b003a5e38f046bmr2303104wmq.98.1660745462987;
        Wed, 17 Aug 2022 07:11:02 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id d2-20020adffbc2000000b002206203ed3dsm12908590wrs.29.2022.08.17.07.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:11:02 -0700 (PDT)
Message-ID: <833a6829585a2209a29c2f99a84be348744d65d2.camel@redhat.com>
Subject: Re: [PATCH v2 7/9] KVM: nVMX: Make an event request when pending an
 MTF nested VM-Exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, stable@vger.kernel.org
Date:   Wed, 17 Aug 2022 17:11:01 +0300
In-Reply-To: <20220811210605.402337-8-pbonzini@redhat.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
         <20220811210605.402337-8-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-08-11 at 17:06 -0400, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Set KVM_REQ_EVENT when MTF becomes pending to ensure that KVM will run
> through inject_pending_event() and thus vmx_check_nested_events() prior
> to re-entering the guest.
> 
> MTF currently works by virtue of KVM's hack that calls
> kvm_check_nested_events() from kvm_vcpu_running(), but that hack will
> be removed in the near future.  Until that call is removed, the patch
> introduces no functional change.
> 
> Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d7f8331d6f7e..940c0c0f8281 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1660,10 +1660,12 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
>          */
>         if (nested_cpu_has_mtf(vmcs12) &&
>             (!vcpu->arch.exception.pending ||
> -            vcpu->arch.exception.nr == DB_VECTOR))
> +            vcpu->arch.exception.nr == DB_VECTOR)) {
>                 vmx->nested.mtf_pending = true;
> -       else
> +               kvm_make_request(KVM_REQ_EVENT, vcpu);
> +       } else {
>                 vmx->nested.mtf_pending = false;
> +       }
>  }
>  
>  static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

