Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F40646C00
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 10:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiLHJgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 04:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLHJga (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 04:36:30 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9435E9DD;
        Thu,  8 Dec 2022 01:36:29 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id h7so918339wrs.6;
        Thu, 08 Dec 2022 01:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vzvhVqrPG1tKRsCvh4LCgxjPjyy657R8RcpZzQGS+tA=;
        b=MfLWVAWkrg7h52VP6avmx+dbSJ7FOnKbDMnbrZv1hBqoS/PBeZrYnMGqIjvtu0E1o4
         paMQmnrTbJSSiP/I2KS3u0ICDMzfORmzpR9JjyHzBQ5Tm+TP0fdgGx/IF4yXLmAioS/l
         mYuExigRjT5hHVtnJUIbqY2caTNt59842NceEunJDFuy5vwouDt1t8hUdiLnwV96+rP3
         9pwCRdEBiAMeCkCaH53x2e6N7HyidPVqtmS8j+NzFvdZxhaXY8ejXzyRNdY2e7Yrn2LY
         JNpzfGMJTkRzlabkmjJmd2RiR5R1IPe64e7Twmm18fZpQI7TLizf+8qga8BXyCW3k9wz
         ouCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzvhVqrPG1tKRsCvh4LCgxjPjyy657R8RcpZzQGS+tA=;
        b=AHYfKCsfGvgb9GwkpbUI9FosmJ8fF30gqgPCm7dKdhLPqGKT6tRS/c3btC5pdWijg5
         mI+iqoULXqa8y1zRKI9xjUDonkp3vcyHxb/WxTLyjH2OHonzlRUFUvH8R7/LECyJTeZI
         9ZfDB0cN6NHRRm8RGhOkRkgsvCZ5B/rAW0kg1/3whG74JXiByAV97VM2/oNXFc+XVjSJ
         4jvQU2RTz0c/UFejPdbTysMc+HaR9gEK8ZfGSuJs2RcxpqLH6CfT1bcsPQmLYist4//+
         wEgE4hXuHZhGR5MBG/jaKRDQ4HWQDoeqnjrMnTxnr4yksql22QzGYxHmw6sl6bhQnrd+
         5TlA==
X-Gm-Message-State: ANoB5pnKtqDj2nU3odDz1rDWU/S7x53WeG0Jgdxpzv5HDmQcWyY/Y+Y6
        mFXstpQxQIQJrgk7gUhujtU=
X-Google-Smtp-Source: AA0mqf4e/mWcPd5avTxy30ryYO/u4DA51g6lNAEGDeUkrn7fyQ3cEAyZCp8lT5Da7dCNrZ4NeByIFg==
X-Received: by 2002:a05:6000:1d84:b0:236:6fb9:9ce2 with SMTP id bk4-20020a0560001d8400b002366fb99ce2mr1101797wrb.67.1670492188100;
        Thu, 08 Dec 2022 01:36:28 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id j13-20020a056000124d00b002421db5f279sm21422615wrx.78.2022.12.08.01.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:36:27 -0800 (PST)
Date:   Thu, 8 Dec 2022 09:36:26 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/125] 6.0.12-rc3 review
Message-ID: <Y5GwGrJmtTJWCCT/@debian>
References: <20221206163445.868107856@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163445.868107856@linuxfoundation.org>
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

On Tue, Dec 06, 2022 at 05:39:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:27 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2315
[2]. https://openqa.qa.codethink.co.uk/tests/2299
[3]. https://openqa.qa.codethink.co.uk/tests/2325

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
