Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835B0610E9C
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 12:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiJ1Kfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 06:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiJ1Kfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 06:35:31 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9DABB06B;
        Fri, 28 Oct 2022 03:35:09 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bh7-20020a05600c3d0700b003c6fb3b2052so3541604wmb.2;
        Fri, 28 Oct 2022 03:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JPxeqoUuZSodtcBLnZWOHUeiam6jMOP2XAoWax7aZik=;
        b=ETdOtPn74s5ttnKtOqu1PJewRiriRRLZAkjS2Biifrge7J5HJuLyn08/QarB01QMr0
         4vkhDo09BnWezPZWkFIUVk6lKTe69s94L/0FHDjBba2h1YZg0LqPJ9JIOxcOKKb2VuGb
         ZQUty2v3ZE1kHF12Sy76w5QNfQESTjtXLsBSZBcyDpV9JZBx7FaE0Gn8uEIrgTaPwq8F
         n029p2zSMawGIunG0RBAW0lbwEfvVzRxo79VmMG/NkV1YNigOg/KU6FT1ZPfvmtFsGIs
         ya3vV0cPHvBNEnxNkGHPRO5Co9AC1tjY2ds3MVnHhgPtKHNAHbCHTiia976t042VDsHR
         l3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPxeqoUuZSodtcBLnZWOHUeiam6jMOP2XAoWax7aZik=;
        b=fx7VEqVnWZ+yrItUKk+k4to2JbFoKBJC9Ybo2ssFwR7b9TgKDNNSXVUfj3a3xPq0xR
         zkLbin037YYZT8xW4NyxWEJeIuDjYf2gpiEcU4X/K1qsrCKwuuTwxfJMKz+wlMkNzfSR
         8DQ7ZZgh8GMDwm278h6zHDVfud0HIosbMo1pcENluEeSdlzl2XKLnt7JpNtKlhENFfK5
         2eoYUhqXefhblKp0ki7uQf009dHuqGEWe38bPZk4pRiWakFwR6nVyLA6JSCT+2OFQZN9
         m6QfxxFULj14TT1JZtChcCjzBrQsddHQgCOuhEgj+iQoyuexHGOdeIwXjYsaVvKMbqzO
         /lBg==
X-Gm-Message-State: ACrzQf0NF25Ueo5R4crF23mR+Hq7u1QzMxLezwO7x5FtSg4mXCVmu0DY
        ecMSubvw6gDzRDYxHkASKB0=
X-Google-Smtp-Source: AMsMyM6QgGQClPrA7zBYcsYzaOrkox2XoKdDmhRUGna1sQdflW2l1FzoRNXPTHZxypLq3F0I3QqbHQ==
X-Received: by 2002:a1c:730e:0:b0:3b4:b0c0:d616 with SMTP id d14-20020a1c730e000000b003b4b0c0d616mr9020044wmb.72.1666953307633;
        Fri, 28 Oct 2022 03:35:07 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b003c83465ccbfsm7213842wmq.35.2022.10.28.03.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 03:35:07 -0700 (PDT)
Date:   Fri, 28 Oct 2022 11:35:05 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Message-ID: <Y1uwWUjlghS4xUJs@debian>
References: <20221027165057.208202132@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Oct 27, 2022 at 06:54:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2049
[2]. https://openqa.qa.codethink.co.uk/tests/2056

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
