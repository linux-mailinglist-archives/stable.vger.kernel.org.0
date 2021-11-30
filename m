Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2610462B47
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 04:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhK3DsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 22:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhK3DsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 22:48:22 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841A7C061574;
        Mon, 29 Nov 2021 19:45:03 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id q16so18229791pgq.10;
        Mon, 29 Nov 2021 19:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iP241l8D4Ml97DGKrkVaKmSejRxAC84DOO3x+7kU65A=;
        b=okOom/tBi8mWTb4ulsp8uU8arus6sb9K4qDEEQVoKU353JOmXEiook3uiR06ajw46S
         uIavRqOyKW8g8cG13A7kzk3GbCuPjwqkQEacWxOcn6iHueOmJIDoYOAdAa/JLr0VN4fr
         YlsLe9p75+IHAKVp8fDNv03/sNvma9hoNYurK1mo91MK22n7Sf72EOxwg98vpAggANCb
         S7Te4grkq0F9NxMJW8Z/tqPlCbPsqbWO2C7BRIHQBtqajvd2umtfaqmxPh3oKC8/jZSU
         /c7Y36r1nFyEdgzzAtH7yEA66EUBYWHZV/vch1EQz2xQ/uyoatpuWOZeEJmA0qmVm2q1
         6LHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iP241l8D4Ml97DGKrkVaKmSejRxAC84DOO3x+7kU65A=;
        b=DEhzsHKIM+9zwr96OM5aNYvH5GSjra6lO4Wqo51Z5n+gOjRyioknl/PqCny/GrVuVi
         jbpVdIp5RJVDfqtHnaf0YugZXJI2MrJbOR9Ptk72O3HZA8CeYTVgGEE9xiwcsjIKEEav
         CWsT+cCxJKJHk0fD6LDTi9syya+vfj/t3uB5yDJ3LjNaNwzbrzl0XmHsbdnGCo9G7KsD
         GvNfKHOCv793BKEmDzAQor8akHjGfvq2vTwyjAIHE4YBNTa/JRpV7nQC5MATk/BCRaXF
         +olZDpD/0eUjLJlnTGZug3eWkm3rtZ4YIzJtI8YaCcf5ju59K2TJCxisMaqfDopvQ774
         zSQw==
X-Gm-Message-State: AOAM533+jtxoZIx/7OqAwT5QjvpOHB4eX2IXKY7ucpyxKnMQ7GiJosnF
        SAzg2YC4YgnOIJ6JQG2R5q8=
X-Google-Smtp-Source: ABdhPJy0d7xlP6swKwTxNcRpPpQdnmYWgSE7+YlKbHpGWa/+h30+6h3pCoy5mE203LSx40CTznIQwA==
X-Received: by 2002:a05:6a00:2290:b0:49f:c63a:2a5f with SMTP id f16-20020a056a00229000b0049fc63a2a5fmr43610725pfe.69.1638243901768;
        Mon, 29 Nov 2021 19:45:01 -0800 (PST)
Received: from [10.230.1.174] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id f15sm20933568pfe.171.2021.11.29.19.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 19:45:01 -0800 (PST)
Message-ID: <31e0f808-d26c-f3cb-7853-de10e95744ed@gmail.com>
Date:   Mon, 29 Nov 2021 19:44:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 5.4 00/92] 5.4.163-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211129181707.392764191@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/29/2021 10:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.163 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
