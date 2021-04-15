Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4022636159A
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhDOWnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbhDOWnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 18:43:40 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D01C061756
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:43:14 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id p8so4468908iol.11
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0tI5L/D34Q2ZWrMz3JeV3QKLJpGA+xUCY3jKLj8HysQ=;
        b=eYejQBpoO8+kXeMS/IENZtAda0+0AEwU3ZUjpflywb6D5e3FF5Y8ujV7uPhiUCqTSP
         Z4xWMU2SYz+c76hImgVO1N/DPP1ICwQbCDaxHssT/ZZeDXZ/nE6TozvX3Jk4KJxahz4b
         xjC4OZBSTdoJwVXvUQaKpMDONIofx/CjvO9xg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0tI5L/D34Q2ZWrMz3JeV3QKLJpGA+xUCY3jKLj8HysQ=;
        b=VAS+9nZLDS4HyKhm4Jp6sopBGTyvK9lkgdvhotd/rYf9jlW/kWfjwIMoqn2h0sHjvp
         lG52o/H/J8uNVnikc4f45628ILcsyoMC4Vndvw/J39tWg9qeXu9/NwnZ4rcvcgEsR+9t
         PU+n6vLKa05+2CEhA8NlAH0PTtTV/nS6t7NdJ4YftoP1nD3gF3bXyHfOlB4jJcYJg8l8
         dMLfguqnICD1T052TsexinV4/rrbkSzIumVtBhJDmaDDDNmRdeZga+jIav/rzFbC6R5f
         LhVY08k0ghCippG+aSnKgo4ou8KjHdY3zkrWzHVnPUb7HtFcQXjB7YY1QvqUsu14KAcq
         HqTg==
X-Gm-Message-State: AOAM532xzIeW6kVnLiDQs6h96n8Q9aadeqmtP3wFUsOQAzJ3W1gVK0Ja
        WAR0tMPnZNPC8UzAgILQ2wYs/A==
X-Google-Smtp-Source: ABdhPJzvvYXLxiBhPcnnxuEVTVADYANteLzTF/zt4Wg5uS6kUXNLk4PW6DZgONKYqPciZ8GzRf8z5w==
X-Received: by 2002:a5e:c908:: with SMTP id z8mr1153617iol.136.1618526594129;
        Thu, 15 Apr 2021 15:43:14 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id e6sm1823123ilr.81.2021.04.15.15.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 15:43:13 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/13] 4.19.188-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210415144411.596695196@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a9ec9314-e8df-010d-27f8-e331743c7cda@linuxfoundation.org>
Date:   Thu, 15 Apr 2021 16:43:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415144411.596695196@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/21 8:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.188 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.188-rc1.gz
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
