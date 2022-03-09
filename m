Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D184D3777
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbiCIRFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237561AbiCIRDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:03:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 122D31B2AFF
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 08:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646844675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ciXf/kDeXmAL/6RIvTYI6KZ9lH0wgG0xeQwUhPXRPo=;
        b=Fr8PVEWzW23g589L41311HRt+hUngvzSxPNGaHcwQ5okgisvfHclXg7yG9lXaY+mjmTLZ0
        bV77WQDF7E6gvs9GtaFBlCxht1s6I9DrMbb5dpuOum34uSWC2Q2hwH142tV/gKse8zuamJ
        25fcuB818slZk9whDmtlikE/i0DLhF8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-r5VihHY2PwyG8Z0_LcBeNA-1; Wed, 09 Mar 2022 11:51:14 -0500
X-MC-Unique: r5VihHY2PwyG8Z0_LcBeNA-1
Received: by mail-wm1-f71.google.com with SMTP id 14-20020a05600c028e00b003897a4056e8so1160936wmk.9
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 08:51:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0ciXf/kDeXmAL/6RIvTYI6KZ9lH0wgG0xeQwUhPXRPo=;
        b=5lIX84RnX2YJgbO/QcZtz9SQj4Hd3PPnQC0IWlQT7k9A9MOK9WgKRe+P4YfX95FA5s
         F+gky7oPG8JA5UWP3ePJ3hAwf9y56eocufQBVcIcVZH0p6jj1LWD4W99ATwdermSLMOa
         gBXeA7IA2l44DKOtHtjFds/1K34jFOGaJaev1eeDR0YWyWPpBRDsVpWBMSSUPQVhZBfH
         j2KVTsMGc8oqvZ9bsNcedIDQQ3TsBqTtvYPx3WJkrPg+0gMBBThNgn2FV/TyCxoyja3W
         lDx/ucz0kBln9ADFJEJZ43tf4xYeZcVE5u+l8zef0Z7kjqY4oqs0EMis+I12ycNDe3Bj
         6G/Q==
X-Gm-Message-State: AOAM531tPTbwwkxkE/KVx9kE7UleiYbii8Bo78AMm0wWGdN4TCBQDTDV
        hFR8KK1YkrurP8VPw+hTn4n6qFQ26PpWcWD3iIDUFHfyP38BM26cVodNtXBM4/7hhUNHbEBlRks
        cGkI2wDLYBwdhevgg
X-Received: by 2002:a5d:638b:0:b0:203:787e:c17f with SMTP id p11-20020a5d638b000000b00203787ec17fmr424781wru.250.1646844672782;
        Wed, 09 Mar 2022 08:51:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwA+tfh26XUx+xmyq2nalkKMHvS2HVfplNvpDg8s9jAzd4fUnvCw/p4zg7E4ldS/LrrMS6S9w==
X-Received: by 2002:a5d:638b:0:b0:203:787e:c17f with SMTP id p11-20020a5d638b000000b00203787ec17fmr424763wru.250.1646844672560;
        Wed, 09 Mar 2022 08:51:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n15-20020a05600c4f8f00b003842f011bc5sm5877090wmq.2.2022.03.09.08.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 08:51:11 -0800 (PST)
Message-ID: <e2917bf1-ec0c-65b3-0bb5-a03ed01b0856@redhat.com>
Date:   Wed, 9 Mar 2022 17:51:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.10] KVM: x86: Yield to IPI target vCPU only if
 it is busy
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220309164645.138079-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220309164645.138079-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
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
> index 7462b79c39de..8fe6eb5bed3f 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -590,7 +590,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
>   
>   	/* Make sure other vCPUs get a chance to run if they need to. */
>   	for_each_cpu(cpu, mask) {
> -		if (vcpu_is_preempted(cpu)) {
> +		if (!idle_cpu(cpu) && vcpu_is_preempted(cpu)) {
>   			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
>   			break;
>   		}

NACK

