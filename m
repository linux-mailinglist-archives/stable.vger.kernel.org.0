Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC60C5EC075
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 13:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiI0LF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 07:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiI0LEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 07:04:52 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA371181D1;
        Tue, 27 Sep 2022 04:04:11 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id n10so14366741wrw.12;
        Tue, 27 Sep 2022 04:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=SlT4G31LyDkVE9RdTsAk0Xmm8HNoPPrCQMm+8arXy7Y=;
        b=amNOsRyjYkO8XdkwO5ztHyAatXtUJ36hjyxKkXEp3GgfvBS93ZUhV7PFm7XbuBD7w7
         rOWbqj1TkUbjJTMQHbuGHe3CQU0/KlImGAFa/qoEtHtMFIGvzjEXFrarJI7O1+Bk4/4R
         4bogzwrj888Io3h6iNtywyiCWp/xBt/PLgfEf7wRlTCsE/kaiQ0Hf9CkOm2+Yg97VzvC
         fUyc8fBNQEZgXYRSiLAGzAVkGSt0n7R0PmhlhQjpBrYfnah9DzdK0S6nLHyA4VdS644j
         xx4EUDkR+PPSHBQRR5883yxCFAzWSCF10C1xj3BHDYspPmLSTkhqGlA23ny1pYBCcj4A
         lrlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=SlT4G31LyDkVE9RdTsAk0Xmm8HNoPPrCQMm+8arXy7Y=;
        b=SIC5xh2qR/kUD6M+4IDsT3+kWsGPefQ8pfYayY7lSt4BRYPhx8A/iXPHax7skZKLQF
         6ZGugOCYENVJNPJ96RDP7eNJk2flQiSdXn5+nGTsN7fX0a6UvGpbcT4GwIyZAPMEcdaj
         EFLakFCtheBzv4mI3loS7XGRJL4c67P6q1CAs2r2AxYsoOBKifXoZeTqQ+ZSgvBh01w3
         NplIW/OSkwIC4YFk9U42cO4NeGfDMj7ZrV4lPTRsOZf38mhtKsLD7TvyTSJ8gHHbSPhi
         En9+/4Lrb6I4FioiF0RQ5NdYGvTtZg7u4Duqh/IXTN7T08UUi2cTZLy9HowKyIPb+bxz
         QLEQ==
X-Gm-Message-State: ACrzQf3gaKglZpOWEyBjfbRxqQw4EQ6B+WemXTitqv4G+ZftVPjBlDNc
        miC3KxKMdkap2f3SlvhjIyQ=
X-Google-Smtp-Source: AMsMyM4Q05QpyOpNqR1iTDEuA5m9s5fEBIkXTQnTLe2W0fa3aFmyX5AiLtGP62/VPgs7EIZUTz1oXg==
X-Received: by 2002:a5d:5351:0:b0:22c:be67:9542 with SMTP id t17-20020a5d5351000000b0022cbe679542mr1320397wrv.203.1664276623800;
        Tue, 27 Sep 2022 04:03:43 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id j3-20020a05600c488300b003a844885f88sm1359328wmp.22.2022.09.27.04.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 04:03:43 -0700 (PDT)
Date:   Tue, 27 Sep 2022 12:03:41 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/138] 5.10.146-rc2 review
Message-ID: <YzLYjXJWQF+0xqY8@debian>
References: <20220926163550.904900693@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163550.904900693@linuxfoundation.org>
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

On Mon, Sep 26, 2022 at 06:36:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.146 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220925):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1905
[2]. https://openqa.qa.codethink.co.uk/tests/1908


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
