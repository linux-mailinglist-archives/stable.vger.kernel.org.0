Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF21445AB8
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 20:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhKDT5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 15:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhKDT5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 15:57:16 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628DDC061203
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 12:54:38 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id v65so8261327ioe.5
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 12:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+LSaJI5eVpAo4OvNrEaEBw8K4N2W7nDPdNitVD57bIk=;
        b=Iqby8P73LFWyoTnSn0epChXbQSKlPcCsGS7vXeCJGMPPdLaqbz3XQFGEP7N7PpJ2MP
         lGve1tkDA+WunjBN8IUqy7N7hVFVg6X6zMjltZspMVQKQ+hUlMU9YDSaqLLd0uT3cEOB
         R5KRluefSfUXRB3k8YMvPoS4sjcqcxDasVNJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+LSaJI5eVpAo4OvNrEaEBw8K4N2W7nDPdNitVD57bIk=;
        b=zxE3KKGcETwgraPwY4aWWS160uePSZ8yNuCLoMw5kDEI9pw40phrz/yqalP724xwEa
         LYk1aYjRZzPZD+1uMYyCVG6BJ+HKo/2epY7lO9f5J0ep7fGF0JjH21S3U7eKpLYBA82/
         HiJtwJf1mzjJQ6cO8mVqRnJ8hs9c9sP8XXVe8YbPwMJbTdjo03yXuqfketJ0DIQeTS/p
         XC9LeiTYfmcY1RLGs553eu1WJm5cTPRh1QQoNWoXaaoWuL+9DeWEOG+fqyDdw8Bi4k0A
         l2qo5ZUfc6HLyjEgofDfFGYONVaFUzIUq6u8G4797yrm+CL7Eu7mJhkiVrBBPHS37MnR
         ctFw==
X-Gm-Message-State: AOAM531qx5/vdbzsQrH3QpEGYE1lAS45Su03Vbn7fgCFYpqxLSQe6ba6
        Cy6D+q0SLWh+L9Y/sLT3EMgSrg==
X-Google-Smtp-Source: ABdhPJwpunAdkJjgKyCTwLLmAvSIWGaGu39dhS0qPvY68uP/7fr1I7x8+VlKhT2n1Xmt5WIz1lcnVw==
X-Received: by 2002:a6b:db0d:: with SMTP id t13mr18995692ioc.171.1636055677815;
        Thu, 04 Nov 2021 12:54:37 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u12sm3306078ilm.1.2021.11.04.12.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 12:54:36 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/16] 5.14.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211104141159.863820939@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c4d54834-cee0-80bf-42b3-31e6e3f38710@linuxfoundation.org>
Date:   Thu, 4 Nov 2021 13:54:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.17 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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
