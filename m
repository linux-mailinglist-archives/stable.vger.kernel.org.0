Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212012D486F
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 19:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgLIR5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 12:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgLIR5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 12:57:38 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34303C0613D6
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 09:56:58 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id hk16so1395351pjb.4
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 09:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=By3AssgavsjT2IVfr8k1J7DR8oNRkKjYWzR2maptMM8=;
        b=USsZgMvFDhU5vggfNJN54lg8DgXFKvpLP98ZEOC1IJwfM6s3MAr4N9tKQt9fG1irRj
         p/gi2ERP4p8XqddpISnwqCbzdrnyd7v52T43MqM8dkm2uY4wmWWlsizw7RElbCrNsNa2
         NmvgfiI1CBOVMjZZDhc3RkgHJ2Yfk0E4pjwbKEEtVxA2L2Ni7cOBvMAa8fxrQLmRJ2O6
         kxNkeU60DTmop2PXMNVkSfiMIKDFqUv3NykaDJRTdJfTVWv3d/dAR+00B20eGexXttKv
         EbtK+4rM93TYg3I2INqCuLXFtfdf+85w+AQbn3cxRuIRRlwcOM0+i7qGJalYKEmEJRnu
         hsJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=By3AssgavsjT2IVfr8k1J7DR8oNRkKjYWzR2maptMM8=;
        b=B45lFSAs/fp5zOIgWac3z6XYK7xGgyg+4QqG1VKmA/g6ca2v4vj45NRjIknItbBoAK
         VORw6YTXKFDd4mBCYJHVJuSpAvmU8+kSEVt1m7jVVVQQEMw1duUGPqCKFJ57qZ8tH+Ve
         q5PcK9V8KGLeFQ3x+0UYTKJZbqdpwjC5XDejApgO+Hq600tlos+eHhSKIRG1scrD8yZr
         cySyryhsy6fIRHfhag9COPMVgxgdBl4wxx9IRQG8DrTEYLISd3IAR8+xjqb9qVBvGUT+
         XICJtNSNE2iatkaItL8cOCNkaZi64motOlFkgvOMWsre9luHgcRASRfsPCHK1VYOa6w1
         SjJw==
X-Gm-Message-State: AOAM530eQ1rYGxOBIy6HiTzaD5Desn3ZidBZ7ccGgDxesAWz/vnHj4o4
        3ZJqKLQNCwFtrznhIEAvqhVOjLeqACeZwQ==
X-Google-Smtp-Source: ABdhPJypZKSNjahW0NNx7ZocbXw3EkZlzG7KYzwhjgscndrUkh7qfVeD1f5Kf+joUevgF5RUxNxCCA==
X-Received: by 2002:a17:90a:c592:: with SMTP id l18mr3264502pjt.228.1607536617346;
        Wed, 09 Dec 2020 09:56:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 129sm3383671pfw.86.2020.12.09.09.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 09:56:56 -0800 (PST)
Message-ID: <5fd10fe8.1c69fb81.57c53.60cf@mx.google.com>
Date:   Wed, 09 Dec 2020 09:56:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.82-39-ge908be9861d9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 157 runs,
 7 regressions (v5.4.82-39-ge908be9861d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 157 runs, 7 regressions (v5.4.82-39-ge908be98=
61d9)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 2          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.82-39-ge908be9861d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.82-39-ge908be9861d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e908be9861d992e4f720de21baa0a1fa2b36a60e =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0ddb4cf5fe17eb2c94dda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0ddb4cf5fe17eb2c94=
ddb
        failing since 19 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 2          =


  Details:     https://kernelci.org/test/plan/id/5fd0d8b461ad199dc6c94cf1

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5fd0d8b461ad199=
dc6c94cf5
        failing since 0 day (last pass: v5.4.82-32-g02b97e6d7294, first fai=
l: v5.4.82-35-gee2505e9b00e)
        11 lines

    2020-12-09 14:01:18.124000+00:00  kern  :alert : Mem abort info:
    2020-12-09 14:01:18.124000+00:00  kern  :alert :   ESR =3D 0x96000004
    2020-12-09 14:01:18.165000+00:00  kern  :alert :   EC =3D 0x25: DABT (c=
urrent EL), IL =3D 32 bits
    2020-12-09 14:01:18.165000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2020-12-09 14:01:18.165000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2020-12-09 14:01:18.165000+00:00  kern  :alert : Data abort info:
    2020-12-09 14:01:18.166000+00:00  kern  :alert :   ISV =3D 0, ISS =3D 0=
x00000004
    2020-12-09 14:01:18.166000+00:00  kern  :alert :   CM =3D 0, WnR =3D 0
    2020-12-09 14:01:18.166000+00:00  kern  :alert : [ffdf8000117998c8] add=
ress between user and kernel address ranges
    2020-12-09 14:01:18.166000+00:00  kern  :alert : Fixing recursive fault=
 but reboot is needed!   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd0d8b461ad199=
dc6c94cf6
        failing since 0 day (last pass: v5.4.82-32-g02b97e6d7294, first fai=
l: v5.4.82-35-gee2505e9b00e)
        2 lines

    2020-12-09 14:01:18.196000+00:00  kern  :emerg : Code: 0b020000 37f801a=
0 d503201f f9401fe1 (f9400280)    =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0dd2944eb793b9cc94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0dd2944eb793b9cc94=
cd2
        failing since 25 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0de851d17cca94fc94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0de851d17cca94fc94=
cbe
        failing since 25 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0dd29b4fcfa0636c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0dd29b4fcfa0636c94=
cba
        failing since 25 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0dce522d4fbd753c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-ge908be9861d9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0dce522d4fbd753c94=
cc7
        failing since 25 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
