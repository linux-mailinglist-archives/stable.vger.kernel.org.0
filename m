Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19623A726E
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 01:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhFNXXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 19:23:51 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:40813 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhFNXXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 19:23:50 -0400
Received: by mail-pl1-f175.google.com with SMTP id e7so7460262plj.7
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 16:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z36XfmBcksFnBXfFTADhrt+k7JEvAVbfTdnGzLSxru0=;
        b=kzhlIxu+d3OMqV6ExpfEhlw7nPkkE9COFLK+xKdnnHOnV/84QrotLkpx1un9QItvGb
         8/QYAfz0cLdCoqv/1gRZZCVH3KSPwF07zan2/SmvbDVyp0YlXFsyDzCJyCqWxYOetkHU
         1g1MK2gsdfQGbRnaUjdeVzikML3xYxiuwb4RgejDD/AP3lDryzYpEwABduJb77c/8nWn
         /GAWsF7QA4d7swtKvsRQaUOVsSOe0WpJZFKwBvX1BX7dyW5tg3FOQVJrTQ90hBGHZ/cK
         gzMUTATIEA/++uPSw8vtR0DYgt4VzdX6Qb8UozdQnvIbC9KAwZ9L/KepBz6JyidQQaOS
         Ri9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z36XfmBcksFnBXfFTADhrt+k7JEvAVbfTdnGzLSxru0=;
        b=QLNXPPXJ2XybLscDWVRfW6l9S+CFI+0fjCBm5RQzCYwt7tT1g+Qs/7TklzhNWxXAd/
         Y4tkBs+qxypQBgil25DSTtm/PICy3989i2Q/tvq8A4XCP4nZvzt39gk83EafhNxkzSng
         otgcuA/3ePz+fSu6f04WrScdBWYChHV6RIOJ3YJu++KqpIf4otn6abvbZ37N7rOUKICP
         B8TzakIcdiu3KZ197xl0SILA5SEJruFeBF+ZGf4kw7Ohir/87qCpA3H2Pnk2cFbwfm+s
         x2x8Z6KKVEW9QTr4IyKu51S9MU520a+HlIsEaihaqxMnzQp2rLh2K8EfRJMnOQhVbDiZ
         69jg==
X-Gm-Message-State: AOAM533m2oaviEk1g0eaaQmnwXTbGASJoxmptkj19w7qIfAS6HRmPUrV
        XzfchefdepNDKAyadBO4fdnAb/nTq2NyQ8zU
X-Google-Smtp-Source: ABdhPJxL+RLrdFyHyPdKm/QIJd/0bdvXMJRp7kvibKSNZZY4hD+dG8R4OQAqzvnlfdEpB5bxytop8w==
X-Received: by 2002:a17:90b:3749:: with SMTP id ne9mr1564153pjb.77.1623712836713;
        Mon, 14 Jun 2021 16:20:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n69sm13824814pfd.132.2021.06.14.16.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 16:20:36 -0700 (PDT)
Message-ID: <60c7e444.1c69fb81.330d6.8079@mx.google.com>
Date:   Mon, 14 Jun 2021 16:20:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.194-68-g3c1f7bd17074
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 145 runs,
 7 regressions (v4.19.194-68-g3c1f7bd17074)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 145 runs, 7 regressions (v4.19.194-68-g3c1=
f7bd17074)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
      | regressions
---------------------+------+-----------------+----------+-----------------=
------+------------
da850-lcdk           | arm  | lab-baylibre    | gcc-8    | davinci_all_defc=
onfig | 2          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig   | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig   | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig   | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig   | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.194-68-g3c1f7bd17074/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.194-68-g3c1f7bd17074
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c1f7bd1707440cbbb07d14370ce120a1a29b79c =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
      | regressions
---------------------+------+-----------------+----------+-----------------=
------+------------
da850-lcdk           | arm  | lab-baylibre    | gcc-8    | davinci_all_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60c7b0eef765c33db34132d9

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-d=
a850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-d=
a850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60c7b0eef765c33=
db34132dd
        new failure (last pass: v4.19.194)
        3 lines

    2021-06-14T19:41:24.837535  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2021-06-14T19:41:24.838169  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2021-06-14T19:41:24.838667  kern  :alert : page dumped because: nonzero=
 mapcount
    2021-06-14T19:41:24.897402  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60c7b0eef765c33=
db34132de
        new failure (last pass: v4.19.194)
        2 lines

    2021-06-14T19:41:25.036257  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2021-06-14T19:41:25.036894  kern  :emerg : flags: 0x0()
    2021-06-14T19:41:25.122007  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-06-14T19:41:25.122642  + set +x
    2021-06-14T19:41:25.123201  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 448948_1.5.2=
.4.1>   =

 =



platform             | arch | lab             | compiler | defconfig       =
      | regressions
---------------------+------+-----------------+----------+-----------------=
------+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7afad9b06c4629f41328d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7afad9b06c4629f413=
28e
        failing since 208 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
      | regressions
---------------------+------+-----------------+----------+-----------------=
------+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7b57622584eba71413278

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7b57622584eba71413=
279
        failing since 208 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
      | regressions
---------------------+------+-----------------+----------+-----------------=
------+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7af8e5e727bcc04413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7af8e5e727bcc04413=
267
        failing since 208 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
      | regressions
---------------------+------+-----------------+----------+-----------------=
------+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7d2adbd8fff62c7413279

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7d2adbd8fff62c7413=
27a
        failing since 208 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
      | regressions
---------------------+------+-----------------+----------+-----------------=
------+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7e2f906f97e687941328c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94-68-g3c1f7bd17074/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7e2f906f97e6879413=
28d
        failing since 208 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
