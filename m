Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDF53054CF
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 08:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhA0Hi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 02:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317412AbhA0AAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 19:00:08 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08996C061A30
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 15:34:22 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id f18so41966ilj.8
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 15:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/zib3hAneJNs9BQgwmcNOajlGeO7H9kxS77lhi3666Q=;
        b=QSxx24xF7iJVPqjblzQzmKN5CEViZlJ5oCN6qklloVlq5mjZIYNvW1Vd7jZrxP9ZOi
         LIpvT/mWtZ5q5/TdyeUFfMpxqvsZW+tE+V6E2c4C92fO5GDvNfb92mexUlXXYapYSlSB
         iuSgUHWbBi/STQBlWIOXwZ9SRUa15FpjXYe08=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/zib3hAneJNs9BQgwmcNOajlGeO7H9kxS77lhi3666Q=;
        b=bPdT/xn0C5B6ZDHPh5tKAsPI7a7MOeuqZOSqfQp5SzEE++e4iFZ08x+h+PGU5gw5Vk
         j34scPdaMtvE4TTwHRKeKlLoB2saaaFuOXhkQozTuwN6+mzxxd4Isorg47pkifSZlrDd
         2RCCUqPP7W0bqLjGQ2mpN7TnbbfUIHtXRoeADt41jqJMGCrtd5g9URqY0M/Pw4vyJfxC
         mOI/S7w07uLIo/UqdTPFQBlDeeqNPXLOC4rPi4fCFhyPnhqzE+0t4i/+UTAEsHal2WRr
         2VUlM/eUqCzL3g45D7Gv4YonBSgO7hMMoV8e5h5gLp5kVWil5NF7W4bQzeNiegYx8zWC
         GhFw==
X-Gm-Message-State: AOAM533JDjWHzAxkFLKPmCEd5lZQ0S/HY5o6YV9Zn+edqSL9HsZzixcH
        XPP+ltL0wCwsURek5jtUs1tOng==
X-Google-Smtp-Source: ABdhPJwWG4SBiQ1h64sg/mo89B/hCHgUFmD4Q3SjgKqQeMlLq1V4mW5zc+nw6i7qVZvkHECMgXfYhA==
X-Received: by 2002:a05:6e02:e94:: with SMTP id t20mr6688099ilj.10.1611704062266;
        Tue, 26 Jan 2021 15:34:22 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b2sm208219iot.4.2021.01.26.15.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 15:34:21 -0800 (PST)
Subject: Re: [PATCH 5.10 000/199] 5.10.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c5de2e29-dba1-a49e-33ef-08d71d572479@linuxfoundation.org>
Date:   Tue, 26 Jan 2021 16:34:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/21 11:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.11 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

