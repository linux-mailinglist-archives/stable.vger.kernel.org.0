Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB845F57D8
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 17:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJEPwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 11:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiJEPwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 11:52:35 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14CB2C669
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 08:52:34 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c24so15752681plo.3
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 08:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=XpBsXD7ufuzwHk/D2R9cK/bgKfH2bJzEUGkvYxf9UuA=;
        b=WJFSopje7dOBQwgQt5GtOv/O7Zh6mZZIzLEzlAXUXVI9If231yP6QqKEwYbJli1Ccs
         8kw37Y7xDqRCD2CGkXqbCJMU2uuh+UHg47sZgaVktUwxNJ2V5+2/mT7FTLzt+7cVBvKw
         L4euspec3WiaCyYM9fW82gquO+EPr5rkdvQlVYDS6H326A65LM6mP3k8cavPWqsLrcWy
         FeUlDqcJITPrBZptPT+JWBetAw3hxWxlbYGSOedIiQgUWN8l2PKK03y39fphXeIIP5iw
         5gpQQKDBHGfruPtdh5buuu6HJcRoqVU508dGNC8731/xSGsrmPi+CNngEPBiPT6mZQKh
         JFeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=XpBsXD7ufuzwHk/D2R9cK/bgKfH2bJzEUGkvYxf9UuA=;
        b=4RtEG8c9NhwXBd2K3WbG2ZqSwOGR7NHPRSMEOcaJ3ZQErBFgTkDfThshYGr4WkHeWp
         HIRwwoMB6osSq0Y32L3PsnXhauFZGDB3nJJ+R7tYC5qRBr7oNZAHzdzswNcNTrZ8H+e3
         jzhXABVL5yoWkL1fbPIFV4OE9sEhP2sJ3u09zo428cQsX9nBMKqcwDAIFDp/yJCfdfgU
         oCqz6pnQCyLJBoVeaNlHMO/cBbs/T7yq+NWVDUKyekFhdPedd371Z6LbuIZytf77ABqh
         y8PJggW79QEx9/1c1tLvsrJHTJZJDwLS9uU5b2rKnECMEWaF4M/Tv9aLpKZXWabuR1tb
         13Kg==
X-Gm-Message-State: ACrzQf3J74sgdtw0uJ9aBeFQXYLZpPvxsMb3lvy1eM+5Lt08sS1Y5MTx
        FslfxTpzB8ghb+b0s1lt4ZFtoLvuXP/mi9/4N9c=
X-Google-Smtp-Source: AMsMyM5t1D5ug16haRUSdq8fIZ2Ouhsw+E7SlaJtXqPwvaixgYZtNh5ZEQ3aby/k1rGbM1dXUEac9g==
X-Received: by 2002:a17:90b:4d12:b0:20a:6307:54cf with SMTP id mw18-20020a17090b4d1200b0020a630754cfmr5671092pjb.171.1664985154305;
        Wed, 05 Oct 2022 08:52:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 67-20020a620646000000b005604c1a0fbcsm7760418pfg.74.2022.10.05.08.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 08:52:34 -0700 (PDT)
Message-ID: <633da842.620a0220.a1d10.d915@mx.google.com>
Date:   Wed, 05 Oct 2022 08:52:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.19.14
X-Kernelci-Report-Type: test
Subject: stable/linux-5.19.y baseline: 118 runs, 3 regressions (v5.19.14)
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

stable/linux-5.19.y baseline: 118 runs, 3 regressions (v5.19.14)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
  | 1          =

imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.14/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      30c780ac0f9fc09160790cf58f07ef3b92097ceb =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/633d6f8e36ee51c7eccab619

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.14/r=
iscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.14/r=
iscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d6f8e36ee51c7eccab=
61a
        failing since 0 day (last pass: v5.19.12, first fail: v5.19.13) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/633d7097e5f7dd99d0cab610

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.14/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.14/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d7097e5f7dd99d0cab=
611
        failing since 6 days (last pass: v5.19.10, first fail: v5.19.12) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/633d760d943182100ccab61a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.14/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.14/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d760d943182100ccab=
61b
        failing since 0 day (last pass: v5.19.10, first fail: v5.19.13) =

 =20
