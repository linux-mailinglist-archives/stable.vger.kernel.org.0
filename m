Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B15A31A560
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 20:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhBLT3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 14:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbhBLT3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 14:29:02 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B296CC061756
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 11:28:22 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id u8so276768ior.13
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 11:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JPMtzLnlt4VsMWUnR2fTirOhyXKhGfmXdJkhsBcAKOQ=;
        b=EwWZA0XKqw7csZDrwBHuPEWnLeZQ+hSSFszis8NThmD4ltreQi2+ivAO/wH6tZHOjm
         usSovTFTSlxL2y8TB+QYUd392rzy1DIFVIlXbklf/BOqrA8h2I9VYPveCKxL3mH69Bf2
         SRPq4FRezzABvtrawtXOke1Mo0rUCyf4GiJMM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JPMtzLnlt4VsMWUnR2fTirOhyXKhGfmXdJkhsBcAKOQ=;
        b=pKX+6RId3pylsXyHnsWsLvB61H9WkxWs0Ab4RZGeLt6KatA3Jo8IY2ukIu1LORSiTS
         K6M44A8bv6poC7Npenb+RXfLRqGMBsJUFUyIWZJ7/bEL7QieK5wHpB4TK899o9BSNLb8
         K3H5z/5WkDE1uf1KO0gr0esZp0AvIc5ZtwRyHG3oYv58FAHkJwrQDBaK3wEhihzW3N7e
         ZI7EKId9NrTcGb97l9S1lTSA5LJ+0Prlml8fy8/2y37LBr3mM5zefh/i3a3XDQtfm4DL
         MNRuEzDaLHSbdGqdKM3+2BVRhGrB6NoNqdZpF8js+YzYa6cCTtG6OhhlNY7jrxFuSWjz
         1hlg==
X-Gm-Message-State: AOAM532r+8jjC9vXwoCZZQK5NXi30Af86xwqB1wbran0yIgUWDnZeFmG
        nCwF5PdNnGAcOAs9XStj9YLT5A==
X-Google-Smtp-Source: ABdhPJw35/TKYlCUoEmdwHVAMMSCsLA9Pz21NfjqOum67K9ijGXbIOEo5b1kt03S+tAd4+jeWY9/0g==
X-Received: by 2002:a05:6602:3283:: with SMTP id d3mr3304506ioz.53.1613158102081;
        Fri, 12 Feb 2021 11:28:22 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w8sm4808988ilu.1.2021.02.12.11.28.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 11:28:21 -0800 (PST)
Subject: Re: [PATCH 4.19 00/27] 4.19.176-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210212074240.963766197@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <32820f45-329d-35f4-7e37-62a433947722@linuxfoundation.org>
Date:   Fri, 12 Feb 2021 12:28:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210212074240.963766197@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/12/21 12:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.176 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 14 Feb 2021 07:42:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.176-rc2.gz
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

