Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2667B4AA973
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 15:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240974AbiBEOcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 09:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiBEOcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 09:32:14 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1E1C061346;
        Sat,  5 Feb 2022 06:32:10 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id bg21-20020a05600c3c9500b0035283e7a012so5582146wmb.0;
        Sat, 05 Feb 2022 06:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2YffGzmTy5wYwzq2k3T5w2BRK+1d/sI06kNAxHtw4ro=;
        b=mrB0msmC8b3YdKE6/o6+9hFnFudo284cpy2sMTkT6zyv91V5acZy0WxvCKFZNIEryi
         F8mtg1gco+gLp9+Aw1wRco30IAyVUXFB3SWgJgv9KOrgLjm5gED2uh9TI+AVP+wJ9oVn
         V5NWLu4f5DwFqYwc0ghI/L03CLKXKj2CW5NLf8wFOYVqAAfTuZxsr1DIrokD17M4erxr
         Fb7m9UJ53kIrys184CxqMFONc+xTaM6uPU4PfwugVMdIVMLX3cSEUFy9m7J2JMFdq70o
         IZSxL/O/OUASm9Em0STeQOZ2zA55pNqxl7crj3ejMJQXHg03G4mur3jhmigeyon6h+r0
         cLNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2YffGzmTy5wYwzq2k3T5w2BRK+1d/sI06kNAxHtw4ro=;
        b=t8zpZ3Z+o4sftUmADnIGRYIiw45ONuhuHV8mFdAKb5OXXu2pTSiSDt0iorpbwvw4Pu
         q3PNmf9F2pPH6slBXyqWjK65ujuVm/cbeDuaqfPwer6kY8ENRc1A3YQgI124sI2vSmrx
         CLp164PSwR1N6ZMzh6Qov3CFpedVtCCyxTk/WO+xfACKQmosi6WwyBAMOtGflRA7Cn0j
         pKu/qI6FVgOB+rMsMaTFf2QDYUZYzEz6HNEQwNrXjlTvzFvd70/Y6HTJ4Ecqd0LOPWsh
         u9r876L2A6/3elGZryD4A3iEKFg7nmalguAgeZC0B9MgafNmBbPfriGK8QNxnwwzi+kC
         cpCw==
X-Gm-Message-State: AOAM531rRIhmty3DXCD5hfvAHdnEucrcNpEORVm/7Uyz8+l9UEfcKDGq
        E5+AMt9Jv7jsgSb0qzJSOHc=
X-Google-Smtp-Source: ABdhPJyCn5gWUxWm+rcCr2w5jbxo8TgCRLnIsqLX0ylVvMBH780imRHeQREdA+bm3ibiObE6rEO0qQ==
X-Received: by 2002:a05:600c:6028:: with SMTP id az40mr6696570wmb.33.1644071528674;
        Sat, 05 Feb 2022 06:32:08 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id m28sm13329267wms.34.2022.02.05.06.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 06:32:08 -0800 (PST)
Date:   Sat, 5 Feb 2022 14:32:06 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/32] 5.15.20-rc1 review
Message-ID: <Yf6KZuOTEggcaOjK@debian>
References: <20220204091915.247906930@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
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

On Fri, Feb 04, 2022 at 10:22:10AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.20 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 62 configs -> no new failure
arm (gcc version 11.2.1 20220121): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/708
[2]. https://openqa.qa.codethink.co.uk/tests/710
[3]. https://openqa.qa.codethink.co.uk/tests/712

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

