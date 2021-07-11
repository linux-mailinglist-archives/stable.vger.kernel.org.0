Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D583C3EC8
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhGKSjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhGKSjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:39:44 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85564C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 11:36:56 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 17so14100011pfz.4
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 11:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yEBJUJiizwyHlLQDCkTwuiePJSXGz55kF5edsDz8b5U=;
        b=fr4Uzo8sD5fIVrfpBPq9nCQPpn4SF/9fRGHnKTDmvuhXnEEMSP4m6xPJzJMThLc+3r
         uoUqXOza+XPMouS8BALKcE8P1p+uDYn3D4n4PS5ZOLUlKrkhD+czHnfz8yjPy7Br6PPD
         zqFrBUz7uHTUTlWy+CT2kV/moO9Rl8Xn7uiQMH4745xkJM7QRqDB5qvzfAKq0UfjMUJA
         KEJJTxWCJuhs6F4kVGqeS66nUBSy6Q9LS6vm5fVW5i6NIGAojZXnF+IRYF08RQkxrY/f
         M6odxR1jUtfLSxxAxijeeOd61Ddjv5vQe8hUJUbcxPgzBRv6NEiodlikE7ax1iKVW4ju
         kjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yEBJUJiizwyHlLQDCkTwuiePJSXGz55kF5edsDz8b5U=;
        b=niukKMYDuvFu5AzThAwN0x3j4usuT0PGQu4gOiio6r14w9SA/CkZf4k8aJw6ugAL54
         C2vONp994J4NXLmXwoyWp1JRaigUHF/MNeKfRIKNvUe2hVG0MPn24YpMYwkkCoCsIAI+
         gXFmPi3LQPp3S2bMaK88xkLGrV4Rs+OmhkJPsgkcRUZmyioas6gjr+B+gKxVNoIG9MPQ
         37YSZQMfNG/GSctgCb/XpCzrSOcgGv2YyQ9A9lKZVBMFimfMfJid6ySeyqepGpdEiNsu
         sOh3T0iAKfCQjxTRapqoODajJ3lpX3PVlNKDltPhRfEp+MUQfibrE+0znsWGmok9HfEM
         nqtg==
X-Gm-Message-State: AOAM532H0cR0dGSYMf4EoPzy4fCBaaBK6HS8i1f2961leAPOHJUKUDMz
        UEBrX3R44ZPku7zBTSmosrckudZ6M5NKI0qK
X-Google-Smtp-Source: ABdhPJzxVspKB+l1oDz7ORsh0Er3Itq1FSoesWywdQDcb9Py2U1uufE06YWrylP3/cbt0anNxOE9Mw==
X-Received: by 2002:a63:4302:: with SMTP id q2mr49213768pga.428.1626028615798;
        Sun, 11 Jul 2021 11:36:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ca16sm8058916pjb.44.2021.07.11.11.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 11:36:55 -0700 (PDT)
Message-ID: <60eb3a47.1c69fb81.baef.81ab@mx.google.com>
Date:   Sun, 11 Jul 2021 11:36:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.16
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.12.y
Subject: stable/linux-5.12.y baseline: 195 runs, 7 regressions (v5.12.16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 195 runs, 7 regressions (v5.12.16)

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

meson-gxm-q200     | arm64 | lab-baylibre  | gcc-8    | defconfig          =
| 1          =

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.16/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      362de415aea85e09c8c8741338ab746716539c7f =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 2          =


  Details:     https://kernelci.org/test/plan/id/60eb08b6d11797635a1179a4

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.16/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.16/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60eb08b6d117976=
35a1179ab
        new failure (last pass: v5.12.14)
        12 lines

    2021-07-11T15:05:13.408306  kern  :alert : 8<--- cut here ---
    2021-07-11T15:05:13.409536  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000021
    2021-07-11T15:05:13.410249  <8>[   43.221270] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D12>
    2021-07-11T15:05:13.410912  kern  :alert : pgd =3D f5c26f64
    2021-07-11T15:05:13.411555  kern  :alert : [00000021] *pgd=3D04249835, =
*pte=3D00000000, *ppte=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60eb08b6d117976=
35a1179ac
        new failure (last pass: v5.12.14)
        190 lines

    2021-07-11T15:05:13.415017  kern  :alert : 8<--- cut here ---
    2021-07-11T15:05:13.415721  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000008
    2021-07-11T15:05:13.416375  kern  :alert : pgd =3D e19d0f03
    2021-07-11T15:05:13.451836  kern  :alert : [00000008] *pgd=3D00000000
    2021-07-11T15:05:13.452707  kern  :alert : 8<--- cut here ---
    2021-07-11T15:05:13.453808  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000021
    2021-07-11T15:05:13.454519  kern  :alert : pgd =3D 00cfd88f
    2021-07-11T15:05:13.455166  kern  :alert : [00000021] *pgd=3D041ae835, =
*pte=3D00000000, *ppte=3D00000000
    2021-07-11T15:05:13.455803  kern  :emerg : Internal error: Oops: 17 [#1=
] ARM
    2021-07-11T15:05:13.456444  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0x6835dfbb) =

    ... (182 line(s) more)  =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60eb0e01b67a3c472e11797c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.16/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.16/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb0e01b67a3c472e117=
97d
        failing since 10 days (last pass: v5.12.13, first fail: v5.12.14) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
meson-gxm-q200     | arm64 | lab-baylibre  | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60eb098db1bd965e8611796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.16/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.16/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb098db1bd965e86117=
96b
        new failure (last pass: v5.12.14) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60eb19116a7369fcdb11799f

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.16/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.16/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb19116a7369fcdb1179b3
        failing since 25 days (last pass: v5.12.10, first fail: v5.12.11)

    2021-07-11T16:15:03.531529  /lava-4176038/1/../bin/lava-test-case<8>[  =
 22.209682] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-11T16:15:03.532089  =

    2021-07-11T16:15:03.532497  /lava-4176038/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb19116a7369fcdb1179cb
        failing since 25 days (last pass: v5.12.10, first fail: v5.12.11)

    2021-07-11T16:15:02.086002  /lava-4176038/1/../bin/lava-test-case
    2021-07-11T16:15:02.086415  <8>[   20.780219] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb19116a7369fcdb1179cc
        failing since 25 days (last pass: v5.12.10, first fail: v5.12.11)

    2021-07-11T16:15:01.070333  /lava-4176038/1/../bin/lava-test-case<8>[  =
 19.760619] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-11T16:15:01.070731     =

 =20
