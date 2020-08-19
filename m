Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAC324A03B
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgHSNki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgHSNkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:40:35 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1A3C061757
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 06:40:35 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mw10so1136108pjb.2
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 06:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=isPyf1F6cXV8+zlD/2aToGBrZ23nJHRvmrhgtXoOVGA=;
        b=qBM9NIJP9fbhkKsl1fOaSVdCalB7BYk2TNaykG3Vh22buyhCmC1LsY7dOSmyLMIKj+
         rig0ecP6j3vr+zcgSMrY0bCYmZQlNMwWmxbhwk1VT7UdU0ThGNT2MymG9AkAdJQNqhLe
         +h7k6/w+nbVcYw5rwcGCyaPAx9c+NnN0AdXBKkn0YXS9czzHUOD8vUyW6v1Vlk3124ba
         ypUHYz+PMWJ7QdCOFgAlc9BPFo8YXOT+KLm5uAzS/uHX8T8EnRatS88cJdE3tWMlKY2D
         xMIi2QIBXq+nZyvBqrta7hEBGGhSkqUkFy1opMTN4OAGDtJlfBpgbpV1QQbzARXQUEJ/
         KbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=isPyf1F6cXV8+zlD/2aToGBrZ23nJHRvmrhgtXoOVGA=;
        b=sjQI0ScJnDO3cnipdEjPaIKggTdee+vVf29PqjqajZzHj9/XvFP2n3U5mcbhlAAbed
         BuQvJR3aIl4oiu0cFIV5sDWOBBUt3BlYjvY9ayIbvuMnvmJYtVUbTzXNvaRSQW+nwVCl
         OfM/+1LezP7YmkOvV/lh1OAB7V0nAilSMGpZkvfpibJpHwW/u/hivwoGSvVbKrhPPc2V
         tZbDS/7aUNHpogET2LD2KvDd3v2TU4c6wG5gr5Bfwc/fYf24Ys3z/OHU14q28GI3hLLY
         H3FPb2n+6hIhO4Ewd7FDLYYWb+nVvusYPhmfEC4BPdBCz876hMMfhz1mmyL8CI+odvLB
         2QAg==
X-Gm-Message-State: AOAM530nC8VI33MVyxhn+z+7NU1pEs13I7KkoNdIRYhU6eu15DS+pPAw
        Nmxwpw0cNucWN5M2kqDpgYSeS0rp5hECpQ==
X-Google-Smtp-Source: ABdhPJwjnj7LsiLNuo/dowzMMwf/Xn10pf84HzrKIR/NG4X699P2xcnfgCEMHaXQ5FyzHKm7f4zcgg==
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr4060978pjb.236.1597844434190;
        Wed, 19 Aug 2020 06:40:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c15sm28200985pfo.115.2020.08.19.06.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 06:40:33 -0700 (PDT)
Message-ID: <5f3d2bd1.1c69fb81.f7bee.3131@mx.google.com>
Date:   Wed, 19 Aug 2020 06:40:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.7.16
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 198 runs, 5 regressions (v5.7.16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 198 runs, 5 regressions (v5.7.16)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | results
-------------------------+-------+---------------+----------+--------------=
------+--------
at91-sama5d4_xplained    | arm   | lab-baylibre  | gcc-8    | sama5_defconf=
ig    | 0/1    =

bcm2837-rpi-3-b          | arm64 | lab-baylibre  | gcc-8    | defconfig    =
      | 3/4    =

exynos5422-odroidxu3     | arm   | lab-collabora | gcc-8    | exynos_defcon=
fig   | 0/1    =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.16/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d036b5d2dd8fa3de540ec3357f657c436ce1d626 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | results
-------------------------+-------+---------------+----------+--------------=
------+--------
at91-sama5d4_xplained    | arm   | lab-baylibre  | gcc-8    | sama5_defconf=
ig    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3cf779968a8a3b51d99a45

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3cf779968a8a3b51d99=
a46
      failing since 33 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9)  =



platform                 | arch  | lab           | compiler | defconfig    =
      | results
