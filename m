Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B960330DEA6
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 16:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhBCPuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 10:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbhBCPnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 10:43:01 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6176C061573
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 07:42:20 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id f8so5198151ion.4
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 07:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vAcdvhrgn3rXC6Q/OZSHHLzs1d9b4MZzZSgXPmB7sKg=;
        b=IAJXaQpFtV/UA0s5wm3pzIyUfJ4n+UICs2o5nWlWeOXFTnhelUNj7ywKThrmil7Dzt
         JgPjAK/AblTxSTe3SP4I3Hd1z/YFF6Qhtw2KYe7zo6Ro1t4MSAbqjN1T1yD7RO/MVlHx
         hD8aNfV99yxNk7NHNjpboE92Js4IrPnUPWg5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vAcdvhrgn3rXC6Q/OZSHHLzs1d9b4MZzZSgXPmB7sKg=;
        b=Kt5fnSRafUOojUXWIXnhZnU6lKUlnA3SwudCkyIxkHTaswniblzsS34j4gHJ+axegn
         75gLpCWzTEXhrUBCDKfWtHMdQcWFIc+JvYyF+IuqWAklwka3bQXgSLUaVqeYjsszpR76
         kDc2ieyQYgkZNauAzSlP341mkEXCnIN5ugPAgt5QAPldUI57fTUfWNG0U89diM9NgmD7
         oaZ+sv/mkNvt5/6SSqvo6akvRvHJdGeCSAqyHn82H2ut7IDfr2OPcCryk/oscx3ReOH1
         BpRywySKHS9n1cn5Ytwm3ox3ia55ONzjnx1e6VhsK2O9srlsaFezd9wyZtyTSC1A+BPd
         qwow==
X-Gm-Message-State: AOAM5321/9272EHqw5MnIrQWEAHDqHMSyyJj1e8LB+hFZD8YCSrCb7Dm
        F+N1HOECNXYkcGkj5RCDDUPAObXFRnld9w==
X-Google-Smtp-Source: ABdhPJzK04tNfaaoKcB2IAQ97t40HX5xwWRzB6dJMegEFuikYlPvbpeLSSR3kVuKAVgBxP8dlprb2A==
X-Received: by 2002:a6b:f401:: with SMTP id i1mr2896112iog.142.1612366940299;
        Wed, 03 Feb 2021 07:42:20 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s10sm1240778iob.47.2021.02.03.07.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 07:42:19 -0800 (PST)
Subject: Re: [PATCH 4.19 00/37] 4.19.173-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <62c3b6cf-9b6d-70fb-b8dd-21560f99c449@linuxfoundation.org>
Date:   Wed, 3 Feb 2021 08:42:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/2/21 6:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.173 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.173-rc1.gz
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

