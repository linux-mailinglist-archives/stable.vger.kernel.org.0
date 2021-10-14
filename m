Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296BB42E44A
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 00:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhJNWkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 18:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhJNWkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 18:40:32 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCD0C061753
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 15:38:27 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id w11so5148578ilv.6
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 15:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m7H19zP+cEHxkuoLJR67ShZQWgJUHHJdRrdcqwcoos8=;
        b=PwQOHLfRKmcgBS5VnSzlfvPCtOWrWvtFsOP5yhgySVGSn/2t1Tt64jCRUZAJhemv5j
         ZOGEm/pE7nrQPut0l1W4RI4AjKbZFTG4ml3oKkTg6unpbQGKrbUax5PGVNxGOjaEZN+l
         LZ2Du03AjdBu5bem7vtCPRTVCIfZnOnlttuPI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m7H19zP+cEHxkuoLJR67ShZQWgJUHHJdRrdcqwcoos8=;
        b=IZdj4ffqjE4x0oL5gD6cEEbM/fjvE3kAoXS67OjXL9rFl+jfu0y+q184tQ9LIUCLHn
         y20wNBLZLJ9eYyAMfwnVY0oM5lj716N0ogS/ZUCcetQBzlXkECrWz1LORQ1xmWuV4iWI
         PxFDCTlxt7J5gKQ1yzDaV6Gxx0Ney/EatEPj0v9FxKsa8fl6vXKYUx1sHpcR79wWtZXr
         T45cW0AMdVFX5J2FCkOcTHhPKOw2Geq1/9KWTpsds3hS6Aq0SH05d86x0kN504IgAOW3
         MlHOil49qZQfxtuyIuoWqDS4olAA3fFu785rQ+Zc4nBOl/td/Zeso4Z4zfk/vnjr2xP6
         ubfA==
X-Gm-Message-State: AOAM532I6EOI3R9ui5zH3XBRCw2AJFY7WR2d4fqZoUOl/8O9+OTonSkG
        qCE5mVPKV4RD8t87JxOQA8jTQQ==
X-Google-Smtp-Source: ABdhPJyLWHGMJFSqjV5eZmKgx98PkcDLmrS3NMUCz8w7eEoxAPe1UhaXMgUm8zYhz8T8XzuDJAavig==
X-Received: by 2002:a05:6e02:144d:: with SMTP id p13mr1203128ilo.15.1634251106698;
        Thu, 14 Oct 2021 15:38:26 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r18sm1863515ilo.35.2021.10.14.15.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 15:38:26 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/30] 5.14.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e27707f3-4fba-7bbc-cfe8-e383b83e2789@linuxfoundation.org>
Date:   Thu, 14 Oct 2021 16:38:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/14/21 8:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.13 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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

