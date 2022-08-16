Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F6E596410
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 22:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbiHPU5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 16:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiHPU5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 16:57:01 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AD174376
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 13:56:59 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p14-20020a17090a74ce00b001f4d04492faso10785160pjl.4
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 13:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=rmRoJ1chzMtXrMJQ79onit/jwihd+EB4h8svJnsNRqw=;
        b=N/P5AojPfZsYomuX3Fppbp0KhW0ksY9OQW83+oJ4jpdxehPly7d0basaYUVbE3AfoO
         x4mxDB5dgF+IlzlugCU9JD+e1bvtnUSfYcEo8BeYDuLMAzGoVsmrhgEHdqct+9Nbhn8O
         UKB2eV/vkqvtJq0W9OwWV+jxiittBY0JfROX5fabzdr0CuRX/+kFJMYGyoGEswH4nzV5
         l3OKMCtqkG2CGBpicZSX8uyLQhWhbIVpXc+8+taLMWPqIgdRT1wakl40SpVsx6btNMhY
         KPWZnaqZcriSkpeZSGNV6z+qBziP1lG2oI+JmPL5rsBKnbN2naBj63XtBajLspMetALI
         nPdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=rmRoJ1chzMtXrMJQ79onit/jwihd+EB4h8svJnsNRqw=;
        b=lD6oEGpbFEoYTORFQlih2SzWiJditnYjRCogOEimHP9dOMEYgLBdnozD5hn+woqS5Y
         zFTEy4Lqbc+sYaep5weWDaGEgnGhjn33rJVApZS7Gw1IuWf9j0U2/OGUDSc7H8r0h0Pq
         24jgjFwbmNVSX8vojny7omvNNGAg54e0ugL0vqlQn3fJnHv3mVDUZVh3Tszl5Dj6w/qQ
         xfLP6GQxEabgwM6zoQkjKjuQAKTnz/plPzl5KsNcNCkYXgxEdNyV6obmtLgpOQJyDbWT
         m5Ea8uWsSB9dlx72uZBwO56NJwMuvCrKDWUnhSWLBAeUkoqF2rkO+c+EBiuKJP0IyArC
         N4dA==
X-Gm-Message-State: ACgBeo2emSo+yMLxxnN6ivQ/UHsacnCnd5n3cmF98IlEBnxibJVqWygl
        XPnkUQ1jVyDbQ+18uC1YxOXXuFYOkFcyHbGe
X-Google-Smtp-Source: AA6agR7HHhxYgNMi3TNzfQlNLdgEo5fZopia+ED6rH02Ux+fN4F1m/7ljZGLO5yFheQTi1uNxfgi3w==
X-Received: by 2002:a17:902:f606:b0:172:6522:4bfc with SMTP id n6-20020a170902f60600b0017265224bfcmr14595823plg.133.1660683419058;
        Tue, 16 Aug 2022 13:56:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13-20020a170903228d00b001714fa07b74sm9613507plh.108.2022.08.16.13.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 13:56:58 -0700 (PDT)
Message-ID: <62fc049a.170a0220.27d70.053b@mx.google.com>
Date:   Tue, 16 Aug 2022 13:56:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.255-210-g613a9e1e0172b
Subject: stable-rc/queue/4.19 baseline: 49 runs,
 8 regressions (v4.19.255-210-g613a9e1e0172b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 49 runs, 8 regressions (v4.19.255-210-g613a9=
e1e0172b)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
            | regressions
-----------------------------+-------+--------------+----------+-----------=
------------+------------
at91sam9g20ek                | arm   | lab-broonie  | gcc-10   | at91_dt_de=
fconfig     | 1          =

da850-lcdk                   | arm   | lab-baylibre | gcc-10   | davinci_al=
l_defconfig | 2          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
            | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
            | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
            | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
            | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.255-210-g613a9e1e0172b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.255-210-g613a9e1e0172b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      613a9e1e0172ba3ff487956b7c508a1eb6aeb844 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
            | regressions
-----------------------------+-------+--------------+----------+-----------=
------------+------------
at91sam9g20ek                | arm   | lab-broonie  | gcc-10   | at91_dt_de=
fconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbd0331ded53e5e7355665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbd0331ded53e5e7355=
666
        new failure (last pass: v4.19.255-210-ge9c2571e8f37e) =

 =



platform                     | arch  | lab          | compiler | defconfig =
            | regressions
-----------------------------+-------+--------------+----------+-----------=
------------+------------
da850-lcdk                   | arm   | lab-baylibre | gcc-10   | davinci_al=
l_defconfig | 2          =


  Details:     https://kernelci.org/test/plan/id/62fbd0fbc4dba63095355664

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62fbd0fbc4dba63=
09535566b
        failing since 0 day (last pass: v4.19.255-213-gfed5954506179, first=
 fail: v4.19.255-210-ge9c2571e8f37e)
        4 lines

    2022-08-16T17:16:22.686217  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-08-16T17:16:22.687468  kern  :emerg : flags: 0x0()
    2022-08-16T17:16:22.689653  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-08-16T17:16:22.690309  kern  :emerg : flags: 0x0()
    2022-08-16T17:16:22.757954  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-08-16T17:16:22.758781  + set +x   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/62fbd0fbc4dba63=
09535566c
        failing since 0 day (last pass: v4.19.255-213-gfed5954506179, first=
 fail: v4.19.255-210-ge9c2571e8f37e)
        6 lines

    2022-08-16T17:16:22.508365  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-08-16T17:16:22.509958  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-08-16T17:16:22.510553  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-08-16T17:16:22.511124  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-08-16T17:16:22.511668  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-08-16T17:16:22.512549  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-08-16T17:16:22.550651  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =

 =



platform                     | arch  | lab          | compiler | defconfig =
            | regressions
-----------------------------+-------+--------------+----------+-----------=
------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbd17898e1c7a29b355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbd17898e1c7a29b355=
643
        failing since 119 days (last pass: v4.19.238-22-gb215381f8cf05, fir=
st fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
            | regressions
-----------------------------+-------+--------------+----------+-----------=
------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbd14a03f2005fee35567b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbd14a03f2005fee355=
67c
        failing since 98 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab          | compiler | defconfig =
            | regressions
-----------------------------+-------+--------------+----------+-----------=
------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbd14c03f2005fee35567e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbd14c03f2005fee355=
67f
        failing since 98 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab          | compiler | defconfig =
            | regressions
-----------------------------+-------+--------------+----------+-----------=
------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbd14903f2005fee355678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbd14903f2005fee355=
679
        failing since 98 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab          | compiler | defconfig =
            | regressions
-----------------------------+-------+--------------+----------+-----------=
------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbd15ee4d22555fc355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-g613a9e1e0172b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbd15ee4d22555fc355=
658
        failing since 98 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =20
