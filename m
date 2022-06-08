Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC09542602
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiFHDgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 23:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiFHDcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 23:32:35 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7B6213ADA;
        Tue,  7 Jun 2022 17:46:50 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-fb6b4da1dfso7363953fac.4;
        Tue, 07 Jun 2022 17:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tXYidA8VDfxvhdcHEuIlZC49pvBdaBEEKy1Ad6GE4Io=;
        b=IwzVh+D4rO53yAnXg7I23+gp/AkwZ21RFWEzUiDBSWiEZtGxKRMdgCFFdkRJAQ1gDp
         FObCNlaUyndH1oJ41sVL3JUs9bDXWEvA4OGLqFHE0op/N/tzcyxemh4F7bCxoNEfhrus
         fCuAbjyD/7ql477TYlqLNnnD2ZxcGMyrcebDPZCT1B2RPMKNK5fWJGLoJ6ZkZIHDRBnL
         vE2lJH99Re44DcdbocA1hrz2XwLHb+rb12zZkjf8coGYshftfWRpbpFuRLF9K/ml7RP2
         g2AC9tMiiZ/xTZtRyTQIO+/h9pi1r+jFdtxFCJZczD11cN1vrzufikfoc4RCwALpnXlS
         X8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tXYidA8VDfxvhdcHEuIlZC49pvBdaBEEKy1Ad6GE4Io=;
        b=CJ7FpUfTmEUfmyr4TOi1yHCqTxlc4uF03zfkeUicVUJrM9W2eG+9XbexWkKU6DY3TJ
         ynGgqjkioc1Wt7Q3Sg8vfbjJVxSrMTSmEPM915BXepXZq6oJwBlKpmkyeDz7WmcGgsXL
         yRmb6l6TI/RhpI0aTcKSn8EXA+HUR9zVYlxy/cMtNnGot6+kvSMbESt1BCDyCHTvb6cv
         JcKFNIM70Sw7PZCvFjzfH0TY0VnyISBGtIysi0P9pXsYnmJtXVtY1cLlCUSapL4CqmP+
         pRJLOcVs9CcvX4RJLAZWtQMLdq1uW27GVZyIw4xBuyYjG3/X5zUclIJur5iBLEzRnpT2
         8DMA==
X-Gm-Message-State: AOAM533AjoUbIRKoZ3y+/BNdAtqKSUW4l5c1NxZXnNTyt1MN2rcxxqCO
        SUuutLZw0eSKFhyxyda/5gGL4MZOfzb5OHRzFWNtcSmJx7E=
X-Google-Smtp-Source: ABdhPJzsiyyT0a/wcX7mRq7Qfc6++4ukMzzGme7X6ww2A3riCUeNvzyT/tWFhveufeNJ21xJdQFcrxzPMIEu7xoVYCg=
X-Received: by 2002:a17:90a:7023:b0:1e8:a692:b3e9 with SMTP id
 f32-20020a17090a702300b001e8a692b3e9mr5843943pjk.176.1654649144240; Tue, 07
 Jun 2022 17:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220607165002.659942637@linuxfoundation.org>
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 7 Jun 2022 18:45:32 -0600
Message-ID: <CAFU3qoY6wAXvtyBqBzNERwfp9zAT7aCsdtdmcpUpUKV48j25dg@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/879] 5.18.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 7, 2022 at 1:32 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.3 release.
> There are 879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.447 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 10.055 [sec]

      10.055368 usecs/op
          99449 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
