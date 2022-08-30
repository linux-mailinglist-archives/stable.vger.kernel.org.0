Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E65A5A60EC
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 12:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiH3KkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 06:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiH3KkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 06:40:16 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB20819294;
        Tue, 30 Aug 2022 03:40:14 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m16so13592823wru.9;
        Tue, 30 Aug 2022 03:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=u2aT7dmggfgjN0W9ssu0rPXEKCYVEEZc+Qb0rHdTMIw=;
        b=gGM14XDJoC+HDJdGZj55275AZirVYSP9CxKzz629P43oEZnJL8OhRMuwo+GKtYsNcn
         f2isCJfL1JoipvrWnoKmP3Ejq8Llun6wnHgRrriUDiEptkZKoBFqD5MFLOQJyaIq0AEx
         CZBQbcI6EM33cOC7TSzciVVHCU3vfO5e1NUcysrtjoPmgEiIEEIw2Eofb7ubVxSKlsVK
         NG3I4CcTxdX5QPzITppLSLxCCOYxlKaxBx74X0qIHo4v8yEdjKWSIVRoR7f3Og9uptqQ
         RHottnZ+looawCjMAEtoGiOTldd5PzlMzUnJpuA7J1MdtTXyAsXZLXaC4MJEZ1NYkgAq
         yfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=u2aT7dmggfgjN0W9ssu0rPXEKCYVEEZc+Qb0rHdTMIw=;
        b=HYVeDYuakp3iuXaqcofU6X1ohIQAL59Dl2YFvpfn2srPJLYJ3ZwF56X+3SjfqDfptu
         UpzvL1MGzzEo2DAzWWdqktYcv4dQwCKHmX8pXw6OevlexcVUw/Aqvav3InUkoToUFp2B
         TgGr3p3FLhd1ySAb1xKj6Ivpu9TLm3H+1oxV6Ar8bMqwB8asB4ObM9sDNiBtSc3BjhbL
         BdAhibjyxFRd4bm6vdODX8VDPxb2lCWKbNLPfggPZfvonRuERGd3y3j05uAXcCxuIi1L
         KjiadP1aHaXowvAZEbtKHZVTlMD8bi45+x6xnZrniZYFq57Yx+X/pFmlUuier12UhWuR
         YqdQ==
X-Gm-Message-State: ACgBeo1+qRvBYaltvGrsVkCUHoJEFtmeCdS2jbHEr30U/RR2jv29ZRpf
        iWfhEPZ9ktBbEC8AyUps6YOoWIbXMvxwpQ==
X-Google-Smtp-Source: AA6agR6MvlcmbDpPkYSUu2obN+gKBf2KWc53tJkBX3BGVZ/K92uHD/HVNSj0F+N0OrgVUODH6BzRcQ==
X-Received: by 2002:adf:f250:0:b0:226:cf7b:d5ba with SMTP id b16-20020adff250000000b00226cf7bd5bamr8929373wrp.570.1661856013447;
        Tue, 30 Aug 2022 03:40:13 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id f28-20020a5d58fc000000b0021e4829d359sm9024247wrd.39.2022.08.30.03.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 03:40:13 -0700 (PDT)
Date:   Tue, 30 Aug 2022 11:40:11 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
Message-ID: <Yw3pC4xjCeOy2sQM@debian>
References: <20220829105804.609007228@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
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

On Mon, Aug 29, 2022 at 12:57:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.64 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1729
[2]. https://openqa.qa.codethink.co.uk/tests/1733
[3]. https://openqa.qa.codethink.co.uk/tests/1735

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
