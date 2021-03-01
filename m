Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26EE3293A7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 22:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243396AbhCAVaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 16:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244274AbhCAV17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 16:27:59 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4582BC061756;
        Mon,  1 Mar 2021 13:27:05 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id s16so10718550plr.9;
        Mon, 01 Mar 2021 13:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XIv/W+yOFfHHFgiAPvJhwe1bqm0qyJu/60+43hBGUEc=;
        b=kP7eUgBOvNAW7aB49gq2znr7bPJcSWsl2HI6gr/SlbJ89wVjleyrq6GXZZEbbMz3OZ
         FBru9LfoCgzwjipHVktlvk2wyIso0b3EbDf1KiU9H747IS6pXgEYXrWGlNqIy99btkqn
         AGGrkaPLoHiuwyV1WQTaxG4JM+4qufgbT/6Svbi8XkxPIF5vx6s5hIHs8JkSb2lxE0Rl
         9mfxRjOfNuIv77MiZQ+ldUaJBbPy+rg21OTRlyAQUzVlS1LMpeg4DA5ODXJ2c97np/po
         uNH3sS1f7AykJqVbwczZsxyVeADleuaWgeV1hKtyXPy7a1NUGe1UlHws7v6q6/P+twQ4
         BTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XIv/W+yOFfHHFgiAPvJhwe1bqm0qyJu/60+43hBGUEc=;
        b=pK2PJQp9U38VOdByTJFj5y7DuHgysp+ZjPMAjpdbejL0efU0q04R9d0pP3U9T5nTgG
         i5g+Pq8cF0bETa7xLY/CFbN8q4FHB4Cl+HBusptE+PLDuD3yxlDRwwKp0rrX6Yy68tdb
         CYlhmOH7Xr/BfSzUkPttM0m1ZOuI5onA/ap851Mwyc6n7cBhuFSL0lK6rPNreqlS5rc1
         t8a0tlc++FCAfDqTE6cOlQRMMcXC4XWGIdZupIN09uQttYu533pxdhUp/AqV9wybV1t3
         JEY8SC3m+oSv9zDwcg78C+UT3NlqLGsZanZJuPS5XknHrdjZexLYJv5DH3XvKF5rvDQ5
         Rcqw==
X-Gm-Message-State: AOAM5331DRjF6qQEbIpxRJ00MXGkWj+XawA3JoP8Z8RmWewX2Tp3yjAC
        V6Ui77kYVZJrwTJA5bzKNAcuirHo+4s=
X-Google-Smtp-Source: ABdhPJyfJCwviyl7oNmyo7dkgTtSfXP9TvPK4kFpFL0Bdhcip0o/s6IRpf80NdlUP1XWsYWoM8cBbQ==
X-Received: by 2002:a17:90a:4092:: with SMTP id l18mr863691pjg.1.1614634024358;
        Mon, 01 Mar 2021 13:27:04 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bb24sm360338pjb.5.2021.03.01.13.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 13:27:03 -0800 (PST)
Subject: Re: [PATCH 4.9 000/134] 4.9.259-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210301161013.585393984@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <623715c9-af27-f914-21fe-fbd882559d1e@gmail.com>
Date:   Mon, 1 Mar 2021 13:27:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 8:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.259 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.259-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
-- 
Florian
