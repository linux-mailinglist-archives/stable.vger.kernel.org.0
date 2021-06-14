Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578FC3A6EEE
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhFNT1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:27:19 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:46881 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbhFNT1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:27:18 -0400
Received: by mail-ot1-f48.google.com with SMTP id 66-20020a9d02c80000b02903615edf7c1aso11900453otl.13
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 12:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5GFM5CYTBc+j6NmnUaMqGZ4lOqRVHgsm/gOrMdNOdLU=;
        b=ij0CCxGhQ9p1nVufwFtIpCNhYMKYZf9TQw6E91/aO4VY11oQ/1QBEO889dDR9tdN0x
         EaM7OfmGQKKFqNmg7KepCGZYhC+vETtb2lMo2ep0y0VBIdMN2m47p7cdxMV207XRZZVf
         Rv6ZVOD9brZYNJxGKLLjFd9uBd64YmD0fKPSc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5GFM5CYTBc+j6NmnUaMqGZ4lOqRVHgsm/gOrMdNOdLU=;
        b=eWnK9G362z795L9P72SXD0UZo20+yIiokukjg3F3BB1CKQWyLWC0lZjGjqFiwp/L5A
         6T30EaZ/EnjV3VuzLH2PPfMvSrOtPmS5jEI9mTmVVpCO3z3c65avy7Q5yCqtSASALtCg
         El60qxWvbqMcjCf5iUJ+zcdi/2c4Lv90Z+rk0XrHDEn+3tyGEq83fPzp2VHw7pLxE09s
         2GHWorNOeX5J9MvBWzSeiiR/9o3DyKxkqso0ijUgYiK6LfM32F+f8T4IadeK9Bpon1o7
         d5n6t9tZaZcTgII78CayYw5gBqfPcIxYu6NHqCW6dEUYBTsb09MovTjSERHrjAREI+2h
         KFBA==
X-Gm-Message-State: AOAM533eqI3gTlp+uBRC92ND60kjymFu1cegHGEtzhk9ucZErn1W4qDi
        UqMOpVvCl1sCMoP/ViqserWwMQ==
X-Google-Smtp-Source: ABdhPJwuyXSWlWOdwA8rWoZZUB6YFHNzKhjT5P9C8v6MoQyKU/XVssPrYRe7lzCGGyQe9o2yj9qIeA==
X-Received: by 2002:a9d:6c4d:: with SMTP id g13mr14921028otq.321.1623698655620;
        Mon, 14 Jun 2021 12:24:15 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t21sm3464416otd.35.2021.06.14.12.24.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 12:24:15 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/34] 4.4.273-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dfe00795-556a-2b6d-e752-ab081eaf3492@linuxfoundation.org>
Date:   Mon, 14 Jun 2021 13:24:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/21 4:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.273 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.273-rc1.gz
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

