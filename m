Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31F0329424
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 22:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbhCAVtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 16:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243340AbhCAVpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 16:45:45 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A157FC061788
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 13:45:01 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id 81so15818772iou.11
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 13:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AG6QCjLD//onoydRceqagIS+mLyAwFtF+tcHI/BlJ+I=;
        b=JbYRN+7Su6fVGhpQZlKkxCxMIJIo13baAMKPCet0QSu2IH6zKX4bNCFz8Bv1rRQvCd
         WNyrJFWkeAja9m0Vn4mno7FBo4AsQhsrcpVgeXApNR3RgM2/YmOgzfZQQY6lnEBfePJQ
         fXBHJb1W1phKi9aCvxDQxrC6VEsiOBt6vFPfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AG6QCjLD//onoydRceqagIS+mLyAwFtF+tcHI/BlJ+I=;
        b=jfM54ZeSOEmh0rA8T7T8xxg7e8C9caakN56JJ5CxC77+Pbk41dodHsQpjC0JpfuRcs
         V3o3vk9IDcCnHtopI8yDnqzRBeAQgaghVLBjbI1d//6GLWEFMZ/R4FcJs80Gk8plc6kM
         ZMhJ4nut0WO8oqswBy2DaEwVy5xZOjxNvJUeHZ5kXV2/e5jstLFCnCxgFMob1htfHKU6
         qsUbkY9t2jmNIErZy3MuCkkatdmmChFG7vIx0AAcFsTkpXwJRjPcp2qp8Qts0jgttuzY
         eH7mm+ikbbiyk5sg1GT7OUVFFSozr3DKHGI9ZYEmiMAY5EaUTsFiizbtyC4Bh3+gUo96
         4BVw==
X-Gm-Message-State: AOAM531/HUUAyZ7+oQBCq9kAbKadMviVD+bifpkizePALtghk3T94N7i
        7jHVERqzkei+s5b/2S6UFrm1jA==
X-Google-Smtp-Source: ABdhPJwCdnoGlvnlYakB2nGxUKmS8LFKdr2H0do0LAAteJ5O/A0GSk2qP1fHlpK5kZKgoPKZJI0D9w==
X-Received: by 2002:a02:cc1a:: with SMTP id n26mr18245380jap.21.1614635101126;
        Mon, 01 Mar 2021 13:45:01 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l14sm9313390ilh.58.2021.03.01.13.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 13:45:00 -0800 (PST)
Subject: Re: [PATCH 4.19 000/247] 4.19.178-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <74ed95f3-fc6f-e535-1ff3-48d395ad7186@linuxfoundation.org>
Date:   Mon, 1 Mar 2021 14:45:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 9:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.178 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.178-rc1.gz
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
