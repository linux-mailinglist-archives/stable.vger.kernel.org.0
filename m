Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8C4403BB9
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 16:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbhIHOr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 10:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhIHOr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 10:47:26 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BCCC061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 07:46:18 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e7so2862668pgk.2
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 07:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fcv+WFe1wkRJ71W9wLrhSdOB6IJWw+Df6RymHuCGXmg=;
        b=hbLhxkHfs6VkIqXf38ko0DYzdvr/KG/mI7iU46ZwXGzJX3z+DQrZbINBac1TxnBXX2
         Rf9xELK9jJleKoFRjwH+YAixxa5IYki5o18WExYGQXgqhNZJ8oJFBAK4rDtUwOwZ/C3w
         JnRzzRRDm2EqT+1youuhu+d4odQZZaRlvXV5q40QjMHn28AcorjfCBcBChr0KfFz2gyh
         QOJDxbhC04HfbJl+u/dwGsvcuN1vuuYkRc8HadMN/+xS6R4WBV8/eEl6vDc31P3YZS9D
         uJ1SihMwBSTRl9G3ZG7MfnxzIqZ2AlamQWDxHOuGO6X2ZvxNBm7hgvENazalYvaReoGr
         UKyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fcv+WFe1wkRJ71W9wLrhSdOB6IJWw+Df6RymHuCGXmg=;
        b=OzMn6NQROAS8UX9B8JR5XCoTy8siCJNKvaY+zJPsdkwP73kkjmIPIK+F8tNPgFQ4kI
         h+F98uQ8JlqMI89FqgsQ4Rz3A4N6sJTAjqVSQbCbaZ4vgpzTBmWukLHHWO3qU2GQYhNL
         7ldNLgWKgYo2qyDAZykg5sFhUbkUxt+fXwayPjLmvyY0Mr2miK7SiEgKJujHiQsrCyyS
         v4ml2HBSUotEGFpzNDrPmplFpOWj3k4bKrO0deyhXBsDSRtyaP6uw4lOfY/rT6jfS71D
         M9qyiKtf7vMWoRjpdWm0XGD460iiWrMHcO4Q5goao2ujssYkQ2qU8Eigi3eAgIgamj69
         2Ifg==
X-Gm-Message-State: AOAM53082wUxEr5Mdpyn4p9LjI6jx7VdHLPl5ByMvejJcxTaEaAEJxi2
        aNEYX9o+MEPSbwkOtuvQWiPAcrHx0YZ9WdPJ
X-Google-Smtp-Source: ABdhPJxvb+UIZVfpjCjYTKQIY3mbAUO8xopP1coVsIurOPD9+9Iu2LetmFTQu4pO7jybmMuA3X9hyQ==
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id l6-20020a056a0016c6b029032de1909dd0mr4012617pfc.70.1631112378150;
        Wed, 08 Sep 2021 07:46:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f2sm3338030pga.60.2021.09.08.07.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 07:46:17 -0700 (PDT)
Message-ID: <6138ccb9.1c69fb81.73e54.912e@mx.google.com>
Date:   Wed, 08 Sep 2021 07:46:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.63
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 205 runs, 7 regressions (v5.10.63)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 205 runs, 7 regressions (v5.10.63)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

odroid-xu3              | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.63/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.63
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e07f317d5a289f06b7eb9025d2ada744cf22c940 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61389cfdfaef2f7653d59677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.63/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.63/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61389cfdfaef2f7653d59=
678
        failing since 62 days (last pass: v5.10.46, first fail: v5.10.48) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61389dbd33b843c373d596b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.63/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.63/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61389dbd33b843c373d59=
6b5
        new failure (last pass: v5.10.62) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
odroid-xu3              | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138c4087efb1a9065d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.63/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.63/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138c4087efb1a9065d59=
666
        new failure (last pass: v5.10.62) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6138b8a36720770ab5d59793

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.63/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.63/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6138b8a36720770ab5d597a7
        failing since 83 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-08T13:20:02.543086  /lava-4475747/1/../bin/lava-test-case
    2021-09-08T13:20:02.559265  <8>[   13.820694] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-08T13:20:02.559706  /lava-4475747/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6138b8a36720770ab5d597bf
        failing since 83 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-08T13:20:01.116837  /lava-4475747/1/../bin/lava-test-case
    2021-09-08T13:20:01.135020  <8>[   12.395422] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-08T13:20:01.135344  /lava-4475747/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6138b8a36720770ab5d597c0
        failing since 83 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-08T13:20:00.098010  /lava-4475747/1/../bin/lava-test-case
    2021-09-08T13:20:00.103248  <8>[   11.375960] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61389d2f2f00d78194d5968b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.63/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.63/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61389d2f2f00d78194d59=
68c
        new failure (last pass: v5.10.62) =

 =20
