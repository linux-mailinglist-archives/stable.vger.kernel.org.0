Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582013A0B09
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 06:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhFIEQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 00:16:20 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:36645 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhFIEQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 00:16:19 -0400
Received: by mail-pg1-f171.google.com with SMTP id 27so18359656pgy.3
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 21:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lZbkne7s+zM7FA/CCViPdgfqV0G9cZHcSalkJ8gwzok=;
        b=XEklKoue4t16HL4nH5Ts0P4u/IOxDgCwukJSs5g7oIfMq8KM/bTCEAxPGM/U+S4g1U
         4YdcpmyFhpkjTHAk7zFBvRagnuD9VXoIMwCg8aHEHsKv3MkGYr6RcNabCE4XqUzCE+b9
         KxgivB4dveLf7FMlRWBR1TpNUn5FZ+rJzB1RHyWZ/P2LQkuT+bEsJO1f9ZAsApRFaaXy
         VfQlo1oliKLI9FB8PPDpAjs1HpPt3FDgDowpDwkI4HDLRsGbooTohi66+6pneBO8DrEi
         +4pIjOvf8neTjKLZ6b4Mwjv47eYXms44qL72BEdf/GFB476Pbe4tD6xK9tJU82d1H4Sp
         L1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lZbkne7s+zM7FA/CCViPdgfqV0G9cZHcSalkJ8gwzok=;
        b=dHsSq2djBWp7gVJJzE6Zokc++/7KdpY2QSS+lN1h9UE86a+XRaONf8cV3gAFj6/TDq
         YjXuh/YzKq/1h20vZ5+/biXv5llUJos3lCCm7daU0cG3Hv6RL7iCmoPmeAOIrG40CUu6
         UAfZXxKt5UINsI8I61L2RED5Z2+6B4jvSA8ChPhFfKbBBDs4tvFgPJL/kT0CGwEUsU6l
         nzV8zrJ9e3ZzYkbV1HLWQaWy5mCPNZeoYpvTVlzGF7UFTT4jDBKS17T750sYYMdjVDbY
         r1qW9wZeDCs/N/D2bTMxBOl88XrA26Qc6WkWeg51M579GjYSbluKYXEttKJFDdn8FG3k
         aWrQ==
X-Gm-Message-State: AOAM530yN50Da3gjPji96oLqtfP35K7YMkdwsTNVtka2qL/sURztqI89
        N2yumF2V5Q+gksdMKmZK6HabUf0L7pRNZ24W
X-Google-Smtp-Source: ABdhPJxOZdhunhqY49INeXJWE64eRgZJDlzDm6GQJV6tFgJ1sXHot55Prq7Kq2jOGmob4BudMy7Zfg==
X-Received: by 2002:a62:2e04:0:b029:2db:4c99:614f with SMTP id u4-20020a622e040000b02902db4c99614fmr3364916pfu.47.1623211993466;
        Tue, 08 Jun 2021 21:13:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q21sm12527224pfn.81.2021.06.08.21.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 21:13:13 -0700 (PDT)
Message-ID: <60c03fd9.1c69fb81.573ee.7b35@mx.google.com>
Date:   Tue, 08 Jun 2021 21:13:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.124-79-g90487dc4fc35
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 142 runs,
 5 regressions (v5.4.124-79-g90487dc4fc35)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 142 runs, 5 regressions (v5.4.124-79-g90487=
dc4fc35)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.124-79-g90487dc4fc35/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.124-79-g90487dc4fc35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90487dc4fc3599ba4b2e00c89edcd0a397d2f051 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c00c085f2babd3f20c0e23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.124=
-79-g90487dc4fc35/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.124=
-79-g90487dc4fc35/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c00c085f2babd3f20c0=
e24
        failing since 200 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c003b189e7fb6fc30c0e14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.124=
-79-g90487dc4fc35/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.124=
-79-g90487dc4fc35/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c003b189e7fb6fc30c0=
e15
        failing since 206 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c00477f0ff68f8ae0c0dfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.124=
-79-g90487dc4fc35/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.124=
-79-g90487dc4fc35/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c00477f0ff68f8ae0c0=
dfc
        failing since 206 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c003df41d9ca9e6d0c0dfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.124=
-79-g90487dc4fc35/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.124=
-79-g90487dc4fc35/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c003df41d9ca9e6d0c0=
dfb
        failing since 206 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c01d64a71e6f16980c0e00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.124=
-79-g90487dc4fc35/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.124=
-79-g90487dc4fc35/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c01d64a71e6f16980c0=
e01
        failing since 206 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
