Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A117659ACF
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 18:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbiL3RHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 12:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbiL3RHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 12:07:46 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E9313F7A
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 09:07:45 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id x26so8567900pfq.10
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 09:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3620dnlzLPDYDwJfxZUNq69cyA3CsvU2Mk22dUrg5ro=;
        b=Jq55x8gsEAG57CDEijJ905bb1zAl0AJPwF2Ce+V0wOhzYjHpaD1ZAoIveu43y7129z
         GA5VfjbOZTAnrRrYBqwdBxdwl1bSgC6IUjuDXXFvuEf/gWXP3PHdmU29dR8F4drTugpC
         VuK66mAQFy8UQlhQ64sbCWeiesWp77/2ipgZ+uxZoc2+V6Q/zWTQlgMk0bLiKbFT5xCP
         xRYo84WuBx+u7EdYWJo3xteNFiJjMnN7WI2qDbIUYJUgSFb3vIcEhpSUkB/m7ipssufw
         3WB1VSUutjYDVfbsF0UtKglAulV/qGVuVecTjJKaMTHq9m82Q6ubFW9hzhPA7/4QXwet
         CMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3620dnlzLPDYDwJfxZUNq69cyA3CsvU2Mk22dUrg5ro=;
        b=TeKKneUaTrYHb5IsQ9RuxX86sgaSmIOqxYG+6qhcACMX71h0t6JLwk5RLmm6wnbJL7
         nlIQTXGd3zdAhaAOdsHKiH4DSai6xf7zJy65vcInUNakjwsJpQ9yP6EigtzJXUuKk3fX
         H4dmJUE7hO2QsibLtyAipr1uFUpW+wBqMywL9u4/RvTWngBXg2jodzCTG3rutqjpga2p
         gUesOW0xUvZvfmXnVOJxRMoBH7cM/ZCzUGWb3diXBe976q8OxN9WApfVdhz7OO163xr6
         RNE8NewSL4ipec2m49zHo+F/fWg2EY/CbFao+NZfVrUa9e59wkTrl8QjtkZR9wEPPd9u
         mQ0A==
X-Gm-Message-State: AFqh2kpE4z+uhA8eA7BSYUHarYW15lAj01QQSlFvqKeM+w/xdssCKB6O
        ffsE+GDEyetXmB9TieaUKRuvEnPvl8j4ujAAJAyOcA==
X-Google-Smtp-Source: AMrXdXtSAyzbSBZuKm8FlmMoiULn24O7nbtAHpbFYhAwM3N+RFY0Cc9g1PNF98IadyaN8TMoxLf0Raa/bAm+FuCSmrM=
X-Received: by 2002:aa7:8887:0:b0:57f:fc4d:f773 with SMTP id
 z7-20020aa78887000000b0057ffc4df773mr2011406pfe.3.1672420064853; Fri, 30 Dec
 2022 09:07:44 -0800 (PST)
MIME-Version: 1.0
References: <20221230094059.698032393@linuxfoundation.org>
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Fri, 30 Dec 2022 12:07:34 -0500
Message-ID: <CA+pv=HNdA=c7W+J5PbKruqph1Y4LBJ-VcV93rJTwiahjKhgX9w@mail.gmail.com>
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
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
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.

rc2 - Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
