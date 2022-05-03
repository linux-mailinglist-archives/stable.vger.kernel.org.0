Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C96518102
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 11:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiECJb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 05:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiECJb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 05:31:57 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2112B34641
        for <stable@vger.kernel.org>; Tue,  3 May 2022 02:28:26 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id j70so2689870pge.1
        for <stable@vger.kernel.org>; Tue, 03 May 2022 02:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=smBx5YNt4p2kesC+QqMf2KfwIi9sdP/k4ZDh6HLVRXc=;
        b=Qmn2FuQt2LzsLjxjgTQ8ZLHaHKTCjDwfDjGBRIbkuc+UtOGySlttA8qTIMFyWF9b43
         tyxZcRPEV3Lkwf4YZdRQKJeLRoLMe0lvqRwqwPfleAr7zjSZWtHaiTvEvTTVaa7EqzQ8
         /GQZXGNlSQxdZs1AnaH9w7zlSyYkTgNZ8BCgUtGIgmsO+MO8nzJUOD2Z+WEsh9oy2clu
         6cHHkMR2NlMqwQ+btUup0yVufx34UBLYN7Cu3wBpWEXtg/dcqR3nPCtCiK+m6m7fMA9Q
         C9TeHUYotKGNEoow70wecmNVTweiTaTdYzPXp0QbWoiFV5Sdr12QK4Ttc5lmrV4RFhBH
         jUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=smBx5YNt4p2kesC+QqMf2KfwIi9sdP/k4ZDh6HLVRXc=;
        b=ukvFOcNxTdzV16JtQbs8NUfmfLDXV3WXLerSQvXLNdbqDbH/mkUmYzoS98CYCM6Fky
         M4J1OxGD98F+tBUTwKHPkfJiywo96fQnxAcOok3Eh001ch36CeNujupAWoRtW8oJM2S2
         NCM7xwUjij6kpLQneY17YaBQorqKEpLfSjQSCYavf140dcqEWzzZD2B5Q5kUqauyn0Qa
         Wt1tjd5CQfNDYQEPoEnAzwn3GkH3Eha2zH8QzJt6CE3Mbk6MfwGKhLJGS8L7SpOq/DtN
         pGkGj9jJfrUQoMZ3EO6fxUx5usJehnIdw8M4ITKChd9jduv8LvE4k6LERgDJXNIZqI64
         GEkQ==
X-Gm-Message-State: AOAM5315uEn4keKOp5fjFkGI4cAwr+ND53NTl3RLyy5t4KVMV5xT9dgs
        GHb4cCtFNOujutdWr3UVjMe/ZgR/9cjbi1xSV18=
X-Google-Smtp-Source: ABdhPJzRYpNzvS4/fPSqDQ2oluW/PKocoPJ2SWrJaMc0IT7yMoO2FRKFGrmwoK3AwXV2BI4oaHKCAA==
X-Received: by 2002:a05:6a00:1784:b0:50d:d8cb:7a4f with SMTP id s4-20020a056a00178400b0050dd8cb7a4fmr11923638pfg.23.1651570105454;
        Tue, 03 May 2022 02:28:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c3-20020a17090a558300b001d5f22845bdsm1253384pji.1.2022.05.03.02.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 02:28:25 -0700 (PDT)
Message-ID: <6270f5b9.1c69fb81.f2004.3c35@mx.google.com>
Date:   Tue, 03 May 2022 02:28:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.37-162-gc188e7e7ab7e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 72 runs,
 1 regressions (v5.15.37-162-gc188e7e7ab7e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 72 runs, 1 regressions (v5.15.37-162-gc188e7=
e7ab7e)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.37-162-gc188e7e7ab7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.37-162-gc188e7e7ab7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c188e7e7ab7e2dd73a65d062948a1e18e3480b8c =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6270c07098672a8e34dc7b22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
162-gc188e7e7ab7e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
162-gc188e7e7ab7e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6270c07098672a8e34dc7=
b23
        failing since 33 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =20
