Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125CF38B918
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 23:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhETVo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 17:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhETVo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 17:44:59 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D5FC061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 14:43:37 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id s7so2047492iov.2
        for <stable@vger.kernel.org>; Thu, 20 May 2021 14:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mRSw2I7XDnnc5ITtr5YLMCGw8zw6dxZ7JSv8THbsa1o=;
        b=SekyqvHWjEeagJMU9CjiHKrfnzbRgsvYETe7YwZWOXnMVVR7nfWLYSYmo79c4yhP71
         FqYMi+lSsiGNcqqunxu1OvMzUtfV6yzWpDiQxPI+dv+0K2XUIRtnhcSGCZjsuChwd+DI
         cQLWUfsjVp0o4xiJWq1Z3fXG/gDQlJme1igTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mRSw2I7XDnnc5ITtr5YLMCGw8zw6dxZ7JSv8THbsa1o=;
        b=hvKFN8pm1mt0UDgb+h/zArcWnJ3zfdY+NvrzGyZ2TmScpnsgAf7xKRRD+uKT9wGHa8
         R62yPtc+A3XcjdoRvC9l6RNxARANtSdPX/Ff7CstsM6uWaMQjPW7hY9pA1xkx7sSTh1/
         aA/6+bQqgO/qSgecOEejRqsGq/8MMXsqypSMuUvC9iSgpLpJY4BPGwD6JmtRyO1ztY1t
         TiRjAfEKkgfXu50xIxEA9lr9DiCieOvKFZw8HDU6+63LE0QoWpvTPR9gWx0XQkSvq05M
         86r1fI6IohDrs3bfWRpe4I09MgQydY+A2NqEHUGq0c/fk3o7Khlgha+xb51dj4Y0P4cA
         zZgg==
X-Gm-Message-State: AOAM531Ua2H9VxCfnQq6vH/5AUT4wJEe7/jixjp0EJ7aDHKWYWYz5Te7
        C2kinmamYCKJY8KogqVyNDtq2Q==
X-Google-Smtp-Source: ABdhPJxGvT/EsOD0HmbS4hnpNFM1zzIhEPA9EvHYU5J5gord3MtgGFhPzmWxWpX0cAcbyfobZ/vzqQ==
X-Received: by 2002:a5d:87c4:: with SMTP id q4mr6553422ios.141.1621547017029;
        Thu, 20 May 2021 14:43:37 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id n12sm4217249ile.0.2021.05.20.14.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 14:43:36 -0700 (PDT)
Subject: Re: [PATCH 5.12 00/43] 5.12.6-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210520152254.218537944@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e67e6529-628f-ee75-16e1-c9b577adbc89@linuxfoundation.org>
Date:   Thu, 20 May 2021 15:43:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520152254.218537944@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/21 9:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
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
