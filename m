Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F91032EFEF
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 17:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhCEQVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 11:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhCEQVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 11:21:53 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E91C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 08:21:53 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 18so2473544pfo.6
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 08:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SMMBxMNUu3MAiU6Qt2jI27SColoXsDWBzorElkPsn3I=;
        b=vOr7odonMmnDkSyjPU3F3a46o6AobPZCeMZl5p6lOQJJQc0DACijKHYsjquJ72ziB3
         Qo1XUT4tah74Peo0rbTVsaFbDEGuR4xY0NeHfC+eMSflqA0xbiHbfGFoSJ8XI6xWbztE
         IF7mwlCqFc97xXUfpiezuVvbTkhSpj00Tkqrx6VFJFK6iq0wppQCEIGut+OhkJjopVrw
         Kzz9+AWHB6+7Nmwov+sReYDaMC7T0oZstPABkN6cRJuxYVdW37Z04xhnETTPwHyH+swQ
         ThNuNrl81yyv3qg+PEcltKcuCYjurChMps+akM9zfs30FTsXh+j+G+5Fk4iK1Edub09h
         X5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SMMBxMNUu3MAiU6Qt2jI27SColoXsDWBzorElkPsn3I=;
        b=GmvU5KItCXy9X0/LidFTuZAUvYAfYeagwpbGiUHiPMD7ZnrOwTbrzk2nDNeJCHwQ38
         WffUguHclPO7Oxr+bvRj9orjxmQYIV3edQ1c+aU5o1fpsLcFlHmHKP5Tnz9Xgq2+8BNM
         tWlPKUR74r8SFiSc23Lrqr3uU8c/iS9iJqiebj9MiLXzde8hF/BDON4IvusiEEfkHonD
         rFMnzTqAblBHv7X3z/IpcgG0dE5G7+f0k7aGbDW3URLy0ZdeEjCvjHQHr5X3UxsUdEEO
         mqV+/MVHyUliyN3ns0peI6JdQ1KOgc3alQF9lLciLATEZlvH0HRhPkpzZdEHiixlbv7w
         gWfg==
X-Gm-Message-State: AOAM533uakiKfHhvtY1N24V4JGMWw+oVXjTlIRV67rpSRgUKtvDqJh/a
        VZrxcPUx+jxQkw9yzQcCcDxebOxcRRNGHHd2
X-Google-Smtp-Source: ABdhPJyruirLmrF+bsUsV2VRAt6FAnb4qlvGdEq3WVIOxoFf4mB6TSWy9Jf2usDtiPrGkSVEzwrKSw==
X-Received: by 2002:a65:408c:: with SMTP id t12mr9322973pgp.157.1614961312591;
        Fri, 05 Mar 2021 08:21:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m6sm3124186pff.197.2021.03.05.08.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 08:21:52 -0800 (PST)
Message-ID: <60425aa0.1c69fb81.3d10a.7d9b@mx.google.com>
Date:   Fri, 05 Mar 2021 08:21:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20-99-gd1a9c9965c5f3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 102 runs,
 1 regressions (v5.10.20-99-gd1a9c9965c5f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 102 runs, 1 regressions (v5.10.20-99-gd1a9c9=
965c5f3)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.20-99-gd1a9c9965c5f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.20-99-gd1a9c9965c5f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1a9c9965c5f397cafc4a5fb46a82ee78a7322bb =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604229795bf5dfa33eaddcef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
99-gd1a9c9965c5f3/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
99-gd1a9c9965c5f3/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604229795bf5dfa33eadd=
cf0
        new failure (last pass: v5.10.20-98-gee8dfc889e871) =

 =20
