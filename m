Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF423799CD
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 00:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhEJWQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 18:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbhEJWQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 18:16:53 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01D6C06175F
        for <stable@vger.kernel.org>; Mon, 10 May 2021 15:15:46 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z24so16318927ioi.3
        for <stable@vger.kernel.org>; Mon, 10 May 2021 15:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s0wqhhFUu9pGFeMvwjiCsLxuAw5ZuH5kb8we/nsKTNU=;
        b=HjaoCJYq3B41TABmOnk/qd8FN/z5yZyIEGJxyi8BCPBf5Kfk7LCPKQjGg/isSGUoH+
         Vd8gINmbE9gVwoU3FXAej6PCesh9XAmsXuKadG+enOh1SOcKE38//uGZIgSQHl7sF+lC
         X8kAA5NNv2LfpOqXEbEvVoZDquDQm6Ye9ixFc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s0wqhhFUu9pGFeMvwjiCsLxuAw5ZuH5kb8we/nsKTNU=;
        b=no5Tn1Efxag6YlTylmzTY5qe6ThCky/57HnKXfGlj/BPZ2Rf3brFv2DxfgzyeqhZAp
         NqfJEB+1FjHmB2EWSBWOY/wyh6znMmTYEUIZ1EJHdhHFb7AX7mDgOdSiae75/AOshssU
         zSV2o5bFIyW8se4Fq2gTwbFrVMb10cFcFLLyv20rvKpaQZfzViboLfJokcIVZxegK333
         d6WG1WvNMHsIOH74KXOWeHHTMXgdON6FC3AvH3inCaJJ7h4qb+bfrUIz6vz6spY9OZJq
         IukXYBCGlGznttGjLsgxGFejHy9BT1yrNbSo3k4fTul4bPiQY45Rl96SPDa8ceFr1CT6
         lk5w==
X-Gm-Message-State: AOAM5308CGYweT534c1w3YEqtuZEw+FdS/ndBqw9qYLBuYZGAzjdLL3J
        Hh5ZLSOYMO5Dp+XMSQ0MUcyMSg==
X-Google-Smtp-Source: ABdhPJxk6fq16BlKxFp8kMxb2KiWfwwCt0r99sNFFIlV70WGy1A1mxDonLm/bKJFPTnf/hP+BLlSBQ==
X-Received: by 2002:a02:cd8d:: with SMTP id l13mr24213648jap.7.1620684946327;
        Mon, 10 May 2021 15:15:46 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v17sm6721238ios.46.2021.05.10.15.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 15:15:45 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/184] 5.4.118-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <292f5be8-cee1-f627-cd47-304213d8b8d9@linuxfoundation.org>
Date:   Mon, 10 May 2021 16:15:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/21 4:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.118 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

