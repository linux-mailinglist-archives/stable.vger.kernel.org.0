Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85BE646C0A
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 10:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiLHJi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 04:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiLHJiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 04:38:19 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F862E9DC;
        Thu,  8 Dec 2022 01:38:18 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id w15so915191wrl.9;
        Thu, 08 Dec 2022 01:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VmylA4p6JIXEdV9jKTt9EugkkSk/Nd5xRV/APqKB6+8=;
        b=I317LVxJl1AebamM5xxtwNP8J74f11NmqL0K5P7Kh7v5poKbYendla8reZ6IZLEo1b
         csWcWwzVEhLaIKP0ERHUZxYFrMMw1NfTCeZOFTBEHQwZAni05tRpLw4nWdy0NuVio9lq
         /k6Be3DAEkC0m1U/AmpcLbRI7+HITe4MiCBGxQc2CBHaFjVrUvJA6hN6iN3JyktOQM93
         11CiPK+HprcnO+7Ky3BmrW/IizKU7NiBW6893iTEKW73LCVYcTBzh7tSVdNckV2XkxGY
         5ERzTamBMHYzAbhpwFqzt4C/tZatx3K0wbikqQGHcwFtoFL/iGaMeHvFH0KT0t9892hY
         s6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VmylA4p6JIXEdV9jKTt9EugkkSk/Nd5xRV/APqKB6+8=;
        b=IMRoGMc73mLzkYzD2B/Jqh5At8/wSOru8a/Qv8iTyYR9v174GG48Pavt2iNkaF0R1w
         LjafzgqGHwFWvqdymKu8d6sbMZHSoUWwth1QC8Aqb9Xl8W2unrXy0iQAT+gcZHnMKiUv
         cf1FbRvk13iyO6yK7bkQB8NCP+WXqe9yzXfyRR7qr+rYURIMfQOPcPTkdruAtzAmQcZM
         jqd6SyBBqfXhVY1685KyzVuud5TvrdQrR1jpSD72WLNkYzL4efdReJNgW5kQdC4HqpQL
         +XgOLMi9Nmjnqi/33jWEBh0eNAZaVWkDqG3HkCkYCftr9NOa6Q9qgHnKSZa51bVlKlOw
         unfQ==
X-Gm-Message-State: ANoB5plmcwecGD3K0Y2pbfsDjvMNOXXYz1KCsNiCBJHFYeUzGAz+ccV9
        CayLZYFOkn1CxJSjMhjTbY4=
X-Google-Smtp-Source: AA0mqf6s3vhO2x3ul3AAFBHxC7005Nl+5wqr8KZt+OdhO7g2RegrcqygugLliC9dvXmAcdMs1XFk0A==
X-Received: by 2002:a5d:4086:0:b0:242:509a:ad42 with SMTP id o6-20020a5d4086000000b00242509aad42mr1096900wrp.36.1670492296692;
        Thu, 08 Dec 2022 01:38:16 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id d5-20020a5d6445000000b002368f6b56desm25837594wrw.18.2022.12.08.01.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:38:16 -0800 (PST)
Date:   Thu, 8 Dec 2022 09:38:14 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
Message-ID: <Y5Gwho1dzyxMdGyU@debian>
References: <20221206163439.841627689@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
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

On Tue, Dec 06, 2022 at 05:39:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2320
[2]. https://openqa.qa.codethink.co.uk/tests/2300
[3]. https://openqa.qa.codethink.co.uk/tests/2324

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
