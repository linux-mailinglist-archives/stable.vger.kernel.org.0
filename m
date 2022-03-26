Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E7C4E7EF7
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 05:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiCZE42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 00:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiCZE41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 00:56:27 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068043889
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 21:54:52 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2e5e31c34bfso101684677b3.10
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 21:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7vwHn5s1yIe/9wwhZyNKMD8IyMrVsk5moZFa9Z5/OHk=;
        b=F3nz4n3sMoO+AxY4YB+6iYWU03AzycAoDUkX/2EwWEgbQHUBHuYX+TOJbxuiOmj2kG
         Rw8cz9J2/gk1ZZN9u2DiK5qlR2ouub92ATJXfuqBKekV7l9YKE3Fp8l1s1WSc2ZA49ft
         BBtqZIOHIBIuLQ3/A9u3DQxYtCg1ve9IrKEQGYhXvMvvEQrDQgi4dag3duZXnD3mUSll
         246c3Yv+1fS9eAozn3JnPoJy0f1xkoIIY7gnbC1SQCwso3/ObepT2Q9QDm8RfmQ/Jn4E
         advk7zAJrh0rTRGWA6PhD//whTCXVYv7kKR1zoMU975YslKsfRgqvSsM2+bXjLC1psNh
         Uq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7vwHn5s1yIe/9wwhZyNKMD8IyMrVsk5moZFa9Z5/OHk=;
        b=C39G6YA7CEWXegtq1ksJNregCpS0zPgz0Yrv0qrfZ265ue8+QODXjFzVIC6oBim5hI
         VH6UKzAbtkDwImRGQYxmxNnOFBSMH/CPvDBugEWC0dATEsxVWn3Wk+8H2e7gWP5T6AOZ
         dBpvEBR1EZwRYR3QNyHCd+f01vrHGyRY/kIOiPJuj0hyCqj6HjicF2qS+e1TdWpRjx0/
         FoyAB3uP4kTql75pJCIYSWLxbLphr76XUDUNk886A2J/iqiw7Qo+dEaUByXJC2lIyLRf
         ANTOc5885L9L/gm17DpNjGwjHxHuX0z3Y/ZbOUps4R/j8n7goG+K7bV7xL2yoWUkUStz
         G8FQ==
X-Gm-Message-State: AOAM530Ma90D8HNoYVKnQwsULtq8aeiC0Gih7/oJ7cWZ1q+hP9NJn4R4
        cCOMjJV/rCSKufNs3lHtthH0Oz5iFzMVd2W5ffHG+3A4X+qboSLH
X-Google-Smtp-Source: ABdhPJzBLhrxu2pCd82B8LFndzD4aNwvt89JDjVWETfdEtE659Ot9knEjgw0G4JcHr07+jkNpPkwpCbitDRNLRvSzkU=
X-Received: by 2002:a0d:d187:0:b0:2dc:5d83:217d with SMTP id
 t129-20020a0dd187000000b002dc5d83217dmr14778814ywd.189.1648270491117; Fri, 25
 Mar 2022 21:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150420.245733653@linuxfoundation.org>
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Mar 2022 10:24:39 +0530
Message-ID: <CA+G9fYtayz_X5tjiCT4gWZNNG=O-zx6-GTLgtqH855RoYw_5xw@mail.gmail.com>
Subject: Re: [PATCH 5.17 00/39] 5.17.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Clark <robdclark@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 at 20:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.1 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

arm64 qcom db410c device crashed [1]

[   10.823905] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[   10.876029] CPU: 1 PID: 193 Comm: kworker/1:2 Not tainted 5.17.1-rc1 #1
[   10.876047] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[   10.876054] Workqueue: pm pm_runtime_work
[   10.876076] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   10.876087] pc : hrtimer_active+0x14/0x80
[   10.876102] lr : hrtimer_cancel+0x28/0x70


The following patch fixes the problem.

From 05afd57f4d34602a652fdaf58e0a2756b3c20fd4 Mon Sep 17 00:00:00 2001
From: Rob Clark <robdclark@chromium.org>
Date: Tue, 8 Mar 2022 10:48:44 -0800
Subject: drm/msm/gpu: Fix crash on devices without devfreq support (v2)

Avoid going down devfreq paths on devices where devfreq is not
initialized.

v2: Change has_devfreq() logic [Dmitry]

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: 6aa89ae1fb04 ("drm/msm/gpu: Cancel idle/boost work on suspend")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220308184844.1121029-1-robdclark@gmail.com
---
 drivers/gpu/drm/msm/msm_gpu_devfreq.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org

[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17-40-gfa2df4c49e4d/testrun/8704058/suite/linux-log-parser/test/check-kernel-oops-4788790/log
