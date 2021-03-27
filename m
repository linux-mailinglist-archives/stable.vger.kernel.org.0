Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFDA34B98E
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 22:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhC0VlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 17:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhC0VlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 17:41:05 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFC0C0613B1
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 14:41:05 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ha17so4217398pjb.2
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 14:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wrFtBsZgpZD3AXkjoQUYrNjc/WaGGA9G1Bx8nx9Y454=;
        b=UDQgQlSAQhMZJ86GlsAepuWDxUZY8bGOlwOeCOTtQEBYoH1Zc0nzt2W5jnrczLf9ou
         RivLPH9OiYcHmoK/gdLhCxFA+4vQ9ZAwHhc2SHOjOBxl3edRKZuXXjsOKEcyOFZZAYo+
         DGb9I+Q9H8GzEp+2zI5QCkAOVtUrm+4i40rkfrUDLfultl9YoEYIoisRxJgXQGnISe9r
         axKLrepqKomJ3Cd+Vo8TDc90TodrIDCPDmBAW9Y4OGqFxZVkMoQGmA9ioeNix1k8y3BZ
         WkMu3GTFH1GlJm0wJULv7dD4fr0gFD7d5iCY6Ihs0J0jmBH3hTW9boHtGi8+LZ5w59M7
         TR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wrFtBsZgpZD3AXkjoQUYrNjc/WaGGA9G1Bx8nx9Y454=;
        b=OHJojQakxcvplQaHcnZ9+FDhilsaxbz3BFaaY7Y3qxYa7yYTkeofkXbVuLSkYQNzaT
         LPZ7Lbi3TxkGc61pzUBWYQSvko3wJHq8RHGtj6CcNeSF+JlMR3NzCbTdtOpMmiU2PY3H
         8ZMENgR9WRiJObyyFrsBZaz5QtXNyKpgXubWpqZ/PTNOsKMmamFIYMAVuzjSP0foPLni
         jiLDCojdWz+qATz41kUMQewCK8u5I8U+VKyOYkYDfuFlVOvS1JFJSTnyyqdYp7JR2uBn
         J0oi5Hzg5MSeONon0jgvhSKnXID0v0hvjzqMxFXc2hs9S0E3cHsk/YmxxpRfuSqHv/65
         iWOg==
X-Gm-Message-State: AOAM530pqupL/eg1tWrQ8x6UMHWNIP7e0j03vuJG1eanYepaO2HgE1sQ
        cNatlyunkWDIAXp+qtBteM2F98brbRgy0Q==
X-Google-Smtp-Source: ABdhPJyUyrzdmHrerWyYEN7+BOqzeMioSdWKo+XEpVNIGbPrn68A1OFnT+9F2W39VPQIek5Z9bYgrA==
X-Received: by 2002:a17:90a:5284:: with SMTP id w4mr19448241pjh.29.1616881264508;
        Sat, 27 Mar 2021 14:41:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o134sm12930385pfd.113.2021.03.27.14.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 14:41:04 -0700 (PDT)
Message-ID: <605fa670.1c69fb81.f73fa.f610@mx.google.com>
Date:   Sat, 27 Mar 2021 14:41:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.263-21-ge0cb3d54252f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 86 runs,
 5 regressions (v4.9.263-21-ge0cb3d54252f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 86 runs, 5 regressions (v4.9.263-21-ge0cb3d=
54252f)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.263-21-ge0cb3d54252f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.263-21-ge0cb3d54252f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0cb3d54252fae6195bd6e3b7898679a6fa34511 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f6ccc79f1d66935af02ae

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-21-ge0cb3d54252f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-21-ge0cb3d54252f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/605f6ccc79f1d66=
935af02b5
        new failure (last pass: v4.9.263)
        2 lines

    2021-03-27 17:35:04.981000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f6a97ba24eb136daf02d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-21-ge0cb3d54252f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-21-ge0cb3d54252f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f6a97ba24eb136daf0=
2d8
        failing since 133 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f6a61c679ffe4f1af02cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-21-ge0cb3d54252f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-21-ge0cb3d54252f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f6a61c679ffe4f1af0=
2d0
        failing since 133 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f6c31e010840388af02ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-21-ge0cb3d54252f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-21-ge0cb3d54252f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f6c31e010840388af0=
2af
        failing since 133 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/605f6abaaaa6716b49af02af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-21-ge0cb3d54252f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-21-ge0cb3d54252f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f6abaaaa6716b49af0=
2b0
        failing since 129 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
