Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966C5417D53
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 23:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343997AbhIXV4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 17:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343815AbhIXV4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 17:56:50 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD24C061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 14:55:16 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e82so14369702iof.5
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 14:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fFLXbjRE3D3sdoECwCJu7JeP9fo/iG2Cnh5R4JfVJZo=;
        b=BLvGicUlV4MQAxLKbqMb2X2TAFlwBesHJCgng2KIHjDhz6XfpVMiyyI9xAPUQPiaTR
         HSaPvHFdk/nn3HpdL/hfn6k7flJ5GY2EGgNtil5p9GksH36nxX5f+x8pnRGJHBVYu+km
         et4gLvQ1QznJ+MEpZc5JwL9GaBbKmNxBta1lk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fFLXbjRE3D3sdoECwCJu7JeP9fo/iG2Cnh5R4JfVJZo=;
        b=CJ6XLoSlIOD+Lh6C8YjCehUd2GL1KnKVml8zC2GP4dQ28abxc9+L07ge98/h8DIQUq
         icB3wMBtfRpkSXKJmt504GiLwmzal8W3tUcn5eHkDdhSoL0up3vykhzMixdBURum9hzb
         T5Mx89LPStRy70qDISer9bWoMskxj6apN+LTE6Lv7/5butVeZjJ8Kv9xgrXTLfHaL9vY
         vT62XqylJmidZgguftbXfnazYNXuSW8m5Qoknzm9t8Fc7IsXBGH1sCSWTYIJg5HXMWa3
         haJgx1TpxbUNBT6J+Uj572dwi5SzZH1TpjldXoVhk5i4P7Y8pMJr+nIrNz9RJhAhh6wx
         JEcg==
X-Gm-Message-State: AOAM530OcLRqWLCRFy2aEhKyD8KK1YmaakdCnf6aMX58WGEk60OcTvxH
        cWT+CxTt/ApIkyt17JWtpIY1Wg==
X-Google-Smtp-Source: ABdhPJyYs0BNRTDd3ZZFYdm8ZCt+0yGh6eM1tr5l/UuQn5oKZasPaj8ZLrT4CxaUE6+SUASpyeoFRg==
X-Received: by 2002:a05:6602:2e0c:: with SMTP id o12mr11071201iow.59.1632520516179;
        Fri, 24 Sep 2021 14:55:16 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w4sm4452381iox.25.2021.09.24.14.55.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:55:15 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/23] 4.4.285-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210924124327.816210800@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a5ec0d2d-f558-219e-869a-54a32493a48e@linuxfoundation.org>
Date:   Fri, 24 Sep 2021 15:55:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210924124327.816210800@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 6:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.285 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.285-rc1.gz
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
