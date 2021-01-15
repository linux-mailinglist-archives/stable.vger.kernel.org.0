Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AE22F8752
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbhAOVPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbhAOVPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:15:15 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C88C0613C1
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:14:34 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id x13so9904358oto.8
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ocJiCaElbn7DEQVjy3Lzk2D9cIaAjRpM8puL/Mq6Xs8=;
        b=N4y5og6ka/hjssuwxO3DR91sixP9ZQDVC3nA73IWG4r4mhjX2InrOtruGmkQWT2EvQ
         FcONUP+gSmp+LCknGMaxMJq+jlArnOSSRbj7DEEMkKQl7vgg5RuqDyxnzDwJ1TKYOJe+
         aKQ0m0Zah7fwb4DNdqkb8HCqts718PPS3Y2xA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ocJiCaElbn7DEQVjy3Lzk2D9cIaAjRpM8puL/Mq6Xs8=;
        b=O13E65Ln6giipgkjPvpUdnDMzKFe5gwmJaxoA70IvuIQuv/zM9xvTcVS0RlVRA5RGU
         IcfhJZ6meTL6xrC3fm4VCDK7YkLSuK4urleFugpscNdf5HJXvNrnKQnQBrr5ukFA6QDC
         s8YQB7C+Or5abMRNKF0PEJFhaZBhOjCVF9/bPLH7+khF/3UYfjmXNzODtSOTukG37FO2
         7SmbCnEFTBqOaXh2cNV75H33cISuSMVyXAjGKr9i0u6gAkU0y9urBMl73tu8Wt2Z7xfk
         SyzaZPyRcGG3cyKknMMjZi7sqCLhQWMKI4afCWrVTf8qRq1EqbPL3KnCfef0HOSClhLe
         y7VA==
X-Gm-Message-State: AOAM5307mXKKG2ERDAcY/JUkcI8V0xvjitt1YGXb9Xp8KKCXWDJzCKit
        QEs90vlIj1CeBDpW0jqh4+q3XQ==
X-Google-Smtp-Source: ABdhPJwXhv4YCStSX+ZrZsjbW5eRgBiE6G1DD7tlHJekuyTLQ3XF4/XX1TmtdgD7Xe2EYs3xry0mZg==
X-Received: by 2002:a05:6830:2157:: with SMTP id r23mr9672184otd.300.1610745272699;
        Fri, 15 Jan 2021 13:14:32 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u20sm2097533oor.45.2021.01.15.13.14.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 13:14:31 -0800 (PST)
Subject: Re: [PATCH 4.19 00/43] 4.19.168-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4d4ae51d-3197-8869-9deb-c20f404b719f@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 14:14:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/21 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.168 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.168-rc1.gz
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

