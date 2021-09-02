Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7463FED38
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 13:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343741AbhIBL4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 07:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245623AbhIBL4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 07:56:13 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81867C061575;
        Thu,  2 Sep 2021 04:55:15 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id e26so1079455wmk.2;
        Thu, 02 Sep 2021 04:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WKyxnRTdCOqP1eiSg/r+qiN3xAk64HvNE12FpKyGMd0=;
        b=kukCWYBGUXjiV8/Sp+gDsYW+BctWVDxuDXEbLR/FE3spTaqxEmNe+dqxFoYCmCKOQJ
         CZAxHLMUsZzQOt3uZ8IztkwKtgulfeVo/K/qQKc69vLJ+rIlOUOSNNY1RAhA4gzm7yZM
         WD24jb4T/S09F8q/n+8AaFy8Zv8BRA5NGnDcJ0R/JFzXl6LjWQqJuvR7uQCD8V+8oxIw
         yKoMkHqz4ncn27m77T5nRN+ElN8igHY5YgjKUYnQj2Ps7l+hrW1BijDBvTc+4lyzZrwK
         cMIDPc44aPm/UMRQqr7nTF27caC6RVKVIVBFjEfbX59ClRZAWZpDMTQBiEX5ISnNCEUU
         bJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WKyxnRTdCOqP1eiSg/r+qiN3xAk64HvNE12FpKyGMd0=;
        b=BTonWu9/Ex0rc0Yy8PTJDe29NgULL40MglHCDgv+kBactFqHYLe/TGuUC2haHSr8Je
         vCvdokchqES/qXQl/Og1D+Bpbhz160R8RIAT261VMBaxSTn25/s0dmvawq7gvjo3PhOu
         TZInRZW/1o7JJDLpK1spmz0O1pZHVX21DytqxUZ/9qNavW0RIlFMuw3eUMQV4NKDrip1
         rUhT4eGQlguu06xuHoP/EuO5hVf+rlFxdfe7mhMnSZ6Q4hwwMfyMRvcM1NAi+1TG4nHO
         N0p1UFsMld5/+IWl1y5+2h+jAavLaGMGrGIunGUxsp90CUm0RcHrN1WN8PaSg7AB6+gD
         IfXA==
X-Gm-Message-State: AOAM532Yw6sv77w7olRIbqYuAhQ5EmT1l5+oAsWw9HdNYVF3Wj1TJTPX
        qFG+Bvj770uGjCxMQu1GnMA=
X-Google-Smtp-Source: ABdhPJzEKxPf4Je8Rx1GtQWnbpvhvE4KrWf9oxivcy70/6OBobg4AO4A8exjR9seRH4PLTWGY+NeFQ==
X-Received: by 2002:a1c:25c7:: with SMTP id l190mr2810295wml.118.1630583714125;
        Thu, 02 Sep 2021 04:55:14 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id k25sm1740643wrd.42.2021.09.02.04.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 04:55:13 -0700 (PDT)
Date:   Thu, 2 Sep 2021 12:55:11 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.62-rc1 review
Message-ID: <YTC7n81Qoh0OHaBW@debian>
References: <20210901122300.503008474@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Sep 01, 2021 at 02:27:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.62 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 63 configs -> no new failure
arm (gcc version 11.1.1 20210816): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/82
[2]. https://openqa.qa.codethink.co.uk/tests/77


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
