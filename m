Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC991686676
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 14:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjBANO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 08:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBANOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 08:14:25 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73FCAD3F
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 05:14:24 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id c10-20020a17090a1d0a00b0022e63a94799so2149593pjd.2
        for <stable@vger.kernel.org>; Wed, 01 Feb 2023 05:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=japdMqNPYuwKgnjXjvhXCwXJmQ/6oB7Rheekt1CvsWs=;
        b=06DkZIUdcmYHjttjEUsYklgFJjdjQkITto1cqyJsiGdswNgjR7+EnMpa8ieG7zOuz3
         oEI91TOMfplvfu+X3ysALxkSpo/s5inYtV5t5hmZJLQRgV5cweVHpZJS3J+Qir+s+UCt
         gtON3cmWCCuX/CR7eoYsbcBW3XW+tiret6d9FOgEqXq/YIpUsKy/jJDRPH5XkNHo9NJ7
         SVSbqbBASBV2BBXdnqaKkgI+n4WXOBpaAn8WSDsDJhKtXvc2jxxy4Zknkf4p8NGZYmnT
         3cSQ2kNAnDkzJ8kN5/s+PfzvTtaz20g4IsnY3OAQS/PWP45hQZuhYkF8HF+r2wMjzWu/
         lu9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=japdMqNPYuwKgnjXjvhXCwXJmQ/6oB7Rheekt1CvsWs=;
        b=r7NLNSPuMRaz7+c9P5NtyovKfbLnib4jUi8zKJgbeLaftam3PhGOCrCVBSwfMnkNF+
         6NR6VWFwlZX8hBM+8OZ09s9ofr+t8k9os/ZIDUSg3h5+Q7GP1IfwnebtYpfxEDyY9Xm3
         4njSXLXZKMOLLuVa2VZzFrMb5ARMjPGr2BMoOJxcuggfRvMIfeNoeTc5oS/PbLm+9Ts8
         1f5R8Xz/VGmQaxdNznMre7qff3JZy3/nHd5CAgClG27xCP41joa/T96pUVxaGVz5gK5W
         3K0b2+tgOwNrp4v6I5tmxjSgl11Wzcglfpi4LcEk4bx1TdKJhGkoTOQ1vWEAxQlfJxwA
         CRlw==
X-Gm-Message-State: AO0yUKVGn5MZJ3Acc5ihuFYvcgDBuPvARuH/XBhBVvt7daIt/TUyN1ut
        bLjA/jBcSHLfbsYNQqTAJ5TF8s/7YBZcYF4/LknVcg==
X-Google-Smtp-Source: AK7set/NFVCtgytqBvNci+wGfXTiJgMvuqZ4C7fz0l0QHzkniE0RNmHKmW1iyjUSYfhtBBpNOKzVgQ==
X-Received: by 2002:a17:90b:1bc6:b0:230:369d:36fc with SMTP id oa6-20020a17090b1bc600b00230369d36fcmr2013061pjb.30.1675257263977;
        Wed, 01 Feb 2023 05:14:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j5-20020a17090a694500b0022c2e29cadbsm1270925pjm.45.2023.02.01.05.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 05:14:23 -0800 (PST)
Message-ID: <63da65af.170a0220.511fd.1d23@mx.google.com>
Date:   Wed, 01 Feb 2023 05:14:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.91
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 164 runs, 3 regressions (v5.15.91)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 164 runs, 3 regressions (v5.15.91)

Regressions Summary
-------------------

platform        | arch | lab             | compiler | defconfig          | =
regressions
----------------+------+-----------------+----------+--------------------+-=
-----------
cubietruck      | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | =
1          =

imx53-qsrb      | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | =
1          =

stm32mp157c-dk2 | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.91/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9cf4111cdf9420fa99792ae16c8de23242bb2e0b =



Test Regressions
---------------- =



platform        | arch | lab             | compiler | defconfig          | =
regressions
----------------+------+-----------------+----------+--------------------+-=
-----------
cubietruck      | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/63da30bc1c073c2f6a915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.91/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.91/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63da30bc1c073c2f6a915ec1
        failing since 13 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-02-01T09:28:15.333541  <8>[   10.074234] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3262983_1.5.2.4.1>
    2023-02-01T09:28:15.442704  / # #
    2023-02-01T09:28:15.545858  export SHELL=3D/bin/sh
    2023-02-01T09:28:15.546807  #
    2023-02-01T09:28:15.648845  / # export SHELL=3D/bin/sh. /lava-3262983/e=
nvironment
    2023-02-01T09:28:15.649916  =

    2023-02-01T09:28:15.752203  / # . /lava-3262983/environment/lava-326298=
3/bin/lava-test-runner /lava-3262983/1
    2023-02-01T09:28:15.753733  =

    2023-02-01T09:28:15.758728  / # /lava-3262983/bin/lava-test-runner /lav=
a-3262983/1
    2023-02-01T09:28:15.852371  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform        | arch | lab             | compiler | defconfig          | =
regressions
----------------+------+-----------------+----------+--------------------+-=
-----------
imx53-qsrb      | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/63da30ccbdf58d2def915f04

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.91/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.91/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63da30ccbdf58d2def915f09
        new failure (last pass: v5.15.81)

    2023-02-01T09:28:36.776200  + set +x
    2023-02-01T09:28:36.776403  [    9.301361] <LAVA_SIGNAL_ENDRUN 0_dmesg =
894512_1.5.2.3.1>
    2023-02-01T09:28:36.883169  / # #
    2023-02-01T09:28:36.984676  export SHELL=3D/bin/sh
    2023-02-01T09:28:36.985065  #
    2023-02-01T09:28:37.086378  / # export SHELL=3D/bin/sh. /lava-894512/en=
vironment
    2023-02-01T09:28:37.086766  =

    2023-02-01T09:28:37.187939  / # . /lava-894512/environment/lava-894512/=
bin/lava-test-runner /lava-894512/1
    2023-02-01T09:28:37.188494  =

    2023-02-01T09:28:37.190951  / # /lava-894512/bin/lava-test-runner /lava=
-894512/1 =

    ... (12 line(s) more)  =

 =



platform        | arch | lab             | compiler | defconfig          | =
regressions
----------------+------+-----------------+----------+--------------------+-=
-----------
stm32mp157c-dk2 | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/63da3075e134238f7e915eca

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.91/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.91/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63da3075e134238f7e915ecf
        new failure (last pass: v5.15.73)

    2023-02-01T09:26:53.049946  <8>[   10.472412] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3262987_1.5.2.4.1>
    2023-02-01T09:26:53.157138  / # #
    2023-02-01T09:26:53.259050  export SHELL=3D/bin/sh
    2023-02-01T09:26:53.259579  #
    2023-02-01T09:26:53.360934  / # export SHELL=3D/bin/sh. /lava-3262987/e=
nvironment
    2023-02-01T09:26:53.361480  =

    2023-02-01T09:26:53.462858  / # . /lava-3262987/environment/lava-326298=
7/bin/lava-test-runner /lava-3262987/1
    2023-02-01T09:26:53.463706  =

    2023-02-01T09:26:53.467968  / # /lava-3262987/bin/lava-test-runner /lav=
a-3262987/1
    2023-02-01T09:26:53.534978  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
