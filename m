Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0118D6A8115
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 12:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjCBLeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 06:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCBLeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 06:34:12 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC7612F0A;
        Thu,  2 Mar 2023 03:34:06 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id j2so16180954wrh.9;
        Thu, 02 Mar 2023 03:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677756845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ep+S3pdxbMooIqcVhUAKETVhQpGPPtmS5sMfXUnAbNg=;
        b=b0no65LLKsRpUmmcmRl1u/JvAI7+XvzWtViUzj+AoA5pAT+4DwYqvQW/QKdECLi5FM
         B1QALlBl3KSRhE4SbQx16FNOdrhQ1KRt0aFlpTmfeZtxU7ZrL5q/JKiPA5dqB97VdYmt
         ExHiAFdIErMC4DzM+u+UP3/4474djemkmtQeNZeU6du56BR9wvW2oPkmNSX8zBtXsHw0
         XMS+lPza4/00prh44j/qwZRF43FIFkp97oPJlmGjDs+0wJbeTLxAmfpqGTitMPQ11mCZ
         /+TI9sXsxNRHfMfXk1d2NdmHM7EQXGJ4Y0/SjthwFKj5I0ynstUCAvvh5GD7QzFLL8fq
         bCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ep+S3pdxbMooIqcVhUAKETVhQpGPPtmS5sMfXUnAbNg=;
        b=gtox9wMUSjhk+kSt0SMYPjoFPIr4+0kH0vQa29A4le3If3TSIXwzWC5k3DbkVk4yQs
         OeSafihRvoaZ1h4Le2/GQguRQekl6qmFuft0rfK6toD599PqpPhqZUv4JqRk4aG7iSsv
         rSWkY0F3tTuKBmRaoizZ/7jDhvDHBQ+MDfvAwgqlR1w5tp+rvcR8BoFDO0vU3rYpGGZT
         XOZAVZKFDlINUCi8c8mulRUE/ISKFk2x6PFD3nsjS2sENXtXGyfcr7ge9vktRy8inw8r
         aaNeuwtdIll7Q2EXYKLtALCkhhcEX4Hezq884OxrjXyQTkh2ydwdHj/tv6pWlX/c/xrD
         cYbw==
X-Gm-Message-State: AO0yUKWIVXxWe2vpfyv8Y1DMJnfJoWZPSrnsX/qEaszzfRWV5fZdcqrD
        y6URhrCUvjPlp2HPK8r+cvk=
X-Google-Smtp-Source: AK7set+cyTQaoBhhaVcjFd4R5kFai5kVb6/v8uNSJ3IYQabfEdWwxGyhAGxeOhKWySIvuXOpeInPhw==
X-Received: by 2002:a05:6000:1b8f:b0:2cb:72c2:3d12 with SMTP id r15-20020a0560001b8f00b002cb72c23d12mr7254295wru.68.1677756844799;
        Thu, 02 Mar 2023 03:34:04 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id p10-20020a5d458a000000b002c559def236sm14735520wrq.57.2023.03.02.03.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:34:04 -0800 (PST)
Date:   Thu, 2 Mar 2023 11:34:02 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Message-ID: <ZACJqpfGw1EleS/g@debian>
References: <20230301180652.316428563@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
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

On Wed, Mar 01, 2023 at 07:08:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2977
[2]. https://openqa.qa.codethink.co.uk/tests/2978


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
