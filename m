Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4CD5BB8A9
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 16:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiIQOFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 10:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIQOFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 10:05:35 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27242EF29;
        Sat, 17 Sep 2022 07:05:33 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id c11so40275267wrp.11;
        Sat, 17 Sep 2022 07:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=DyhsNkvxmBnjPCqtatS4dOP83t+vwVI/Jo8B+cg3r7Y=;
        b=EVfrO/yHQqRYq5/ajb2/bx/iUmr8Emne1f+rftqZQkDsB4MovsLHeQMOzDIP5FylHN
         yIT6YeC9ZRPH/9UppP4UbimEFhtwNn0oEGhQdzgoMhImcTh0ycSwFLnVdKAfKE7HQZQB
         ldXhuUy2OSkk9Pquk/Z4qBdqFJuFLnBZzKRri4E+FwPuswrwtfCqQaBZwmVRxB4QjP4o
         TepUz+v1y0qodPEIs8UgDKuDt95cJScAwFzdPrju6lHsO7g1Fk5vpOxn1nbwFrKPCjd5
         4hrCueLPslp/QAqi/JBYVw03D7kdmD7Ew5hcCuHXQLEWdhGAYKF78SlzIteIEpASdy7M
         fZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=DyhsNkvxmBnjPCqtatS4dOP83t+vwVI/Jo8B+cg3r7Y=;
        b=5XrVXelCqC26G9dVgjppl3oQmbovrsJDc3KBr6LAfMjLrvHJAh3Pw+Arv+rE9DI164
         ERRecJizU2eLMIXEwJHGmuBrvDT/+HmKUnezNHZlFq9NQ6U0SEy6dktUf8hh5vFdBCmt
         A5rI8+JgUV0lC8UBoLQQmg8M86KKeonMxRTl5uusvAOxQcgyhzFyyjM1U7d2L198QZFW
         juCRJIHTxxgRtITM3IFlM7rLlKjQu0uSbVkaV8eCWJlOJo0T6wtUXO5aBhmogbEHMFFx
         BoZ1BCT74uav6BRhklFRdXmaYpm4+M4xg/YO8SvK9cmeimaIF29DZEU0hbCoFLUBSkRF
         yT9g==
X-Gm-Message-State: ACrzQf2QOnhiRiPk9BZB3v8MSSG04AYHVp4PMrlkYR2iqJWEnLup9fSi
        xSOlzSKi9qXonUgFIMtjqJc=
X-Google-Smtp-Source: AMsMyM6C4ct6EfbSpzE2mbQdTedzaPpI8GwsGX3fLZHMy43qEOvo7PdD92NrX2mSbU6Yn4tGN/GzlA==
X-Received: by 2002:a05:6000:552:b0:228:6296:3b33 with SMTP id b18-20020a056000055200b0022862963b33mr6073651wrf.615.1663423532339;
        Sat, 17 Sep 2022 07:05:32 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id x12-20020a05600c2d0c00b003b47575d304sm7401622wmf.32.2022.09.17.07.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 07:05:31 -0700 (PDT)
Date:   Sat, 17 Sep 2022 15:05:29 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/14] 5.4.214-rc1 review
Message-ID: <YyXUKSOI9/4b9E1m@debian>
References: <20220916100443.123226979@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916100443.123226979@linuxfoundation.org>
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

On Fri, Sep 16, 2022 at 12:08:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.214 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1843


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
