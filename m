Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DC75F423D
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 13:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiJDLr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 07:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJDLr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 07:47:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB2B4D17B;
        Tue,  4 Oct 2022 04:47:56 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bu30so1027125wrb.8;
        Tue, 04 Oct 2022 04:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/YZum3r5lf4glMgsSavP3Juj4v/JufzsMr6RiLybDcc=;
        b=asCoddZx0cOGNyapOdEkcuMZeG5sjGWKQSqrTCWPyRo+9amwM/YDFSG/1AltSzU1i6
         8gap9jFLM+67J+nmpi8+c8L8ROgwNSZ4o2qb0e7Ch2W+Opn9eKWzRRqT9eEMI9b/Dd32
         Dv9rLTD6b9eM5PdFAJ2gNQPLki04wMJ6CjrmnZ7eHyZGULAh7vPWtE0sSU3XD2WZareW
         DYv6gs+HoGQR0/vp6seeG0kVbBOv0+g9H3B4OtZF68g/sfy21jw8UeJN6B4t8PGYhD7b
         fAaAbXe1O+Y2G2kOkrOGbAZrbD+nfM8AEX2g6/UP6O3ByYz94F3K1z7jUbULxfH8qTfx
         o6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/YZum3r5lf4glMgsSavP3Juj4v/JufzsMr6RiLybDcc=;
        b=38hLFJ3xkE/xhrILUfPCe+YiL62ljT89agx11rwLt3/dUjOLhaaaxg1+E0WZTiaaJL
         t72YKn8aKUP0r8fFCxgxgiaEWZrmyHs2wXiV67O0AV5pMAsEbxFUVTtOrLFokKVaZm8H
         w0gERUM7K/5WpsHVEy60XV7YR0lqpFVmmEWDWYaxz0K81YXGJOmxbsnsVfxmNejZzOmu
         3zvANRT/ymwjLI7HeM1cdd6Ye5T9Gb0OMN28oWaFJxGwI3D3sRQtNGS0MQ+f0RAi0pcF
         kaKFlUotrBU2BWdknXa9MMyG2c/GMjOt1hGMtUJG2mYk2tB9kiNuaHeIIufr3AH1GTrt
         n9zA==
X-Gm-Message-State: ACrzQf3JSw9c//x8RYP6febzjKs+lQH7TLqZUTR9TziU5St5oDMbFR7l
        R4eWjmidDP8InBfngOCZydw=
X-Google-Smtp-Source: AMsMyM6zAWKJ0Bj39HJBe19L20daB+Fepnur+H1pB8BVXz7UJ8A3EQBA4lvIsIdu++Fs4hzCDH5+Rg==
X-Received: by 2002:adf:d1cf:0:b0:22e:4125:1152 with SMTP id b15-20020adfd1cf000000b0022e41251152mr4806871wrd.558.1664884075133;
        Tue, 04 Oct 2022 04:47:55 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id cc7-20020a5d5c07000000b0022cce7689d3sm16185784wrb.36.2022.10.04.04.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 04:47:54 -0700 (PDT)
Date:   Tue, 4 Oct 2022 12:47:53 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.19 000/101] 5.19.13-rc1 review
Message-ID: <YzwdaSV7a0WrneBV@debian>
References: <20221003070724.490989164@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
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

On Mon, Oct 03, 2022 at 09:09:56AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.13 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220925):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1947
[2]. https://openqa.qa.codethink.co.uk/tests/1950

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
