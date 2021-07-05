Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF033BC2DD
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 20:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhGEStc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 14:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhGEStb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 14:49:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99008C061574;
        Mon,  5 Jul 2021 11:46:53 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so434231pjh.4;
        Mon, 05 Jul 2021 11:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=MOUogTgzCZv9vKhYKCDd8pNGYOu1E0m2jZPnN2Zb2Jk=;
        b=sO2gxYbMGStIX0AlCB8xqqCaEcGkzpcn9TwUrPcNf7sLJUwv8jx7nyep56Z+NBqjhA
         z3QfUwd2TFR56ph8l8W8oqpV9RWvBY0yftPtNkcvY2fTPTZxj9mFuIRRP/0nevgZ06Vi
         MmewXJ1UCu3H59B6/gG8S3Kovi1bBAkOngXujnMIfqXcJX/EmhmPJWQOw2LoKrn4CNoK
         IyeOKVNBZLSYDUl8nETc8dy++lA7ZjDYghXaZJoTiKJljY7W24eQBhfkmQjUkXxp5k2q
         rDIam0qlmkGK8L0PDH7OmoVlsmX20lSVUycgXcgpnA9PW+SR0niBDlay3Wt9KspjZ6si
         hA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=MOUogTgzCZv9vKhYKCDd8pNGYOu1E0m2jZPnN2Zb2Jk=;
        b=YhzjISdY5JnjSMvkWUFsR7G6CRkj1oZiFBea/5igJHC0u8z2AUOR9voRbTzNhLFn38
         dmBzF+YMnk59R7TQLfY/gTLQrXQcWf5Mr7eEzOOn6wXQzMBZFM6HQYfkii5T354sony7
         13qUAOPRtjO/lc3ynNRJLG39vVLeCz4WJ8c1Gqf+EYwQQKvAs/C3uKE7xEcGRnXDF3hh
         smnrPkAW+/X9kMWS7ElgUPECGjRmaZNRB4ZI9b3JNAUx/omnLF1l/J8ErrSvcGaQ6Vsy
         LZWJ0fQuAvR5/rYrlDpIv2Y+XGi/faacMOCKwHEouIX+Lcb2hZmwbEnnfvt+ZPuM0+CL
         2Uww==
X-Gm-Message-State: AOAM531zYtNK6GlLrr1fBlJUDQPR9zL0WWkC//K8+zrsmCSh6MLYwlpS
        9FvQXAgjPuqB8ymLUjLDW3PcfrEFgfkpGbV6
X-Google-Smtp-Source: ABdhPJyGwVji8wQInlD9saxliQqDYbgS7WY925eKW/zKY5iOsYjua5xkrLlfVTL6Wc9hrPM2XZNtsQ==
X-Received: by 2002:a17:90b:1115:: with SMTP id gi21mr450368pjb.116.1625510812635;
        Mon, 05 Jul 2021 11:46:52 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id g11sm16922037pgj.3.2021.07.05.11.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 11:46:51 -0700 (PDT)
Message-ID: <60e3539b.1c69fb81.e1511.17c0@mx.google.com>
Date:   Mon, 05 Jul 2021 11:46:51 -0700 (PDT)
X-Google-Original-Date: Mon, 05 Jul 2021 18:46:50 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210705105656.1512997-1-sashal@kernel.org>
Subject: RE: [PATCH 5.13 0/2] 5.13.1-rc1 review
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  5 Jul 2021 06:56:54 -0400, Sasha Levin <sashal@kernel.org> wrote:
> 
> This is the start of the stable review cycle for the 5.13.1 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:49:46 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.13.y&id2=v5.13
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

5.13.1-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

