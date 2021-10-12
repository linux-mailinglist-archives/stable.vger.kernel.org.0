Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047D8429AE2
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 03:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhJLBUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 21:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbhJLBUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 21:20:16 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043F1C061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 18:18:14 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id d125so5922613iof.5
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 18:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XwNLlCoziqCq19LxKxXu4mYNmRBF6cKqLUssHiFb0dQ=;
        b=ZC8R7IHpko2asLw/HuOIXVPb/Dut3Wq24jMlbFWZ54gGGCNd+8usxO6I9wFiawEla/
         pcVtu8ic3Y4ec+P5DIiWoWp1EdVAiUQ8snbyNmGywPh196wD+BJlmqDD18Y9q1FVAlqM
         lctbFmb46Ji6JSTK2MPa9pOfdwEA5n7X0ClW4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XwNLlCoziqCq19LxKxXu4mYNmRBF6cKqLUssHiFb0dQ=;
        b=G75DPnDOwtW1QjGjlJ0b8viS/lwPJCXqsIgJfCvc/JR2nCCFmLvPtOyXXKXyVF85+1
         E1dkjAs27HYSzQ2ZMRWHi5bnE5BxzG6T9HMZMagQ118IHy6zFHFrQ5ctr5AannvG4NOn
         wvAI0Ys/PH4FWZm6hzsaYbtxby+A4DtkRe8x+sIQAnQUw0I3AWoongB2ItwK66+w+793
         8SPG+ljTEo4Q21VvXwYSH5277bE56mI/Ye0dK/EDeIQp685PXNdrZ3D/duFnROimBXnv
         czxgZweRQTcBELTpXxPQinj3J1MdHYsWF/VsNCgnuYPSB9x3593e7KrBXnyf2lPA0qs9
         iztw==
X-Gm-Message-State: AOAM531OWqP7z6/iyr7xIqK4v+AoiKZanu3lQmm6dmbDcJI+dtNqNyfe
        dkeddn5MjxYRn6+fFPYjBmIx6g==
X-Google-Smtp-Source: ABdhPJxazTDKAqVtr9YVrzsm9pb3WTmYCgW6VaZrYCstuSgq3LawnYSgf5meydiHZ91bv0aRWvQQZw==
X-Received: by 2002:a02:2a04:: with SMTP id w4mr5376258jaw.107.1634001492278;
        Mon, 11 Oct 2021 18:18:12 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v17sm4809968ilh.67.2021.10.11.18.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 18:18:11 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/52] 5.4.153-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <756a412b-d060-5efc-0039-e5878a744c8a@linuxfoundation.org>
Date:   Mon, 11 Oct 2021 19:18:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/21 7:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.153 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.153-rc1.gz
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
