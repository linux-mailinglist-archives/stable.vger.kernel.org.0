Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77E042B283
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 04:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhJMCKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 22:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbhJMCKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 22:10:21 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463BBC061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 19:08:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q5so807633pgr.7
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 19:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pXoSFVYQvHtcZK2Q+KlAwCdqXckGdMONgF6ULKTwv7U=;
        b=e7jL5dIx5i+y1C9Qo+eGvqBxJ8OYyujBNZZSoXUqdUxZxROi7Kfm3QjAgcmA+GiWyr
         GnWSeJQ8ARxApff5EGUHrF9H497psGBTm0EVCkz6OUlAJf/x9U4Pr3aUe4xlFM82XcI7
         uaHvzC5T1ynVZhNHLrz/ZbjsZQ3eTuOyrBzgJ7HDZ3VDf3R53fxOsWnEv4LHxi3kwor4
         DuUjHRwHfGA1wr28Ru64lHmzc1N9hq5WAlIw3/ZTxVenV9WMpa1oeYiY6QuJctUgC7Ic
         IdUw/PpqkszHbvXbFt2Gdqy94rjaxmd83ar8Dk51kavTp8Lv1RHJs3YNyvzJJCmR60yQ
         5nLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pXoSFVYQvHtcZK2Q+KlAwCdqXckGdMONgF6ULKTwv7U=;
        b=0JhfHjjwIX3LDU8LlWvmpw03viz+jkVDHG3WSc1fnaMnzxRzXVg71rc2f590Z4sVh6
         5CDPNFVq0awQVxpv/m7T1b3ltDSUQTD0LkZMaG67aT2Qj/POT/ijhOuT5uxme36hJCZP
         g0NU7iCpyHHxBN3x37GqDyNE6Va9+/qv0cFHbRTdyXbFSmy47jxTXguP44YaWRfbmOkx
         Xf3zZOIKxJjAXvm8Cd9xNivSup5d31VwyQTcsZnbqhas2N591rtv0hCnYdmmTu3Jr27+
         ysq20/9A2t2Wn7spz53taD/3emsMKR9kxGU+TX15HQhOAsmrRpqGV4njVqhGIsx+ONs7
         Ihww==
X-Gm-Message-State: AOAM533SeNry/bVGHTtkBkmvOE0+dsKbqbkB5YdjV+R03GZI8C0d3ALV
        iJG5QdfTOemhHxWoGMhs8zV7ToR9aXJLVErR
X-Google-Smtp-Source: ABdhPJzq69xBtnBF6SEgHByCx5roQqzcZMJvTUaQ/X2ruePj+SRPNGOhPCHMJye77n+/AtANq3nmdw==
X-Received: by 2002:a63:1d53:: with SMTP id d19mr25070466pgm.85.1634090898520;
        Tue, 12 Oct 2021 19:08:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14sm4059310pjd.24.2021.10.12.19.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 19:08:18 -0700 (PDT)
Message-ID: <61663f92.1c69fb81.dbf4b.cb06@mx.google.com>
Date:   Tue, 12 Oct 2021 19:08:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.210-28-g9d7f82841498
Subject: stable-rc/linux-4.19.y baseline: 90 runs,
 5 regressions (v4.19.210-28-g9d7f82841498)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 90 runs, 5 regressions (v4.19.210-28-g9d7f=
82841498)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =

panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.210-28-g9d7f82841498/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.210-28-g9d7f82841498
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d7f82841498fc2d3a1dcaa988257501521dc37a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/616607d6d303fda64808fab3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-28-g9d7f82841498/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-28-g9d7f82841498/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616607d6d303fda64808f=
ab4
        failing since 1 day (last pass: v4.19.209-13-g0cf6c1babdb5, first f=
ail: v4.19.210-29-gbf6c58e72541) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616605986f42e0ed1108fad6

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-28-g9d7f82841498/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-28-g9d7f82841498/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616605986f42e0e=
d1108fad9
        new failure (last pass: v4.19.210-29-gdd0ad52a3bb0)
        2 lines

    2021-10-12T22:00:33.122637  <8>[   22.575347] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-12T22:00:33.167609  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-10-12T22:00:33.176760  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cf4 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6166047672b4549ee208face

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-28-g9d7f82841498/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-28-g9d7f82841498/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6166047672b4549ee208f=
acf
        failing since 328 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6166046f72b4549ee208fac8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-28-g9d7f82841498/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-28-g9d7f82841498/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6166046f72b4549ee208f=
ac9
        failing since 328 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6166049a0553d5324f08faae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-28-g9d7f82841498/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-28-g9d7f82841498/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6166049a0553d5324f08f=
aaf
        failing since 328 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
