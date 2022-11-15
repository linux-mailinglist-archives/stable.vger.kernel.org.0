Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF285628FB4
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 03:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiKOCEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 21:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiKOCEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 21:04:36 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B1A6151;
        Mon, 14 Nov 2022 18:04:36 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id c203so1652659pfc.11;
        Mon, 14 Nov 2022 18:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BM+g2yW8tQwEmaDNgyw2ipzOWbVkTd7NC/d4eDjEaow=;
        b=XiETaPy1Kamv7cV3sL566lV6zGXthztq//TxWGhrCIyTX3LDlA3dd9yTPI880SU+vk
         2gVjUXQeMKRCGWp1DKgSfCgQLRKXU2Tp0YkkveXwAO+mYjzaFR0NRj6m0PkUniDTv+6t
         +uX83VZaEtxTKWc4Cb7ujEfSJigDcYvq53Ng4NJsgxkF5ABdo5EWRIuZEYhNgbqx9JOk
         nCmXB29GxouXPat8/IM545mXof6vX0pTA6SXy1ajToEeXNPPjMzNXdmZeuw00ZKeofTN
         2DvpareWVLcbV1mMPPryRRswJWD+siLQgggfJKbCxRUTmy7Wu7adPaRAIrurQce0bVZu
         8Elg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BM+g2yW8tQwEmaDNgyw2ipzOWbVkTd7NC/d4eDjEaow=;
        b=LqCoCr39zBqbW+A8vWVS/+/j6rjR+LTVtmmj/VVkagLxvY08z9ngsx/6jIHoKb7Yhf
         mympGwNvJa7/xGixMegpfuWNn7bZAXi/zWZJI+J25Kea0I9DaTomLyNKzTLGbtOMH1+b
         KgWsKSrqUpZ7NmaMbXU/QPmkDbuRiwMkllXkxBxGfFHWxFhjcZUii68aLO45KARsNjkf
         TDvZFqUcVffwycnyKBm/YoAhK4+sbs0khUgLILhAAx74zI0eHzFGkth4+Tspckfw6jW+
         S5n1AsRS6byvFd+3b7FQgT3kqp9G05Mm7x3jLjn23/2AU+4NOxpd84NuhXsxQYNFbU+d
         wBRw==
X-Gm-Message-State: ANoB5pne0EGKPIVMG/PZaKb9CBM0G9AwmvU1KxhUgDut3LBPrjIzt/02
        P03zC60u7wlc7JLrHQHPDJGE12xTyg2Qv83Q3EovJgCfVWY=
X-Google-Smtp-Source: AA0mqf5l8mX9I5vsR3m+80cKKvzc7seOVc1WKYFUsNxNP4aUZ5OwI1ibgUz/bFPlS7r0dkBzg53vMP+fRjDF512Hfe8=
X-Received: by 2002:a05:6a00:4186:b0:56b:d951:67d2 with SMTP id
 ca6-20020a056a00418600b0056bd95167d2mr16233532pfb.55.1668477875409; Mon, 14
 Nov 2022 18:04:35 -0800 (PST)
MIME-Version: 1.0
References: <20221114124458.806324402@linuxfoundation.org>
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 14 Nov 2022 19:04:23 -0700
Message-ID: <CAFU3qob7x7OnrcdkSi2B3UrDS74ONQF59GWdz+Nq0as7wEyxQg@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 9:56 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

     Total time: 0.816 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 9.507 [sec]

       9.507659 usecs/op
         105178 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
