Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AF44073C7
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 01:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhIJXT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 19:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbhIJXTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 19:19:25 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28806C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 16:18:14 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id b8so1960002ilh.12
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 16:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aRF9+qqshJRxoOURWf31CuywRUzKYx5uCq4SEWQFgIo=;
        b=IjqDVZqKhz+Ga16X+exSzq/XrMT1TR8joSyyQOpH8vTefVG8Ftk8HwwXuGjFplTinJ
         0i63fXXTxEqSrhMsUcj4OvZ/iVr79gwXBgkwJ0C9xLIA5yPTLBb7Ds8P0LUBhpW9rzpm
         nA/DLKtIieMlPJzkxhBqaXrPBMI7fQvw5aNnE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aRF9+qqshJRxoOURWf31CuywRUzKYx5uCq4SEWQFgIo=;
        b=5W7b4kh4+p62Li3JdzuoR80CLfypgByos6LEDL2BACEvQGOerl7x/eDn+hXibPofqM
         ZymtAX1R7myUtb9NMp4Wv+SGg/GwuViFWkCzWNBN9XQXIXO+jaHAYdAEqHVobgHumJyO
         hSaTp6x8BzqJ2Pn8lotbcX0f1rY63yeNk6EyO3sYIaTuZLKDpREcpIKxK7uIdsNFfFxK
         C+A3oQjTzn22heqqeiMFi6oahMQvczcPI2eXHMZbBdhToH4jV9a5XhJjW/bjch90tm9T
         4ABskQr5FCaNnrEsxW+u/RD0i/wOlnPhf+ZQxfKVLVJp+/teBgphHizpDOhFFiv4cfC7
         v41g==
X-Gm-Message-State: AOAM531wksJDnWBHDXxW0Wr6IsZVwDDlxN9GE4v1xTbJ3TafAhBaQFbb
        CqPMtUvBcbIS2FXdgj6EJkfNZg==
X-Google-Smtp-Source: ABdhPJybZtjx+H/33334R3fvWSjVwDB36A9pLlTDIwW7eWbzbPki2d7l+2CBqIkbXJFM2tgtbFZhDA==
X-Received: by 2002:a05:6e02:1546:: with SMTP id j6mr89056ilu.154.1631315893570;
        Fri, 10 Sep 2021 16:18:13 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y11sm32031ilh.5.2021.09.10.16.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 16:18:13 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/37] 5.4.145-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5b29ca0d-7f5a-e0bb-2dfd-fa5b09316a65@linuxfoundation.org>
Date:   Fri, 10 Sep 2021 17:18:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/10/21 6:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.145 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.145-rc1.gz
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
