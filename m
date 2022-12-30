Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296F1659ACB
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 18:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbiL3REq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 12:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiL3REq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 12:04:46 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D736577
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 09:04:45 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id m4so22433618pls.4
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 09:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rp8DP41XrSw0rokxDPlHiL2vJVa6DK6lhh3jR60QHzQ=;
        b=jQCEnGalnxhHOck1mpzCJTxyEOCEGMM0VObMvYaUwQc2WXxbmcxUI5KtICtKtBGnl5
         g7fyRVxFBJ+z9pjQZE6R9hiN2jSDc8G7vqObk/UDfqKKYnry4EYpkNudJSczMIJYbQGW
         pnqkBL+bWSkZSOsEVUmbf4c4QodAjzr8OgJGzLmBradO2skjYwSOv3cWngR0knKEeWok
         hSoSyEjWF+20dxo3ZdfNhaDBytq2A6G3SttD4KlLZd8D0FaBXicsFioM7RlTX37F9x12
         6UEF48zrn7hR1O086VTgp7fjZn8av6gvfn/NFNYUkId2XNiC+ocU1rXn3UYxa3idug57
         /Fiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rp8DP41XrSw0rokxDPlHiL2vJVa6DK6lhh3jR60QHzQ=;
        b=vMT1XiilSsUdZe2AUg9h1blAQjjc609k/3GnIwZAWvPNzUbL/2CVX2OtHw0Rx2Ir5y
         tVKDjIT2O3wagkVM5Yp4HTdIZ276ap5rdVew5q5vxSSpiDYfLpwu0e6K22O/jOGyikNZ
         Wkdmhc2iL3Cnt1NFLQR0gLIRQl4kFOCCuS5zkeVnB5CdH8xISqIHLBmZR6FnfXFrkhTW
         ikgbepF0Azrm+rld10H0kxyqP4QHGoEBN3vZXmepts12p8g16ARDPusBR3rYHbes7aJW
         aLOG26eo3iaEDF5Y1xl3B3NV0OtHhvjXS2KSSOKgh6kXO6lDmpDJV+spr5jsQcH3qZ80
         p1QA==
X-Gm-Message-State: AFqh2ko+pL7qQh8C1Mtn60yv5bY3Osdd+f+0ccYQ6N2D904DjTorg3K9
        k3ju7TiO+i37wr8SnU5Ix7PX9nJAuidEV0FGajjeTQ==
X-Google-Smtp-Source: AMrXdXtX6SgWkB8eYBoy55qpzn+bUv9TBTVEu1B6SElDTvzpS2nx6LNeZAYQfbA4yR9RNC/dBQ2cDlWs6+44t/eY99Q=
X-Received: by 2002:a17:90a:af91:b0:219:536b:41ef with SMTP id
 w17-20020a17090aaf9100b00219536b41efmr2903859pjq.71.1672419884549; Fri, 30
 Dec 2022 09:04:44 -0800 (PST)
MIME-Version: 1.0
References: <20221230094107.317705320@linuxfoundation.org>
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Fri, 30 Dec 2022 12:04:33 -0500
Message-ID: <CA+pv=HMf6-d38AJLm4_gO2NOW9SAPJO5uBq59ga+SVFsexOQ1A@mail.gmail.com>
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 30, 2022 at 4:49 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.

rc2 - Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
