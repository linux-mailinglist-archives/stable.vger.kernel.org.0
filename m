Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07802EA2CA
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbhAEBJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbhAEBJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 20:09:48 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E7BC061574
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 17:09:08 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id h10so16489693pfo.9
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 17:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s4e5iI4xL15xJSW6CuT50GNixKlvxiXHQ2YAMxV177g=;
        b=nhNSDuD/zfzBJgOXuAtL5tiu7iB6GJylPajDQioNr8neVm74k2DvafRmGnB7ifwUQR
         F43kk2oS+4WhvTZcAFGaX3oF4n/2cOqPwWzS16H3nfflULOIPrUOr6I/9bhaERCYSCyH
         gD8tC8kAuunMu5hMqYQMNfFSp8szhhriYbEQtF63qh4Z63piF7zbEHfbZQjBiWQJRuzZ
         TS7fS4kQIbUQDy//rCPrLX804+AXCAZfTbZXbkIRx8iIR18zrKGQlsxpE5JdfUscs5Kg
         flTQ5ddoMImH/UHHd1epsDU4kMtE0oaxM3ctehlwPu1Mnv4uFNWsz0VHWBi7Hmlfw0eA
         CdtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s4e5iI4xL15xJSW6CuT50GNixKlvxiXHQ2YAMxV177g=;
        b=oEp5X0LBdKyXZITaJOtpCLSCAjXzZpP/fe7nepKQv98yj9GkgUCELa4CupNk6F/HiL
         wMT114WeS0KKqHqyZQTyNzTd9k8vI9IcdI2A79ze7yELWNmpgmOEp0dAYBgkbhSV/6ef
         3qisHLTwQ6DnHx3GTmJTQHlud3qx/QBIOya0zHteOs6UsuSBBKlid8n/4fKMTlK98ky8
         t4SP6rEZ3h4vINACjJB31BtfWF5bJp6Nc2YNofHJ9re5f1ZTcHjjjeDjNxplf8hoE2AU
         Ir2UvTdfU40/Xaz1olIbuPxuBCDh5ufR33CyFAHn+EYCJkHDXT+sOAD7X90fT4pJVyzP
         vHbA==
X-Gm-Message-State: AOAM533nw2dC4P4ZCQkshuBU5LyL8gtx9KNtxfeaIYUKhzQV6FB/wSd7
        bxMgvigduAaYhEAlid2FVZeAOqpN1iaXVw==
X-Google-Smtp-Source: ABdhPJze15JDsRgBJwPju+yjQhGUTlCqIqjJwkZC1i/2JMDTbC8NjsPIHQVd01qygEOxh0zdvfpaMQ==
X-Received: by 2002:a65:490b:: with SMTP id p11mr45732826pgs.88.1609808947658;
        Mon, 04 Jan 2021 17:09:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k15sm58030552pfh.40.2021.01.04.17.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 17:09:06 -0800 (PST)
Message-ID: <5ff3bc32.1c69fb81.ae81e.4087@mx.google.com>
Date:   Mon, 04 Jan 2021 17:09:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.86-47-g55b6e606277b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 172 runs,
 5 regressions (v5.4.86-47-g55b6e606277b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 172 runs, 5 regressions (v5.4.86-47-g55b6e606=
277b)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.86-47-g55b6e606277b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.86-47-g55b6e606277b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55b6e606277b74c24df274b3c5074cfc201ebf69 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3830b2e7107a215c94d4c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.86-47=
-g55b6e606277b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.86-47=
-g55b6e606277b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3830b2e7107a215c94=
d4d
        failing since 45 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff380b5297c051377c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.86-47=
-g55b6e606277b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.86-47=
-g55b6e606277b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff380b5297c051377c94=
ccf
        failing since 52 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff380b3297c051377c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.86-47=
-g55b6e606277b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.86-47=
-g55b6e606277b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff380b3297c051377c94=
cc9
        failing since 52 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff380ad8774e088fdc94ceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.86-47=
-g55b6e606277b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.86-47=
-g55b6e606277b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff380ad8774e088fdc94=
cec
        failing since 52 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff386bc4c7b464713c94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.86-47=
-g55b6e606277b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.86-47=
-g55b6e606277b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff386bc4c7b464713c94=
cd8
        failing since 52 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
