Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33BE3E0F13
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 09:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbhHEHYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 03:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237185AbhHEHYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 03:24:50 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40328C061765
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 00:24:36 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mt6so6742015pjb.1
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 00:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s0oqClL5IoqZySgL1zI1Vbghn7hMT1Q8g3Vn6jafSWo=;
        b=J3phZZBdChVN0td7O9Jmeu90KRZyGeUD2l1kqExjUQbq2Z7WPrbwrX/JPph3cbNXef
         NuZg7yqlqp6Zq3UGCjy2j7816svBhutp+UluHfUH6K++ekHMh/NVszsWw5NGvooEk8nn
         /BWlwWLAsoYXQVPj4Gbs8ksUe3OLKfuEUb4H5ETney7696jF5C1zqOopUdMKajLdDz1s
         rnLDOjBNgkIoC8Xq1/zmHxBOxJl2FN5pkF9whcR1nROjgUg8T8FV1BcfeqteFOtfqAyB
         Iuet/LEJlFNHVcbK1DPh//q5i5MdC1GBQ/qPcBLqKU6MpsLhppB+WkGpRBfUMij1G0PG
         A2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s0oqClL5IoqZySgL1zI1Vbghn7hMT1Q8g3Vn6jafSWo=;
        b=QwHtRkPQ409HDMGdvN4Blm6jLN7UIK0pczuqzdT3kL04Us0UMtaN0Up5DHsgVXUwYT
         QBsFKkSzjYAIwYHa817V/dR3fc/LLQu7jGzljFBnvX/g6LCm+GXYrtI/x5jfFw2V74ND
         sJMuPPzr1QVY1ZlfQR7BDJzZVSeUeITXiehXwT+RSXXhix4Js+oEhyvfegAKsfreBq40
         1J7VkqVLluSacjVO1TQiiPVk92EgLDHNeCFN1h68o6WJQzfeSOCxTVUYyZXG3J5Fk3J0
         i2Q5vVLbkJ+M9kgrZqUufFEd3BtsZ1lPPOOeYe7LZADBjAFcYZj/dxWKALnJfGm5plET
         uxsQ==
X-Gm-Message-State: AOAM530GO8lhBf5Yb0+vJl+lpoC9ptNpOauU7ZfwBBkVfwkM+1lnQB0P
        lcAZ/RF+eer7hGMzcdIjQr3iLI6BokKgDOh2MWs=
X-Google-Smtp-Source: ABdhPJzbU7OATzmH1H4ROcM0t0rDkcWEgKeERWnrfj8OzhcCHNBuUTZ6L/ORd+V64TR6bG5CopuUeA==
X-Received: by 2002:a63:5908:: with SMTP id n8mr1270163pgb.202.1628148275699;
        Thu, 05 Aug 2021 00:24:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n12sm6561216pgr.2.2021.08.05.00.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 00:24:35 -0700 (PDT)
Message-ID: <610b9233.1c69fb81.508a9.34e3@mx.google.com>
Date:   Thu, 05 Aug 2021 00:24:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.278
X-Kernelci-Report-Type: test
Subject: stable/linux-4.9.y baseline: 84 runs, 4 regressions (v4.9.278)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 84 runs, 4 regressions (v4.9.278)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.278/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.278
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      29bb8b3fc24fda91eecc1df462f055d60eab817f =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b5882136edf6b03b13667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.278/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.278/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b5882136edf6b03b13=
668
        failing since 259 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b58846102ac7cb2b13670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.278/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.278/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b58846102ac7cb2b13=
671
        failing since 259 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b6105d24ed3a1bcb1366b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.278/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.278/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b6105d24ed3a1bcb13=
66c
        failing since 259 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/610b574e663e9a510ab136a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.278/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.278/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b574e663e9a510ab13=
6a9
        failing since 259 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
