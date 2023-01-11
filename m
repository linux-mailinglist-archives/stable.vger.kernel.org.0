Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A1F665BE7
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 13:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjAKM7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 07:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjAKM7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 07:59:01 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C231C4;
        Wed, 11 Jan 2023 04:58:59 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k26-20020a05600c1c9a00b003d972646a7dso14274813wms.5;
        Wed, 11 Jan 2023 04:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bmMcIUft4WbYyd1YhRNwUDrox+14DCGIc71j97XsCZc=;
        b=jJYGjutRCIJ7bxY/mRz8HyQPYqMotaewXKqHE1baOqVh8HUMWW5gUwf1Kyz3EQLZo8
         cUsJsvYqNqVe9NsATCX8xtbRkLCRzI8lRmSLX7IOgAEChR2MSeLcsPtT2Yz9+Cjde4lZ
         Gkf5tt6R3QH+CbEJ8jHDC+pzRFP9L3ufPTUi+zSiQ4VOAbWgObw7hAkdU3HR8BMo5YqQ
         Rd29B7RQQAWOKgB3URL0/aWcC8WKZRtruDllMNbbUWGTNHNR0f0n2LBBteNDqduHT/e0
         S/i/7GmaakpvTofjUzy7w1ndeGBllLFrlpHPFS0Pofsuq1CoM3/jOfCw8z4YdwOpJr6E
         FDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmMcIUft4WbYyd1YhRNwUDrox+14DCGIc71j97XsCZc=;
        b=ufvGEUxLJ4QujoFbFp6FJ0ybwOr1ijlxhYN8fto6Slut6LY3BDpreaYtzgWWvYYS0f
         0b3XonmJXZYWPfhL26G6wMWcw0zW3COc+/9Wuw8wDF+v8mWZ6lCeJe4AMqWLnXHwhUp1
         JowM9YqQD3cJGJ9ssAN5nN5cM1fjBLIFb/S2gEfpgE1SnUCWj5RmE5TkQEyzoJgWMBK0
         sYCzdQW06gqDAecNGOVT1iHJ2bc7PQHHeKaeVn2C6ZB7tLN/GoliivjFz+MA18b2uSMk
         07QgmoqHz1gd+V36xSjcYV50sD0xtOePvSNramd6jxDa8Y9OTsRojDlEQq0hS6aruHNd
         b2Ng==
X-Gm-Message-State: AFqh2krSJqVn1BY3n+eXtHE5CQCHt4CIN4E9fiC0vCtLWTvev3IiLhRC
        5enEI0V0jAtXI+bbID4lAfs=
X-Google-Smtp-Source: AMrXdXve0ye9QtTUBMqF9HXnzpbarAwLO2ONitQ31GE8gMiYOnzrDPD95Gt5cJJ0b/L0iRueVm7Vrw==
X-Received: by 2002:a05:600c:3550:b0:3d9:ed30:6a73 with SMTP id i16-20020a05600c355000b003d9ed306a73mr9392280wmq.9.1673441938343;
        Wed, 11 Jan 2023 04:58:58 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id fc14-20020a05600c524e00b003a3442f1229sm26143990wmb.29.2023.01.11.04.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 04:58:58 -0800 (PST)
Date:   Wed, 11 Jan 2023 12:58:56 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <Y76ykHsQcyusWNah@debian>
References: <20230110180018.288460217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
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

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
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
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2609
[2]. https://openqa.qa.codethink.co.uk/tests/2610
[3]. https://openqa.qa.codethink.co.uk/tests/2613

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
