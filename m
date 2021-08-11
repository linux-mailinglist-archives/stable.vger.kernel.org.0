Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F11B3E9ADF
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 00:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhHKWWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 18:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbhHKWWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 18:22:45 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E60C061765
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 15:22:21 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id t128so7026963oig.1
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 15:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HbOCL8hggztIRnMEXo7ZFaqYUA40MuqyhWLwnY70QeE=;
        b=LcTXlc6ZkGeUEl4MHITuRo1q4VaVKkRPrRAWq91WNIgIp0S+M5y735EX7Eoe4baOdr
         ZMfTFilq9S/TEtR4N1RSbhzTmMN6+b8Pw13evbJKi+pkL17w/9cM6Kp8A93N0M5Q0fzx
         6L+a3WFEaywRoNiKvOTklBsbL7/uZTcHPr7fI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HbOCL8hggztIRnMEXo7ZFaqYUA40MuqyhWLwnY70QeE=;
        b=tTA1V/58GltWc4kMUGWTWXs8FNKXIUPiUDdeABBifgiuOZxmAsrrZJ07WFESoj2oo7
         FWx/HhIks0hAg/9IDBbiwT/EhFS+XAd5mtNWxH1NH182lH7yVUsslnoRDBqHOoM/Vd0T
         raocV910O90j6dUP9wNP6TiOlFz9vNf+HszxnbeijDdBEd+BJhH3h+D/dfyejosXkaQM
         UASy+olC9cn7Jr5TIY4hdoItaeNl27jIZL6QIYaFfsqE8CMbT6oKq84W43K0rrc5zWTP
         Pnwa/aYb5XNP6pqZQzfuRSJhviuclfLITMNzL+JVj+tfCv+wHLHeBHoUzGK94k/2kqDy
         heGg==
X-Gm-Message-State: AOAM5330jDivDUise/iWW8mRWxOHMF9VE5o8ngdPrxBXM7jFUN9fFv2q
        fpbZ3f9jZUaJAMEr83UvyzCYAg==
X-Google-Smtp-Source: ABdhPJyzGEF1019Zm/zq2rdMWVxts7KfOQQIwKHw4pjX4lB3w2I+cKd23LYAqEqM7e3Ogg5cYOkLwQ==
X-Received: by 2002:aca:c0c3:: with SMTP id q186mr9137944oif.39.1628720541080;
        Wed, 11 Aug 2021 15:22:21 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 68sm189532otj.57.2021.08.11.15.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 15:22:20 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/54] 4.19.203-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <87c3491b-cc86-0b0d-e675-46b2d0c91959@linuxfoundation.org>
Date:   Wed, 11 Aug 2021 16:22:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/21 11:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.203 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.203-rc1.gz
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
