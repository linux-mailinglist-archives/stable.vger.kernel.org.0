Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813EC38B923
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 23:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhETVrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 17:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhETVri (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 17:47:38 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015C7C061761
        for <stable@vger.kernel.org>; Thu, 20 May 2021 14:46:17 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e10so14903923ilu.11
        for <stable@vger.kernel.org>; Thu, 20 May 2021 14:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TnrfhMqe8IMYSiIhRflaM6cLg99z377tkPoGbvreho4=;
        b=AbD3QJ3nOom2wGUMMvLCZFn8zMx7mvFkqQwPz2fDn/OKtr+0fhtjfCFD9AA7qbfs+3
         KzeqFeMWVV2dJ2daEqb3jJ6s/TS7qY5mNN/RmPRTxl3kr6o4fGe+Xy79l99Yh5f7Urnk
         v0WoPp0qKYAf6xqtc2+F3Km2rGug9DmGrVynk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TnrfhMqe8IMYSiIhRflaM6cLg99z377tkPoGbvreho4=;
        b=Y0t920ZtNqE6aObEhJPoFU0SE0tDsD1rS2ZXDsm0uOcoBBu1YKEt+O/Gx22IB0GbiL
         C8cfRYHTjIyy6+8inmfqwaz6WBKUXjqx3axYcoEWjJPGJmWTRjQyOFHoS6EWW4/Uk4WR
         GxbMsooAByxYLOlVBL3WnKhhT3qhdOhnxR4JSlIN3V0BHKlHX5rIjs25fL/0oEqKNXS4
         8kLuqy1h1dBKW6jy4gm78u/hZNJqUa6ziCnc+ooJO+lL9iklXKKITXpUZpSfqeDcYZ0/
         qr43kiLqqvYnGm1R6oJoI33eNoGd4EQpVRvs8ft0ZJuAA3cxiJVmR0kgRZjxXXmA2rbp
         k9Ug==
X-Gm-Message-State: AOAM5319XVSIWh+cg14oDUAiomgQxTXgRjuP7Ct4Ltup54JCcQG/+yli
        6h8xX9NgNA1VTzLXkgNfN/qVLA==
X-Google-Smtp-Source: ABdhPJwYudELQHmXOjjtK8KREFc8BXc14uO/VDThdZR8oYy4VvDrwiYm++3qioK4faVrGoYjvs7rZw==
X-Received: by 2002:a92:cda4:: with SMTP id g4mr7243793ild.47.1621547176361;
        Thu, 20 May 2021 14:46:16 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h16sm4118357ilr.56.2021.05.20.14.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 14:46:16 -0700 (PDT)
Subject: Re: [PATCH 4.4 000/190] 4.4.269-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <69671a85-ccdc-0ce7-9f5d-3afb31c5035d@linuxfoundation.org>
Date:   Thu, 20 May 2021 15:46:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/21 3:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.269 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.269-rc1.gz
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
