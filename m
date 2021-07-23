Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6E53D387A
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 12:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhGWJgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 05:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbhGWJgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 05:36:35 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E2CC0613C1
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 03:17:09 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id f1so2768228plg.3
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 03:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+FGuBVcS1v8brNMAk1WXJGfjhS/h4o5t57ypch67keM=;
        b=VYeVf6T4Q5YJjwBO4yQEPN8nfLbErmrQ2qAWKhZBJIiDt/un8DZGwsaLkobVFtXy1I
         /kWHJcx4PhheDGKEEqbqoYgPmbvoX0sgk8GawrCcnzWy7zncXHoFyTcxy234sw8JsMoN
         089mB9+OjOjXkmBNS619c+NGT9fDxRuwBijjs+I7y5mB7WgWcQP7ZBhESvxHW8wB4ZcC
         L+yrYvrPy0ug06RUFajv8D7PS7LFccTuy0rfJ7Hi22aNW+q7JZ/T4mT6+0jIuXJxhKKx
         mDdL1CkA3TcxecGRiofIXiJ1MhNt5kCozhduVAc55ENFz0LiEmg4Q8wDXJNyrX7zJTRA
         Z3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+FGuBVcS1v8brNMAk1WXJGfjhS/h4o5t57ypch67keM=;
        b=AB9XzfATlLvlNSH+YLuGaJ39gEXiLGGg2yU2pIhHskz+jIxIACQdNUcI79lrLJLJZc
         aK3fyGo/TbBN0LJiW70SvufOKlxt35/Edcpy+G2KEDE6sr3Xjv5lczcvVSV7CsfsY4Cl
         CswGWkash3CmHyph4J/gINHIi0x3YxTTfGapkQnSmWB4FxFmslTkaEfMyZSop+Axm22A
         y0XefHN199ZhDg2L4cGeHOats+n1IQ2VcSdmaDqppF1JN5plq4f+YjFglncyNVTPyPek
         MXmXO1KAuGc8vduOo/Q0pbXI1xd/AtPCZCcTp4rX2hegFNB1x/RBpSn4emgHZF9SWhV1
         K3IQ==
X-Gm-Message-State: AOAM5300gsHY9oZupufH0zL1XeneUotsJ+dOlMaqY/Iu4r8kXMgXW0jh
        xcmAvxpn1Q5w2ZTjOQ23FOidL7D2YGZwoofB
X-Google-Smtp-Source: ABdhPJy1zp/62XfZQWHl0XeKywzt53hDoQNMG9t+JQjoaU46JXnWqQexFqFhUlLyK2reEnAALPU53A==
X-Received: by 2002:a17:90b:1b4d:: with SMTP id nv13mr3906435pjb.216.1627035428516;
        Fri, 23 Jul 2021 03:17:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x3sm5669858pjq.6.2021.07.23.03.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 03:17:08 -0700 (PDT)
Message-ID: <60fa9724.1c69fb81.cdbfc.1c66@mx.google.com>
Date:   Fri, 23 Jul 2021 03:17:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.51-364-g5e0262e1f1ac5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 170 runs,
 6 regressions (v5.10.51-364-g5e0262e1f1ac5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 170 runs, 6 regressions (v5.10.51-364-g5e0=
262e1f1ac5)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =

imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =

rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.51-364-g5e0262e1f1ac5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.51-364-g5e0262e1f1ac5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e0262e1f1ac5576193112de3ecc70fd3726fee3 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60fa612f67d5cc43a385c262

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-364-g5e0262e1f1ac5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx=
6q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-364-g5e0262e1f1ac5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx=
6q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60fa612f67d5cc4=
3a385c269
        new failure (last pass: v5.10.51-240-g665c847fa9b6d)
        4 lines

    2021-07-23T06:26:28.997120  kern  :alert : 8<--- cut here ---
    2021-07-23T06:26:29.027989  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-07-23T06:26:29.028315  kern  :alert : pgd =3D 9c896214
    2021-07-23T06:26:29.029431  kern  :alert : [<8>[   14.743528] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-07-23T06:26:29.029816  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60fa612f67d5cc4=
3a385c26a
        new failure (last pass: v5.10.51-240-g665c847fa9b6d)
        26 lines

    2021-07-23T06:26:29.081349  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-07-23T06:26:29.081737  kern  :emerg : Process kworker/0:6 (pid: 14=
8, stack limit =3D 0xe02fa0c4)
    2021-07-23T06:26:29.082266  kern  :emerg : Stack: (0xc3a3deb0 t<8>[   1=
4.790814] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3D=
lines MEASUREMENT=3D26>
    2021-07-23T06:26:29.082552  o 0xc3a3e000)
    2021-07-23T06:26:29.082812  kern  :emerg : dea<8>[   14.802123] <LAVA_S=
IGNAL_ENDRUN 0_dmesg 587504_1.5.2.4.1>
    2021-07-23T06:26:29.083063  0:                                     c3a3=
c000 ef78f540 c20f679c cec60217   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa6240883d2743f185c27d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-364-g5e0262e1f1ac5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-364-g5e0262e1f1ac5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa6240883d2743f185c=
27e
        failing since 11 days (last pass: v5.10.48-7-g5b40bcb16853d, first =
fail: v5.10.49) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/60fa74d5d3b0c3a76185c258

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-364-g5e0262e1f1ac5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-364-g5e0262e1f1ac5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60fa74d5d3b0c3a76185c26c
        failing since 38 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-23T07:50:31.140335  /lava-4234217/1/../bin/lava-test-case
    2021-07-23T07:50:31.157365  <8>[   13.303611] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60fa74d5d3b0c3a76185c284
        failing since 38 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-23T07:50:29.713362  /lava-4234217/1/../bin/lava-test-case
    2021-07-23T07:50:29.731412  <8>[   11.876916] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60fa74d5d3b0c3a76185c285
        failing since 38 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-23T07:50:28.699976  /lava-4234217/1/../bin/lava-test-case<8>[  =
 10.857290] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-23T07:50:28.700558     =

 =20
