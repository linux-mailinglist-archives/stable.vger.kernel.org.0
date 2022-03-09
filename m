Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13584D380C
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbiCIRBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236896AbiCIRAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:00:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 991B8381
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 08:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646844427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ipYouFZiDbGHky53FeVZHKDK4SIGwfG+XTgGSHDhMCM=;
        b=dhMnYI/1dEQnA4V60Eji275p2xDmmFLE3wfbcCXixlhjYZDp0sX3Ag63PnLFKH6zizvpzP
        o54pLWZP7DO48MlADbz/fWrpomDjbkjASusrq8c9bbz2JQ9HFXaXgYqJjp0O4B5qXjTmNf
        WbQfco5TZwowSFh78Jm2ECZYfQxR3dE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-v5GiHuLKP0ufZR3rATnlpw-1; Wed, 09 Mar 2022 11:47:06 -0500
X-MC-Unique: v5GiHuLKP0ufZR3rATnlpw-1
Received: by mail-ej1-f72.google.com with SMTP id ey18-20020a1709070b9200b006da9614af58so1605157ejc.10
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 08:47:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ipYouFZiDbGHky53FeVZHKDK4SIGwfG+XTgGSHDhMCM=;
        b=Czv+BXX7tfi/npeu67Gbah2ZtqBbatubWfpof/aXaY7W6gG6yplnUPhyu6qpoyH83N
         S/uJDDN9K2gVG5PZcQdHfPX8/nPMj1sLdN3qzJYC2EfJYQIPT+4QZaMI+JNzHGWAGF3G
         yA/gnmFo5RbnsYH3CpQMTviGrWfXEh0DNsTK+aXrceKQ6YIF600HGTpC6KfpbR0Qs4NC
         PoD/O8tnsgp5CBg/PpZT01xbkiZSdZjS8l14ZQAscbtGNG4/RMlBDPux1MPFS8qNMNF+
         Ug24XT4/aYXBpRP0SC2DcL4/0Y++ULEMf1lC95AQl8dfGOiXnnC63l0rroifL/lRQHwG
         RqpQ==
X-Gm-Message-State: AOAM5334ImFlJ/Es0MWUNk40cyOyqm6sLvBHzE9sQki5L4A4svjb/nx1
        EsTWfkJM+esyJef4S+HJwee2k0JSzjXs6uBwo/9Z6A+Sjr8GsTvKEj9clsuF7Jx68xe1S6dHDCI
        VQjlc4JGwsN3bEBrn
X-Received: by 2002:a05:6402:3489:b0:416:9121:6936 with SMTP id v9-20020a056402348900b0041691216936mr310685edc.249.1646844425021;
        Wed, 09 Mar 2022 08:47:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzH84i/kZ3vII5SpLkdFUh2hPiQt7AxMY/YMw3liCSc3DymOHCpIJ4tZh9EtCphaVdzBD/ZZQ==
X-Received: by 2002:a05:6402:3489:b0:416:9121:6936 with SMTP id v9-20020a056402348900b0041691216936mr310666edc.249.1646844424802;
        Wed, 09 Mar 2022 08:47:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z11-20020a50e68b000000b00412ec8b2180sm1046807edm.90.2022.03.09.08.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 08:47:04 -0800 (PST)
Message-ID: <c7e4a000-9e76-266a-7cb3-4ccdaf54bf6b@redhat.com>
Date:   Wed, 9 Mar 2022 17:47:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.16] KVM: x86: Yield to IPI target vCPU only if
 it is busy
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220309164618.137930-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220309164618.137930-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/22 17:46, Sasha Levin wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> [ Upstream commit 9ee83635d872812f3920209c606c6ea9e412ffcc ]
> 
> When sending a call-function IPI-many to vCPUs, yield to the
> IPI target vCPU which is marked as preempted.
> 
> but when emulating HLT, an idling vCPU will be voluntarily
> scheduled out and mark as preempted from the guest kernel
> perspective. yielding to idle vCPU is pointless and increase
> unnecessary vmexit, maybe miss the true preempted vCPU
> 
> so yield to IPI target vCPU only if vCPU is busy and preempted
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Message-Id: <1644380201-29423-1-git-send-email-lirongqing@baidu.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kernel/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 59abbdad7729..2121c20e877f 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -619,7 +619,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
>   
>   	/* Make sure other vCPUs get a chance to run if they need to. */
>   	for_each_cpu(cpu, mask) {
> -		if (vcpu_is_preempted(cpu)) {
> +		if (!idle_cpu(cpu) && vcpu_is_preempted(cpu)) {
>   			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
>   			break;
>   		}

NACK, just an optimization.

Paolo

