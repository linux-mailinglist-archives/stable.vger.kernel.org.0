Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98B249AA04
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323970AbiAYDaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415622AbiAYBt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 20:49:57 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9116FC06179A
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:49:57 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e8so15545448ilm.13
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AImPP5+EvhZ/tWPNzZFo5L2k7hf+qghxSKycuEBYZFI=;
        b=eE6JQ/1veU8Im/1/flntGNHileyHYslAz9ja5zZb9oLAzk4s9ltEN293bgH7Ftp7Gs
         ArF2MNgYJDvafitZrPpqpNsBxm6N3YiM/oH/pLmHDVIho+Rb7wsTePOrkHzKcfNuxZiE
         dMWe7BAnuwWjCKT5XpgtOXnt38WuFP/0U/1Iw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AImPP5+EvhZ/tWPNzZFo5L2k7hf+qghxSKycuEBYZFI=;
        b=xYacC8w2SZZFmkx+Sh/aS3+IRPfBETovPhgNZZGfO5QNVyGsdW/DWT89fxW7Wzrtq+
         mWgdX3tzdKYFQtnVLECAXwpEZg9r3Kwovx4sNdZ9TbVqMeojSFDqR0aU5z4OKgTlKjpK
         ZMH2m+dRUhLADRcsmY9NUP6VUXZmhE+pDYUMBTyscnbeyT8rwUigB0AqE0aWcnWSJlNo
         bPXCnC62GWWAMERdE99KSxOlXQu+B1uqKFcxjRYdgb0uBIfVVCBYz+aCexarAgsAdifi
         HdXxol+EzfJOKit/KhwgQIGyECR6IXHEaES/gUwC0Z87PmyibquPX0nG8CJyd16GAOpu
         NNHA==
X-Gm-Message-State: AOAM531DH2h4GtXgzKLvVmPj63toMnfki1f9TFQtBDjv8JMdOJ+cYwSw
        zu8/1mN9DzkgUbfWJQFqY0Ro8A==
X-Google-Smtp-Source: ABdhPJzhOGbSX+R9IvZpdC5vz+gbkPVO5UmsLYytxRQdSPLkLBM1c4A06NniFMLBvDOBLvIZOB5b0A==
X-Received: by 2002:a05:6e02:1a08:: with SMTP id s8mr10111376ild.164.1643075397040;
        Mon, 24 Jan 2022 17:49:57 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:b48b:eb27:e282:37fe? ([2601:282:8200:4c:b48b:eb27:e282:37fe])
        by smtp.gmail.com with ESMTPSA id e9sm8720703ilu.43.2022.01.24.17.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 17:49:56 -0800 (PST)
Subject: Re: [PATCH 5.4 000/320] 5.4.174-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f2345d75-8036-9034-360e-c1b6f64bc2e9@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 18:49:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 11:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.174 release.
> There are 320 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.174-rc1.gz
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
