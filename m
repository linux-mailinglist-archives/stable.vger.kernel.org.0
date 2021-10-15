Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677CB42E884
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 07:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhJOFyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 01:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhJOFyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 01:54:45 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD90C061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 22:52:39 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f5so7605501pgc.12
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 22:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y/YxzoCFdGlUO9kfGO0IuQs32io5RrpBsWdHxrbppFI=;
        b=2Lg+OAPeeUPJjH11TANxSUyIngPD0Jiv/SFMvIhNULZCB0GTDDQ1jCt8bAEeK44qJL
         iJdS1trtp+tsrXhkZy21vHEn7duGEHSHB9NOzcAcwoqstK/Mb4M4Nz+J4798RDEZV5M7
         B8epMD61OFCFhBiNVbMHe07/LJkl9yJPaJoTjfi7nWJ+CWCqmUUzz139XxT6nSlAUSWb
         mh5+jZHzXwGtk0HiQERBl3IKQ0XnAv9Fby9Hs/1vvL+BiNrrQg3hlZ9SmgsH8hF1q8qS
         VMjfvGmm7KU+P5CoG1PbOmKiXVmnwOirZ6ym9I7lQbMwW6YVS77r/z1jqTVqa+jNibMA
         pUYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y/YxzoCFdGlUO9kfGO0IuQs32io5RrpBsWdHxrbppFI=;
        b=etP7ungjj/N6+T9pzakUMNX7BKERkcrKNcZSSfGqWTYl9mNqiCOaOB6yuJX9Cy6pRJ
         zBrEl6cklLAG2ysBddeHKKfnXtNBFjp/CzgxWpxudQlwqiheqrPGWthS3MGBy6B0uV3O
         NO667eEkVyEY2aLchBZbnO79W7m+SvboP/KP/jxApcg++LtOXo1ch9lTTCzj3mDB9A0Q
         rTnL3u4HxEMUkVEtwljzSNbAXa8R/9eAtpaUQCX9YOt7/vWL9gy6GnQQQfPX9EyS/p9h
         +ozopjQrW4yYfKNEjX34NhNF0uE7PQMr/SsITWccnU9ecyhAbnXEg+3VNdSKMkD2wjc+
         8ZfA==
X-Gm-Message-State: AOAM531KJpF1X6EohEjVKVgaj8qa9AmiSg3wMzVhDo2nptAqVXtk4vwV
        Ab7VPMWtgnTBt0j9A+LT1b5WBuhmt8nX3NzH
X-Google-Smtp-Source: ABdhPJwIuECR2TiI6oZM/V1Hv7W3UvX+B/d7ydjgMqUfFwlb4NWDR6L3U7W2AIjrBLSikARPUbQTYg==
X-Received: by 2002:a65:6287:: with SMTP id f7mr7821007pgv.444.1634277159254;
        Thu, 14 Oct 2021 22:52:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f84sm4023936pfa.25.2021.10.14.22.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 22:52:38 -0700 (PDT)
Message-ID: <61691726.1c69fb81.66327.d2f4@mx.google.com>
Date:   Thu, 14 Oct 2021 22:52:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.153-17-g8f48de738cda
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 86 runs,
 4 regressions (v5.4.153-17-g8f48de738cda)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 86 runs, 4 regressions (v5.4.153-17-g8f48de=
738cda)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.153-17-g8f48de738cda/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.153-17-g8f48de738cda
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f48de738cda248d961f0fc9967316716498b80f =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6168da054f0fcfa4f8335906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g8f48de738cda/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g8f48de738cda/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168da054f0fcfa4f8335=
907
        failing since 328 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6168d92660d4250a723358fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g8f48de738cda/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g8f48de738cda/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168d92660d4250a72335=
8fe
        failing since 334 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6168da39beb949c4f63358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g8f48de738cda/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g8f48de738cda/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168da39beb949c4f6335=
8e2
        failing since 334 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6168d87590ca2de7493358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g8f48de738cda/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g8f48de738cda/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168d87590ca2de749335=
8e9
        failing since 334 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
