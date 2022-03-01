Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B0C4C9604
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbiCAUSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiCAUSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:18:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A909B340F2
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 12:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646165873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kbtnGrIoAXkidAZTj8FmIyhuel5W031FIJwbUY20FAA=;
        b=QeHSnPwcGqPowM17j08m8fdc1RMPdGb83K6lINecxmUgSUUoEka05hzbpnNUYr+27yNtvI
        uR82X/jEUdCU3dI+ZPQZGHv7atfA50+8zFYXpYUQ2RLN312erqcvu5lg1vN4hySl81iklw
        ++icgX40TpjrVppa8O4QDEfbrb6xJ0M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-ngtB5vWUNhG6ZLoE0Pozsg-1; Tue, 01 Mar 2022 15:17:52 -0500
X-MC-Unique: ngtB5vWUNhG6ZLoE0Pozsg-1
Received: by mail-wr1-f70.google.com with SMTP id a5-20020adfdd05000000b001f023fe32ffso570041wrm.18
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 12:17:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kbtnGrIoAXkidAZTj8FmIyhuel5W031FIJwbUY20FAA=;
        b=6RFht9BvHvS2QD2jr00Jc2dxwpACgKFy7oW+M0r2BOQLDKiDZvDc5OEHBUfOUsJOl4
         aPkFPImEkDEV2IiUQaWflktawQXb0wnkkBAS+4G1+DwHqcH6JGNgQGfxn+t4KzcV4j/k
         k0ZDG5ldzRh+bx69ZpLhZvXGIc1S1UuJ6iStgSn37hXvPIvIu1QMMuT9O1hR1gPNqToy
         4ScwEW7lCyyTV+Rd+KUoKAFiZffOpZHJJlpRH1MLbEqmeool9sKS3cbgeHyPVmqb38h5
         LDQbAfoAY9RLw93iuGcASwpWf6jffe6roOjJ4ijW9J46IX5DJRtB6Lj1bFs+/n0nTOxI
         eNdw==
X-Gm-Message-State: AOAM5338onjt98FBLugvO6DKQMkon7rgLQaiLWo2FK08tp7GFdenj8h0
        cF6uozkVWqU8n0BC15PFDQGD5G5HLYLQrWZgHC7Q766Y2RZixcPJRr5KSe86JLghCTfZbeRTsJA
        nTuW8VexBbD2fVGm/
X-Received: by 2002:a05:600c:4e08:b0:381:9094:6b3c with SMTP id b8-20020a05600c4e0800b0038190946b3cmr3338839wmq.103.1646165871011;
        Tue, 01 Mar 2022 12:17:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHRA1O1tPDB9klqjpvqfr2MK6rdobahePsJyhIS2BUsCgaysLn9yR7ZHPI3cYyFrk3Va3iAQ==
X-Received: by 2002:a05:600c:4e08:b0:381:9094:6b3c with SMTP id b8-20020a05600c4e0800b0038190946b3cmr3338828wmq.103.1646165870783;
        Tue, 01 Mar 2022 12:17:50 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id k15-20020adff5cf000000b001e4b8fde355sm14482929wrp.73.2022.03.01.12.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:17:50 -0800 (PST)
Message-ID: <2619b94d-d1e8-5185-5533-506421ca7281@redhat.com>
Date:   Tue, 1 Mar 2022 21:17:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.15 05/23] KVM: Fix lockdep false negative during
 host resume
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org
References: <20220301201629.18547-1-sashal@kernel.org>
 <20220301201629.18547-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301201629.18547-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/22 21:16, Sasha Levin wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> [ Upstream commit 4cb9a998b1ce25fad74a82f5a5c45a4ef40de337 ]
> 
> I saw the below splatting after the host suspended and resumed.
> 
>     WARNING: CPU: 0 PID: 2943 at kvm/arch/x86/kvm/../../../virt/kvm/kvm_main.c:5531 kvm_resume+0x2c/0x30 [kvm]
>     CPU: 0 PID: 2943 Comm: step_after_susp Tainted: G        W IOE     5.17.0-rc3+ #4
>     RIP: 0010:kvm_resume+0x2c/0x30 [kvm]
>     Call Trace:
>      <TASK>
>      syscore_resume+0x90/0x340
>      suspend_devices_and_enter+0xaee/0xe90
>      pm_suspend.cold+0x36b/0x3c2
>      state_store+0x82/0xf0
>      kernfs_fop_write_iter+0x1b6/0x260
>      new_sync_write+0x258/0x370
>      vfs_write+0x33f/0x510
>      ksys_write+0xc9/0x160
>      do_syscall_64+0x3b/0xc0
>      entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> lockdep_is_held() can return -1 when lockdep is disabled which triggers
> this warning. Let's use lockdep_assert_not_held() which can detect
> incorrect calls while holding a lock and it also avoids false negatives
> when lockdep is disabled.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1644920142-81249-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   virt/kvm/kvm_main.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 13aff136e6eef..5309b3eaa0470 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5416,9 +5416,7 @@ static int kvm_suspend(void)
>   static void kvm_resume(void)
>   {
>   	if (kvm_usage_count) {
> -#ifdef CONFIG_LOCKDEP
> -		WARN_ON(lockdep_is_held(&kvm_count_lock));
> -#endif
> +		lockdep_assert_not_held(&kvm_count_lock);
>   		hardware_enable_nolock(NULL);
>   	}
>   }

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

