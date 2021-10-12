Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AD3429AE0
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 03:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbhJLBTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 21:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbhJLBTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 21:19:45 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7B5C061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 18:17:44 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id x1so6457835ilv.4
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 18:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4sam4qCBqc/ZimyipzUvMpUKbb63MELP+G5CZYiprnY=;
        b=A2eQsNk2t6mt36IRU9Mryf/l6EOlFMR/F2gWKpPauhJe/MlQTSR1kAZDzZF6q/2il7
         KQZS1H1PWcoxP0vO/T88KMoOg7wuHS6MajYumXhMHHf4FPrNKX+W39ckFeePzdyXUZa8
         8RDz9bcPUKLFjbZDrY9+xqhigN6NQTJopM8n0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4sam4qCBqc/ZimyipzUvMpUKbb63MELP+G5CZYiprnY=;
        b=xjWwblK1QmZ3JL+48Rmz3vpsqhz5gXokeXSfu9sv1k3ieZmT1ON6aFOycCgme+UgDU
         C34ZidEFBooKvwuBnenKF+IsXZMz3iRomlUReoF0w7usqEvLvbMJXMNV+ibV5iVF/K6l
         IZjNJqQZQlxMWsfXx7fcwU3dYlRNG7Dj7O/GIphlFqx4v+8BZmwiVNlAY/pAUZINDUt5
         bdWhhK00kKyM1HbQobyZ2haLc3AaG8j+U1qIX4ccTvDoFK+NSXV0PJGsY+OQ2GObBtty
         Sl1hJgKbM+FoleCal/oWdFddTbx6GC3cQAMRSjkuAFt8pbK0wuRDnAlQn3oGhA8iJf+T
         gtXg==
X-Gm-Message-State: AOAM5310cpXKB/bkPIZp+NPtRx6pzjCW46lPmgDQ0f3C1OWZSi//vRdk
        JV1GdXnIlQGQE/xcZO8qigZSxA==
X-Google-Smtp-Source: ABdhPJxJqRLUE+CT5D8zU+WTUZdG8fz58JN0e3tpZtrzCK3cmh61q6Ylou89Hi5/OPYLaUR8V4MSsg==
X-Received: by 2002:a92:d090:: with SMTP id h16mr15180573ilh.56.1634001462664;
        Mon, 11 Oct 2021 18:17:42 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i18sm5081386ila.32.2021.10.11.18.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 18:17:42 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/82] 5.10.73-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211011153306.939942789@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ed2b993c-9b15-9f04-ee9b-39bcb54627d4@linuxfoundation.org>
Date:   Mon, 11 Oct 2021 19:17:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211011153306.939942789@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/21 9:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 15:32:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.73-rc2.gz
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
