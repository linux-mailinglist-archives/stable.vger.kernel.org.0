Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3DA3C684F
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 03:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhGMCB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 22:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhGMCB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 22:01:56 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308F2C0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 18:59:07 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p36so8402651pfw.11
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 18:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=geg2AFR/r2sRGtz1XdCouvgy10jOdUCqhu3HQVYp6xM=;
        b=arOo+Pg04VU1GSfQtpZwsPzxqu3MoD0jvQw1BmJo0XD5+2IpZIqutJyIf13hZ614VJ
         TdNVYtxbQ4+yv+NVfiqdO18955fljqM8enm3HZAgXd9yLHAicH22zFyr+vbQsclKt+DL
         4B20BesBU0WntDzrK0D9ZAbk+1C78koO9qg56FuXbP5VOC3TRz8sP5HWXXx2V+gF06Z+
         +O+F17ZoXfrRrIvHocuX5kv91XI58DfwQPR1JX4Ullt/oZhMsykmWT9gGAmkTf0MQgC3
         GdK7r2zUS4YJ13vu61D2h0eAFgUmDvXBs6gcS3TpbV2gQo0kzF8r1LNqdqvYnUUxybLV
         yGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=geg2AFR/r2sRGtz1XdCouvgy10jOdUCqhu3HQVYp6xM=;
        b=MioX9k0YDbDFbCV9sDn5ZTwG29xbux+yIkoKWzCeu2GGasQECFGgZqSPomEtFkf0Kn
         fYSIg1CTiuDzVNgVvsGjXkS6WKE/vHOcMm0FtocM5lS6Qt6uRvl7q7ghZM/u5kgK3giT
         pF4818wm/NzQblGaorNAK01QSGZakFYaxUOhCDMfc8lrmKLE9MagAUl580NFqkXh+pTA
         peOGpJj8EqEFhvmr4WjFjlkXpGZnXvnASOlQNNc50eq84iMIqVJ+ajSltRIHYtCb3AsE
         6OlDR5fCvQq/x5tbxUc3SarNV5Bvgq8ZqRgBs0ML46AscAZ+Njiu5Hqrz+jC035XvNZx
         lN7Q==
X-Gm-Message-State: AOAM530Y6116sMU3uF0Ulq6d7wovnvHfYfeRheclpGZ3dgomm2F4QFM6
        J9y0cyztK4MMdHx3Qog6c6Q5r9Nerv3fO0aZ
X-Google-Smtp-Source: ABdhPJxsrVSp6F3GQ7PtQrkCiGbWIn/gldD2BCu979ol7vn1PPP96rfp/SZ8hrquL9y3QzP6smb0DA==
X-Received: by 2002:a05:6a00:1692:b029:300:7193:f67 with SMTP id k18-20020a056a001692b029030071930f67mr2122770pfc.19.1626141546485;
        Mon, 12 Jul 2021 18:59:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iy13sm694975pjb.28.2021.07.12.18.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 18:59:06 -0700 (PDT)
Message-ID: <60ecf36a.1c69fb81.573d9.3e7c@mx.google.com>
Date:   Mon, 12 Jul 2021 18:59:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49-597-gf820b41f4b3e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 141 runs,
 6 regressions (v5.10.49-597-gf820b41f4b3e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 141 runs, 6 regressions (v5.10.49-597-gf82=
0b41f4b3e)

Regressions Summary
-------------------

platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
d2500cc            | x86_64 | lab-clabbe      | gcc-8    | x86_64_defconfig=
             | 1          =

d2500cc            | x86_64 | lab-clabbe      | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =

imx6ul-pico-hobbit | arm    | lab-pengutronix | gcc-8    | imx_v6_v7_defcon=
fig          | 1          =

rk3288-veyron-jaq  | arm    | lab-collabora   | gcc-8    | multi_v7_defconf=
ig           | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.49-597-gf820b41f4b3e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.49-597-gf820b41f4b3e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f820b41f4b3e043e9c7a8543e703f2749fc4f931 =



Test Regressions
---------------- =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
d2500cc            | x86_64 | lab-clabbe      | gcc-8    | x86_64_defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60ecb9cf2e5f7c0ce6117977

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-597-gf820b41f4b3e/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-597-gf820b41f4b3e/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecb9cf2e5f7c0ce6117=
978
        failing since 1 day (last pass: v5.10.49, first fail: v5.10.49-581-=
g85a3429452df0) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
d2500cc            | x86_64 | lab-clabbe      | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ecbb2461c6d1aae01179ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-597-gf820b41f4b3e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-597-gf820b41f4b3e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecbb2461c6d1aae0117=
9af
        failing since 1 day (last pass: v5.10.49, first fail: v5.10.49-581-=
g85a3429452df0) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
imx6ul-pico-hobbit | arm    | lab-pengutronix | gcc-8    | imx_v6_v7_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ecbbab727d6e9086117980

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-597-gf820b41f4b3e/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-597-gf820b41f4b3e/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecbbab727d6e9086117=
981
        new failure (last pass: v5.10.49-594-gdb2c2c1f4b16e) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
rk3288-veyron-jaq  | arm    | lab-collabora   | gcc-8    | multi_v7_defconf=
ig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60ece3c546cc4d91c6117976

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-597-gf820b41f4b3e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-597-gf820b41f4b3e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ece3c546cc4d91c611798e
        failing since 27 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-13T00:51:57.790905  /lava-4186859/1/../bin/lava-test-case<8>[  =
 13.296086] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-13T00:51:57.791522  =

    2021-07-13T00:51:57.792055  /lava-4186859/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ece3c546cc4d91c61179a5
        failing since 27 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-13T00:51:56.347762  /lava-4186859/1/../bin/lava-test-case
    2021-07-13T00:51:56.353075  <8>[   11.869857] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ece3c546cc4d91c61179a6
        failing since 27 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-13T00:51:55.334345  /lava-4186859/1/../bin/lava-test-case<8>[  =
 10.850250] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-13T00:51:55.334811     =

 =20
