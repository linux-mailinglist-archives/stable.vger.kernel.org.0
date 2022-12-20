Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B58D651F93
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 12:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbiLTLUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 06:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiLTLUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 06:20:05 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ACF6301;
        Tue, 20 Dec 2022 03:20:04 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m19so8417405wms.5;
        Tue, 20 Dec 2022 03:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2lkzhxocRun/354TaurNhyByO/xU5VYZuEn4lnI7Les=;
        b=LG2XND57AYCLmmziUE9xBeCYCWIBljQwA1eSzf4iNVyblavE5P+LlRaHRHY7f099VW
         su5EG5OIK3/oCwVFzqN/LJxbl07L4aLCMDdnq6IpJIQwYjg4NjgqlUPhs8xpSjJ+kLIW
         CnuAbMdekFTVZ8aD1Kt3LCy39UdYGKow4PIxXcre+oe/s7bR/dNItcUbLZLDplGd7iRG
         qmYFf3K9beZgpI7P7xEqUI1VdECTr7QtBfy0632vFbbvCperkdq85qcTNVW1QbKGpPh6
         SzcyplIxRUuLFfDkiATBxjMzUi4uUxgHbluKprQ3oif8AVhWQaFkrQ5q39wcLBYthq9o
         FeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2lkzhxocRun/354TaurNhyByO/xU5VYZuEn4lnI7Les=;
        b=15OsYHI3KW70k/rkZp8rDkoIEvl1bbLwlF/8SoN/n9etW3YfZ2QSgJ+d1MeitB4WqQ
         vkHWR68rsNSfcaFSf8+reNbG3iqSw2nG1FaE9MXpGvKx74Mcwg8G7BswSlw6PWcbr+9P
         ZAMz6/x4OO8/DSsy0bBsotTlkWrGYjTycYTHVmYlWCh3Eda+xijpy2uUhVb97pDb+iec
         iuX1cZ+qNqIfCdC6GfhkPCK9XHf6vwpLpTYi1Cm0VaJExTbFybGyHP939Wbs6I8Q24+2
         Fh7DWDzpMWXdx3XPkqQXE9vjUQWpVzcH4vTKCSK0HYrEYk8816H/qN+yLufQ/I0xsMGY
         LGmw==
X-Gm-Message-State: ANoB5pmGhab4R4z24Qu0cM87EkHgY3DRsLLp9INwkA2ATQpzVNci8NdW
        FvtXvwEASp1tFl23f4dVt+A=
X-Google-Smtp-Source: AA0mqf6lLW7WJ7KzxajZSlVFlhw1yOdpWQtaC+WCBLV+bGwGK7ancWAEq8J4wbmzHcLmc+r0p3SUrg==
X-Received: by 2002:a7b:c30e:0:b0:3cf:6910:51d4 with SMTP id k14-20020a7bc30e000000b003cf691051d4mr33540745wmj.29.1671535202599;
        Tue, 20 Dec 2022 03:20:02 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id p189-20020a1c29c6000000b003c701c12a17sm22204179wmp.12.2022.12.20.03.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:20:02 -0800 (PST)
Date:   Tue, 20 Dec 2022 11:20:00 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Message-ID: <Y6GaYM7gg3ManVGc@debian>
References: <20221219182940.739981110@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
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

On Mon, Dec 19, 2022 at 08:24:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
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
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2422
[2]. https://openqa.qa.codethink.co.uk/tests/2425
[3]. https://openqa.qa.codethink.co.uk/tests/2428

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
