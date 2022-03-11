Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB04D5F27
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 11:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345669AbiCKKJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 05:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345238AbiCKKJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 05:09:49 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469932DF8;
        Fri, 11 Mar 2022 02:08:46 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id e24so12118082wrc.10;
        Fri, 11 Mar 2022 02:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MtTc6ORFeGZwXVwFyTMld44sHdzomnrsBg/8msyyWrw=;
        b=iHKBpZcOYrfgdvK1D5P+bBlPh3tN2j7aXH7Xxx9mgzpU8qJUx3a2TKOCOUwE9BS9DP
         twSqoMCTEx1Fs2H0J5XEeUuB4JDVe0WL9JSO2B1dKTdYm4QMyHe/6krNsNISRAY6RM81
         B8k7jZguSM/9VBd4lT2Zg6Da6aa/HwwN1YPNXUoV0RVNfTK3cUGsGwNKNN44d5I+oRzU
         Io2WFP4uOAP4a7EhQZdZ5D2I/C0Jy72+RIN8MkTqWxwpH92btXntGCMgeV0eJH7Il1vv
         6gPg31aPQ2tO0RXO8wec9ebwHP5LlFU8f/RJupnrUAfMGRVaSF9CGUUuDFMBCa/Q9Mx2
         Ms4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MtTc6ORFeGZwXVwFyTMld44sHdzomnrsBg/8msyyWrw=;
        b=fSrJvqyeW1pcSOXc1VtBv9ouUieBNVok3LneUIH4+mJVZeESd4LjnVzRwXn5zGb2Hb
         nhNQnGT3A4sEBjRTdkW96Y1QSCc4Yo4uUQh/KYwAABXhihd4QDMVZbN1nSFFj7NAvi1R
         62WjUL1lQvulh1kIEkIMcLr7VCwgfHjzrHECJZwxISLv+EVDtk3vGk73ItAq5uxc8ON7
         oVKo4Ya7gj0NdGBbIqLVG6+FLPyx4rs/oVviNgCGFOjJl/fiygN4PpljZ1rk1GJf4eJN
         HTHgU+RDm4CzFO+7SBDw7eUs3QzkelVt/KKmRpU6m6aL/dKIAnqmqFps/hcjtTcQrE8l
         O+ZA==
X-Gm-Message-State: AOAM532EJZB47hKr6jrLH3Y8UzjE/wRWS+FZAfa+unpgIZAP8HRjCToL
        TN0vTo9QVLwMH4U0hD8crEM=
X-Google-Smtp-Source: ABdhPJw4sj9LRc6yomVZnBo2Lq7NUXjb/limeqn9FrdTNh+vj07yAFOQBuGyH8ne9i5NmSpD6VO6mQ==
X-Received: by 2002:a5d:43c9:0:b0:1f0:5f6a:30a0 with SMTP id v9-20020a5d43c9000000b001f05f6a30a0mr6539816wrr.274.1646993324784;
        Fri, 11 Mar 2022 02:08:44 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id v12-20020a5d4a4c000000b001e68ba61747sm6210306wrs.16.2022.03.11.02.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 02:08:44 -0800 (PST)
Date:   Fri, 11 Mar 2022 10:08:42 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/58] 5.15.28-rc2 review
Message-ID: <YisfqrlO5UnT934W@debian>
References: <20220310140812.983088611@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
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

On Thu, Mar 10, 2022 at 03:18:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 62 configs -> 3 failures
arm (gcc version 11.2.1 20220301): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Mips build failures were reported earlier, and it needs:
e5b40668e93 ("slip: fix macro redefine warning")
b81e0c2372e ("block: drop unused includes in <linux/genhd.h>")

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/863
[2]. https://openqa.qa.codethink.co.uk/tests/870
[3]. https://openqa.qa.codethink.co.uk/tests/868

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

