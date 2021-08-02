Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1E73DE12D
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 23:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhHBVA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 17:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhHBVA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 17:00:59 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4D7C061760
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 14:00:48 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id z3so19811217plg.8
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 14:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7X3/acjXeV/7zm5cKVcU2CDHt1w17/p1SPF9bE6H3Q0=;
        b=jEFF4Bmz86luOvIU0mOjtX/Lc83ov6zLAkDkOCHJRiunfJVoJ9y+fzxgK00xqaXhMk
         itT/3B13iN48vY13ydY+vdjdV5A+UDSiScqhnX3bBd5ZzoKAPShwX/4f1doO6iwbqKVD
         nYju7slo3JdR5UgVf6FPdAvf3HhMr9SJc5tVSXhMn5qCvi964Lc0DL+NZmqbyJtRTs8e
         dkn7zuNJ+jju8nKo3BwE0pIklV4kii/orjQWsKOD9iBtpQHevb4BaRy99SPwD4xDJ6RY
         0161Hd5dSWA3B6/89vl0nfqfcd/RTEGKRMiSNcCK2ZePPPgFpU9OEFpH8kxvwYDeN8LR
         vSUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7X3/acjXeV/7zm5cKVcU2CDHt1w17/p1SPF9bE6H3Q0=;
        b=puDkPi4S/aT2h9ZA8Wp9MN9qU+QXrcrpj5UqSRHyT7tVe5mDqqIwEFFFHXKtVFgu6L
         2QHPEHx/pLNZlXj0/gcF6clt+3sQsRKWX9xQU2zTF7ExvZtF3SdZStgr9oIHaAJubBXE
         m8hW/bc4UwbfDs+LgHzebHfcQi9QK68CHDyFyvAHNOOsxRo9dTi0kpcKILNLfSzcTOSn
         Bc3uTu7C9epKEqck8XLWD7Dp2sVtvvV8SEMbeNOXU59EXTGPpKKHbbi+6Wgjoc1FtsIG
         nto0EFHTf8j+1JVQ3UBkjTV085TlkuvIMOP3SE1ji9hYpT3KxSvEbPJxUN1NTJtGNk+2
         Iqyw==
X-Gm-Message-State: AOAM533+Pzs9m0vYWo19m19jSb25K+aePPl6chELx7HlodFvZxV1vZNp
        rfHcUDXZMXSfRq3gtZ4UO20VmhikzMVrJ4HV
X-Google-Smtp-Source: ABdhPJyClVL7NaoE7bqg906bf6zRS9kEJtAIaFMP1u3//bM0+5Y8/b8YRHLMX+5qLVY5ZIgx8ZuFrA==
X-Received: by 2002:a17:902:7b8b:b029:12b:8d3e:70e7 with SMTP id w11-20020a1709027b8bb029012b8d3e70e7mr15543890pll.76.1627938048062;
        Mon, 02 Aug 2021 14:00:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v5sm14498702pgi.74.2021.08.02.14.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:00:47 -0700 (PDT)
Message-ID: <61085cff.1c69fb81.77c35.9c80@mx.google.com>
Date:   Mon, 02 Aug 2021 14:00:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.55-68-gf9063e43ccbb
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 166 runs,
 7 regressions (v5.10.55-68-gf9063e43ccbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 166 runs, 7 regressions (v5.10.55-68-gf906=
3e43ccbb)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 2          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =

imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.55-68-gf9063e43ccbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.55-68-gf9063e43ccbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9063e43ccbb353c5b2cafe59c6b9534aa7ddc14 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 2          =


  Details:     https://kernelci.org/test/plan/id/61082271238cbbb77ab13683

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
5-68-gf9063e43ccbb/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
5-68-gf9063e43ccbb/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61082271238cbbb=
77ab13687
        new failure (last pass: v5.10.55-27-g65d2f1e1446b)
        4 lines

    2021-08-02T16:50:35.861156  kern  :alert : 8<--- cut here ---
    2021-08-02T16:50:35.897364  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00<8>[   13.692887] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2021-08-02T16:50:35.898253  000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61082271238cbbb=
77ab13688
        new failure (last pass: v5.10.55-27-g65d2f1e1446b)
        49 lines

    2021-08-02T16:50:35.902438  kern  :alert : pgd =3D ba8eb795
    2021-08-02T16:50:35.903280  kern  :alert : [00000000] *pgd=3D04222835, =
*pte=3D00000000, *ppte=3D00000000
    2021-08-02T16:50:35.943613  kern  :emerg : Internal error: Oops: 817 [#=
1] ARM
    2021-08-02T16:50:35.944774  kern  :emerg : Process udevd (pid: 104, sta=
ck limit =3D 0x25b841ee)
    2021-08-02T16:50:35.945440  ke<8>[   13.736873] <LAVA_SIGNAL_TESTCASE T=
EST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D49>
    2021-08-02T16:50:35.946024  rn  :emerg : Stack: (0xc<8>[   13.747481] <=
LAVA_SIGNAL_ENDRUN 0_dmesg 636399_1.5.2.4.1>
    2021-08-02T16:50:35.946574  4237da0 to 0xc4238000)   =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61082ac44ea99978deb1366a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
5-68-gf9063e43ccbb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
5-68-gf9063e43ccbb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61082ac44ea99978deb13=
66b
        failing since 32 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/610826d65b3203c605b13677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
5-68-gf9063e43ccbb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
5-68-gf9063e43ccbb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610826d65b3203c605b13=
678
        new failure (last pass: v5.10.54-25-gdfa33f1e9f64) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/61083d8f9c92a4b5b0b1368c

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
5-68-gf9063e43ccbb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
5-68-gf9063e43ccbb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61083d8f9c92a4b5b0b136a4
        failing since 48 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-02T18:46:19.564271  /lava-4308786/1/../bin/lava-test-case
    2021-08-02T18:46:19.573374  <8>[   16.244766] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61083d909c92a4b5b0b136bc
        failing since 48 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-02T18:46:18.154601  /lava-4308786/1/../bin/lava-test-case
    2021-08-02T18:46:18.161631  <8>[   14.817373] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-02T18:46:18.161956  /lava-4308786/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61083d909c92a4b5b0b136bd
        failing since 48 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-02T18:46:17.124701  /lava-4308786/1/../bin/lava-test-case
    2021-08-02T18:46:17.129887  <8>[   13.797795] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
