Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5355C3C2AF3
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 23:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhGIVpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 17:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhGIVpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 17:45:51 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85CAC0613DD
        for <stable@vger.kernel.org>; Fri,  9 Jul 2021 14:43:06 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 75-20020a9d08510000b02904acfe6bcccaso10895182oty.12
        for <stable@vger.kernel.org>; Fri, 09 Jul 2021 14:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wL6O9+uf0UtsaSmR/HUTqQv1zEFtC4X0DRlcCMAvlVM=;
        b=EHPGMPkg2fHIUNsJzTzYNnHnXGyAXN1eZAXaOEbPetByC15CF8EzyHNuhCFr6JlcZZ
         aasOLVuW34P3qU8+hCHk5nc3PIDotiUDYyXJcyrOOYyb2QOCYhbQTaA1ABjqqPYTuby2
         cyJvwRLz0u/oYp4f2uPc6IEPHr1PGv8fj/rcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wL6O9+uf0UtsaSmR/HUTqQv1zEFtC4X0DRlcCMAvlVM=;
        b=qHI9zIIlc+tIQEflBUslXxczChSz5/xdVv177QsHugEgGmR+rGGjSWbWJbD2JNu26A
         Q2Ydu1AtWUsIRFo/HigVs5eX8LXa8MhVNMdcsTEfwnFQymumko/Azx7vLTGu5eDYJ7H7
         kPS+orlgVAgfLWUPRGyQQAZpM3TdhWk2auDSho3GRN4hfT9bVVQox05OxgeSr8vwflvz
         Enl/NbYCCWSH74ORUXwNvWUdw93nDj/Ed6umkmzpI5xMmvPyuSwcN91SBfzU8v85FZIg
         FsMkB9V/MQN6g9CvfUm8/ClXiwp01PMH8dBmy5qB4+QVfXvuvpX582CjKRu6XD++TRSW
         73Fg==
X-Gm-Message-State: AOAM530otL3+bSOpbwMMHY5s+oQNQXxepSBWkmRuCPBs0lZyDXPFQLFy
        xGn1UcsV22Hj3bM6T4sgTn/Lkw==
X-Google-Smtp-Source: ABdhPJwaREncqbahCdenov+TEoleAtqcFy4t5SZTckVoaonji/8ZP000jzgvEJHNdFSz+hlPc2w2tA==
X-Received: by 2002:a9d:141:: with SMTP id 59mr14545271otu.57.1625866986148;
        Fri, 09 Jul 2021 14:43:06 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i24sm319485oie.27.2021.07.09.14.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 14:43:05 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/34] 4.19.197-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210709131644.969303901@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b19071dd-1706-c6b5-1146-750f66853b80@linuxfoundation.org>
Date:   Fri, 9 Jul 2021 15:43:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/9/21 7:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.197 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.197-rc1.gz
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

