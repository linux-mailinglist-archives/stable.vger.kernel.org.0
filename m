Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F475EC09E
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 13:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiI0LKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 07:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiI0LKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 07:10:03 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAF215FCF;
        Tue, 27 Sep 2022 04:07:43 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i203-20020a1c3bd4000000b003b3df9a5ecbso9217288wma.1;
        Tue, 27 Sep 2022 04:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=smELam+C1mHa7hXQtmvCHgerOjDPN5Eu1MdsEogTVL4=;
        b=WHDHOLUskSYxI6OtHna6WkG4ZsdiPMZgoHWW59vhUGVMc9Sok7d6w9my6meROtWTDU
         SobXOG5fvDTv7PLHWrBi2bpNm7FlKmg5i1RZp1W8QKqRy8sx0LIUn0JUzOIEBURLHGrP
         YL4dxfEHVcWmxGHCnLtXlI9aejMl0IsoK0I3wiB6+BkxNnAxJTa4MshBlEQxEeTm/Z6S
         /9sqGoA10ystdaQFUrm4BNmf+jIaxVPutFSPmIaf0pMypufpLQRHMdeAz8VuXR66kYw7
         Z6CTGH82iDgsn5dS80w+aM2GCptRXZc3yQDj1TeIgpygSrB0wx3FmJF0XKzbHkJ++pVe
         xNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=smELam+C1mHa7hXQtmvCHgerOjDPN5Eu1MdsEogTVL4=;
        b=EWAf8E0koK/IgQj0tK8WEcbnA6CSHoZAnkKeQNfSMR8O9kS0zgSphP1MQgn5CJLnEY
         ZoCYQY7ZQcAlb35NaUiT+XLhnKjysYAHTRFeEOjPCh5Ljvxi7q0e6aE6OX7E141YaUaS
         JQzf+YL6FvKCVPSdGMtF7SFhwlgD25VAncrG/2TVa7BgtrZQbdToL2paBGvSjQwgRpZH
         WLc8Xr3qdv22uW+IGVHFhdKoKsKzFGmSTO9w6eBEPBuMcPOPx+Iqg3iUJKP6lWAsEYsF
         NGz+TeIDmJxHTtCeoh3laVgqDScTLx+T6aKqF+4Rifze6w2I1kD2Bih3WlPeQ41hag7y
         LpyQ==
X-Gm-Message-State: ACrzQf3CywYLjMniDJ1EmSye44meRxcqLdtTsY3FkGxQa63gl4Q6584t
        040nIk9Dxhangpy+hUPF9nQ=
X-Google-Smtp-Source: AMsMyM5OBk64pwJp/ay/FZteOoCbSMmNC50uCmQwIsZclwfLnXD16ZJck6Rm1g+X7MY2WuvO60PGew==
X-Received: by 2002:a05:600c:4f07:b0:3b4:a5d1:1fea with SMTP id l7-20020a05600c4f0700b003b4a5d11feamr2230885wmq.103.1664276861911;
        Tue, 27 Sep 2022 04:07:41 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id b13-20020a5d40cd000000b00226f39d1a3esm1513849wrq.73.2022.09.27.04.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 04:07:41 -0700 (PDT)
Date:   Tue, 27 Sep 2022 12:07:39 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
Message-ID: <YzLZe5ECd0E4xJKa@debian>
References: <20220926100806.522017616@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
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

On Mon, Sep 26, 2022 at 12:09:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.12 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
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
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1907
[2]. https://openqa.qa.codethink.co.uk/tests/1912
[3]. https://openqa.qa.codethink.co.uk/tests/1914

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
