Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3862A2F02B0
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 19:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbhAISGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 13:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbhAISGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 13:06:15 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C98C0617A4
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 10:05:42 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id n10so9754740pgl.10
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 10:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DD1H1W2/MZzlGwVnuccGB91FjYB0YqebLyVy5Uj2c4w=;
        b=qOzNwX95UIsdiqyiysO1IENaltWU4cOEZIH2HQSRaSxxHOpb2k6ib8cpeySy/nlI6N
         vLuPv6fm+3E/Q8pwolP14QfgPwgqukF5/vrKmMSUcbhWL7JK0LGsa2wl1d48bOO66Yaz
         v2PTGccxRlpJZRHiv2e+HvzXzUwchJ1WBaSM2hZbpPLDjB5mbsn+CBAyB1Dty0IYJ4B1
         l6xf+hqdk+hUZ8ABUjBuV0d6M1f5W0NxygR9n/blGx+ghXUrxo8h90Yjbkzt6Du5BbDY
         xl+tOx2Frc2f65gdbIxYAL2ZKkvp3rn7eXUF23jL0QEUb2NW5F8EQEA9MwO1W2cO0pjN
         BPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DD1H1W2/MZzlGwVnuccGB91FjYB0YqebLyVy5Uj2c4w=;
        b=W8df7u8zacJ8iA9hPVF3voAFK6UqcWN2xMeCmrYPKU5SD9tQ9eywPdAYUABGTYGQKh
         zajtWJLMaifuMV396/mGz3hwLUzl19vnOHNUsLHYJ/aAJvxeocuju2W9d3jsF7JiAQDn
         RRn8ve1Un3wD4YW9aIzo2GrPDFqQ9I2hrfWe41XHduATIW0vVa/lJU5soZ6Ww87urpIq
         00lTEB3Lp9x/spityM/3uDUjFq0MSnXOaWmZBuNanNCKEXZ5gOIH/9pSS2AqsGWCOuM/
         5645Jb7SdwcQjlQ9FjtXnVmr3nhnNbof5eCDTgav1pzkcvTU0hcRSfJdbsQagpzcEeL4
         vQNg==
X-Gm-Message-State: AOAM532kCzSbBU6P/sUpBwXUyHyYSKXo7PAvr9fLq9nsPO9L/tELJTU0
        +y6GUr4AuQnFNfaOF83UoGNXBX+xFdzRAg==
X-Google-Smtp-Source: ABdhPJxS6/HDuNPybhhX4rtrTMSKhdmtErLHXt5fkzzskaxJmK0iLteEtLzdKrb7/oZcItzp+kw2HQ==
X-Received: by 2002:aa7:9722:0:b029:19e:2832:4f63 with SMTP id k2-20020aa797220000b029019e28324f63mr9240527pfg.58.1610215541615;
        Sat, 09 Jan 2021 10:05:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k64sm13643665pfd.75.2021.01.09.10.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 10:05:41 -0800 (PST)
Message-ID: <5ff9f075.1c69fb81.8adcd.ead2@mx.google.com>
Date:   Sat, 09 Jan 2021 10:05:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.250
X-Kernelci-Report-Type: test
Subject: stable/linux-4.9.y baseline: 115 runs, 6 regressions (v4.9.250)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 115 runs, 6 regressions (v4.9.250)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.250/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.250
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7e8e7dc278864a2391fd73b9f163bfe1963451da =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9b6842e661ce21ac94cc8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff9b6842e661ce=
21ac94ccd
        failing since 45 days (last pass: v4.9.245, first fail: v4.9.246)
        2 lines

    2021-01-09 13:58:24.887000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/118
    2021-01-09 13:58:24.896000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-01-09 13:58:24.911000+00:00  [   20.307189] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 92:8a:37:c4:c5:dd
    2021-01-09 13:58:24.917000+00:00  [   20.320556] usbcore: registered ne=
w interface driver smsc95xx
    2021-01-09 13:58:24.935000+00:00  [   20.333709] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9b6c06df6f61603c94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9b6c06df6f61603c94=
cd5
        failing since 51 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9b6c9ca1c0ccb22c94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9b6c9ca1c0ccb22c94=
cd0
        failing since 51 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9baaea20aa60328c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9baaea20aa60328c94=
cbb
        failing since 51 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9b6992e661ce21ac94cef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9b6992e661ce21ac94=
cf0
        failing since 51 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9b696406ac9b477c94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.250/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9b696406ac9b477c94=
cda
        failing since 51 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
