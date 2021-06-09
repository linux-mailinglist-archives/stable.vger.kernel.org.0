Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A333A0A59
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 04:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhFIC6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 22:58:43 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:45767 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbhFIC6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 22:58:43 -0400
Received: by mail-oi1-f173.google.com with SMTP id w127so23680083oig.12
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 19:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AbR0pgw+eKCoWm+Es/JbmIKk+Vs12rJ1RUhCtiCefHw=;
        b=grO/+19fj2JSQJKi575P3PWJ95jOtYu0efLvJXAmexS1zOfENhIfDZVcuWlr+T/vTy
         qNxaPgE1CBeGcSFdrTYgSoi6pLQbwPbrZy2FjH47ZecjiyXqJPeJmFPQG/Xtt+9Px6eS
         F4UBUA+m6SzwczXYaZVIR1T4jyMDt0vC6tbWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AbR0pgw+eKCoWm+Es/JbmIKk+Vs12rJ1RUhCtiCefHw=;
        b=pdy3zAtqZaz1ggbyn9a3Qa45PDJ9ZgouNIo1gg3n3j2JyqXKbBaYkBQTG8kVeM1sZX
         BYvPuyZOu7lMPmN7xkSf6ghwk7PK8FkYohd2y0RNG+pzp1/06P5dTLpxz8FbNkVrTVM2
         D6qObG657c29je2c4bLgriCUaHtkCqhF2ywBTKvRoRMcwbbbqIfhseVU/wPw5Y+SRCoG
         p7wCDRXGn1/9lXxeSkimUCVDSDqumYHI9/VYhjr9kUXM5U0cvvL8yOEpW8FrSkY3BJQI
         JdDQZ0mNtYI3e7qtgUy5HtSBfxmbnzAnjXPbNqcee5JySFdr9KG3qP15/0+JKssdTxmU
         UPXQ==
X-Gm-Message-State: AOAM530Z4FmxFzP1hKN1lqvyU+ig1VsBFDslKYv2nsvbaXq9wcE9yVP6
        I+1K+2wFcUiIibl0V67IMUrAmw==
X-Google-Smtp-Source: ABdhPJxjAywbMXc/TqyX+D1gVSv6xOp+4IHk7ijDhxqqrn3++TOFaWoDZUBroYwMgAL5DuGpkCcmXw==
X-Received: by 2002:aca:59c3:: with SMTP id n186mr5207551oib.98.1623207333018;
        Tue, 08 Jun 2021 19:55:33 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l24sm1963387otf.39.2021.06.08.19.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 19:55:32 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/58] 4.19.194-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e93190ca-7a32-1ca9-b1d7-5923aa0761f6@linuxfoundation.org>
Date:   Tue, 8 Jun 2021 20:55:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/8/21 12:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.194 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.194-rc1.gz
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
