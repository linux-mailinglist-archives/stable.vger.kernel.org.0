Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB10389B5F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 04:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhETC1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 22:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhETC1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 22:27:34 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216EFC061574
        for <stable@vger.kernel.org>; Wed, 19 May 2021 19:26:13 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t21so8156104plo.2
        for <stable@vger.kernel.org>; Wed, 19 May 2021 19:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ASVvJiqoBzIfa3kQKdbrmYPzx8sRE2Z2iZE2UOClW2s=;
        b=0eaOOcwPDyXCcrzaHHzaXLBC3m1GCvfFn4cDE5xO2N+qxDeN1WCzILCaAiTVL9Z+pZ
         y5QvKh8sqMFY08KAL6jKo/HBjLT9bv+7rmX1srnqC9CIcRuFUK0v6fH7F5GWcwEPcnY7
         iEl/kTtSzVZdGi8EAjR7naJANHv76I9RiiQLbCRc4yQuaWZ2WmsD+IDrIJLAdK0VUXXC
         zR3O5elgRnXRdTY180Jnt/ZLQur25QZfxSbEdjBoZdneio6/1g4Dwcadv2ixa1+dkX7M
         0bL/bSiORCDb6zpYBP9wpF3zQ2jc/x1rO/jal68IrsKiKIweQ1iX1r4O09djfG98zbDU
         rIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ASVvJiqoBzIfa3kQKdbrmYPzx8sRE2Z2iZE2UOClW2s=;
        b=oIpwlWkbwcSI341KtvhEAayfAbbTTs21/MiAtfCI8hpwMaTnTfX/xEr+glwvmx2jJx
         NN7mc5ZTTLoLdKe3XnHFwHzW89j0b1kJg9apFx2v+GWJSf7lm0J/gqaMcS7jOsDbt/Bl
         2+VqpAviVEF920BdT2cJp+SXn1SQyq0znfU7Jy53UFLEeEPEsQXdGK3J43Ui4wIyJnzk
         RV8Au/PuSyilBVwNxXY/rqjBx4/jbA8LbYu7Rul9l57aYZnffEzbc9wt2QYPl1UqhPfr
         X/tZzvTDoWCtJ8d2eBidStqBQ5lJUVzSXVejdp4EJ90C8SVYgj8Y3gSeSWJtJvlJp0hp
         NYPg==
X-Gm-Message-State: AOAM532de1E7G2Bl12pjB+t4UK7hSF9MHAnhj7I2CWHZpTeXvDwLakER
        vbhj34RqjbZ3tNiLJwrgWsgabjeVBXkJYfDx
X-Google-Smtp-Source: ABdhPJwPR47a6UPoCwM4SU5Z0yQeuolVffK9lzlB5/Mvadr3iDb/5twRyAmSoqBJb1o5oXHCbbn0jg==
X-Received: by 2002:a17:90a:ba8b:: with SMTP id t11mr2632244pjr.106.1621477572906;
        Wed, 19 May 2021 19:26:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6sm541105pgv.48.2021.05.19.19.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 19:26:12 -0700 (PDT)
Message-ID: <60a5c8c4.1c69fb81.1f62.3513@mx.google.com>
Date:   Wed, 19 May 2021 19:26:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.120
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 174 runs, 7 regressions (v5.4.120)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 174 runs, 7 regressions (v5.4.120)

Regressions Summary
-------------------

platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
hifive-unleashed-a00     | riscv | lab-baylibre    | gcc-8    | defconfig  =
         | 1          =

qemu_arm-versatilepb     | arm   | lab-baylibre    | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb     | arm   | lab-broonie     | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb     | arm   | lab-cip         | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb     | arm   | lab-collabora   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb     | arm   | lab-linaro-lkft | gcc-8    | versatile_d=
efconfig | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.120/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.120
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e05d387ba736bcabe414b0aa05831d151ac40385 =



Test Regressions
---------------- =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
hifive-unleashed-a00     | riscv | lab-baylibre    | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60a5943d7eb2370c6cb3af9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a5943d7eb2370c6cb3a=
f9b
        failing since 180 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb     | arm   | lab-baylibre    | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a593a49145504c83b3afc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a593a49145504c83b3a=
fc8
        failing since 186 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb     | arm   | lab-broonie     | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a5939f9145504c83b3afbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a5939f9145504c83b3a=
fbc
        failing since 186 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb     | arm   | lab-cip         | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a593ad4c8c4f75a2b3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a593ad4c8c4f75a2b3a=
fb6
        failing since 186 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb     | arm   | lab-collabora   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a59348ab6950683db3afe3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a59348ab6950683db3a=
fe4
        failing since 186 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb     | arm   | lab-linaro-lkft | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a5bcf37c8ea84413b3afed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a5bcf37c8ea84413b3a=
fee
        failing since 186 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60a598d6850bd63e28b3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a598d6850bd63e28b3a=
fa8
        new failure (last pass: v5.4.119-142-gd406e11dbc13) =

 =20
