Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70037386B1F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 22:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237507AbhEQUSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 16:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238772AbhEQUSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 16:18:44 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5FCC061760
        for <stable@vger.kernel.org>; Mon, 17 May 2021 13:17:26 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id n10so7117297ion.8
        for <stable@vger.kernel.org>; Mon, 17 May 2021 13:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8HyGemKs4eEqxDzXuXCclgZuAut0JyAGM7DAttE2sLk=;
        b=cXZKOGGaJBwezYNaT8zvk2xsF4l76PcEIamrpbiiTEQF3hb3JRd4hRsep61uCSrr6V
         bK8JUfXAyllB2Tth1ueYEs1Jsvj4VRBWdiu4DDK8dFoq7hgxqSkNwaV4JO4WwO0tSzYL
         KRY1qxTRjqBxY1RM9GDJar3IKuhxpc7hrhkFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8HyGemKs4eEqxDzXuXCclgZuAut0JyAGM7DAttE2sLk=;
        b=TvIRP80uczpGVqXkjDiM2p9tKmLyvpPVlLSsEJA1rloLibYD409LIsvLKTtNeeSqdX
         ctcCsqQvmAnhJiJoejCqtbe3F4FikWjrNaKOFolvocVdPGUBx8eBCKp6WvDPoF3t5Yp2
         MN83QvTkpu42woyKBtNF3ecx9Yj0d1EubfytLA98oXAIwtaCjU3a9dmDSAFqYuczGkxu
         B3WQ2W86eGXLCw7SVZj2anYLxTnRKxM8hyP0/Eptn/Pu+agYbI59oP1J973iwa312SfM
         QfgcNM7XplIV5KOWuOkVKsesQwUU9ECzSqH8GJjlRGLNW1JeCt2zgxjZRyUWBtSALYUk
         48QQ==
X-Gm-Message-State: AOAM531sKO9LU+Oo9CM0nWQPnOM4SXWOyek09i3MGO838/mth3Z4OWYI
        6UUpDuzp0NGUjujVQNo2Budheg==
X-Google-Smtp-Source: ABdhPJywmuYJRSKJPwoHjIN7feuUpshrrR3XsS78qnUwEX7d3uv/hjvpZxYA3vt+g+5lEFcf6ysFHw==
X-Received: by 2002:a05:6638:344e:: with SMTP id q14mr1752477jav.47.1621282645778;
        Mon, 17 May 2021 13:17:25 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o18sm1839469ilq.9.2021.05.17.13.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 13:17:25 -0700 (PDT)
Subject: Re: [PATCH 5.11 000/329] 5.11.22-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8a0aa39c-ba14-81e4-cd0f-bfa7b801c59c@linuxfoundation.org>
Date:   Mon, 17 May 2021 14:17:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/17/21 7:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.22 release.
> There are 329 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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
