Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAC8476627
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 23:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhLOWrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 17:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhLOWry (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 17:47:54 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A00C061574;
        Wed, 15 Dec 2021 14:47:54 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 200so12488110pgg.3;
        Wed, 15 Dec 2021 14:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RHqGM5KaVx4aanEHt68tqYagkFbd+faffRCxKAJuME8=;
        b=n3QOGfVjVSngBc98aSouNBFqW1iJMZ8U28WYvbKDYo4PdpLx8mszyjPnh3Tru5O0rj
         cKCAtH7Rx76En0zhaZ73BKcbkVYyyi0gRY4BukOKNAkhIMqSucajp83hbO09/2KECt5w
         EvFEYjYb8gUPYwmuukqCoWpEbmykYvlBQT0BlyOE+D4sXSmZfTskkjMo8CyN2HEbO60w
         grMFSX5b5fTJRwWNHFD9+FN1kjr40GgSCZ74tCTFJ3u99FgoXv3guj4TY/8qtO2CFUrW
         p8br+kVSvvWqGxpv8q/9Vd9cJdrTTXMgcDl0dCbTPNzFuiNvBeoKD41uuIlkP19djdVl
         qkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RHqGM5KaVx4aanEHt68tqYagkFbd+faffRCxKAJuME8=;
        b=Y9jgGV9VeAyVGo/juebjZxGB38ebija+iDA7tmWootGzm+ShLni3dCiYXuKICcrmwi
         WxQgD6zasglYfKjWBynjmvFjnwjW2Ued7Cn79K77vXdiSBWjZzJKKVMKJi2BudC88NgM
         ooLnFSd5XpN02vd6StOUVw81RPwSH2MUb7mqo98AoEw8WEVYpnvLYu3XxoFLBGY98dBu
         Yk4IHf58Z2tILWzRYpSR+ngo1tb86+DtA4VJN0r/dqiQoIq/cynJ8qKM1kJDlpNOv8T1
         WVIkXLIqo2c87V4GE3Nvb9g/9jIBSL1o99Pm2NIjkJfHBsA7QsBKYvlI1kvuSufhbkrU
         dhjg==
X-Gm-Message-State: AOAM532ypZnUYN5FpqfAEfo/lyn7HQVPmvidmt8MaJpxm328UNm5H58Q
        jiKD6PDCdlK117IgtWyIvMgFA63nN8E=
X-Google-Smtp-Source: ABdhPJx9DILb5VAXYPQ41GIthiTDQk83woDWHRy0x2yhvskIBd+TfVsHJxC2QelWQcKJL6V3pe8Ycg==
X-Received: by 2002:a63:190b:: with SMTP id z11mr9519442pgl.414.1639608473370;
        Wed, 15 Dec 2021 14:47:53 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h191sm3190700pge.55.2021.12.15.14.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 14:47:52 -0800 (PST)
Subject: Re: [PATCH 5.4 00/18] 5.4.166-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211215172022.795825673@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <324adb61-1ab5-4b66-80f8-d942f6421dcb@gmail.com>
Date:   Wed, 15 Dec 2021 14:47:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211215172022.795825673@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/21 9:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.166 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.166-rc1.gz
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
