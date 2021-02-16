Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB9F31D2AC
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 23:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhBPWaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 17:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhBPWaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 17:30:01 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48443C061756
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 14:29:21 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id n14so11869008iog.3
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 14:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rWQ17XGKqjCJKCzygKtmoh/8Mi9KJ/scfqUBAGTsLG0=;
        b=iYg1lMZqPKb82yWEEHC/STuXHS/dXN0/6aP7i2H1zFWYQe4ojt432qLr37m7+BvxzS
         X1kDUuBjL/9F25lashSPVzE12LHd5QrmOEHOo1u9t0OHdQ+nuN/ac40+h8mYldVtf7pz
         7Br6O8qZ5rXscz4woW2JWju8saOGabG0gUIb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rWQ17XGKqjCJKCzygKtmoh/8Mi9KJ/scfqUBAGTsLG0=;
        b=ogQhNTYDOeWTd/hGYZeGOifOLtAILHCbssdDAFxF+hJXiiNghY21ZZPb8XC5aDwbNK
         XtoZr/DkokpBZdB2IxPq+0q/aA4HgtC/v3IdpTNp+SZIShR90luSxzm1RUVBB5t+4Bjt
         o1m4ZkfF76juWuFFtf3VC5ZpDqMnrI0beLIkdQZmGwqgJLNndcfbAQ1ppsnERqMbkxpy
         VbxUzpZM/zZPnHFn4gor91SQhZ0zHz9r/YD7Ybdlq5M6iU1Tttd+DYOcencpWfR1MmyS
         5eJcG4+6VQS34QOHMCVdtol7+Sk7f03FKx7W5IVmavUKDb14gU5u4qOjQsiuKYGfNwVv
         LTtQ==
X-Gm-Message-State: AOAM530iPU0+Gsqf9tEz8J85YtqipHCKw+LsOOoeJSIvRbuS67b3hFL3
        pBM/PlRbomhLT06cQ32DfeERYg==
X-Google-Smtp-Source: ABdhPJwZy6qpeVAiX1mvHCbNW/iI737imzbdn7AFnk45TAcb7EYMQbmll9V3iw0R0fJPUBc7GdUbPg==
X-Received: by 2002:a02:c60c:: with SMTP id i12mr6431926jan.28.1613514560750;
        Tue, 16 Feb 2021 14:29:20 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h23sm17814ila.15.2021.02.16.14.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 14:29:20 -0800 (PST)
Subject: Re: [PATCH 5.4 00/60] 5.4.99-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a76524fe-ce65-ccd7-3f68-260121527c34@linuxfoundation.org>
Date:   Tue, 16 Feb 2021 15:29:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/15/21 8:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.99 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Feb 2021 15:27:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.99-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
