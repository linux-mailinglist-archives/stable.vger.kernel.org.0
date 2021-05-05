Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB613747C0
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 20:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbhEESFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 14:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbhEESEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 14:04:04 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43CAC0610F0;
        Wed,  5 May 2021 10:53:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id m12so2306771pgr.9;
        Wed, 05 May 2021 10:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=F2C5cf9B198jaC0/2aV3ii+I4uZpmeyVcCtSq67VLBQ=;
        b=hjGcJxR9LYIXOA2kEBBtFvQP/J3QYPoUWRV3D+kYk7hk7lIvUIpw8U3aLN598JwBVs
         UDaWh1s8dlCCVmb3VbZSiWeBrwTZ4TgOICEaxVBCz8bceLstj4m9UKwZzAyHPPOM9HLE
         5eWNfnFUV/DN92on8/EwTjtdH33r6F8l63zXv6gLUoSgN3jarf5y16+5CegVLKv8snzg
         VFgYLtzhw0UQn8RHR9uVqLOUY84SjyhQQVTWcJxNoATMITtszocXJPrif9gvb/4NaBYy
         bLY2w9vSG034BH9X8tbC/3i3kuriCv9S7e/YGYodks4LSyUi/IluuSRn2OTTFrz9wZIP
         yCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=F2C5cf9B198jaC0/2aV3ii+I4uZpmeyVcCtSq67VLBQ=;
        b=DPtL0jcIMC7lH6uwRZVEJJlU0Qd0OiimZZosSWUmI+vLyQyBC9xYqfeQBJzhoYoTuc
         S9zyKmF/x/LhWDGDsagTOhXWXucltKZDOwrqBnXlLde0SaUHUb4ym3BMkBLUgJsgT/60
         +FL/06TGhkpcDwuB4LjgrB7YSaure9G7NmcWM5OrTcNTiUgGObS6752TC521IRxGvyb5
         EoRVzqCh1yOAMiTw6CmAE/1zolxvuGp3PeEdQocbKHeQaPpGjvEAENZv1CdyNG9Wq50j
         l6DMArz6Oafx7EgmJY/qi6G2u3og4A54jbYSPH6dbRf20J3drDUqHzKp3aiWt6qSAw4u
         5KqQ==
X-Gm-Message-State: AOAM533nVw86ZcTHryqJ5nOSoxQvx/p0tPJvszXg5pyrUwxQgvLEmGwF
        4xj200zZxGDxwVvKpsJHiymSIH+MgVztdQRT16C38A==
X-Google-Smtp-Source: ABdhPJzM7Bh6WNr0AQQUNa7FDE59wr8Dzkat0UI18Eaki6EICVl/f0XQw0s/F9c9MmXW3qCXgoawOA==
X-Received: by 2002:a62:b412:0:b029:21f:6b06:7bdd with SMTP id h18-20020a62b4120000b029021f6b067bddmr120978pfn.51.1620237180000;
        Wed, 05 May 2021 10:53:00 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id j1sm7275109pgj.17.2021.05.05.10.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 10:52:59 -0700 (PDT)
Message-ID: <6092db7b.1c69fb81.c8318.f7b8@mx.google.com>
Date:   Wed, 05 May 2021 10:52:59 -0700 (PDT)
X-Google-Original-Date: Wed, 05 May 2021 17:52:58 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
Subject: RE: [PATCH 5.12 00/17] 5.12.2-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed,  5 May 2021 14:05:55 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.2 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.2-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

