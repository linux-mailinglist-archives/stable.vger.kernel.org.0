Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC1964B4AB
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 13:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiLMMCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 07:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbiLMMB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 07:01:57 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2029DA;
        Tue, 13 Dec 2022 04:01:55 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id h16so6390707wrz.12;
        Tue, 13 Dec 2022 04:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wWgHX5jSvV1MjDJOVOhUVYT7IbR7BRcjtNaxKkj11pY=;
        b=lgYmiLs9DRSQroHMfB+tDUy1vvg7wt1wThMgtVvJGnT0j+vjddHyIQH+jyFR9V78Ca
         f05Q7FsNlE2f6BqxFPyD5/9qtAGcNDfBbXixKh6Ylk+mrNfztrnRkVz2x9rDZdHf7N6r
         7qIHyceAarUWdm41Kp1mPQnbPkycix8wzk/CiBm72PaykM653WabDtvE/sBqitqHyGVs
         sd4Y91gmaWYFW/KEG6B97gpyxOemKtXCK/qfeSvGs4o5QlcbLO4amor1fKekyixGfJKx
         pUiDGxbXysTD5CbN2aHCVGRt+lHkJXdAU0PSmkgZgjjjxRbOqUuBC5z342y/E+jPGLLS
         Pkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWgHX5jSvV1MjDJOVOhUVYT7IbR7BRcjtNaxKkj11pY=;
        b=QfTCH6naznF7q5c56dtVRRj2zRS/OV/wBM2pyQSjiLzByaYohkB6/srsaEwhyajyYv
         3G4yftHIpkfETF9iDh/bBlSsX3mw7FyoNXYLUuBu1c/jhRQUNOQvumsvcAMclkisv9Hd
         G+XOIyl8F4NPwBfdloWSyb8jDG5yOvd9VoRIBelvAMuFwpLeU+lQRl3pnOfhx95p8whV
         XR4xy2OD7BYDZxhnFo5xvVZ8SvD2P+d+E+P4sCewuGKXq/uURAms6MzfNa47YRazgG9A
         fVNcLSZJm7kg43jHMgp+Rm6OFaiNWKUoYxil46TnC/iw3/WVCHwb+qgBzc3L8RBdC9s1
         JJ0g==
X-Gm-Message-State: ANoB5plol2vOZcWVA973U7NFEm9ttU2sKyEweLtkNSooQwoa1Noe992a
        tGu2WVM1ff0Qi+me3/pzwkU=
X-Google-Smtp-Source: AA0mqf5PIQehlqf74gHW14tkOANEmMt5P+hf+taoWEFI7yC/WYv9WTXiydndr4vBCWKyuvKtMAUw9w==
X-Received: by 2002:a05:6000:60d:b0:242:6777:c7e2 with SMTP id bn13-20020a056000060d00b002426777c7e2mr15899554wrb.31.1670932914337;
        Tue, 13 Dec 2022 04:01:54 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id i8-20020adfefc8000000b0022cdeba3f83sm11583454wrp.84.2022.12.13.04.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 04:01:54 -0800 (PST)
Date:   Tue, 13 Dec 2022 12:01:52 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/49] 4.19.269-rc1 review
Message-ID: <Y5hpsO3WGeTRvTuj@debian>
References: <20221212130913.666185567@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
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

On Mon, Dec 12, 2022 at 02:18:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.269 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2337


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
