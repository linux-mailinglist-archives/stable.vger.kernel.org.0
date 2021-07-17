Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD053CC1C0
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 10:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhGQIJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 04:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbhGQIJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 04:09:44 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9CCC06175F;
        Sat, 17 Jul 2021 01:06:47 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id d12so12324037pgd.9;
        Sat, 17 Jul 2021 01:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xV5QNvH91d+uZB5P/lvTBXgow59kMCnRg9U2vwGRtJ0=;
        b=hPO1rNbsK/UhbmTXWZVu6h+nipKhBV6Aa0bfb76ZT45biSj9WCCtDo7L4Fbku5uO24
         DRxvdleGofdUc8w6kM5AyeoQkYGAr3zEVCSqSJV67HU75CKsVG+N6H/5GfnxURLjsDyG
         t8zNdGq2Tr2ADGSJ3wu2PnoungKFkUtY+VhnMJFhq8ln9ss7p5CvPtf8ZASj5ireKgcr
         x1H2wNOiFd2DSJ+v1lQEoa0XfBQTmOQGeJPPM/R4F/G1bqDu1F+DpW36RHnmhMMN6pW+
         N+swo8LAj7fxH7o8VIssc6OQOIsBiO5hwZuTMEUGPzeMtT6fbCibOPaXemnHDnfkdLhX
         ylqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xV5QNvH91d+uZB5P/lvTBXgow59kMCnRg9U2vwGRtJ0=;
        b=PhsFVpHBHpJna5LR66Z9dhW+Hg/ykY2EXBpLrYejlvzGTfFfCFTVgR4gGsnoTlXl7j
         N3jlTAfDzGwfJiyRPNqwP9915ejEOTx9/313659x8a6BLATqrK8Cdz8q6t+oDEZ9rEUi
         bgacaxy5AXaiiy56kFmQy7a+Dr1NWiXQK/7GS6Y/BgtXIXcZ4ZL99k/K8WBBpyNu3w+D
         /MsHqYNajm164x7xHxF2mgb7D/5L4uYopoklvCcFi3LY++/AaEnJNBzJWDB08sJJ51Oi
         npWZ2tmE2eI3RKAjAk0PQQXubnAtUlKe9x/TOn22h+Jg19+hVxfrjMO6sirPhxmQ+kqe
         0uKA==
X-Gm-Message-State: AOAM533pEVThOK3CQF2fKaBWhiAIozX0/dptCDd4ZLbB0tfw9XEKZWM6
        qw9eIwtVkI2JNu5RkmZFYoGNWqb9DLCd4l/ReZE=
X-Google-Smtp-Source: ABdhPJyNzq7kohkvEsENrQAkhP9Gn7Jauozm7HVELd/q+uFjE6Mwd+YGrAHKJV4QJHu8rxXAaBI/qA==
X-Received: by 2002:a63:4b20:: with SMTP id y32mr13868027pga.382.1626509206352;
        Sat, 17 Jul 2021 01:06:46 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id k19sm10528418pji.32.2021.07.17.01.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 01:06:45 -0700 (PDT)
Message-ID: <60f28f95.1c69fb81.eeb0d.22c7@mx.google.com>
Date:   Sat, 17 Jul 2021 01:06:45 -0700 (PDT)
X-Google-Original-Date: Sat, 17 Jul 2021 08:06:39 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210716182150.239646976@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/258] 5.13.3-rc2 review
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

On Fri, 16 Jul 2021 20:29:21 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.3 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.3-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

