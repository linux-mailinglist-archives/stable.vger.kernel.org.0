Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3074B5873D2
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 00:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiHAWTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 18:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiHAWTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 18:19:02 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B8427FCC
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 15:19:00 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id n138so9467259iod.4
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 15:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=buWpDoyRJL+IgqIja3qNH5XA+qhezm6ica8qDK/+0ng=;
        b=MbRFc1imuyNgpm5/KrBD2htSg/jJSj6zWsN59GlvQ2ZExegKrTfRuC6/mWsLAqN2Ro
         S5cKDdripZHZPb+tZ2e1Ucxj0S8L4Wtd8r8fXRs1Ke3A9D5KHZVJmgOczQorzJ4s9RaK
         hztvBM/8OXCbDz0yQ57vV2P6RIzHtEiwTq7UU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=buWpDoyRJL+IgqIja3qNH5XA+qhezm6ica8qDK/+0ng=;
        b=fxnxR/AIeK/Jh+vIKAfhwtwdKdVVnYB1qoKgfoYJZR11OSSkjMLxuvcM12wA3j0OAb
         JsC56RcYkQZU3ULK4qtSopK/0SDQgJpLmwKbR5LuriApbHP5uxQJsmcKBfC1tQHEi7MU
         uoHRQUE005CcDGLATnq6IHwNMHxRQE35VHh2+QM9uQoKGsDPkXpP+zZpse5wb0V1BpD4
         4dlovRZpq8CY2lsO/Rd4THF8FkAUUm3n3AaU8BKqCH0swkbmE11+povIyUUyYklfZLUq
         0XXrIYJYRhbSeZ1q7dK4eHXAdjgHUpy+PTagu0eb6h1aNrALF7M8FDV+VLOo5eiXsVdI
         30tg==
X-Gm-Message-State: AJIora9//q998agRIb8u/S4YRvvaIkBf48/1cLMOhu+JmV6eYsARpNVQ
        oAGWiTFKF/Syhesd64TqIMc20g==
X-Google-Smtp-Source: AGRyM1uz5AQwJEETrCxvG9oQBd+GOrHViYp78JQCCsJ0i3dNK+OPQRafNcu0rRSM8uklg3NfQgcuVA==
X-Received: by 2002:a05:6638:12cc:b0:33f:7b73:541e with SMTP id v12-20020a05663812cc00b0033f7b73541emr7354939jas.275.1659392340229;
        Mon, 01 Aug 2022 15:19:00 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k18-20020a026612000000b00331b9a3c5adsm5767840jac.170.2022.08.01.15.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 15:18:59 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/69] 5.15.59-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bb24cd0d-7a3e-34e1-f091-4942b60538aa@linuxfoundation.org>
Date:   Mon, 1 Aug 2022 16:18:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/1/22 5:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.59 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.59-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
