Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A2B462963
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 02:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhK3BGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 20:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhK3BGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 20:06:05 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED40C061714
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:02:47 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id h16so18588173ila.4
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Oo17EMEw5BxX/HQWNTEsFJK+tTurDt+yf//oQgLqyE=;
        b=fSm/eLS2UtvqnK6oys0PczstYWPgM2KDBlvaquzV4KUT4P/cFZhKKw6tZyClx+Myi3
         1AOJTXOdc3i/tgK9uSR4Xg4iH77/TSu44qgXqdGnNNP23J/S/U854qF4xkQB4amhOJjY
         vuxmR1JhDm5HG5dd11S4kfkPYXpHhcQq2zaO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Oo17EMEw5BxX/HQWNTEsFJK+tTurDt+yf//oQgLqyE=;
        b=Fc8c9f6/U0Q9gav5euXf9/0U5yVDXij+IiQQvBPA9tZae17XKX14V858rW3F99qdH5
         +opvP4rLD2waGupkQ0xzPlvL0BI2CzNEsdYG+9rvmXzYv8sqHSbx80QCjf1yGqHq0FiN
         p9OHW+k7KLFYxk0wevpfJUEg2VF9NPnBUlpqb7VT/787wfcprvTJRjV/1oxY4IPIJ+Lg
         eTyIPX0pjqVzaKzmSpcKwak8iI3j9HwCV46ZuGSXvUJ/8cXBXa+ncO7Mg3PBjKdkO6Pg
         NFmrWugUK0aA25wjNK698WaUn93+KU4U7xclt1E7f93P/tu+w4gQIw6zeRvUDcynmUdf
         Kmsg==
X-Gm-Message-State: AOAM530eEgnVkXyeCfzlGwJ45rzrni1hAlzZVmQ4u2JWwPFrMQ0DSkRS
        2/JSPQXMBVxbf23Cmhh+Hx/YqA==
X-Google-Smtp-Source: ABdhPJxbTXKft41ADCO9xMurZEdxPLAjhsVFsH05pIjvPM5Wz/XO+vyZnNYL8k9OlunbIcZNT+olwQ==
X-Received: by 2002:a05:6e02:1c88:: with SMTP id w8mr32433151ill.318.1638234166919;
        Mon, 29 Nov 2021 17:02:46 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f10sm2086728ils.13.2021.11.29.17.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 17:02:46 -0800 (PST)
Subject: Re: [PATCH 5.15 000/179] 5.15.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4a1555f8-4955-f09c-5b71-2c7176b2bd8e@linuxfoundation.org>
Date:   Mon, 29 Nov 2021 18:02:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/21 11:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.6 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

