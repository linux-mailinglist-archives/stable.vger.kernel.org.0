Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D62235D4E2
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 03:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244125AbhDMBhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 21:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238964AbhDMBhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 21:37:51 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484F8C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 18:37:30 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id 6so12756150ilt.9
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 18:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x4sP66olXyJtoIVJHUM1ZSa1rKe0qv26/GOEaIe1yKA=;
        b=PTXV+CvBBb5vx2nwD1HE6SOQzc9amTt1MkP3hpJYJOkpDuiqBpO8e0VtQVBVicNN4T
         aaDe3JfCBxlL1KfetAsF5fO2c6xsWdgLdWB2wzpUE6XC7zHTp6bcY93vDI2C9tnWK6q/
         PbGECzWXZp5BLgZOIcjnF9z94ivlBgeJdMwY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x4sP66olXyJtoIVJHUM1ZSa1rKe0qv26/GOEaIe1yKA=;
        b=iuXI+mm5mXJQicNCSDmXdef9UTma3maiJr5L7rNiZHpReyPTy7vBoFKvzAzz2TpiSs
         +g599Xcf0JkKlcDD+9bjzJq58oG2/9Ud1yPEsew8GlNTjAFexlCkTxRGw5LPfrgqeHyo
         W+UObFmCE5ez+pJYwUm8CV8eJkP8U7zhvR3JStI8jmu+Ny7MBfC6TygPwzfT+81qxJpe
         SuH5jwrxAfEtwvtwZFrpCb6SSk61p0QQhMruV1iLrkBF1/O/8NWE/QPydmQ9xJGJfGBd
         Cy1XOeUqRlle756vlsze3mz9gof3sAl+zCM+lNAYVywgFx77ZTWOla5cmHWjJE/RG+0n
         YXbA==
X-Gm-Message-State: AOAM531XCC/X8W4IiYLVWidzgyJr+XFJrs2sMO88CBBLiKPLUy92wLcT
        bzvx4WQJpm/3XGJmqggUFYzL1w==
X-Google-Smtp-Source: ABdhPJz9Q9mCvz6m/4W0EVzjSVm1xjIKX3L/ctdIpDmoCZx/D6YmcUJkI/Gpw1uVDf+KEatZx2KGSA==
X-Received: by 2002:a05:6e02:1c42:: with SMTP id d2mr13554746ilg.287.1618277849818;
        Mon, 12 Apr 2021 18:37:29 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i12sm6420328ilc.27.2021.04.12.18.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 18:37:29 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/66] 4.19.187-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2021d2fc-b1c7-ec53-c4d9-cf84171e60c8@linuxfoundation.org>
Date:   Mon, 12 Apr 2021 19:37:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/21 2:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.187 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.187-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions. No problems
with wifi this time. I will be on the lookout for this in the future.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

