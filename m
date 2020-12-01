Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48B52CA948
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 18:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392120AbgLAREn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 12:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392064AbgLAREn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 12:04:43 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8A4C0613CF
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 09:04:03 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id s21so1489107pfu.13
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 09:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YzgXjOh73vWlG+dlp+Um9wrMhksTrxPDPKV77T3fpeY=;
        b=R6Xgp9ObYNvxEPuPzHa8N2i+1BU2BWhi/+jTGCubX1BncQSs4YqqL3NRErwLXfMhnN
         PuAcH5ER4cngisMoQrvJgpBmVYdy6iWh7XQvKzhGHAY/YBoHqT8hZpOJxASHu5q1+1il
         UnsruaY3hsLO8n62IXq4mOLn5/6fa8PPEsUpaXWekMsP5PWetqlBY4SdKKwD4/JItol1
         i0eZf/9zkbNy7hmRi+o7TuufzBaSiUZfzchzzkqPFA3J7aWqkF02UieMcLL8GHbPK2Nu
         BC4DjUtvZKAJEoscryvg6oFIhMSO/TCj2bg4+vAvStSC/RztfHeA7DsoZ86PeC/3qgJz
         j2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YzgXjOh73vWlG+dlp+Um9wrMhksTrxPDPKV77T3fpeY=;
        b=ffGslAbB+Ui9KFsFPevLtWwtuYoyzZmToaiJbnuCKBMkhreTc0X6pLAqmr0Zod400K
         MXFXip+5P/kFlbzLFgUES2x8BYEuR/h3I55iSGeTmAx408DzjT5WOuvcPzSv1DnTEcSU
         QUbkDZaNPZKHavcQ3EygwaArd5UkQyy660vLrt1Qt3CqSoVUBUal+JhDHwXtLVB+xsTe
         m/474/z5RvtebHhNQAZSyrmq3JG72v4c7xXP5lj7MqU1vG1Jrnygd+kzUENVc4v+4I9u
         y28apWdj064ghX2zTZNVzKfILrd5u1oy3ubfW41isx+LLPKSSV0cjKibSxVvrvbeAaYL
         SP6g==
X-Gm-Message-State: AOAM531vZcRCD3mAQ571laWzLf9MHYngqry3IoFNh3YYS3N92OO0r6kF
        pzhP9E6sn0hG5PxPB4vrOaeqrWWf3Cs/8g==
X-Google-Smtp-Source: ABdhPJxRrot3n/R1P1OGZjyo6TNY1QKuHg8ku83Zp2WWsvMr4d1lRjPp8bMIlleB7ouEcFuGB4LekQ==
X-Received: by 2002:a63:1346:: with SMTP id 6mr3099316pgt.330.1606842241371;
        Tue, 01 Dec 2020 09:04:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z17sm228427pjn.46.2020.12.01.09.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 09:04:00 -0800 (PST)
Message-ID: <5fc67780.1c69fb81.322b8.0701@mx.google.com>
Date:   Tue, 01 Dec 2020 09:04:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.80-98-g988f6f57c83b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 152 runs,
 5 regressions (v5.4.80-98-g988f6f57c83b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 152 runs, 5 regressions (v5.4.80-98-g988f6f57=
c83b)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.80-98-g988f6f57c83b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.80-98-g988f6f57c83b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      988f6f57c83be9493adb5149145bbf312d1c893d =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc641b41dce0e2bc7c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-98=
-g988f6f57c83b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-98=
-g988f6f57c83b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc641b41dce0e2bc7c94=
cd3
        failing since 11 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc646dbfd73c77a4ac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-98=
-g988f6f57c83b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-98=
-g988f6f57c83b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc646dbfd73c77a4ac94=
cba
        new failure (last pass: v5.4.80-90-g768da561c6f00) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc6416cf76c23cda3c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-98=
-g988f6f57c83b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-98=
-g988f6f57c83b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc6416cf76c23cda3c94=
cce
        failing since 17 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc6418cab425a9493c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-98=
-g988f6f57c83b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-98=
-g988f6f57c83b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc6418cab425a9493c94=
cc8
        failing since 17 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc64181f76c23cda3c94cea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-98=
-g988f6f57c83b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-98=
-g988f6f57c83b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc64181f76c23cda3c94=
ceb
        failing since 17 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
