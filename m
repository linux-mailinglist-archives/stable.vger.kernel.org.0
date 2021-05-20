Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5F438B91C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 23:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhETVpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 17:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhETVpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 17:45:52 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14E7C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 14:44:29 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id k4so12829886ili.4
        for <stable@vger.kernel.org>; Thu, 20 May 2021 14:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z7+oyx7FW1xBvnYI34FQ+7Ywa2LK8NLNJlPo/Ll4Xzc=;
        b=JzfocgQqdQeW6r/2Jb63Vf8BpHICw6XPGnXLljnFGCZGzOORf9CCoqt7Ppdfp0QUTB
         GlrCQnqhuXgnGmRg0j8WBOHiBj4eW8Wd3URtjL6fvLDYmj3xvkSkbny5VykBzM+Cg4m/
         4dmOJuGiQxWXfwFzoSinkCqQ0B+hdD+Kufs6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z7+oyx7FW1xBvnYI34FQ+7Ywa2LK8NLNJlPo/Ll4Xzc=;
        b=HvZco+13HUXJujwek5zR/LGsi9a9wrhxVrvS7viEY2jjCfDBNEseWcM7bIMQsU+GkV
         7dGpwj1mXJgsW0/vGyX6dOxb22BjDt2ry348Yrd0WOweOUwcP1uItq6oWB91v5I7t6Pl
         BU3tB9h0pHAYCN0zeHaBrs+xr+d5uglcLPVIIJCBGwg2SYDsjAUM7ydnG6Qo6VslPxjq
         ndzDkpbp8ZRbew0ymO7oAl+RvnKpPBUNmESKMVAWIRQT4CvLJSykZVDySCH803yMViBs
         TyVPIp3Ku9hWgsRQYw4CCiq5IM2r53jOU7POpwfiejTLfLSJW9kJItq2HE5ppbuOvQSX
         QFHw==
X-Gm-Message-State: AOAM532fL0t9dR1nvBtOImRhztSzHa0QkRPqK4HaJh+K2V4CJx+g98Id
        UZuEjONedCjX5JbWoRUoXWJWSQ==
X-Google-Smtp-Source: ABdhPJyc7MpacNiBuAGamog0hHL51gkvXNT7oYAfDUJH4g0I7bzo7Z89bHVPylLtPGxK9U+3chyOrw==
X-Received: by 2002:a05:6e02:6cc:: with SMTP id p12mr7755670ils.244.1621547069308;
        Thu, 20 May 2021 14:44:29 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 11sm4081728ilt.7.2021.05.20.14.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 14:44:28 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/37] 5.4.121-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <91be52d9-c49c-f847-c8ba-1c263d872df9@linuxfoundation.org>
Date:   Thu, 20 May 2021 15:44:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/21 3:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.121 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.121-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

