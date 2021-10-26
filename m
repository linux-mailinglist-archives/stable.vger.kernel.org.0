Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A3743B81E
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 19:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhJZR1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 13:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbhJZR1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 13:27:47 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D16C061767
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:25:23 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id j10so57581ilu.2
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YAY7NqnNxo2ZTH54u5aRi5aIrhzg6YLPBc/3pUJfTzs=;
        b=FE9vGRfNOn2xFNG9hZSjkWcE8MuymZ3CFS6RLfX0ppkyg73tvTZsWeqv1QAsDSCOSX
         RgpMSj+P0QxErCQx0NVseaxCAhL/cTrHQP4njPs742NO9qjcX/zo/QphdF0t9Vy+r8l3
         +zeeTavq9ZuixzoShd+rlZ7XJpFSQhlMTZGyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YAY7NqnNxo2ZTH54u5aRi5aIrhzg6YLPBc/3pUJfTzs=;
        b=nhQkoD19S5VWxEJDlSvBPJ4tguFKTBvoHBIt4vSh1jgK/SelrCKPUkfBNIwZRB6maI
         nZ8kSopjDrE8301EL1FvqhZBz5NnMP4jy/T2sH28DKiAxxwIt4uBTwq+2o4B7LXrDpBZ
         Jrpc0eG6jKTXx4CczWFouG+hr0vl9jt2lS/g1F0w8wROvyI8wJz8umbR6rRlD6rbqHqQ
         q/Y6vA96iQGN/fJuMfaLtywW8VCY9aMG2QZDgG7CmpKVk2AsWlqhmaSgdCyU88x6/yCr
         ghSKoN9p+r+InE+CEzUz5GnmMo5BsAljgUMvrpjZtcSIvFo6DC/hkcVcHoXc/ZRtY369
         RJxw==
X-Gm-Message-State: AOAM533Hu9cjuzjI5yuMN093W7OjP0jQ8B1uN88k5ix2hGtm5I96WxbO
        K2gRONn9TC6lUFE8V/j0akxFmw==
X-Google-Smtp-Source: ABdhPJwJ/5vCsOWaxQjxb4Zdp3/9OBQqgIshFQ9L92eXiJcE5WTYeE6YeBy1RGsaZjifYttOmr5xXw==
X-Received: by 2002:a05:6e02:1c26:: with SMTP id m6mr15385937ilh.229.1635269122840;
        Tue, 26 Oct 2021 10:25:22 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m5sm10714751ild.45.2021.10.26.10.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 10:25:22 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/169] 5.14.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <46e778e2-0f9a-576f-9f4a-8964b8b9ca50@linuxfoundation.org>
Date:   Tue, 26 Oct 2021 11:25:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 1:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.15 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:08:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.15-rc1.gz
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

Upgrading to Ubuntu 21.10 caused issues with the boot related to
zstd compression which is the default initramfs.conf for 21.10

If others run into this:

Change the default to lz4. I ended up enabling
CONFIG_DECOMPRESS_ZSTD=y for 5.4 since it has support for ZSTD

On another note CONFIG_ZSTD_DECOMPRESS and CONFIG_DECOMPRESS_ZSTD
naming rather confusing.

thanks,
-- Shuah
