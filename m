Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F814B5B79
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 21:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiBNUvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 15:51:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiBNUvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 15:51:31 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E87F16BCDD
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 12:51:12 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id e22so1133477qvf.9
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 12:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l8oDDwvFNImY/VPR1iI+PTzO8EFCV3s3KPhPnO2c9qA=;
        b=rI4JOyp6IV6w3InslglP235o0EtoDitOmNELyKh8B2Up0oGYgaVOWRXqwKiX9TLfAz
         N/2ys8LUy0o18leOKmEw5jJ3DEvqQYHy3xxsiT2o5zWvHUved3MSXP9mu3GborQQtXay
         ISMq80DJ8Ou2f8/XmrMyr+/+LX4XC7wfhRYHA3Ja3a05N56J8PQ19wNBPzb0VM4rb6hU
         P7mxRkcgf0GCQZOnt3HteIoUDNo5wKZ1rbAxOf1AuI0pDIFeOk/FlgLUM9SCZoKhrujm
         yQxkuwheZRelQtdwNZ4htfATDkm299zk1VFn16AKkKHIRFeaDzwwkeeAQ+HmljxteeM1
         t4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l8oDDwvFNImY/VPR1iI+PTzO8EFCV3s3KPhPnO2c9qA=;
        b=tAF1zKE0KOFUWKJQXuAQTt9Z9CH2/tu8LeXda3356ak1Wgdbmri0mhj+BeoNE2SB7M
         jo/7bpbthaYzXWD8u8iFlJU1XuMAfv3e/McmUGA0XOzjcsVLq0aPgd0nkNAnJ7AXxmdD
         EZPvHKsvUhMWu/4EmmB/ioNRtzZ/lagdrR5G+uR0nQG5JNue3CZU+0SVnl9FqavjR4+D
         y5GWG7QW6vDDQu6KFaKup/F/tiZI60OojB97/NnY53SFkjKxKy8BNRP2croP7EpA4ouP
         f9Wndfsft41f01yHrPPUip0pwK1384lxJ0oG3fPRozuDsnVXlDkLMqkfsZz4b5KozGBo
         SNtg==
X-Gm-Message-State: AOAM533lPaj8M/Ntg3eqwpNwlP6R1oPr70N2XdEakyWmwMv71/ZjNndX
        qedkNWdBD5rg//h6tPZ52w8zoTEQHq8VaVq/Id+L1TXkbecPolg+
X-Google-Smtp-Source: ABdhPJwrV9PAaE833RQnSzliybCzTGC5tXIZJBODdZdXtN+MdiLtf7qksrvTJNixCwaxHomIyGnU/PinBMcVwG0/VPE=
X-Received: by 2002:a67:7206:: with SMTP id n6mr51013vsc.21.1644864661852;
 Mon, 14 Feb 2022 10:51:01 -0800 (PST)
MIME-Version: 1.0
References: <20220214092448.285381753@linuxfoundation.org>
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Mon, 14 Feb 2022 13:50:25 -0500
Message-ID: <CAG=yYwm=7zS0k9VY+Oie18LtmN1jemV0AP778+s4+wR5jC6N+g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/49] 4.19.230-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 4:37 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.230 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.230-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
 hello,

Compiled and booted 4.19.230-rc1+  on  ...
Processor Information
    Socket Designation: FM2
    Type: Central Processor
    Family: A-Series
    Manufacturer: AuthenticAMD

NO new regressions from dmesg.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology  -  autonomous
