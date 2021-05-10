Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95760379A68
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 00:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhEJWx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 18:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhEJWx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 18:53:26 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE49C061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 15:52:19 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id w16so9128987oiv.3
        for <stable@vger.kernel.org>; Mon, 10 May 2021 15:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8wFl7hJJ2a+eXSDm8RFGjLLaRg0fEvenukXjrrPiLW8=;
        b=KUIVXcj3xkUmmA1fTM/3HyLx26b7e4eMD3x+leijfNukiFfEXCTPFFl4qt7ApN4N0J
         3mjRRLZgm10l1756gZR75QOIM35cmIXyaR3SMha8QN/kAfNk0Lxcj7DAV2PrdmdtzIv4
         cnW0aK7OUtlajlOcuZAjgdwpl8nL+Ns68G+qI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8wFl7hJJ2a+eXSDm8RFGjLLaRg0fEvenukXjrrPiLW8=;
        b=hZGZCAVcb50SA84ocJ/T9qcp0n9kZTbEEmNvER2VnadqwoZCbapMBlLUpHWc7K8GPf
         biW/KpvNF68T8+21Y9lv2x/wesPWW6vh/CzMee24Spj9mh3rcKczYJtPKqTjzRz2UVQZ
         ueFQvAf9rINLJtBtT3QYJY+3W7mEAGaWxNY3S2KKVCiwEH5OiTVWg8E/fWTUZTQ/QLeU
         j4RvVEHLG+uv60ULK/PGFbB2uA4D1Wnsjk4o3QwlgogPfqPH0i1fZ5ros2cJBXTCXUhf
         ceceDpsr5V2cKAVYshBrJ8BBifr7/Vc/N84YLYkMoZfg3/lt/Qg5pt79dfCBMX3PyKxx
         bx5A==
X-Gm-Message-State: AOAM533WSrxtwuWW/j5s193tp8LDHElxdlWL7yo7zdu2dS10Mly1A+hx
        hzeI3fU/28NKoUmls8ttC1591Q02EK/chA==
X-Google-Smtp-Source: ABdhPJwsGYwxjf37Fcoh37enJlZQH4vWtYpsbYll52QZPlutjPahaw1HSkZvQp99ifLonkkRj2BOVg==
X-Received: by 2002:aca:1e07:: with SMTP id m7mr1157806oic.107.1620687139401;
        Mon, 10 May 2021 15:52:19 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 35sm624070oth.49.2021.05.10.15.52.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 15:52:19 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/384] 5.12.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <142fd239-2f8a-26d9-68d0-706e90096b66@linuxfoundation.org>
Date:   Mon, 10 May 2021 16:52:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/21 4:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.3 release.
> There are 384 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and boot hangs. I will start bisect

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
