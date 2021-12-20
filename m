Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78B447B622
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 00:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhLTXTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 18:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhLTXTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 18:19:16 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F0DC061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:19:16 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id c3so15428770iob.6
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ixwBixl3DA+Ak4NT1uAzar+Y8cmjPcOD+Oeij9tM0xU=;
        b=TZMba17RhAqvQRP0CtntsGxAOLnOEl53W6rQbjAw4j8wXsGtxK1dBKVZZIgn71W6zo
         cYYW4o3zyiFZkXRmuQ0V4aSCtIg6D7JE3x7FNph4PHNxgRiy206D9oThfCT0WbO9CUcI
         rkwBOsRWd+CRT/tLvtmTwN+kpSpcH72Ahl2eY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ixwBixl3DA+Ak4NT1uAzar+Y8cmjPcOD+Oeij9tM0xU=;
        b=vhOHv5ulRtziEQMZzDG8+NQRHvGRSki1B+F67VBlZhJbL5TRDAOfffXJ6wnTWSe4lb
         fqnUGNK4KQHPuVudKtcTJINymx65FV6Uhn3Y3py0bKj47Xf55yWWhrKqaHfNFkJocxXn
         DWZ+cOO8uvI+NXOcpoIEWk/o+AtEvVB/vty9e+sAUs6pgmWcOgpNgvNa1y3L+BKZ00up
         hNpdfV6mli1CXzx/e9ZJH+Tz3fiu43Ih6xhREoIvUjepPc+hL89+zBF1FhvXh4KXNOXQ
         j1/1ozWQmbkBGuEu1ZARXSg95xc46xprJp5u84wgzbx5vJyRv0b7gq4p6kJ4gK2NattI
         Yjug==
X-Gm-Message-State: AOAM5337JGM27oW4yldFd7sfsn5jCcl7yVRAOSSrG8PJd9nOqR/71MNf
        twJykBe62EsbGhVSn1izpsmr+Q==
X-Google-Smtp-Source: ABdhPJytEZvjew9s5V0Dvuv/njOuPuvWwEfMvMb1Wv1TZixNdoaRPIgkzl/rrxOdHgwIsbWBovvLDg==
X-Received: by 2002:a05:6602:25d4:: with SMTP id d20mr254401iop.72.1640042355501;
        Mon, 20 Dec 2021 15:19:15 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a1sm3085157ilj.35.2021.12.20.15.19.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 15:19:15 -0800 (PST)
Subject: Re: [PATCH 4.9 00/31] 4.9.294-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211220143019.974513085@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3eb58b6e-4291-413b-02b8-b94ab2417ea2@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 16:19:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/20/21 7:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.294 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.294-rc1.gz
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
