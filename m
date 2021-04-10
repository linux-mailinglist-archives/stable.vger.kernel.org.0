Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC3D35B051
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 22:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhDJUPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 16:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhDJUPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 16:15:36 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEA3C06138A
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 13:15:21 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m18so2134688plc.13
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 13:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O2NY9JMGCZZUqR4ppWiajLzmpLPsfF0AA2BxhBrnZCo=;
        b=uWscuh3cX1UR1HdRqKgZferbnU4e8HHpcotRcL0JPA3LRMkz12W7o/AM2XBK26iHYL
         AUTmIWSvLBBJ3bX+BwwtiDPq80zFyMJLfBq2cTFjBu8SvkbhHC2R2SBp89ftV0ZFuQGn
         x2K69fMuBVoIRVqs7o6nRx9+/NCdHENYWUz3j5KZ3crZ6q7JJrsU2AN1FX7DkHSiOjln
         1Ra1iskBnYxRN1Zq027cQ1v7veZhdjLMEao7uz+hPkCs0nlll5cK6tr9ZNNUoL6Gn6SU
         jCHmjHSdUxrYdyZK+FxzrSuXD8TPdgK0uy42srY3I9vzLKubuGToWvAZ116MVu5qOgTd
         TPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O2NY9JMGCZZUqR4ppWiajLzmpLPsfF0AA2BxhBrnZCo=;
        b=k8Slmrp/KVsunkfA5Q3JCQdtEoBg8vxS80zu4TS1AwPKST9zpZAA0CNn6jDmyhC6pB
         gl+0g9/w/N2+ouFynBUpg/mqkvh06aTs1+qz8017l+ji4uYJImbGQKY5oX/6AUig7s8j
         swpPhdHXm1Gt7BsjaXPqJl5RCdNBJ3a6TneYInGnOL+pl+IlBOglP6BEYYugvF0qftjp
         JlOwGRXr7va85MeMlkp2/Icn5NIBiz2vDurXRjz/+cZEYYp4wOhkNPVEiGFH6V/oAjdO
         pYu6j8ohek8JCUpFdyIH1uSYVV0P7t7DHAtaG/Op+5jPBwDovWDASXxKVQ2N+/nLks2o
         jTAg==
X-Gm-Message-State: AOAM530vgpZJ6SJUgwZHH7DTSoy1eF8O1WOvvBSxkXmPnE1OLjTAv0HF
        ZZaWxPaskrvC6NmB++zS/AdorzOatdp+i8nq
X-Google-Smtp-Source: ABdhPJyAJ5IvTnkMs5p2OOboJf4kTcWrlnahrY8DRiW2AcERHe/yzbXC3kN8O/Rq92XN+aToRcDgPg==
X-Received: by 2002:a17:90a:43a4:: with SMTP id r33mr20379209pjg.119.1618085721181;
        Sat, 10 Apr 2021 13:15:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v13sm5229141pfu.54.2021.04.10.13.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 13:15:20 -0700 (PDT)
Message-ID: <60720758.1c69fb81.6e7b4.dcc6@mx.google.com>
Date:   Sat, 10 Apr 2021 13:15:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 124 runs, 6 regressions (v4.9.266)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 124 runs, 6 regressions (v4.9.266)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.266/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.266
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b76c99cf586bd7e2078de72e6ca5195be58b0dbf =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071cd37dc12523151dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071cd37dc12523151dac=
6b2
        failing since 147 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071cd457e090e4849dac6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071cd457e090e4849dac=
6cc
        failing since 147 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071cd3fdc12523151dac6c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071cd3fdc12523151dac=
6c2
        failing since 147 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071ccd8084e73ec14dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071ccd8084e73ec14dac=
6b2
        failing since 147 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071f011fc5f16a4c8dac6d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071f011fc5f16a4c8dac=
6d5
        failing since 147 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6071cff9c038359965dac6bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071cff9c038359965dac=
6bd
        failing since 143 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
