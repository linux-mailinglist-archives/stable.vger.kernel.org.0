Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA50C36BC57
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 01:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhDZXtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 19:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbhDZXtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 19:49:07 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C329C061756
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 16:48:24 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id a9so116844ilh.9
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 16:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HKfX60qyJHhVwdcWm8es8/kYODKadyAvexHgfU8BlKA=;
        b=dtiNn5Z3oodaEoICir1M2tB+F85jDVY1603MLyeW+9Dtx/bGoAfIGMZWMywLzUFIuI
         fgPtwxDu2vE3cDixi3GsN+YR4qV1gapk7MJbKkLMwGrNmMbWRVDTmSj3S6HyPBtWgb3L
         6RH13MjO4Gq0n/HhnR2K4AilLkY+MZEd2LPhU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HKfX60qyJHhVwdcWm8es8/kYODKadyAvexHgfU8BlKA=;
        b=eX/+1g5+ek+rsBOb9Wcp8RI/QA/oBXmXsuAv4Dl1HN/V9fhcrWHiNXss4uYeUiy/rv
         KdaaNcLAq52pEFLn7dhk7hJ4y4AVKMngvNML7A3LeTBdT23PdlnevbI5GbPoFCxk20fH
         ji1TiaL+7jwBxqSWMoVrMeEkXo+0cl3fb9snjghgQZqyG3/SZa0x2EXCsdX3liUhwTMO
         TFuJSYSSp0a/dZIwoQ7Oo5fNUVFBnoqcfnakbKo7lACMmCj8hFGeETvZgqwtReC/OG4/
         vAutgp6pMFKKy3bvB1vjG6mo3aDu4hntSBPIEUxRuQx28U7JGm4gXM85WO76mRV4cHVC
         vDjw==
X-Gm-Message-State: AOAM533N7YgnOFKxZkutZJ2G8dOa5p2timSbUxC3ZrjjlSggWpI0ZEFN
        0AnFWxP7aVQTdQOw5JtAk5AzKw==
X-Google-Smtp-Source: ABdhPJw8yrdO+y/c7huENqJX414DRYIWSKHfZ7a9wvwforzmsWvbmmB1RQ8eB57WR+uhOtjdbcbXfw==
X-Received: by 2002:a92:c791:: with SMTP id c17mr10762151ilk.107.1619480903462;
        Mon, 26 Apr 2021 16:48:23 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u4sm603653iln.36.2021.04.26.16.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 16:48:23 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/32] 4.4.268-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <32fdfc53-65d0-4e4f-551c-045862936dcf@linuxfoundation.org>
Date:   Mon, 26 Apr 2021 17:48:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/21 1:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.268 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.268-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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

