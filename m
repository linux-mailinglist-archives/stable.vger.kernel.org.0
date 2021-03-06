Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE2132F885
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 06:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCFFck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 00:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhCFFb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 00:31:59 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4079C06175F;
        Fri,  5 Mar 2021 21:31:59 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o10so2776527pgg.4;
        Fri, 05 Mar 2021 21:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ba6Kh5nlkiTFtk0PXNQUw8yZAHH+934YM3ghxMY4d5s=;
        b=DwovAFeNcBz6wMpiYdDM2ejicIFMzmYmvj3Eqdp0fvkzII4dNZR1nI2OSEtyP+iPTX
         X137WqWWNx/uLkzwvv2qMxlSGs2QJ+nMtdzJwZEgbu6cZ21rlM2uyY0Nfk+unwE05suM
         ZClNt7uo6ZGqi9QzZoStfPe0PIEaW3WQjs3TD9AoxtxdtN8mK28s5wy9HIszFRzHdisY
         HcmTIoQH/YGMPlKmf0mMXxYWObXoXSY9STGHYRh4J3iAHTYg2u5MHiovEKAZmmkmSzCu
         eEgafZ4I6p0sZNtuBiOYHeBov8G2ATnwI/MP+zCEcv7mhedscucBdqnDig7ZnFf11K1x
         Jtjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ba6Kh5nlkiTFtk0PXNQUw8yZAHH+934YM3ghxMY4d5s=;
        b=Ot/4/nCdeVdSdiunUuu41L+YdRwrsLA2NOEgbenA9yIX+/NM+2ObfNhCjLEc3pbXI1
         lCHM6a1myBHQ+jyZumh8jpOAXYl/Me0VKn6r87Yjxlak3ii/2CbGmfOw+13VOLZjUi1l
         aUUIesvDDaAaExinuSqXAo+b7HuzXD9roClug9HxJgGMqls5OPrK7gMKDcdt7WL7p2S5
         CimBnUToKO1LphrF9PpdgTJMuFz0ELfbeFaxz204+ylnfHOo9Y8O7FH7chMtHpyS2Ybs
         p59y+HoTEB7qSo/EoXObn/OltEggZNsQv3CXOVmk1MyvYJSeJoWorSWKJ7YJHRNc1Ud/
         +G9A==
X-Gm-Message-State: AOAM53124xdrsWaG1kodEoOJcoQde0eLYVwmMkbCULHMOK/AvqpGpE2M
        LPexTSBXJ3qQ/NGFUpDcR+xxCccyNKo=
X-Google-Smtp-Source: ABdhPJyHalJOaGuB0mZjKXXa9ezMYpENRLmNnbxkj2qF4DVFP715xlTmcBVuJpi5bjZ06NXF7NxUxQ==
X-Received: by 2002:aa7:963d:0:b029:1ee:253:5b7 with SMTP id r29-20020aa7963d0000b02901ee025305b7mr12370910pfg.4.1615008718889;
        Fri, 05 Mar 2021 21:31:58 -0800 (PST)
Received: from [10.230.70.25] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id c12sm3745671pjq.48.2021.03.05.21.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 21:31:58 -0800 (PST)
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210305120903.276489876@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cc21ec83-b6a1-d11d-280f-fd88120cea09@gmail.com>
Date:   Fri, 5 Mar 2021 21:31:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/5/2021 4:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.21 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
