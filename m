Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678895F41FB
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 13:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJDL24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 07:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiJDL2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 07:28:55 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B19F2BE17;
        Tue,  4 Oct 2022 04:28:54 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so7357646wmb.0;
        Tue, 04 Oct 2022 04:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=69fcJP8hlczmZPtCin2sq+jHrTLn2yvOkJ0a8TtQZDI=;
        b=C9GL5wE2u4dtEDc8tJYYmUmx+Cq2yRiPPquIjkCYHeQxYlE4/SLs/vKpA8ubKBstKv
         wLwrxDgkYoD4U8gJfVwvhWCCGQyUZEXVIImQccjvJ01dCC8DSVKkXpdZhx1KRBB+u5eV
         tSqVfXfTIIB3ovH0GlLFeSqXIqt1jZv8UCSddhEiSNfdO0BemWUTle+7OPJ9dNWZjECU
         +cQr6ZVep2xBuAfrta2sS/XclOw+ibX9hsFQa4AxlAGhvPxIfmD4rQZjpHDmRiUet7dP
         nv8Y2mFZ7iZS2jGJyysns3phnWLZrr1ZgWtuUpSjjHYrxXOOIRKKJSUhSlwvPJnWsKFl
         A36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=69fcJP8hlczmZPtCin2sq+jHrTLn2yvOkJ0a8TtQZDI=;
        b=Fpb6MlNnpf60WcoW4zGbikULL1KuQCmLTVtY+9CH5zUGxSLavzqkltbN2TsovgCSGj
         sEUT7zdTUltBUghmysToWd8TBAjfAuZEPsWzX8P43AU4vrLBEVgZ7558P8XBu3VadwK7
         +g+Aq26mUaVXW0kOoOsAISwjKHIgCvXvD3d0J111VJx4flvCgfX1dxH/8yrqltNC3Jk+
         QQ4bgTVk4ivHlonkwD7onPFXC3gLPBJL5Jzab+bQ4CGJ2+Wvd0/G5fZ0xRIXGvol9Hzi
         1BUyQ1I8IiJEExoytcbqlsYkJyu6CLkM+LxpuYQxYSJ2h6jQhCh1GVC2WjPACW95Gm6o
         bLZQ==
X-Gm-Message-State: ACrzQf0Hwq1kkDpxTsEah3Uopwx28tWLCkaGpyTICYZHnDB0BHhlEaFv
        5hRZVD6T3nchEkhXLrXwWDk=
X-Google-Smtp-Source: AMsMyM628Vvqdl+glkFGp/n/wM4NuWrp5hONFWgkZC9W9NK/MXQSKy7XmaZezVzEeOGMrukeFnlRhA==
X-Received: by 2002:a7b:c00d:0:b0:3b4:6331:2fc5 with SMTP id c13-20020a7bc00d000000b003b463312fc5mr9710641wmb.11.1664882932958;
        Tue, 04 Oct 2022 04:28:52 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id o17-20020adfcf11000000b002205a5de337sm12235107wrj.102.2022.10.04.04.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 04:28:52 -0700 (PDT)
Date:   Tue, 4 Oct 2022 12:28:50 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/25] 4.19.261-rc1 review
Message-ID: <YzwY8mrUVq4Ucatc@debian>
References: <20221003070715.406550966@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
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

On Mon, Oct 03, 2022 at 09:12:03AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.261 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220925):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1943


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
