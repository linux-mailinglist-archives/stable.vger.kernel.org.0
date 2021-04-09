Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D29735A7F3
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhDIUjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbhDIUjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:39:02 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C99CC061763
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 13:38:47 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id x16so7249005iob.1
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 13:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EE3hkw2vhgun02xrrqJ5291jMMGU5F26hjD6+r2g+cw=;
        b=U6Ajj3h31kxKBaWr5Yfb5YAyWhv1xyNclvEYmeybL8Q3+hQqoYGicPIz+CLeEGX8Vm
         R1zb/VKvVLY9x7y4KfJfA65pvUjOWNnrh5M6f0l6g/2iJuLwcmH6Fc8ecjLreQ0tAOcS
         vNZKVr/kKnBu7oPfGLwdyxxscyoUWRgmb9hOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EE3hkw2vhgun02xrrqJ5291jMMGU5F26hjD6+r2g+cw=;
        b=EVR8iRowHZGMbgLq7IM/UiFafcGTjzjCe7OlBfANtOk/bbgVWgp0deLxRuEPlonFYo
         tJrY0XlP2pPGbN7VP80ID5preJAiQsUYhX8h8D+EQvmJf+OvZNkT25hx+M2S0Z5heAsD
         WykmvhjXXVIK7KNQRTr9yXzmLaEHVgsnzfeMDgCPSDAzFylWbLPaN7l8HCPMN4bD/WLF
         BU+d5GY5RrJdxHpee+tCeiPvsIErI+qssAVsGux4NJG4rHPbo1xNzYuEn4p2xfQ7JRo/
         VVZKSo9OmsOhVzNOlaE0MWogCtwy5XagjRyF0pUjhjwy3IVpJnN6Ivj6SIB8ohBOlck6
         r1hA==
X-Gm-Message-State: AOAM530yhiGXCMUuN2qzmYyW+/gE8DjVx/SMqKcQczYO9WIoHfVtO2dE
        E2qE8orbjE7009MTtsQCr0xQ4A==
X-Google-Smtp-Source: ABdhPJxNRpxuWj7Wws3gWMQbRGZqHsmW0Xuu3tZMBOqrIDCx1x5rSKyZ9zDh2DTTkyKh8FrxolCZxQ==
X-Received: by 2002:a05:6602:3403:: with SMTP id n3mr12683920ioz.203.1618000726969;
        Fri, 09 Apr 2021 13:38:46 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s7sm1684149ioj.16.2021.04.09.13.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 13:38:46 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/41] 5.10.29-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d34f8995-e6e0-e7ef-0e35-0866f510f70e@linuxfoundation.org>
Date:   Fri, 9 Apr 2021 14:38:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/9/21 3:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.29 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.29-rc1.gz
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
