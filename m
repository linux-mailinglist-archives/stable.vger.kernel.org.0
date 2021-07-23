Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDB93D3D07
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 17:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhGWPS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 11:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbhGWPS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 11:18:27 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0CFC061757
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 08:59:00 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 48-20020a9d0bb30000b02904cd671b911bso2548075oth.1
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 08:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gsAtSKzvk9fquVfCZQyjVjjkdpxVo1nm7YgxqYqDF2A=;
        b=P8h9kGlgSkZ9ak4PdU/D9xKsC8GfFxHNQFlU0468namzJijaAjpkihMcEyVLyaaH1m
         qpUrLLmxJfO90qNUn7ih+mFsP6XpM3lH80dOQ4/bFi6wHdejNUWPHC9/84I8iikK2kLE
         blNMkRre8Wc3ebVJhiGUuXJvSJWW0rD8y+Hmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gsAtSKzvk9fquVfCZQyjVjjkdpxVo1nm7YgxqYqDF2A=;
        b=MWjzbpXRnzqUsMpRH6mY/Z7IjXNBPjXriJ14MNZypg9QbiSDjnd8ZD2ivhY1sjr1Ri
         NdHYUb+yP3l9yKpFJhtWL7arSFs/mEulad7/MMJ/fOLImT20NNuQfuzTVogA3jvQTHGp
         w4Yeq0TcjAWI01t0m4bsXJiYhCQxeV6jyUQ/IzuFWHWMxkiMUfRCrlpcLaOTJsMyUErE
         bvo//17QSY8FMC74uo9FPBc0gFIgAt0RvluJBJPV/1AbdAW968Y53E2OP/2MYiQt9Orp
         j3+U+uqvnwv7n5fFEVN1MHCJqdpvJ5eg7DVx/PJ7aWuEqGZbf8SeyRpsy+RpdnVBNXZg
         W+CA==
X-Gm-Message-State: AOAM532T7L8kNG3SjZWidge4FsQTGe0ugf+9NaPhuHrwewR4ydGVPz2x
        5zXM3euaINfmLQX3Xo2DwNagCw==
X-Google-Smtp-Source: ABdhPJyHyC5MS0gQSXv5zzoh8bN0AKbT8U73wIFg814usxijhF2W3/GewA2qiuqUYwrqmKwMqd/9xg==
X-Received: by 2002:a9d:8d3:: with SMTP id 77mr3567217otf.6.1627055939760;
        Fri, 23 Jul 2021 08:58:59 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h187sm1279505oif.48.2021.07.23.08.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 08:58:59 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/71] 5.4.135-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8900e167-69c6-ccf8-64ce-d130d3974cc5@linuxfoundation.org>
Date:   Fri, 23 Jul 2021 09:58:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/22/21 10:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.135 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.135-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
