Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7932D79EB
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393284AbgLKPvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393386AbgLKPvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 10:51:23 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9652DC0613D6
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 07:50:43 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c79so7239386pfc.2
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 07:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j07ClbncT6AUaYEDJJ5W3CLh+jn5Gr20proDCm42tas=;
        b=Anu24C6riEWA9yUvPPt9fdLrjM25N3K1vh335X5DguK3F+JYav3GJbDb7+0pF9YeoS
         0ruCVlA7MNUvM6VkfTxQLLPuAV7J6DCwpErBQhWc7T2npMSgUN2oDC7Y5LLDPrgwZwFl
         cd1DZ+sBT3UcbSe3H2G8nEk4m4TfpklUJu/dekbeSAfaiH2B9JZ/e/6YAFALUFcJD46Y
         G8h3yE7K4RN7M1KRn1OyWy53kbFG0eUyrnZ2e3uwqGRKrSm0F+VBHE+Vt2cnQ2bRCdLB
         GjtmFB+tyPaSL6Ar4mrYkTZ218niV6pFRGrOzSGk+YnEBhptCDVL97Uz8jpJSb6GGuSG
         51pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j07ClbncT6AUaYEDJJ5W3CLh+jn5Gr20proDCm42tas=;
        b=CPKUyLClOy9SJAQJ6VMbVDDUhXlEfrDs0jb5oK4I6X4VgcH8UBoMSPWiCmKqelegyV
         Za3FcJpHh1DFkeVk/XlI/cR0zIAMGkcwafKCUg2+MCwdy/9i+PKJLjYbaRbb6NhwUjDy
         pFflARL7DqJwmOOZflBNXl/fhYVw3uNkZFie+qmznROxHErU2T9qhHq1zF7JBIY/Jiy9
         jtnVfMbGBoDrF0DDf6jXZp+f/miVMYfJndhbK5NUrEQgSJDL7sBEuHr1cwEa4vqnPVkm
         BcNsooPNateLLrzBbJKhmp5I2XIv397oFHKfsTS3jldtaEL1IUWjvKgMM0phyO20MgJn
         F5kQ==
X-Gm-Message-State: AOAM532WR33l8lXEyopkIZ5yEFiMKpEkYLmXaXGpDvQSmwGIfmiVWEF0
        ZlU0GuT6I15mEXK29mTcy3wIVNV9KLORhQ==
X-Google-Smtp-Source: ABdhPJxkvVEBlTerz86d5cIjYq/ZHD9qCarU83P32qhNP6Yk4P5LWd84wLCGacQqeuT+AuzLaLJwoQ==
X-Received: by 2002:a63:b908:: with SMTP id z8mr12658477pge.396.1607701842735;
        Fri, 11 Dec 2020 07:50:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11sm10832699pjg.43.2020.12.11.07.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:50:42 -0800 (PST)
Message-ID: <5fd39552.1c69fb81.195d9.484d@mx.google.com>
Date:   Fri, 11 Dec 2020 07:50:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.82-54-gc610d6ff4f18
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 145 runs,
 5 regressions (v5.4.82-54-gc610d6ff4f18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 145 runs, 5 regressions (v5.4.82-54-gc610d6ff=
4f18)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.82-54-gc610d6ff4f18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.82-54-gc610d6ff4f18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c610d6ff4f18a47566355dc56a5c28ef742da6b2 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd35fb15be70759a0c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-gc610d6ff4f18/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-gc610d6ff4f18/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd35fb15be70759a0c94=
cc8
        failing since 21 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd35f1f77ff43a263c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-gc610d6ff4f18/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-gc610d6ff4f18/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd35f1f77ff43a263c94=
ccf
        failing since 27 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd360c9b12a3872c8c94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-gc610d6ff4f18/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-gc610d6ff4f18/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd360c9b12a3872c8c94=
cdb
        failing since 27 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd35f354735516724c94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-gc610d6ff4f18/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-gc610d6ff4f18/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd35f354735516724c94=
cd5
        failing since 27 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd374cf6c8209d567c94d85

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-gc610d6ff4f18/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-gc610d6ff4f18/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd374cf6c8209d567c94=
d86
        failing since 27 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
