Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D663EBEBA
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 01:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbhHMX0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 19:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbhHMX0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 19:26:54 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21B1C0617AD
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 16:26:26 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e186so15379615iof.12
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 16:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bxuiDhwFd5/1+OCBgqMGo92C3FHs10czCMmzZapYzHE=;
        b=Oj0N9cDZ9O9c8vzbLbDwgR4qGQFxbodUjWThHcbb6ddIA4Fys970KUpFCmEDd72NeT
         mn24Xh0mafXq823IQrAsYawniun0+AA6bi5twP7Fju1OTlnpDdutig81mfvANA8St99W
         hZWNMPALR/K3FyJ2fxnHeOm0sYA7M2YTNYNdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bxuiDhwFd5/1+OCBgqMGo92C3FHs10czCMmzZapYzHE=;
        b=rX0P7VnzGGLlH8hibHWrkXefCudfEo0sb0yIC1pyjxbFXAbf6ha63LVARYTMPDYUbL
         3v0jW0pZ+gAl5NHAGXmAZhrrVEHveT2W8M6lA2ZwM/P+gw7UCXZM4g0aZiZT5lputpeY
         TKkWN+rKXckw2CusVY9Jvvw01pr+JHwnkveeqsuAReVFSv2PGgD68yQDztArfYXujSLI
         yTx2akSSz1PfhC8gfeEzFJkcXXirBkiVtOzrQTBgCPdW2RnORgnszi4bHrHDZhPsFEEg
         CJsTLUkJv3Gr3EjaaJefTBbgAVUQ1jc7S5AsVQJja1/9LJRERGZXpjQaV5+xNw1x9y6d
         XGDQ==
X-Gm-Message-State: AOAM531zCfYM/VVtzPIwM9+7kXmbuQT+rorPL3cXGVSpOVKKeLyupXhy
        3xHrThn5AjFkHw4wOjK511XU3g==
X-Google-Smtp-Source: ABdhPJwUoQ3XBf4BUzo+IvppWotMbhMHpo5R+GLKF5XsXnL8TMWAY0ES7O8X8hJ2HMtdzD6g821tUg==
X-Received: by 2002:a02:caa1:: with SMTP id e1mr4456669jap.107.1628897186197;
        Fri, 13 Aug 2021 16:26:26 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id p19sm986512ilj.58.2021.08.13.16.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 16:26:25 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/25] 4.4.281-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210813150520.718161915@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3d0a2bd6-3f9f-ccee-a442-855ba610f97c@linuxfoundation.org>
Date:   Fri, 13 Aug 2021 17:26:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210813150520.718161915@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/13/21 9:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.281 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.281-rc1.gz
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

