Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B732333D
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 22:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhBWV1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 16:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhBWV1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 16:27:17 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4931FC061786
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:26:37 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id z18so15492780ile.9
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6wYF0cAAipyZEHwxIeMa1va8HYwX5oJvBF/44Lk5PqY=;
        b=F4E+yagVdbi5bCp5T6abCaycG9c4L9Dmy5zsLDGwa20NcTefWbhTRGJCbvO5aTgK3g
         ngzE645eLVoP11DdSIBMxFqWwtkB+zRg2PIqldXco5eNKsaLafYjyal2sxdLAN1nDtjj
         9fK6Rz4odJdtwKxCel4AaoP62setC+vF3nzVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6wYF0cAAipyZEHwxIeMa1va8HYwX5oJvBF/44Lk5PqY=;
        b=rUs3xfFFtRb4HTWSBde/wgo5NVXshp76jIGfwZPmiy53izBJeEBZWAJIJ3PQeAz8nk
         M8NQpAulUUdwNFxQvQmMwVIlDl9nrS3OaxWynupQGFjP+Ux0B/ieSO5IEV50sxkFLgr9
         fcfY3OkOy4tepb151bw0wEdHNWJbT38uNgUEXzhtw6/pw21s18cpItQMPFudmiPqsjNY
         rH08KaDgJ1vzqjodb4ay6p45aUbrlmk1PrIgiqjJ2/VyVJMaT12oj8jthMwfd5QIj3Wr
         fyBZK6vn4ZJLkCSj1HSweJGYW+j9m2Gn8i57drFOyCBY7cFZ1LkLLnPBCWPsiuKPwRWC
         jsbQ==
X-Gm-Message-State: AOAM5312d8JE3AKyiak8sethSvAQCo6dwKqeJiXT1WHExjon1ynmW1gD
        r3pc4Mf/dlRW6QhzdtnjMspzOw==
X-Google-Smtp-Source: ABdhPJyrzFejlm0o/ywmHHE99aaROGMJjAcEyAcmvvnpuEIZ0MEChvxcwjqeFeHzT/9DwuJ7m9L6fQ==
X-Received: by 2002:a92:c78e:: with SMTP id c14mr10323676ilk.212.1614115596729;
        Tue, 23 Feb 2021 13:26:36 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l21sm51166ios.9.2021.02.23.13.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 13:26:36 -0800 (PST)
Subject: Re: [PATCH 4.4 00/35] 4.4.258-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e4050d3e-491a-e9da-eb10-58a76940a1e2@linuxfoundation.org>
Date:   Tue, 23 Feb 2021 14:26:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/21 5:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.258 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.258-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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

