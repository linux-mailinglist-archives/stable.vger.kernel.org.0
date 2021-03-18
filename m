Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBE733FED7
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 06:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhCRFYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 01:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhCRFXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 01:23:35 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC99C06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 22:23:35 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v186so690530pgv.7
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 22:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=io/ZBOHMGJYKBIxlsAJdCzTlFLph0lwS/6BBvZb8Nrw=;
        b=H9HRE3WEha1aJv0J4t3r1icMOM0TQUINqQVF3SvVzzCgnPuPR1qy0er6Ey/HFzKvqy
         hpVPfE0splM6PWP53R3QS6jlTOP5jCA27x2b7e4Ue5giSOakrE0hv2DJEN5Q1id149Ss
         MIgIpJA9o3qtAzRNebuRyk6aS6KXuenKVjb04jTk7lvxgmNEbrnwjvWDgaRmKHvdaKiB
         Dk1Oai2FRnH4aLFYcuW7aUte6JMjd5F3/JSG1Ox3AyJJ88EtVuyw7CNjBZBxbZq0ALts
         07BuZaSV/9ZUxxFXJIWk1UENAJ8/PTSu6G1M0mOSuOvi2GqMlHdNqGg6feqdj7LtXtIc
         EAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=io/ZBOHMGJYKBIxlsAJdCzTlFLph0lwS/6BBvZb8Nrw=;
        b=SVi7apyueyS4EOBjifhM7lhX4OXbss3bTELeeTjBd6XoIlKPoXKh/Ijw42Jz4Y81zp
         aK2zZn/fYB/5HCW4xDXgoMu77rABKPuRvsyb5abfh8vtqzsadU/lOH2kaMX78z3nspHq
         UkULsE5lBXDkLaLOcHGFD9fQ5f8JxtMhWRM22QsLopTqp/Z/YZFNPWnP4FLRID7MmprK
         syR6rJsdMXO2PjLfH6HVmChKNaehSEveK4R9QyIT7IPPuxbyANaW0sVXv+0b204Lt8B6
         sQkPsdG8WQJIWZdF6xePeNlUvYT44ZkOy8AmEaC4MOH0dbniVxu0g+8VOxIiQZz4pcRs
         REyg==
X-Gm-Message-State: AOAM532Hu1ZpWnIJd5P9oPZc/g3rtoEx8Ryu3uZtZHOpKFR4Uc03V23n
        3NwY7CYfEMgvlDuVmaNEBndAuJOIj8oF5g==
X-Google-Smtp-Source: ABdhPJzF/b0dNUYh231EGCwwqLbBQ9hlqGEYgjeaNkH5w+fohzwID0z3MtU/PLkI5O3tXoD+CqWL5g==
X-Received: by 2002:a63:792:: with SMTP id 140mr5502842pgh.200.1616045015034;
        Wed, 17 Mar 2021 22:23:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ds3sm776497pjb.23.2021.03.17.22.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 22:23:34 -0700 (PDT)
Message-ID: <6052e3d6.1c69fb81.339bc.29a3@mx.google.com>
Date:   Wed, 17 Mar 2021 22:23:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.106
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 133 runs, 5 regressions (v5.4.106)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 133 runs, 5 regressions (v5.4.106)

Regressions Summary
-------------------

platform                  | arch  | lab           | compiler | defconfig   =
        | regressions
--------------------------+-------+---------------+----------+-------------=
--------+------------
hifive-unleashed-a00      | riscv | lab-baylibre  | gcc-8    | defconfig   =
        | 1          =

qemu_arm-versatilepb      | arm   | lab-broonie   | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb      | arm   | lab-cip       | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb      | arm   | lab-collabora | gcc-8    | versatile_de=
fconfig | 1          =

sun8i-h2-plus-orangepi-r1 | arm   | lab-baylibre  | gcc-8    | multi_v7_def=
config  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.106/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.106
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0437de26e28dd844f51fde7a749a82cb2d3694ad =



Test Regressions
---------------- =



platform                  | arch  | lab           | compiler | defconfig   =
        | regressions
--------------------------+-------+---------------+----------+-------------=
--------+------------
hifive-unleashed-a00      | riscv | lab-baylibre  | gcc-8    | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6052afbfa04fa7e307addce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052afbfa04fa7e307add=
ce7
        failing since 117 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform                  | arch  | lab           | compiler | defconfig   =
        | regressions
--------------------------+-------+---------------+----------+-------------=
--------+------------
qemu_arm-versatilepb      | arm   | lab-broonie   | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6052aea64b66403ba7addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052aea64b66403ba7add=
cb2
        failing since 123 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform                  | arch  | lab           | compiler | defconfig   =
        | regressions
--------------------------+-------+---------------+----------+-------------=
--------+------------
qemu_arm-versatilepb      | arm   | lab-cip       | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6052aedc23a3ca25baaddcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052aedc23a3ca25baadd=
cbf
        failing since 123 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform                  | arch  | lab           | compiler | defconfig   =
        | regressions
--------------------------+-------+---------------+----------+-------------=
--------+------------
qemu_arm-versatilepb      | arm   | lab-collabora | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6052ae4dab687eb111addcd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052ae4dab687eb111add=
cd5
        failing since 123 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform                  | arch  | lab           | compiler | defconfig   =
        | regressions
--------------------------+-------+---------------+----------+-------------=
--------+------------
sun8i-h2-plus-orangepi-r1 | arm   | lab-baylibre  | gcc-8    | multi_v7_def=
config  | 1          =


  Details:     https://kernelci.org/test/plan/id/6052b3465389a44f10addcc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h2-plus-orangepi-=
r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h2-plus-orangepi-=
r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052b3465389a44f10add=
cc5
        new failure (last pass: v5.4.105-61-ge8e77f614b2e) =

 =20
