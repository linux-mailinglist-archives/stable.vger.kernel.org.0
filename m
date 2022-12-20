Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E1C652055
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 13:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiLTM0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 07:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiLTM0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 07:26:07 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5562E9B;
        Tue, 20 Dec 2022 04:26:06 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so8617705wmb.5;
        Tue, 20 Dec 2022 04:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYPzO1sV+Q9V3ln8qWKl03fQyPbIX5Xv6crA24tJRIc=;
        b=DVc3xzencbOETXcD/75Y4g3qqyEejDQn7ccQsCrBCE44LyvZwIgNoiFHgiOl5q+RZ/
         BkU98R5tEWTD8g/DHt2GdntW6/SZGWa1/N8nyqo4smPtzJRLaMYKJKLbVAPLQ2abFizP
         SncdSlHAz+szR3gZSmD/mskRXySndHblL+Yu6XbU151/n+z8io0Qo+olqQuhdp/Pcwi7
         dwXGVspbenPCjGdhayCiJXm+j/boknUFV+ZpDFpN7LpYXMiu6J8EK15/sgq8BGINiV30
         J6Z7gsVYRcL4BvQxNdAsdIPOIAwEnIICzdAti044GzKYiaKhYKbi6M/YSG36ijcNvRg1
         rOHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYPzO1sV+Q9V3ln8qWKl03fQyPbIX5Xv6crA24tJRIc=;
        b=y49x6GI7k0WWaQg8UXWD8Y25A06TlcjKKYV74iRlZ7drj4P014yYCCKVvs/yl96ia7
         /xAp16vlJPEMeQAlqHf/5FMs1aevt8+j7aZnzemWMcq9pi9zhK9IVKtEFwDfhiBCb3kT
         DBr5GQwzcV0QOzMlrAfs5YndcV7HjhujVZ6akXU74ggBPzIgNUwvaw7aJoe42raJiEJb
         /v84omfAuCnQYtdbl/OJkt4QCvBVDbas1OniQf2Y1ZUdYNq4eZoGP8kuyvHFWNbGbwA+
         SfLE+vZhhPWwaoohhKODjp8mZgvXkeezKoJGLAnJll8qBhnsgzJEB3wUZuVmX4h1brW9
         fqFQ==
X-Gm-Message-State: ANoB5pkhvAprvXmdlJuI3yhgU2c+RpjYI00Id6cFwHpM7QKrDTw5gS7g
        r5r48FnICkwKEzV0NyzXkFs=
X-Google-Smtp-Source: AA0mqf7FmP+sPdD68l4OCaTcBjwJEHVWyxx/tEbdfAkj2zTju/NvgA8gRUAxchzNVHPvqutKLCSR8Q==
X-Received: by 2002:a05:600c:2d0b:b0:3d2:2d2a:d581 with SMTP id x11-20020a05600c2d0b00b003d22d2ad581mr20856209wmf.30.1671539165332;
        Tue, 20 Dec 2022 04:26:05 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id t16-20020a1c7710000000b003c6f3f6675bsm22148657wmi.26.2022.12.20.04.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 04:26:04 -0800 (PST)
Date:   Tue, 20 Dec 2022 12:26:03 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <Y6Gp25YJ/m+DcgWH@debian>
References: <20221219182943.395169070@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
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

On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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
mips: Booted on ci20 board. Regression.

Note:
networking.service is failing on mips ci20 boards. Issue seen on v6.1 also.
Will report upstream after bisecting.


[1]. https://openqa.qa.codethink.co.uk/tests/2420
[2]. https://openqa.qa.codethink.co.uk/tests/2427

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
