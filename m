Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111B668BD45
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 13:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjBFMto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 07:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBFMth (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 07:49:37 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FC414EAB
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 04:49:36 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id e19so4049357plc.9
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 04:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Yzi7cpfq1xMg1AMaJNmvsdUyq/7KeQoOUJCaSBvid6o=;
        b=7LjejYK/g7hTL3VPvw3buWmvtyeG13qaarPwXhHD7KEf0aYIZL88RNUwXFJYZMy/Ik
         2kmbMMhVRjxjlw+oFqGZoDG7dH/GCmdHqLr4Edd5LqS8XE4CIpl/33N9uQnt9kQ4rj0u
         E8A/uFFqTJ7MKUaDyJpVfiLoRT/1L2+Oh1pQPlzsoR7R3wwLcP3mPJUX1VGX3/mqnwno
         /tgmrfH9dz5fcByiFNZIdE/HxHrEXr0HaA3I3RP9G445hUGsyYAHgWzvVaGHMb6Ez7Aa
         NkJjah1mbz3ufmK4Tirgmjts8hqWc3YPG50/OZ7CaCusedSuH2NLAs70J0nQAxdIoCUw
         SIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yzi7cpfq1xMg1AMaJNmvsdUyq/7KeQoOUJCaSBvid6o=;
        b=2KDUYWTAaHdY8WNUPGv7DwBlJy5MqFoxs0DoYYdEUQPE7gaohr1oIwvyF5UCWr5tOR
         /rX1drJRak8TgiMxvDeI/buWarNcfNVRqHkhitXJ+bHKfuCIoi/1IVuBK0Zbx8YxaZDs
         xLFa0BdCjnRkLiNhSL5U3d5jyJwf4NHiy6ZNnZyCLpx7qYujLmSNKCnyJlbI3Nz3918V
         nKazwju4y9ym212VR49YhLjpkuCl4l80KsEAdtRl/JvWgAJY4jIJcLJbrc52/va3muIv
         Wd1BOG/dTLek98zIOjArCYQsqiib3JOXtdb1RNSjR8lkosEp/isDHQTlatb3VORaJvnz
         rfyQ==
X-Gm-Message-State: AO0yUKUjp9lLRUiXjhtCuS0rBzoLx8AoMiGZNprx15NO/RMZL8BnjDZn
        W2pOoYivm6a+lYDmaYMDCHy00eHJt2GGDeSt
X-Google-Smtp-Source: AK7set/SAzTFwEOJrkM1gTQvggbYYVb4npj0XO0uErDeB2ik3B6tDWV4lfUHv5LaVZFNe39/gnoXsA==
X-Received: by 2002:a17:903:187:b0:198:c4ff:1c6 with SMTP id z7-20020a170903018700b00198c4ff01c6mr17399451plg.4.1675687775546;
        Mon, 06 Feb 2023 04:49:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902ab8700b00196053474a8sm6822794plr.53.2023.02.06.04.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 04:49:35 -0800 (PST)
Message-ID: <63e0f75f.170a0220.e3ee5.a7bf@mx.google.com>
Date:   Mon, 06 Feb 2023 04:49:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.167
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 159 runs, 3 regressions (v5.10.167)
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

stable/linux-5.10.y baseline: 159 runs, 3 regressions (v5.10.167)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
r8a7743-iwg20d-q7      | arm   | lab-cip      | gcc-10   | shmobile_defconf=
ig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.167/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.167
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a5acb54d4066f27e9707af9d93f047f542d5ad88 =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
r8a7743-iwg20d-q7      | arm   | lab-cip      | gcc-10   | shmobile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0e50bbbb6852240915ed9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.167/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.167/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0e50bbbb6852240915=
eda
        new failure (last pass: v5.10.166) =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0c6916c217f97ff915f1e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.167/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.167/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0c6916c217f97ff915f23
        failing since 5 days (last pass: v5.10.154, first fail: v5.10.166)

    2023-02-06T09:21:02.457328  + set +x
    2023-02-06T09:21:02.459687  <8>[   17.097337] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3294837_1.5.2.4.1>
    2023-02-06T09:21:02.600744  / # #
    2023-02-06T09:21:02.706290  export SHELL=3D/bin/sh
    2023-02-06T09:21:02.707864  #
    2023-02-06T09:21:02.811210  / # export SHELL=3D/bin/sh. /lava-3294837/e=
nvironment
    2023-02-06T09:21:02.812717  =

    2023-02-06T09:21:02.916181  / # . /lava-3294837/environment/lava-329483=
7/bin/lava-test-runner /lava-3294837/1
    2023-02-06T09:21:02.918843  =

    2023-02-06T09:21:02.922132  / # /lava-3294837/bin/lava-test-runner /lav=
a-3294837/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0c747f28a2aa9ef915f11

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.167/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.167/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0c747f28a2aa9ef915f16
        failing since 5 days (last pass: v5.10.154, first fail: v5.10.166)

    2023-02-06T09:24:16.691162  + set +x
    2023-02-06T09:24:16.695609  <8>[   17.039851] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 259626_1.5.2.4.1>
    2023-02-06T09:24:16.805965  / # #
    2023-02-06T09:24:16.908604  export SHELL=3D/bin/sh
    2023-02-06T09:24:16.909153  #
    2023-02-06T09:24:17.011339  / # export SHELL=3D/bin/sh. /lava-259626/en=
vironment
    2023-02-06T09:24:17.011895  =

    2023-02-06T09:24:17.113674  / # . /lava-259626/environment/lava-259626/=
bin/lava-test-runner /lava-259626/1
    2023-02-06T09:24:17.114694  =

    2023-02-06T09:24:17.118722  / # /lava-259626/bin/lava-test-runner /lava=
-259626/1 =

    ... (12 line(s) more)  =

 =20
