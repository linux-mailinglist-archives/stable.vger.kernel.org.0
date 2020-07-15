Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F8B220E82
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 15:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgGONyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 09:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729757AbgGONyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 09:54:12 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E2CC08C5DB
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 06:54:12 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id c25so1500283otf.7
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 06:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zevQ7L819A5+HQKEue+bXkAwYvfiFRDlPMUrv63M1Lc=;
        b=e6yziB2Y75V/oJ47iNgF/BM8AgQRy8qxhw86+Pu3WqavW3gOUUDrUVGuc/SFldGhbf
         ObQ3lm/YBMv5/xNzF+dCZ+S0mAKiclwl0cSJi1DCn1nTdJsLkTE1jHB9sUUkgwM/QHZd
         k59c+GSpQY5H/t3OHfx5giJRfzYBUXY3mNQbw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zevQ7L819A5+HQKEue+bXkAwYvfiFRDlPMUrv63M1Lc=;
        b=gLtZp18uKSTZ2x8M0LuYQQjGGvchOsPlw0Rq/wRpxE6blsGRkutEdcCaP5DmgvDRI6
         SFhr3XvElG6OhmIlBk9rofclmpAyh/yLYof/9TfJCCIVIoTiXJ3xdl8RMlBjSSTxcz4d
         aXC4u88XGGGw6nMLNN0d1hzmnfB8S9+40R3vF+KAYEaACNTmXqt3piPk76xfeEYlLA+T
         h+BetlQgcJwQJCVc0u91MGkY/eBtuO9yPArRplQHQw3Jptm/gnOE0W89hvgojpTtXpFT
         pGUgyDTs2F+1uHyvMg3bKi+ctMl4t8yWxp0xrxAphivnBMhRqbPxR1WVZrBm66sY6Ipw
         xnww==
X-Gm-Message-State: AOAM533nBnN+3phSM8vgBaQEZJBJ1NBfI14zSZMiQAweYwoimh7Lq1rm
        GWbF1xQ6xfTySW9nqAFccwNqSg==
X-Google-Smtp-Source: ABdhPJw4YtuIvoz55X2G1KSV6+9Zs36xzyXAT2Sd1S+gfTcLnWqxD8jlFW6jsuOlkW66s/ikG0BuDQ==
X-Received: by 2002:a9d:7c8:: with SMTP id 66mr8586373oto.169.1594821250495;
        Wed, 15 Jul 2020 06:54:10 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g7sm433754oop.47.2020.07.15.06.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 06:54:09 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/166] 5.7.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e8d1da73-9c00-66c9-58d7-18175f539015@linuxfoundation.org>
Date:   Wed, 15 Jul 2020 07:54:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/14/20 12:42 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.9 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

