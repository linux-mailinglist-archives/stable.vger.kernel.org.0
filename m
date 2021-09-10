Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C157A4073C0
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 01:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbhIJXSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 19:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbhIJXSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 19:18:04 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A9FC061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 16:16:49 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id q14so3701733ils.5
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 16:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=teoGGDJrwMDSnzkbropRrs5KZGfhxx7HoDMmN5AKHk4=;
        b=gmdpn48pKAGhKTUuSPSxmMilIrXDAoVX8BNaQlQCMSCdPOaXGbAwg1hJsPSOfzo5uo
         JKHNxiFBHxgD0gTN5lLLR+w4tiR4wPVNizMqPm18PN4zmqBTAE88Z7YbhNc6Q/KZffNj
         yGJ8f6esOfxYCV8A2y1t5Y6b7GcMSvYIIfsqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=teoGGDJrwMDSnzkbropRrs5KZGfhxx7HoDMmN5AKHk4=;
        b=vBJOl5jL+SAFp42dsDRh0TFAY6dKM/6AfA/k/rdV1T6l8sBpMz/GFJx2J1fzt69n8Q
         Sy57Kxsixq8tPvjpEWE16BLJkqDDFUll5Wf/QXXF2fQROVNO0fgRDuAJDD60yXLATF8J
         7KbP/uL2LvIBO7Xu6wIH1eStn4Dxp5HXIGQuLnYhpA+LljI3b3uXqC/72svWzvVmqSdA
         fp7OYezyYVP8C7zn3MgQYGRxRUCwyrcJhUrmMMOKJ3A8X2BSMQ5NNQpsjMv4JSLneyRS
         kOZ8hGz1E6rfH3uFHyvmc8A7zF9NazJ+KPMdQc08JS8A9rMSw7xVyqHB1Mx0zeWFzgq+
         pkEw==
X-Gm-Message-State: AOAM532zgHp+ApbYQZJYwdvfLpohGC0PXwJNprU9KMHOiGDU8IXl3AC2
        zfFNEyJFUpKNDenC2guGfuvHTQ==
X-Google-Smtp-Source: ABdhPJx4A035kdxg7SY+cHdwiUAekQkFI8rnRSnKPDW1gktHHkg9gVkUiHITAJRNZfL+Bz/huyKzFg==
X-Received: by 2002:a92:6a02:: with SMTP id f2mr78938ilc.19.1631315809251;
        Fri, 10 Sep 2021 16:16:49 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 3sm14198iln.79.2021.09.10.16.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 16:16:48 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/23] 5.14.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c51e5e48-2af2-f167-9850-2bed102b1585@linuxfoundation.org>
Date:   Fri, 10 Sep 2021 17:16:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/10/21 6:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.3 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.3-rc1.gz
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

