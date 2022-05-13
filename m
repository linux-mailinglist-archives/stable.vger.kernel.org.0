Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAAF526BAC
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 22:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384246AbiEMUia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 16:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiEMUi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 16:38:28 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD35F1654BE
        for <stable@vger.kernel.org>; Fri, 13 May 2022 13:38:26 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id z12so6522437ilp.8
        for <stable@vger.kernel.org>; Fri, 13 May 2022 13:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8UqDdKnaqXrZrEMpWysqVRGr6K6IKSG1alEKIGWRTvQ=;
        b=Y+NYkU079gdaSFmk39mG3HvhGnS/JwLlCu3yi3A3A544U8dRZjDpEU2hAY5tOrPBPp
         Hd0a/coiR/AHqWzIPoc0gsv0rLtjZt3eSm9Sa0+UZudEwT3VnlKX+RInA0mIaWef7EVW
         f2NMfEAP/+zn4i3bgXgQPbY4kKObwh4B2ARJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8UqDdKnaqXrZrEMpWysqVRGr6K6IKSG1alEKIGWRTvQ=;
        b=pqEKVVcLHDX/XVduGYXyE3KpeGvOaKRiv+Y38cCh9I2wMzHASNZDo8SI8FEYZltpuQ
         0FK5A4PnPfjT5iLYguIYH18GB3gJybbmpTGBLPsQw63c24r18b7vWmmexAhfOsuiGq9D
         nEoefJoERFIUpyzC5+KxrgFgJ1y1+y6KAztI8tc6atLs1zCei1GPvN/McOzmA4AsnKV0
         M43EnajNZ/37OADKyR8rR8dN73OQsWPis4OkZdNtNZjStcBQF4dFpISZlZjPVVGQ55NS
         PV6xYlW19N5ZeYKHi8qDYoHGNkS1I0nTeqyOP1A0lwcvcUrR36ANNSIaj6NAadl1mjbb
         FLKw==
X-Gm-Message-State: AOAM530I+EESfu3rdiDGIdi27eyd1UZFblQIiIyrYHyl24T6DMKtDYwa
        Jxwl2x5NhpuTZCp27+Ld2W3Stw==
X-Google-Smtp-Source: ABdhPJyYED3pLTwlCu/XOq/zeS5O5Xrhklu4vT5rAKmTd9i+naogsO7D+sCv5tqcomUqqIIDxsadRQ==
X-Received: by 2002:a92:ca07:0:b0:2cf:95c4:9e9d with SMTP id j7-20020a92ca07000000b002cf95c49e9dmr3580089ils.99.1652474306342;
        Fri, 13 May 2022 13:38:26 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x1-20020a056638034100b0032b3a78175asm930235jap.30.2022.05.13.13.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 13:38:26 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/10] 5.10.116-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220513142228.303546319@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <00742f65-6a1b-5730-46c1-870f2388711b@linuxfoundation.org>
Date:   Fri, 13 May 2022 14:38:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/22 8:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.116 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.116-rc1.gz
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

thanks,
-- Shuah

