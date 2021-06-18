Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B734B3AD295
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 21:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhFRTOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 15:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbhFRTOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 15:14:30 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB854C061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 12:12:20 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o88-20020a17090a0a61b029016eeb2adf66so8457595pjo.4
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 12:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9ffcwiUXye8cwUWW0OuEmQXGQbVoyO9EbJgfoZFAv4U=;
        b=GbA3354SZ2z1MmkvTAzrh15KvCfhttKlYXnr1bDdfnvMzBn+Mlr6XKPSqM4J6xGVgJ
         QYLu9HtEC4o5+xJD1BVNvdcPtotWHxToyMddQdEwQxrJsHMVVygc7tm6AM+TaCShNbWX
         qpws+uWnM9TH5fzioM2oeg9j1h+IgWJqzLeFJbCO3812pnL0U61iKKM88Y+/iOiN43uV
         UCSlyuUG4PAJPYJn67p5APwv3Sr9h1FO0ZvHzEKnK0MV9Jb01LYo/UvEY+JT1J6kdwUF
         DN1YrLxio+s353XR3oPGjDxviSwQGEO2FLutL6GPPrLkFkLLo0AKHA1FaedMwKTBkYqp
         dcvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9ffcwiUXye8cwUWW0OuEmQXGQbVoyO9EbJgfoZFAv4U=;
        b=Z12+cv1zHe+y1zRLc/813JXsg9madXRCdFZj5yqE0dVjLtOganpz1F0EsoBMYRqNTY
         KLY9WyqtnYshHSOG2+GED/Y44WXl1F9wY0sK9jcP7Vo44+iCYFck2BMpZrETYOmignQb
         5Ln+qLkoGyUeHw7fq/YdvQ5kiCUGX3xwGRp+0fpS1eENnc1w/hjOj1gaeiEMhZyqx7iH
         q+Liy5TVfoMuo2SVO4FX5u9yEpnxoaKrUhgBFkNcj8u8d+nn5gmMMxG7FMh1xXEwZWIC
         PLBYdsrKurfYBhEW9zH4fFg7L2cUtbLo02T15JG6Rlmz3Y9KYDaYpsMuTiuHeig3Qa+r
         JURA==
X-Gm-Message-State: AOAM533XWwpTyV35MLq4WqT1nc2IKjxxTq2NlAEwZWQCzoFRDr3mtzIw
        1LgNjxNX8X4AbPRv/hi0hTeyTdhaPL6rL+IY
X-Google-Smtp-Source: ABdhPJw37gllo9ashoFB2u2Hbk5zx6nshVJGr27DLxBQjocyOOdtXabogZPdfick0XBxvHY8KEDU+Q==
X-Received: by 2002:a17:902:9f83:b029:f6:5c3c:db03 with SMTP id g3-20020a1709029f83b02900f65c3cdb03mr6128750plq.2.1624043540000;
        Fri, 18 Jun 2021 12:12:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o14sm5570328pjj.6.2021.06.18.12.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 12:12:19 -0700 (PDT)
Message-ID: <60ccf013.1c69fb81.c756d.e306@mx.google.com>
Date:   Fri, 18 Jun 2021 12:12:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 98 runs, 4 regressions (v4.9.273)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 98 runs, 4 regressions (v4.9.273)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.273/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.273
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      94ac998a27d889965ac32bba3169281d6986fd13 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccbec94ed66e7fae413274

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccbec94ed66e7fae413=
275
        failing since 216 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccc767873e64d360413272

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccc767873e64d360413=
273
        failing since 216 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccbe5b1dc65f9467413394

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccbe5b1dc65f9467413=
395
        failing since 216 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccc2b294e84c386041326e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccc2b294e84c3860413=
26f
        failing since 212 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
