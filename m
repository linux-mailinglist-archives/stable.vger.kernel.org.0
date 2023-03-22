Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9954D6C3F1D
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 01:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCVAdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 20:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCVAdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 20:33:07 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600B738E98
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 17:33:06 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id o2so10408784plg.4
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 17:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679445185;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pgHx/cqbG5I9k9hMArcCVjiTdDeyWWfGZHHFyjuXNUU=;
        b=IH/yXm8HKVgdXdyhxLZ5e+KA/Lq3rYy9mNkKJkJhqgOVHYjI6Y5L2Se7qXRdM5fumQ
         whfQFttuvkpxKeOqDgVHDmxTvxedDmOoIX8Y4peWjCmpnhEP91d10WXMbZD7VR+XkX5y
         wfu8fMLp83x8ElIoGyErX4lmnYS6862Af17pyi8Vq9FXTQlF0dKWDGoXlJopFc7jsU4Z
         CiXRRaXgDYaQWBaoAJKLeXmN6qLR59WI1umyCQjG6ZJuYV20J0It5VOQqnR9VqJLZkN9
         i1ynS72yY0VYXinot9ZxQbrGAku2avnMm0use4rlxvJ68yzigkDObtXUFnsmqzTpGSOv
         bFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679445185;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pgHx/cqbG5I9k9hMArcCVjiTdDeyWWfGZHHFyjuXNUU=;
        b=V4Ifl8H9kxnITSkBUnPfYy6/NJad3P1HDxH2rvBH5HEgpLYjdUG4/Z+YrT+a4FSMfS
         V992y7L+b4jmxCjtDMz6mhyLzr17MWe9MUZZtW5H9m1qhL/O2m/C1tXu8oUVZH3iM+jl
         YjFWq8SFszzxktpO05n5UtlF6skl9DUclwmMU4Lz4llYV/KRvbBSRkALZKK6qMWa0eKT
         m32li1cQCItX0jH6cRY5F24RTqhQpau3+Irm+swCu5TW8CkvLgX8uUtZRAvrAs1KIzCu
         Aq5C4/cp45bGkSfbC1BTpclHvvWt8+YjwxJfy6ovGjEubxdbkBMwBz5/Rco0mlhvrXJx
         i5DA==
X-Gm-Message-State: AO0yUKWUTYb/WH76aE6W/M1UBzqPANevN3zXvayc/Qu2urg8QRvFXoAi
        OWwgYCgObPfm+DNKrSmXu9sNiz6dOnwGNRCAqXmSNg==
X-Google-Smtp-Source: AK7set9Aa7cxYsmQcPB9HbhKjzSczr0jzf/a9kNtAMkIyRZiXgOxwz8OBF6iciE0kHVi50HoI6FhOQ==
X-Received: by 2002:a05:6a20:8ee2:b0:bc:32ff:9afb with SMTP id m34-20020a056a208ee200b000bc32ff9afbmr3793492pzk.44.1679445185599;
        Tue, 21 Mar 2023 17:33:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j19-20020aa783d3000000b005dca6f0046dsm9055815pfn.12.2023.03.21.17.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 17:33:05 -0700 (PDT)
Message-ID: <641a4cc1.a70a0220.7e530.07fe@mx.google.com>
Date:   Tue, 21 Mar 2023 17:33:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.103-115-g0028848d9301
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 3 regressions (v5.15.103-115-g0028848d9301)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 172 runs, 3 regressions (v5.15.103-115-g0028=
848d9301)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
cubietruck         | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig =
        | 1          =

kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =

mt8173-elm-hana    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.103-115-g0028848d9301/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.103-115-g0028848d9301
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0028848d9301afcada0ceb88341510e2e621bb97 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
cubietruck         | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/641a1c04c642386e229c9514

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-115-g0028848d9301/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-115-g0028848d9301/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641a1c04c642386e229c951d
        failing since 63 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-21T21:04:48.023174  <8>[    9.959387] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3432661_1.5.2.4.1>
    2023-03-21T21:04:48.132405  / # #
    2023-03-21T21:04:48.234234  export SHELL=3D/bin/sh
    2023-03-21T21:04:48.234754  #
    2023-03-21T21:04:48.336037  / # export SHELL=3D/bin/sh. /lava-3432661/e=
nvironment
    2023-03-21T21:04:48.336432  =

    2023-03-21T21:04:48.336644  / # <3>[   10.203784] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-21T21:04:48.437745  . /lava-3432661/environment/lava-3432661/bi=
n/lava-test-runner /lava-3432661/1
    2023-03-21T21:04:48.438419  =

    2023-03-21T21:04:48.444079  / # /lava-3432661/bin/lava-test-runner /lav=
a-3432661/1 =

    ... (12 line(s) more)  =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/641a19e84afaddd30e9c9514

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-115-g0028848d9301/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-115-g0028848d9301/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641a19e84afaddd30e9c9=
515
        new failure (last pass: v5.15.103-115-gac0c67f7c475) =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
mt8173-elm-hana    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641a18ae0f1a29896b9c952b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-115-g0028848d9301/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-115-g0028848d9301/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641a18ae0f1a29896b9c9=
52c
        new failure (last pass: v5.15.103-115-gac0c67f7c475) =

 =20
