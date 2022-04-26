Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADC8510A25
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354562AbiDZUTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354859AbiDZUS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:18:56 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8481D322
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 13:15:45 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id 125so21796605iov.10
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 13:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HLfBsULnxIHtTg2vaikfG3QQHyujaLrfdQn3O+y4ETI=;
        b=K+QcZXo4BDYUlsPbgXhdk3qDu7qLz/0pZHUt2IEnBCVZKIycAZA/bn5Kc0czFEulAS
         oGPBa00f1zJkrVHe++8dSEIPcfxhlnkwAeZF+baX+zb5MS+5yoVWBWW6G9hqGGEydkwm
         G9SosRBRI55oHTWo/M36KYsCcBD9eotVtNWPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HLfBsULnxIHtTg2vaikfG3QQHyujaLrfdQn3O+y4ETI=;
        b=mzDPPkJUyDBBdm3NjCsWoJNWXxZ6liMntTtcM8FqLVIm18AhHRggmJaS0DI+G0CY89
         77G1fConoFpqMMg9Xm/pwEre5CTkY9OqD/tkNYi59wX+KZDg3LtgPKIV/rTvwf/YqYex
         t1Sr2Y2VP9zktICk3blb6BO6aSKDnn33Y/IY1J4ZX/Yt2EbylKT4p7DF4MiJGIYbvVW+
         2u8GVqY3NFFPh+GYrrx9iwhLOx1nbuowRzqSVl4YA4qR1KWceKvFj0oU94NMoemJXIbi
         XbXmqUafqZoRfX/xAO+kChTxXZKy2pkrbW87bfIWmvV2vK+9SH8yWfkLa5K60PgK7OGI
         q79g==
X-Gm-Message-State: AOAM530HKleENV/mdgu/Ph0r/3JiaEDbvYX8PLBk/u3qPvLE8txiVlRp
        smZ7ze7gID8muNIiixllgtq4Xw==
X-Google-Smtp-Source: ABdhPJwPzMOmHWAfV+Bu4oMaLQ30snKfKqCT/WHhMeSJMw1dHMtTe7qM6LLhSrQA61YA33tSsEU15A==
X-Received: by 2002:a5d:860d:0:b0:649:be05:7b0b with SMTP id f13-20020a5d860d000000b00649be057b0bmr10349378iol.22.1651004145105;
        Tue, 26 Apr 2022 13:15:45 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id y126-20020a6bc884000000b00657ae00d56bsm1153279iof.48.2022.04.26.13.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 13:15:44 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/53] 4.19.240-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5337eb4a-73d3-881e-83a6-69919e812f34@linuxfoundation.org>
Date:   Tue, 26 Apr 2022 14:15:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 2:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.240 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.240-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
