Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DCA52989A
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 06:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiEQEOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 00:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237206AbiEQEOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 00:14:01 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7666B47564
        for <stable@vger.kernel.org>; Mon, 16 May 2022 21:13:41 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-edeb6c3642so22822309fac.3
        for <stable@vger.kernel.org>; Mon, 16 May 2022 21:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vlS8HH9kxm8e7oyzOpwYqn9TLCV2qWKpTfyr5YCSt/A=;
        b=CT4MNXpeWUvPhXVxDxbzENUUVOBdGOtNsdLT3PNgZBjzQzggYUNwg9TQNBSMqRJ5oX
         A/IFlgHmL78OhQcSWWAXh1RmrEVFQ2ax328nk9PDnPouUKz/7q6iWR7GiP5KgX4xibFS
         JQuT/HBwSrRNsJSgKbaJsI5u2uEQWDicABhts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vlS8HH9kxm8e7oyzOpwYqn9TLCV2qWKpTfyr5YCSt/A=;
        b=jBMeECWA4UpBQcYdRTHQmYr7U0AJkVvf9+bXL5mtG8sJp3x4gYGaB3brbX+Jm8mfQR
         cOqHHiAfoR3PDLZt9ZN2yItYnC5QDZmN8x37Fibq+xbweuMezRLL2bFRiPGerqgLygN4
         TBM3isNGrZLg3ShWCONTJlsJktA/nQV+ww/dYJo6s04C3VaJNh2BnHz88YR3moy0R72E
         8YmQ4QQeW0mHI/VFJL1f/3JikZfL/RitcgLwDkN8MDt5bCkp8LwkNOnQJoWXsr9SgK7J
         lxJEeok0IuqNYIbbpnNXdwiJaDealUHboD+GLlsPZM9cKn0RXFAOdFlfDLL5es4kA/rR
         /6qw==
X-Gm-Message-State: AOAM531TMlJijlRSPZj9z/hbA77qLbBBPgeeSQ7fuCN64FMc6i8kPBUE
        bsF+3FklYO/8JZ7vlSTRMnLCrw==
X-Google-Smtp-Source: ABdhPJyTolo27BXXMRFHmmDpLVwb/LF3OFgkIccSFPHKl8sSgsbI/7a8ff7sIIrhkmoyHgyh5wnILA==
X-Received: by 2002:a05:6870:d0ce:b0:ed:9988:ba91 with SMTP id k14-20020a056870d0ce00b000ed9988ba91mr11286681oaa.205.1652760820159;
        Mon, 16 May 2022 21:13:40 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ed5-20020a056870b78500b000e686d1387asm6121653oab.20.2022.05.16.21.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 21:13:39 -0700 (PDT)
Subject: Re: [PATCH 5.17 000/114] 5.17.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <03643f12-8c15-a2ca-0897-5539b805930b@linuxfoundation.org>
Date:   Mon, 16 May 2022 22:13:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/16/22 1:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.9 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
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
