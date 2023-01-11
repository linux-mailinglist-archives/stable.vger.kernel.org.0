Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D08D66506B
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 01:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbjAKAhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 19:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbjAKAhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 19:37:52 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3856550078
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 16:37:51 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e129so6987124iof.3
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 16:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nf79i4kFYNjvkaViMxUA+Wevatn6h1yiqkK+1eISKPg=;
        b=Mn7Kiyli+tUpKDurXXj/ueqz+GrUBetMGrndmeWHOKhlDtaLi0LeOnW6LZVwGG/rPm
         gc3UhuUyu1pVmXRtEM7mtrHDIHlmXLM7AZ59f64J3BTUvBKRizFj+DXCtHVV+fHZhLsj
         KwBVENeEGY7Rdvm+PQRuoT2ovC2szyV5Hs4Kc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nf79i4kFYNjvkaViMxUA+Wevatn6h1yiqkK+1eISKPg=;
        b=sCyO8UWN/LltWkgbKG2dAUENdAh2Fj11RAoWy/Gmv5668Y5wLNTzRVip53lYzgAxR4
         akBpiGUZfz3PsZEuTDP0Gst+wdE344vecQADNSl4sdP2qAakF3k3qzwpqdjS8cVoP8Oy
         ql+66DbVryVTZ+1p+TYz225OXeKzVweUZPO6EVHWadqi9Uv20HWlGPSDOLwtQUUUg4lf
         QoGEhotNFqrmsn+Liy2z2+8lqUtCPWHlrJCxgD9qCjV2wlk1DqCOaLCiPgli4Mm1n8bb
         +y8uecLRLsPokmPzZpojXHWeeIq0N/r2kaA8aYkrlijh0/Vw3Y226QutXevkHyjCEYZP
         Jt5A==
X-Gm-Message-State: AFqh2koqJ3xqfRxwCUxOvs+5AF+eDCkVEP3UWWjJKqXLjQpf8Jbneqx6
        CUt49d6DhQcGj+vvGfc67GlhzA==
X-Google-Smtp-Source: AMrXdXuqTgeYvvMdXOJyAWi71olRqUT1f2Med2xoF4IWRl+GEC6xHU97LDGYEk40HwHddJlFxCBjMg==
X-Received: by 2002:a6b:7d46:0:b0:6ed:1ad7:56bc with SMTP id d6-20020a6b7d46000000b006ed1ad756bcmr10498373ioq.0.1673397470566;
        Tue, 10 Jan 2023 16:37:50 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z10-20020a056602080a00b006f8b45e858asm4561046iow.29.2023.01.10.16.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 16:37:49 -0800 (PST)
Message-ID: <d5509667-da54-d5fb-4258-8f7931f10bf8@linuxfoundation.org>
Date:   Tue, 10 Jan 2023 17:37:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/23 11:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> NOTE, this will probably be the LAST 6.0.y release.  If there is
> anything preventing you from moving to 6.1.y right now, please let me
> know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
