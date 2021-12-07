Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACCD46C3B3
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 20:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhLGTes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 14:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbhLGTes (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 14:34:48 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D7BC061574;
        Tue,  7 Dec 2021 11:31:17 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id j11so14794947pgs.2;
        Tue, 07 Dec 2021 11:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J1qgDMbkh5XqBTpRbmO7Iye4ml9GEsBgb94EryPvQyU=;
        b=dZl6d+uCnB9/r8b6coaPKSc3mVVyG3Li8MJMUdP4cRYGr2vF4RnerQIc5W+/hQJPgz
         THZOI7gYZp6WDxwypSW1zUhtcOk0GyExqKlEYR63lJM7zQhgBywxTiMRUFry6nh8WqII
         3z6tyb1BcUDrNmhXDOlKeeCIWhGCF1JVq0AsPcUW6chG5bdgfHXIBIC9NbZT5r0GI9v/
         tpjNcTVfEntwI3Chq2A3Uu9uYuP2XH9CHIImLJZTWEC+ZrgtWUVpB6D3wOUHUB41x1zd
         /W9PT+FqOB3ZTISDZNolQDcugmy+UoXeNIwJmwg1RFZJKlSfqNFyzEN5c8LJvZNDRCzZ
         AMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J1qgDMbkh5XqBTpRbmO7Iye4ml9GEsBgb94EryPvQyU=;
        b=TDWnVcr6EZZQmN4G8LksfFrPzyzhFI2k6aOloclauk/z3BkPnETuiiKnmfQi4e6TP2
         KF5abiGXLiklM3cKaAY0+88uc806VZlkmMoqLKMBm03tIkDNsMwchDjOEbyiFX5ifvo9
         Owygbrr1ZycCay4fRWvwtJkPPjqOaKOCz6sySlDW6Dkaulm2y/MFTkTrmucvpEmy2Crd
         dUArvTmgXFb4Tg7fsJEzmyfv9pM4pSDTmQ7CLNqf40brN/n/qdJgXkQPra5x9PGvpAud
         drym2lToXWIVQ9fpXC05QOAWqL5D2XxY7is4mHAxykiC+P3NgXm48ONwMGz3NW8zFSqs
         AohQ==
X-Gm-Message-State: AOAM530nJMYCs36/ZPTIRN10mSOCHwxxSgAihcrlMN8hDZOlji8u2IYk
        d//oS0QHz6382+hy2fRU1/4FW3AyRVA=
X-Google-Smtp-Source: ABdhPJwpsa9wZ3iofIUKX1CRwlLeK9dAF8W7ia9LioWJZvdciewVTLxASn/rB7ScTNQFlgNuLhnO8w==
X-Received: by 2002:a05:6a00:a89:b0:4a4:e9f5:d88a with SMTP id b9-20020a056a000a8900b004a4e9f5d88amr1214056pfl.28.1638905476634;
        Tue, 07 Dec 2021 11:31:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b1sm538605pfl.101.2021.12.07.11.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 11:31:16 -0800 (PST)
Subject: Re: [PATCH 5.10 000/125] 5.10.84-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211207081114.760201765@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8321c21b-5ab7-7f68-2201-e7a5f2f9d5b9@gmail.com>
Date:   Tue, 7 Dec 2021 11:31:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211207081114.760201765@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/7/21 12:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.84 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Dec 2021 08:09:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.84-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 4-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
