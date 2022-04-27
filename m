Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC6B511D30
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242207AbiD0Q2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 12:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242520AbiD0Q2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 12:28:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C75C6369CF
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0vtvSuzLYLcgoD95SpJhSmih26+GW1SKNz4Ydfjj5rE=;
        b=fbPkNQy4/sXURsFvC9WnUMkrbJ1/sUlfex7qXpJ9TBYD9jQ4ioaputyEUolBRPYrpG4Gfd
        K//tffAq3u6+2v+mLWZ+v/D58F6iAphFfibLRldoYFoXVse+FjhdN6GFzeMlL7QWhCKPsj
        M4na0zGvdaPhhLKSSAp3HUOut3xJri0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-jzbOrRTSNT6cYbFohicuTQ-1; Wed, 27 Apr 2022 12:19:20 -0400
X-MC-Unique: jzbOrRTSNT6cYbFohicuTQ-1
Received: by mail-ed1-f70.google.com with SMTP id cn27-20020a0564020cbb00b0041b5b91adb5so1257835edb.15
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0vtvSuzLYLcgoD95SpJhSmih26+GW1SKNz4Ydfjj5rE=;
        b=QqZgvwd61lnNsQAlboDr+ptXMh3t+HTTiOzH9bwjA+Pp9tHtpwP+zAMfkzuX3icOx/
         Z2VKxpjCnKnwzIDMlHYGxotBcdLI+b07cHYqKUB9EgNVimVbHcyBUcF/mb88pV8NBX58
         MMOoWJHfz8xVMTqDUb/YJ7ZnVK1KGSxV8o6hBsa2qovbOi1QBqqYpvEbmpMkGp9im8ug
         zbJP0UYhCcvnN5ifTIroVl3Gc7512LfPAKgADi+25Wh+Y20pZ1+r9OGu5QGf7cZZQeFM
         1/KJdoWYU+E5DaJDPJqSNk4o3lUSrcQtmeuZwPWc0vkU52D9/oa6Q9uo2jbC89HHqZcX
         LJUQ==
X-Gm-Message-State: AOAM531FB4EX19xHN09/e3ShLk4XzTZr73lyGSlPCDHjsCU6AjSrTgay
        ABu4WSlgUpTO9/9HXZ1zwiqi8F3Ryi5l7bE/l67c0mck7kTI9tlsGKhULnz/mOpdtmEdvaL0V/3
        +5fiQbcfcGpNv1qOM
X-Received: by 2002:a17:906:2709:b0:6f0:13d5:d58f with SMTP id z9-20020a170906270900b006f013d5d58fmr27200699ejc.443.1651076359509;
        Wed, 27 Apr 2022 09:19:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9Dgl/s8uZP58yIRaUi3Jvtur40DwqDMW4yP+pK+QmdGZaMin9hYn/cnbzo5rPHR9Vve4T5A==
X-Received: by 2002:a17:906:2709:b0:6f0:13d5:d58f with SMTP id z9-20020a170906270900b006f013d5d58fmr27200676ejc.443.1651076359238;
        Wed, 27 Apr 2022 09:19:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id mf1-20020a1709071a4100b006f39f556011sm3841382ejc.125.2022.04.27.09.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:19:17 -0700 (PDT)
Message-ID: <37137ef4-c2db-44a2-9ed3-1d9ab8bad9f8@redhat.com>
Date:   Wed, 27 Apr 2022 18:19:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.10 4/4] KVM: LAPIC: Enable timer
 posted-interrupt only when mwait/hlt is advertised
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Aili Yao <yaoaili@kingsoft.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155435.19554-1-sashal@kernel.org>
 <20220427155435.19554-4-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155435.19554-4-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/22 17:54, Sasha Levin wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> [ Upstream commit 1714a4eb6fb0cb79f182873cd011a8ed60ac65e8 ]
> 
> As commit 0c5f81dad46 ("KVM: LAPIC: Inject timer interrupt via posted
> interrupt") mentioned that the host admin should well tune the guest
> setup, so that vCPUs are placed on isolated pCPUs, and with several pCPUs
> surplus for *busy* housekeeping.  In this setup, it is preferrable to
> disable mwait/hlt/pause vmexits to keep the vCPUs in non-root mode.
> 
> However, if only some guests isolated and others not, they would not
> have any benefit from posted timer interrupts, and at the same time lose
> VMX preemption timer fast paths because kvm_can_post_timer_interrupt()
> returns true and therefore forces kvm_can_use_hv_timer() to false.
> 
> By guaranteeing that posted-interrupt timer is only used if MWAIT or
> HLT are done without vmexit, KVM can make a better choice and use the
> VMX preemption timer and the corresponding fast paths.
> 
> Reported-by: Aili Yao <yaoaili@kingsoft.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Cc: Aili Yao <yaoaili@kingsoft.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1643112538-36743-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/lapic.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e45ebf0870b6..a3ef793fce5f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -113,7 +113,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>   
>   static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>   {
> -	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> +	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> +		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
>   }
>   
>   bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

