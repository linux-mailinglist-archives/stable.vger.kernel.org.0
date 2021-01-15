Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBB42F8754
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbhAOVPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbhAOVPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:15:42 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA21C061793
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:15:01 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id q25so10978244oij.10
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ql6nzmebA2RYxS7qPOf9DoFPEP1WEJ6769p7CfEvFaw=;
        b=YslmPM0PCOo/aSZ6L4SSGcKAqf+raHlBUZAHttoBIvvzVu7ZhTUVTgqyaJnFKqqjn+
         MU/RiVV3752EDmOa3iypfUVrDgsg4gK6XKDGYeNbauwViarFQHWkg+5JqdTCcg6R2uqs
         im5f08Uhgc0lv7AIC/IwByurEa5VWmcfIHmRs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ql6nzmebA2RYxS7qPOf9DoFPEP1WEJ6769p7CfEvFaw=;
        b=suLUKaoFSmsUCE3EY+/UQN8rbBmXyiw4K21Hw1IOuxm3T0Q5tmWfb/lSRqaqPOs1yk
         xLEhUqH3mUJkzAU7OaZLpPgEnr5nmN6CYPCkL5jLEttKuqrwrhn+OfMIatlAZa9FCCK3
         /kCIotc8DLjyy4C/JADE2Ift4gdHGHeMZb0ylFirYvIB1F5uJnpQp6rdPhSq+plK+aHI
         lgEGcgSRwazkPE5TjSDtgDQeajcUkX4lbMoYeXvrluTlWMXbIJKQpJMCf8iK4GE0sTkq
         F4ICsU/WHuiYsJpo4OcgymwheVEK57J8jBsnF6OKxUqTcZlmwSSil1JEdiTddqmDEZhM
         MTxw==
X-Gm-Message-State: AOAM530h1vbLsU2ooAd6JAxYYXY1oBimJRewXgXEZCUmnboiTbJon1wK
        uLDoXjK9l3uWYCg2J22zv4/pvQ==
X-Google-Smtp-Source: ABdhPJyWFwfwfzmhSQkDn87Zpd0YNhzyWOsWcLL+keLICGva2ISjYKohLUS0hg55+Luub5+aowDTVA==
X-Received: by 2002:aca:1c0b:: with SMTP id c11mr6868771oic.16.1610745301332;
        Fri, 15 Jan 2021 13:15:01 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q127sm1949686oia.18.2021.01.15.13.15.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 13:15:00 -0800 (PST)
Subject: Re: [PATCH 4.9 00/25] 4.9.252-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210115121956.679956165@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <cd1905e6-1d95-cd93-af58-9ddcc2a7ff96@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 14:14:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/21 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.252 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.252-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

