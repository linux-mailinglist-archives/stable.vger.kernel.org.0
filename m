Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E6B66A1B0
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 19:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjAMSP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 13:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjAMSOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 13:14:44 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E946ECBD;
        Fri, 13 Jan 2023 10:05:50 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso27812051pjt.0;
        Fri, 13 Jan 2023 10:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M7NMAvip3vfz223F9hHO3sbLI85Qz2jNvsvM/QRqJNU=;
        b=iqHyBtfue4/l/adXUxuM1ma0e2zNIFivmoKfdBUu8DuvMIBMK4RQH568rclP36h571
         xbUd69mCVySJwkJuap54Fm5zUymVXHEYFEsgDoDWKpMUwt/YZ3haOY1FsU41hp24vwOn
         LgFLq1ApaifjvcaPbJeAH5wA124yz5AcDlQ48eX1HKrvZK/Rahmpj5vIC98T4T4n/558
         vpRaH+GVk2qVrB8mXcOdiLonIrQ3PPJpkZzdNCtNXCIPZhQ4y+gd312MF6JHYrBblPdH
         4Cpwt2EWLnJtBnoA6P2XBoXRDIiHDb6pFudSObGNuIuYB2GPm1Fjw4yf/8X6083sLrh9
         m0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M7NMAvip3vfz223F9hHO3sbLI85Qz2jNvsvM/QRqJNU=;
        b=KbN+KO+ot7T2M6u4C7ukeWkrb/Kxgveqk4NkvjRtwdBd5PqUW8II7GX90HRdiwV5tt
         mAmUcz2PsDrZkHJ2BfrkAA9V7I8gDucCbMgwliAdx7o0z1ck0ZkSCcLVVEY4gj2LSj9O
         IELgZdN8wX5nxqbSNQCK+7xdI2pvH86NAHClWnHRXFhu58+k4O64ESxnqlHzuMq6cPKF
         UGmbF/wd5wwOowALCWRaBMt6rc9YvAIX2JEpPPYW+9ud5Q0FAtZq/T+P9zW2JfO8lQxV
         CqQTsgruVbPRgd8djdDDKhwGcc9jildISMAOT3ynpJaX88iyE2lB2kDV4bWDWugtzZff
         clNA==
X-Gm-Message-State: AFqh2kqAjkKdh4avlmYh4df8UYONC/gz+wW0Jzvs5Hr5oYngTTqiETO0
        CvsFKpEDz9QZ6/Y75EZzbNXfRaa4IyBevpcf4wE=
X-Google-Smtp-Source: AMrXdXvTz/OR/mjkEDIh1uXTetfqAEHYND8ZDBSaBkZQnGWp+cLVTgiovs6DZV4YTmL+MF8tCi5WLKHNuqd/PVImRZE=
X-Received: by 2002:a17:90a:1a13:b0:229:3009:5233 with SMTP id
 19-20020a17090a1a1300b0022930095233mr223463pjk.213.1673633149684; Fri, 13 Jan
 2023 10:05:49 -0800 (PST)
MIME-Version: 1.0
References: <20230112135524.143670746@linuxfoundation.org>
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 13 Jan 2023 10:05:38 -0800
Message-ID: <CAJq+SaBg0D=rFPwG=FqPE-F-p8ujiAX7Jt+vJb7HjeLPQBfQnQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.163-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
