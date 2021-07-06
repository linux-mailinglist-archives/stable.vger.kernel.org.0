Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D7E3BDF79
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 00:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhGFWrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 18:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhGFWrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 18:47:40 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95018C06175F
        for <stable@vger.kernel.org>; Tue,  6 Jul 2021 15:45:00 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b1so619602ioz.8
        for <stable@vger.kernel.org>; Tue, 06 Jul 2021 15:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oy/NbPha7b/BONvLyNa1xrM1PBZ2k6dYZjtt+utPBZM=;
        b=JGZ9ksaddAO9fnE5nnkcHxs0/dp1klhlPuH1Z2t+KM6YWDmKADig6x30c7IQzPtH3m
         dIBO2bH+abJaIRrvH+GOZOkhZnf7i9HW4a8UWvXl6PT3VGzisPOBiVhgWhAqtmWlkknv
         b06XfGCsqM9pV8PF7CS6yVxMkyBuv2WpBI9Ag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oy/NbPha7b/BONvLyNa1xrM1PBZ2k6dYZjtt+utPBZM=;
        b=RP578kqWvfF6pgne2kmTZsPBtO+KR6vBJGOzC0rwfi2CW2RoiRFqGQROfNEojYucpZ
         8KduoYl3/+Jwn/5aAGNJIDSj3cxDNvpxEuQen7pUJjIcLdszYe0Kdo78H/ikSxUiGWzu
         a+q2pvuY3iogaXYI1DJafWZMkHlm1hUAOjhTbeh47tboxo52B9RmQniNsbXm4+PWyKVh
         P+HsWAXpJ+bhUGuiDi58PCpXsV/ZmWa89CeePIfzXNuHybzQmNDWJH+XJFN+z29Wm18A
         sTIXA7sUFYaqtrM6daeQq6WHngowE/3GA1Fi5L8KrAR/4se+rk6OtogQKJcJrAtP1IOq
         or+w==
X-Gm-Message-State: AOAM5315V/utjaOHQ1kWeQqOJJm5lzGTZLQd1DQZN9sV3ulLprIuqyCN
        LZjqcwXqW4YM7+OcvF/7uli/AA==
X-Google-Smtp-Source: ABdhPJyhe/fo3HRhK6AzpN3ofWSJhebcPRa5pE552qi6VAcK16E/JoN3r0HfvekOjsOzYVi1rYtThA==
X-Received: by 2002:a05:6638:501:: with SMTP id i1mr10242846jar.67.1625611499449;
        Tue, 06 Jul 2021 15:44:59 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q7sm7370504ilv.17.2021.07.06.15.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 15:44:59 -0700 (PDT)
Subject: Re: [PATCH 5.4 0/6] 5.4.130-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210705110029.1513384-1-sashal@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <86ad6fc1-b7c7-7fa8-0d61-cbafbbfddda9@linuxfoundation.org>
Date:   Tue, 6 Jul 2021 16:44:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210705110029.1513384-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/5/21 5:00 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.4.130 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 11:00:14 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.4.y&id2=v5.4.129
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
