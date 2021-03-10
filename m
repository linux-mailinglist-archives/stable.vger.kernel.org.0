Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A35334A5A
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 23:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhCJWBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 17:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbhCJWAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 17:00:44 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96869C061756
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:00:44 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id m7so625946iow.7
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7c7n+CulAUyPLHgHE9w2Ws2ZzK8EomTpRlYGMyiY3es=;
        b=Ocb+HXBjLtFfD61wgB8hmJks2bObzrIYHP7bydYtzTTO2Q2Cspp7hJ1nv7vNEKLfJ7
         25jI2DNkSd1b6LeqYetahccN9fvPuJ5OA6aRxgxmPC7SDKbqI43qz50xKRdcnMjoelzO
         56LD/N343RX3KUgg4XVtWYrf7o7OG6UQ1bFpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7c7n+CulAUyPLHgHE9w2Ws2ZzK8EomTpRlYGMyiY3es=;
        b=jDsOtGgdfaPC0b4Fbhy197HvU2iSxgNpa/s0ey+L+JQ5AZfeiDuc9GTSj8mnvyphpy
         zANMd6NaGXBdMLCJYotj2v93/BR5rOPE6+JeEEuTyXCRNAfGUr8sgDdAJI7c7bP9P7be
         7zzdi/m6IVZCiAPXIV6hHlmaEDE9Dal6pAslkAV7Zvy40Ocu3N3quZvFrw6H1oQSpusu
         HIyLs2diCC10Ey1CVmyuk9vqDRu0bH9Gs7hUOPxyhrKYnY9GtmElAaYyTArJunO5THm/
         Nii5zoUGWrmBURPxBI5YsBbqkz6J7iLaXodCMxvdPpZ+Eql7eGivQJhLIC+zod7X+jel
         d1WQ==
X-Gm-Message-State: AOAM532KXTKXs8F79LNxyRVXfW45Yejus2UIGSS3Zj3/oc+tDx44bpkj
        ZafuFDT9lxc4yIwJs95iAgsoXw==
X-Google-Smtp-Source: ABdhPJwivgRLg5IvNTnwJAXdxwgUN6QKPu6VTt9krfNJNmGariPEUxdkodgOZ1Qa7+gKm7z8A0T66Q==
X-Received: by 2002:a05:6638:102f:: with SMTP id n15mr635732jan.28.1615413644139;
        Wed, 10 Mar 2021 14:00:44 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x24sm402761iob.28.2021.03.10.14.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 14:00:43 -0800 (PST)
Subject: Re: [PATCH 4.9 00/11] 4.9.261-rc1 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210310132320.393957501@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <00e93ddb-1469-9ffb-43ab-a3c351412c35@linuxfoundation.org>
Date:   Wed, 10 Mar 2021 15:00:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310132320.393957501@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/21 6:24 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.9.261 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.261-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
