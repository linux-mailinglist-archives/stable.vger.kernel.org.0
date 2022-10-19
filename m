Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E156050BD
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 21:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiJSTvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 15:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJSTva (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 15:51:30 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C4A13E10;
        Wed, 19 Oct 2022 12:51:29 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id t25so11462387qkm.2;
        Wed, 19 Oct 2022 12:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mRh3sUpm3qMdhWacBjA4h5l3rneIrGVTLqXNu/AUJr4=;
        b=Rg+ntIVOLxAkDGhqQd5FG8t4yU6n4MkPeuluKs9/C9kkkSNuF8yLlKfN/UpCMkyevt
         P/OoTCCfyTTPLmLT7g1cw9P1fbn8d+zK9o+JzsWf1W5Rk2Ln1bUDrHX5iTTQA54Dt1oq
         2bj8rbgdNpUfuq8/1QzUhJU3KCLMywnTS8q+3xy6kzXVgp3pyDcliCDITn+ckezYKgBU
         PD/+bVa8q3jIN2uYPMd3GV6kRfTXez4fGy5nhAZgXwvc3iZ1x1CSeDJ+aSYBxqxRjdyT
         IYoF9mlxJYs8nnQ4jNO08NOZ7azl9oJugY0jPdFXwexQPG2ZzK2KxlgOlBBZAeM1iOrv
         s5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mRh3sUpm3qMdhWacBjA4h5l3rneIrGVTLqXNu/AUJr4=;
        b=vMBd1iS83VJbGmK0VbZjoXPFkjKawRb3h8wXEGvcR572ATUpi6lnINO/M9ciOBIXt1
         i6+IXiuSZoz+3uJMUaMue8O57Tng2Rzs2iBMX7ptlfrkv+gvKj8E7Eut8i3q5VP9EVQP
         6EDKvjkCvhGgVK/kB0OAe+jfnheVN0ItzQXNSSd3vgPO1BaHo9dHqYeJyPSK5F8xUYGL
         nOCOmDsmyK/8yMNIMf5oGlxBp4jccxOVRimycxspn8MsVLOoPI+XJBMCVlyp9dm00JBQ
         SbDaBRzNhOgEPzl5gVhkXK3sFy4FBUKKUQFTpCtpL/7Qxmzdr81fendosSKa/83mEffX
         Lytg==
X-Gm-Message-State: ACrzQf23WETsFJ4Zi5k/WNeoGGTS5hr0Qm5Ru/hvjFQJWvjujuwqSDve
        ggsI1WDyjUQjuuQ2KCBj+H0=
X-Google-Smtp-Source: AMsMyM5ihVCT41/+OLFOn8RNmsZGmhDpIWY8fN89HXo05NpdzS2/WGaSmqG4l6asThPQdEla9S695w==
X-Received: by 2002:a37:a49:0:b0:6ee:6816:41e9 with SMTP id 70-20020a370a49000000b006ee681641e9mr6700054qkk.173.1666209088926;
        Wed, 19 Oct 2022 12:51:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ch8-20020a05622a40c800b0039cc82a319asm4566667qtb.76.2022.10.19.12.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 12:51:28 -0700 (PDT)
Message-ID: <51257525-25e9-68cc-bc84-12ac886de56b@gmail.com>
Date:   Wed, 19 Oct 2022 12:51:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221019083249.951566199@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/22 01:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Oct 2022 08:30:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

