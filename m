Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAC35FF255
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiJNQhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJNQhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:37:33 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C781100BE7
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 09:37:31 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id d14so2802976ilf.2
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 09:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQ3ynZAgs6f93DRp+wIAkOPgGAVpfwvo4gIS1jIMlzc=;
        b=U2eQoqGPbnBoEGENJnnVdLSayXv+bE75HZJPNN8ktQDRYAJ5/UEm9YpkZ9F8T5lsXN
         3UV+r/HMdI3G7VSQ2zoKNTT4p00rivWdDhKk93pcfPhyoaVvl+bnZHYhByCFYyUB17jN
         8Z8aVrdB6EQKrVyrA/VbbE9ODfy9B595g5ZeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ3ynZAgs6f93DRp+wIAkOPgGAVpfwvo4gIS1jIMlzc=;
        b=N41gmVvSBo+38WjqKYVzldSMFX5ncaDOtZACHdHnN2puAs3suELLy8g7Cq9oVRmubQ
         G/ntrluAhd1mqVZcJPsBU3k99ice9KPAa0jBTMOA5zPiU0ZU+3IKbHTWqTki1CycOI4D
         afh2eAiuJtBgfmA9SSrGC0cBTQTEvcJgVCWDyIoEgLLv2a3p1Y3JMMBh9qus1YxHO3y4
         PJqkfHFRKBz1NWdtThzQ2KQ0ObmP05eq7Xi8FNceHBymeuqpV52o9ErCWqrnXIMiExRZ
         r+WRkc8djHwvh/SbG8f+bD4OSgIU12ikTRZ2yavxPjrw9rQvVb+yb+iW4a6YNyqWECst
         zvOg==
X-Gm-Message-State: ACrzQf0c/opNa5/WAkEHncbWABePbPyrCU0QwbrH2FOkgMDpsyF5ya1i
        oZcRK5GewKz1LeadoEfhOhLQrg==
X-Google-Smtp-Source: AMsMyM7eiGtMZnwH12IbKsq3RUoWkr1OlGDtmJJ6RpA7tyYHXqzFepYZbgsHc3nMtImyZoqLBury8A==
X-Received: by 2002:a92:d686:0:b0:2fa:6226:6247 with SMTP id p6-20020a92d686000000b002fa62266247mr3008321iln.79.1665765450793;
        Fri, 14 Oct 2022 09:37:30 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q4-20020a02cf04000000b0034c0e8829c0sm1284578jar.0.2022.10.14.09.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 09:37:30 -0700 (PDT)
Message-ID: <3c26b75a-270f-727b-23e3-e38e59dbac4c@linuxfoundation.org>
Date:   Fri, 14 Oct 2022 10:37:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 00/54] 5.10.148-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/13/22 11:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.148 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Just a note: I am debugging drm issue from a previous rc (5.10.146) and
I will let you know once I bisect and figure the offending patch.

This is not related to this rc - doesn't stop from releasing this one.

thanks,
-- Shuah