-------------------------+-------+---------------+----------+--------------=
------+--------
bcm2837-rpi-3-b          | arm64 | lab-baylibre  | gcc-8    | defconfig    =
      | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f3cf8006800182068d99a77

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3cf80068001820=
68d99a79
      failing since 1 day (last pass: v5.7.15, first fail: v5.7.15-381-g483=
2c39ae70e)
      3 lines

    2020-08-19 09:59:12.060000  / # =

    2020-08-19 09:59:12.064000  =

    2020-08-19 09:59:12.172000  / # #
    2020-08-19 09:59:12.175000  #
    2020-08-19 09:59:13.441000  / # export SHELL=3D/bin/sh
    2020-08-19 09:59:13.454000  export SHELL=3D/bin/sh
    2020-08-19 09:59:14.961000  / # . /lava-4099/environment
    2020-08-19 09:59:14.972000  . /lava-4099/environment
    2020-08-19 09:59:17.692000  / # /lava-4099/bin/lava-test-runner /lava-4=
099/0
    2020-08-19 09:59:17.705000  /lava-4099/bin/lava-test-runner /la[   62.1=
43696] hwmon hwmon1: Undervoltage detected!
    ... (11 line(s) more)
      =



platform                 | arch  | lab           | compiler | defconfig    =
      | results
-------------------------+-------+---------------+----------+--------------=
------+--------
exynos5422-odroidxu3     | arm   | lab-collabora | gcc-8    | exynos_defcon=
fig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3d0619482ed55850d99a3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3d0619482ed55850d99=
a3e
      new failure (last pass: v5.7.15-394-g833b53db2607)  =



platform                 | arch  | lab           | compiler | defconfig    =
      | results
-------------------------+-------+---------------+----------+--------------=
------+--------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2/4    =


  Details:     https://kernelci.org/test/plan/id/5f3cfb8dbd08dee251d99a50

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f3cfb8dbd08dee=
251d99a53
      new failure (last pass: v5.7.15-394-g833b53db2607)
      4 lines

    2020-08-19 10:13:22.377000  kern  :alert : 8<--- cut here ---
    2020-08-19 10:13:22.377000  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60207
    2020-08-19 10:13:22.378000  kern  :alert : pgd =3D (ptrval)
    2020-08-19 10:13:22.378000  kern  :alert : [cec60207] *pgd=3D1ec1141e(b=
ad)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f3cfb8dbd08=
dee251d99a54
      new failure (last pass: v5.7.15-394-g833b53db2607)
      15 lines

    2020-08-19 10:13:22.420000  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2020-08-19 10:13:22.420000  kern  :emerg : Process kworker/1:2 (pid: 79=
, stack limit =3D 0x(ptrval))
    2020-08-19 10:13:22.421000  kern  :emerg : Stack: (0xedc0feb0 to 0xedc1=
0000)
    2020-08-19 10:13:22.421000  kern  :emerg : fea0:                       =
              c0388ae4 00000000 ffffe000 cec60207
    2020-08-19 10:13:22.421000  kern  :emerg : fec0: 00000000 00000000 0000=
0003 00000000 00000000 6adf3990 cec601ff ed09f040
    2020-08-19 10:13:22.421000  kern  :emerg : fee0: ed09f094 cec6008f 0000=
0000 c0985624 fffffc90 fffffc90 ed1f5000 ef7ad400
    2020-08-19 10:13:22.463000  kern  :emerg : ff00: 00000000 c19b4330 0000=
0000 c09857f8 ed1f5190 ed9d5700 ef7aa200 c0361e80
    2020-08-19 10:13:22.463000  kern  :emerg : ff20: ee927200 ef7aa200 0000=
0008 ed9d5700 ed9d5714 ef7aa200 00000008 c1803d00
    2020-08-19 10:13:22.464000  kern  :emerg : ff40: ef7aa218 ef7aa200 ffff=
e000 c0362464 ee927200 c19b3b8c c136d8ac ed9d5700
    2020-08-19 10:13:22.464000  kern  :emerg : ff60: c03621bc eee5d480 ed9d=
4a40 00000000 edc0e000 ed9d5700 c03621bc ee915ea4
    ... (5 line(s) more)
      =20
