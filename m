Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE2E669738
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 13:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241653AbjAMMe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 07:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241559AbjAMMdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 07:33:31 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D45DF57;
        Fri, 13 Jan 2023 04:32:41 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id bs20so20932737wrb.3;
        Fri, 13 Jan 2023 04:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xthF7iCDdDoJ+wYb8AViE4uLWbO2Q7orZV+yQZVrMx4=;
        b=Pjr+N/xavfSbgR7zdqgo14MrLpP0avzLCQbLpQK6yqQqdiXP3GX/IpfOArzlAA16GE
         O5LM0PtyNOwIvra63ivWh3PZQcxoBuWD5bquLqWPJfj+jztKXt2ILaQuS1pWh4Yn0wFf
         XaKFVmJF0jy8DHI7q0wghBn80YnETqJzRaGE9dU7orqm94iXwt2x8Gt/RKDrJlvEYB7i
         50xoqzHM+mFxcLPDFLsrYTxbbwP+6o0OPbabunKXakqGx+Rl6bjXTlZkSHBARWdVL+hb
         9zWPvl7kqacikdUp6+zCYAMPjC4oJTHB4q3diTzj0MycL+MLmsYIs4xNRCwZXNqEVboM
         J0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xthF7iCDdDoJ+wYb8AViE4uLWbO2Q7orZV+yQZVrMx4=;
        b=nvInf9a9Q4IKR+ljlJH2ZxSLzGVV8ScGOz6a8SU0cCI27esQIiBdiJl5BDWVhPAuA7
         QQDqBGjmkoZi27AX1zrWreila+DvLzw8VCkt+FXSxKmc3yG1b8lGPSXIYmngDGtCzqEh
         8jvFZhHVrYLlqXi8fLGHhB1MzXZ1IDjfYN5MF7KaAyL24hyXhv+41wxkUmgw9q4QCUYG
         fYDLYaIl/1t9NOdIP8G5/f7uCoxRgF/W0oOz7MXjaijGqD5eJRbVwKHvOspYi9G3DCsi
         TUX9qhNPkKcFVweGSNcZ48VMHkC3o/vywg7Ku0D/uf3nFiPfYCxOFK2O1TttmrewvyEy
         tlbw==
X-Gm-Message-State: AFqh2krUH/thnb2pSauLOOTRbp9nLDkcYodz7VBqMo67R66UGXADJSlG
        0w/2tX8EajLVagPaYMMiSLc=
X-Google-Smtp-Source: AMrXdXuhNdYtTkhsqB3G9TvD9iQQ0ny+B78134u28yGkGmU4BxNeRHWEzpryVSFZTy0jCIzlCMHr5w==
X-Received: by 2002:a5d:5e91:0:b0:2b8:fe58:d368 with SMTP id ck17-20020a5d5e91000000b002b8fe58d368mr20984993wrb.29.1673613160451;
        Fri, 13 Jan 2023 04:32:40 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id f8-20020a0560001b0800b002423edd7e50sm18688009wrz.32.2023.01.13.04.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:32:40 -0800 (PST)
Date:   Fri, 13 Jan 2023 12:32:38 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
Message-ID: <Y8FPZpuV4L8LoXtK@debian>
References: <20230112135326.689857506@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
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

On Thu, Jan 12, 2023 at 02:56:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2629
[2]. https://openqa.qa.codethink.co.uk/tests/2632
[3]. https://openqa.qa.codethink.co.uk/tests/2635

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
