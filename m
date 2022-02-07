Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D881F4ABF4E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386671AbiBGNEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383706AbiBGMfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 07:35:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EF48C03BFD9
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 04:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644236569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QSBowbgf2vb90A9ABdZ9rYr8VIZn9VMzK+A/qJ0lcdg=;
        b=XV/Q0JpjYNIIUARi4GmyBGonzgk319nrjqBilYfkxYCluiVfZKXLKDbdhRPazV3X1t1D++
        wGKvYhFAE1WZqlaVyTnqdMN8Kmv5ew7d0VZRYPbi/zWsKexsqrhMqjzqwTZuFgPHKl95rS
        bFXq7pG8pxK1Ehj/1NOIEZw8CrxMF8s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-r5nvurt9NlSKEJZAFG6-NQ-1; Mon, 07 Feb 2022 07:22:48 -0500
X-MC-Unique: r5nvurt9NlSKEJZAFG6-NQ-1
Received: by mail-wm1-f70.google.com with SMTP id m3-20020a7bcb83000000b0034f75d92f27so5582489wmi.2
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 04:22:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QSBowbgf2vb90A9ABdZ9rYr8VIZn9VMzK+A/qJ0lcdg=;
        b=mtWokSDV4UoE6LWK9kq7smMSsIHIzZuKzJFChKZxsfHrVgM09Wl9jYcXanypuOi1mW
         7cF2HdVGHj8NWNBxHt37jBrCA94sVtD8sgE5QwE2TZes2oMBuuLG4aoJb+F0C4D4VLox
         YWuqOtvbJNbsMkdTvqHvg4p1tTEvmcYZ2G35UglnHsUOmCqUedM58xsG+sEXlf/FmUAx
         chaxpOBNv7ntn7OnXW6kxDFyiP0vyiSuuCuuxl/k0d/ymLXrw7m+vVUfuX4fp8kXaQ/w
         tZDPMvuW0hb25QvAGKYpF6sezT6oYpMEocAFn8yP3eZquvHF4ixlnhgRer9CEibDhnqW
         hEEg==
X-Gm-Message-State: AOAM533z2sZ2bm9nWhCFIWI0H+FNOgsp8U77uV/yR4UG0XIlAITA9So1
        FRU5o9NLm8xueJiPgQ02rUP/KOuaUqplXQ01N6HjLH+b12V3MegZqwjGoVaNdC6IL2EdoIi/uPQ
        VPEkczmSVhJ8VOs3G
X-Received: by 2002:a05:600c:4982:: with SMTP id h2mr4267646wmp.140.1644236566936;
        Mon, 07 Feb 2022 04:22:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx91JTZSeZfXaf4e9dtm2LUw/crJMou26urFCvtQBIFE8q74IzQmEVn+9kPPM+Z3Luotfv8SQ==
X-Received: by 2002:a05:600c:4982:: with SMTP id h2mr4267609wmp.140.1644236566681;
        Mon, 07 Feb 2022 04:22:46 -0800 (PST)
Received: from ?IPv6:2a0c:5a80:1204:1500:37e7:8150:d9df:36f? ([2a0c:5a80:1204:1500:37e7:8150:d9df:36f])
        by smtp.gmail.com with ESMTPSA id j2sm9523231wms.2.2022.02.07.04.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 04:22:46 -0800 (PST)
Message-ID: <d4a766d90803e794985e8d693972c24e5fe1926f.camel@redhat.com>
Subject: Re: [PATCH 5.16 000/126] 5.16.8-rc1 review
From:   Nicolas Saenz Julienne <nsaenzju@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Arnd Bergmann <arnd@arndb.de>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Date:   Mon, 07 Feb 2022 13:22:45 +0100
In-Reply-To: <CA+G9fYsd_kjuXOJx9umAhkaA7rRx40gVhY9ZBEe6xsMOZ2oTQg@mail.gmail.com>
References: <20220207103804.053675072@linuxfoundation.org>
         <CA+G9fYsd_kjuXOJx9umAhkaA7rRx40gVhY9ZBEe6xsMOZ2oTQg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-02-07 at 17:49 +0530, Naresh Kamboju wrote:
> > This is the start of the stable review cycle for the 5.16.8 release.
> > There are 126 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >         
> > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.8-rc1.gz
> > or in the git tree and branch at:
> >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > linux-5.16.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> Linux stable-rc 5.16 arm64 builds failed due to below errors.
> 
>   kvm/arm64: rework guest entry logic
>   [ Upstream commit 8cfe148a7136bc60452a5c6b7ac2d9d15c36909b ]
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> arch/arm64/kvm/arm.c: In function 'kvm_arm_vcpu_enter_exit':
> arch/arm64/kvm/arm.c:778:9: error: implicit declaration of function
> 'guest_state_enter_irqoff'; did you mean 'guest_enter_irqoff'?
> [-Werror=implicit-function-declaration]
>   778 |         guest_state_enter_irqoff();
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~
>       |         guest_enter_irqoff
> arch/arm64/kvm/arm.c:780:9: error: implicit declaration of function
> 'guest_state_exit_irqoff'; did you mean 'guest_exit_irqoff'?
> [-Werror=implicit-function-declaration]
>   780 |         guest_state_exit_irqoff();
>       |         ^~~~~~~~~~~~~~~~~~~~~~~
>       |         guest_exit_irqoff
> arch/arm64/kvm/arm.c: In function 'kvm_arch_vcpu_ioctl_run':
> arch/arm64/kvm/arm.c:875:17: error: implicit declaration of function
> 'guest_timing_enter_irqoff'; did you mean 'guest_enter_irqoff'?
> [-Werror=implicit-function-declaration]
>   875 |                 guest_timing_enter_irqoff();
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
>       |                 guest_enter_irqoff
> arch/arm64/kvm/arm.c:925:17: error: implicit declaration of function
> 'guest_timing_exit_irqoff'; did you mean 'guest_exit_irqoff'?
> [-Werror=implicit-function-declaration]
>   925 |                 guest_timing_exit_irqoff();
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~
>       |                 guest_exit_irqoff
> cc1: some warnings being treated as errors
> 
> 
> build link:
> -----------

I think this patch is missing:
https://lore.kernel.org/lkml/87czk65vhq.wl-maz@kernel.org/T/#m49f8ab674c269f14f57dae33f90af30617bc735f

-- 
Nicolás Sáenz

