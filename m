Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FB2559803
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 12:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiFXKj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 06:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiFXKjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 06:39:53 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528BC7C522;
        Fri, 24 Jun 2022 03:39:52 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v14so2565836wra.5;
        Fri, 24 Jun 2022 03:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a50Wd0uYN/FqbUAxGD2tCKD+dkhWmh195FinYbW4Eu0=;
        b=K8uSReNZC84GNYbaYitytYru8m6tLm8sCiBElyCoOshGf9UDckIZFUmL8FN9OzNEkW
         BwwLzIY1q3BcZaWUHGL1K6HZTuqrov9WMc7baPcqbiWHhwmu0QF82QiAcA5eXzMc3oAY
         rdYlDs7DJY7QEviuV3KtJun0gXpRtUpwTgw+mFBpZleO7PQpMUbCuDwnIt81g/CjNHHU
         wYBw4fo5QjY3KcCk8Fb5NK9NFkk+4NCDEZXtGwsmuM5JITzhMhXKbE0PK6f4sUBPxOe5
         3wBB3rKttBW2imWzHENfIad+qn11inFFg9L1MC84Ss4RbbjHr+WzYvN74pOSBQKs0ZH6
         jLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a50Wd0uYN/FqbUAxGD2tCKD+dkhWmh195FinYbW4Eu0=;
        b=17hMDUAj7P2O4RufXNQEc5TbCRwID4g1NvMIsldcboC6xI4Kcht/fcm9VDDrkYkby7
         EKUzXxVqJhexwFZUTsuRIzDVBGtbSGIYKEY3Sv8QbP1k8BiHpXJYroayK+Fnz/L/VMZp
         FWdsVbYxj9n+ibGD97EEXli9n8uwfODvCdQGo7yNjRg87abvotE4Hc2Mx4y5bcIKtf/0
         7+298LXUc/m+p19Aya8Yqv6vj/XYIsl5DVhpta44s7sGFjPrBvsi5Ro5cMODkjUJVhhq
         ph3VAHWlY1yJp13tORI0//0WtAabWb+j4+S0SiWmaX770NJ9eJpeYOONE6xGe81fwil+
         B90w==
X-Gm-Message-State: AJIora+5earPBwYq6y3SLChN2RFqNA6xX89xf7aHNaLO+Kl4JXnrKt9d
        PaB53rOC4gFnOuSuPPpBZc3vEiuuUcE=
X-Google-Smtp-Source: AGRyM1vKe+vfOAE1I6+Kb+Im852URkv9+y4ZMl6A9ckvQYGT0J/7Y5hA7H0xvjZRPu5NI0sXoRBJug==
X-Received: by 2002:a05:6000:607:b0:21b:855f:c6d4 with SMTP id bn7-20020a056000060700b0021b855fc6d4mr12664533wrb.158.1656067190778;
        Fri, 24 Jun 2022 03:39:50 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id x13-20020a05600c21cd00b0039c96b97359sm2278193wmj.37.2022.06.24.03.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 03:39:50 -0700 (PDT)
Date:   Fri, 24 Jun 2022 11:39:48 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
Message-ID: <YrWUdK8iElsT+gp4@debian>
References: <20220623164322.315085512@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jun 23, 2022 at 06:45:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.7 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220621):
mips: 59 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1382
[2]. https://openqa.qa.codethink.co.uk/tests/1387
[3]. https://openqa.qa.codethink.co.uk/tests/1390

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
