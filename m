Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AA74085DB
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 09:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbhIMHzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 03:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237806AbhIMHza (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 03:55:30 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107E4C061760
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 00:54:15 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id n18so8655948pgm.12
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 00:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8foLLcxDAqr7vvLDU2MDB131sgrkGvl30aOgrg1Ko/M=;
        b=eldebWST1HiGqXDRVvRN8miEy3ADUva33gX5oHe+BBbB+iHzGWah5U3LfZxRFbYhgQ
         RTA2iCD/97mKV+Msx+WTXnZpNwonVxUJdbDMyF1EkeQuVH3cXGCno7U3FBqxy1M3Rd7t
         LQjVqiY612iqqSj4veHSGh0c4w+ZPNOyfuBczjE9frclZlUPRFCz+rv7LGde6BN9BZdM
         mxkaWsOyPr8Swy9qPgymNUfedFk0gU/C7Ve2Y7aLTGqKowC5Z3ZwqOvT998wKpJcjrCk
         N8a5Dw0xf66Md3DLtD2ZWHhguc1ouxh9ixYcPeg2bN601x3L0jKMls0fYtvjQvszISx1
         zO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8foLLcxDAqr7vvLDU2MDB131sgrkGvl30aOgrg1Ko/M=;
        b=gyWscDrPMDkg09VJ/8YkFehdO0LRZyc7aBK3roY3CDklRSA5MVqOuVhybjF0H/redF
         WK/9XOO/w4oC5o1rA9JI+uCWbOHQatdzniIibNPqShljVmeJ3SLblVzleOT1ena4DVK+
         1FJLEgzWDKg6bfQnDGXb++4fZItNDGel9Ue8Ju4317mrypEqamkc8HhrYEnP8RrxKCwF
         9lh09DYSyI8XMyRMRtkWWUkjxxB611jescrxpua+2u1USR4yoLEpCGaIZPMqKZ7hI8JV
         p2PU8LaCjGvJVKPQGn22V7hsIGBYE1B+/cF/MvMiUsI1T+SwwViA+m3fDbcWx4q7OoeI
         r+0w==
X-Gm-Message-State: AOAM533owc5rsPApgTj9KbSMBXpoVVIDNQYDRFkimT12d5QN/2tttX79
        G9NTZIK1B43VJRvGFrHifxVGs1R8G6RcmUXp
X-Google-Smtp-Source: ABdhPJxervN+YSTLAp1vHsy8o6D0xn7IbIvaDmsjP2N8SvFHuNW1/k9z0vHSUg/YiCidj5wKhD0SPQ==
X-Received: by 2002:a63:4917:: with SMTP id w23mr9866321pga.344.1631519654282;
        Mon, 13 Sep 2021 00:54:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b20sm5975472pfo.3.2021.09.13.00.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 00:54:14 -0700 (PDT)
Message-ID: <613f03a6.1c69fb81.abe5d.0581@mx.google.com>
Date:   Mon, 13 Sep 2021 00:54:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.64-214-g93e17c2075d7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 172 runs,
 7 regressions (v5.10.64-214-g93e17c2075d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 172 runs, 7 regressions (v5.10.64-214-g93e17=
c2075d7)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =

rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =

sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.64-214-g93e17c2075d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.64-214-g93e17c2075d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      93e17c2075d7b9a99957b0f3cff7ec91e27171de =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/613ed324c540fed58cd5968f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
214-g93e17c2075d7/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
214-g93e17c2075d7/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ed324c540fed58cd59=
690
        failing since 73 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/613ed0db2dcf189a53d59679

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
214-g93e17c2075d7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
214-g93e17c2075d7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/613ed0db2dcf189=
a53d59680
        new failure (last pass: v5.10.63-26-gfb6b5e198aab)
        4 lines

    2021-09-13T04:17:03.363322  kern  :alert : 8<--- cut here ---
    2021-09-13T04:17:03.364010  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-09-13T04:17:03.364649  kern  :alert : pgd =3D (ptrval)<8>[   39.44=
9462] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-09-13T04:17:03.364895  =

    2021-09-13T04:17:03.365119  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/613ed0db2dcf189=
a53d59681
        new failure (last pass: v5.10.63-26-gfb6b5e198aab)
        47 lines

    2021-09-13T04:17:03.416324  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-09-13T04:17:03.416792  kern  :emerg : Process kworker/2:5 (pid: 97=
, stack limit =3D 0x(ptrval))
    2021-09-13T04:17:03.417302  kern  :emerg : Stack: (0xc36b9d50 to 0xc36b=
a000)
    2021-09-13T04:17:03.417542  kern  :emerg : 9d40:                       =
              c3c011b0 c3c011b4 c3c01000 c3c01014
    2021-09-13T04:17:03.417767  kern  :emerg : 9d60: c144ac58 c09c7254 c36b=
8000 ef86b380 80200019 c3c01000 000002f3 023efbf1
    2021-09-13T04:17:03.418257  kern  :emerg : 9d80: c19c7874 c2001d80 c250=
aa00 ef842140 c09d49ac c144ac58 c19c7858 023efbf1
    2021-09-13T04:17:03.459460  kern  :emerg : 9da0: c19c7874 c399c5c0 c3b7=
6a00 c3c01000 c3c01014 c144ac58 c19c7858 0000000c
    2021-09-13T04:17:03.460089  kern  :emerg : 9dc0: c19c7874 c09d497c c144=
8980 00000000 c3c0100c c3c01000 fffffdfb c2298c10
    2021-09-13T04:17:03.460364  kern  :emerg : 9de0: c2759500 c09aa89c c3c0=
1000 bf095000 fffffdfb bf091138 c3a50b00 c3bf8308
    2021-09-13T04:17:03.460597  kern  :emerg : 9e00: 00000120 c27356c0 c275=
9500 c0a04500 c3a50b00 c3a50b00 00000040 c3a50b00 =

    ... (35 line(s) more)  =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/613ef4221b123f9e08d5969e

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
214-g93e17c2075d7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
214-g93e17c2075d7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613ef4221b123f9e08d596b2
        failing since 90 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-13T06:47:55.411113  /lava-4506337/1/../bin/lava-test-case
    2021-09-13T06:47:55.428126  <8>[   14.528519] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613ef4221b123f9e08d596ca
        failing since 90 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-13T06:47:53.984958  /lava-4506337/1/../bin/lava-test-case
    2021-09-13T06:47:54.002162  <8>[   13.102112] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613ef4221b123f9e08d596cb
        failing since 90 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-13T06:47:52.970929  /lava-4506337/1/../bin/lava-test-case<8>[  =
 12.082972] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-13T06:47:52.971341     =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/613ed254285645d3c3d59676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
214-g93e17c2075d7/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
214-g93e17c2075d7/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ed254285645d3c3d59=
677
        new failure (last pass: v5.10.63-26-gfb6b5e198aab) =

 =20
