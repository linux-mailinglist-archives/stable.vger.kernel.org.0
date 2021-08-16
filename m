Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12E13EDF84
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 23:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhHPVyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 17:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbhHPVyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 17:54:01 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AA6C0613C1
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 14:53:29 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id z1so850231ioh.7
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 14:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r2gd+iS5nGo1XYgWZVQrbMQL+FGUrxwpxg1qPdtSrDo=;
        b=EMIBERULh0ujx3smlgrFiEfXf7GeIR0ha4Cld61ADrt+zgnN6kdg43sPGSNyVaUb/o
         BrU3BHp22ntiz5Q4K2B/RIws+hA71/YF7r9JDO+94FV1+jHV01aKYVkfLtG0P9wOISIt
         k3ZIq/gukVxON1tYnAQSp7Qa//dZRQZazuNdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r2gd+iS5nGo1XYgWZVQrbMQL+FGUrxwpxg1qPdtSrDo=;
        b=iz1wZ4GoE2E8uP0QPdpmgK9vVhprAMEP1vDhdiruaiPBHcDchEily03tBXhVacA0Om
         kt3USdtxZVw8N/BmGDX11g/S2RIJ4/V9L0pSDvS451qWEy4pL/WXWDUv4dFBqwsIT6cI
         3Lls4WUHce64kO0BQctAnM6p6o5UhWS3Uowacey0d4RzPyx4UTmpMKp2lf9tmH8bxkWz
         pi/F093+P3jMQ5GfYjNc3sMqE/ZQEXr2xH6ZJf810MEj5+oeku92X/Bvvc1D+aE5ZwNK
         JN+3yt94b1IfLsfU/s4SKDa+ZrEvuYfCG1K4IFlaX93z1U69C+doGQkGjRSaDpAaX3/+
         +0UA==
X-Gm-Message-State: AOAM531tvz6I9Gb9h+BW25ixaEbYErd0u2kBbpNY3O8SC0zwSKtha8qQ
        tPlPt/+KpHPVuFKWkkQcn6C2vQ==
X-Google-Smtp-Source: ABdhPJxmFczV/Rx26e5G4SwwHSjMSq+fEeIQJ0HeIkcstJws4LyA+MZK1+jjytx1n041INFuEAE6Ww==
X-Received: by 2002:a02:9f16:: with SMTP id z22mr24659jal.18.1629150809066;
        Mon, 16 Aug 2021 14:53:29 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t15sm38581ilq.88.2021.08.16.14.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 14:53:28 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/64] 5.4.142-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210816171405.410986560@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <18be7b0f-694f-e904-eec9-bee4a57af650@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 15:53:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210816171405.410986560@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/16/21 11:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.142 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 17:13:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.142-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
