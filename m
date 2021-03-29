Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36E134D6A3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhC2SKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhC2SKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 14:10:34 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8600AC061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 11:10:33 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso5578346pjh.2
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 11:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9tdbhTgGCAw4xogNCVCHrwaEAY2k0wfZxdRBRMMHD4c=;
        b=iWtBbzxx0Knu9Azp8fQdNBmJcH6fhz9w9eh0lVw9HDbG2rTaINmoo8ivsvMyzzv9N5
         wvqvoVoFBopuuN+WSv3yJN8bnF9pidZVL9k9z/btWzHv7nrRarzTUCdHwWBpauNL+PZL
         zpaI7zM5EfBIzU+juLvAx/i6LdXjj6IjXPst+J2/GIshJ0Hflo9nSz0wRVpH9OQm5z9f
         ZyvXoT+AVeFf7RoyIbXaRUkeQN/6fd6LHnrX3JsUQrXxvSEoznW1yECEDAVJTiphkX/H
         BfyVJ6tNVXfr6pyGf+9IhkHC2BA4sh6mzTRcEqgW/3KdNXwmoEH6KRdXrP3gF7zzTwSV
         sbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9tdbhTgGCAw4xogNCVCHrwaEAY2k0wfZxdRBRMMHD4c=;
        b=C7ltJesuwE5txZYayGQBe8AOdBCEjsN+NgEo+ePeMPePD4QaTYSouHHoFRBbv4DkB8
         o3JimsvB0Rd9JbMwwUAte5ihxQ0J1SLDqH/nPDNNEJdBivGKVMDF8Sx+wbcr3WGd/HW0
         8Da1AOVdEw6cwsIDZ0ePg4aFSKY3tquEBot2nV/NmTTjaCNpa05DuyHP48wAKjlrAI4F
         fPti196DBY4/FIPbN6sdfAcOERUcA0146fZfNPnFe+AyQcU66HvDwJRsh3freqhivHWo
         8/XBhtU7wa0K2c/STt7cHOgAg9qYxFZelqzz+pXdo8wjKptycdUeOeWYtBUeLjevO3g5
         qz6A==
X-Gm-Message-State: AOAM531Xbcsh33MS13gvlrXEKOmUvgJgE+IjBmrqoj6ewUxHFAqn/dvM
        GQneH1qTZRQ2yaA4f6ePOWS8GuIkAPzQug==
X-Google-Smtp-Source: ABdhPJwrwO6DXARSm15mgbkJO5bncmnUslkRqpHmvPNma4IRzyWZtII+9dF5szFacrS5vYWgxhpkgg==
X-Received: by 2002:a17:902:e983:b029:e7:377e:834e with SMTP id f3-20020a170902e983b02900e7377e834emr12483690plb.53.1617041432785;
        Mon, 29 Mar 2021 11:10:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x125sm18076511pfd.124.2021.03.29.11.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 11:10:32 -0700 (PDT)
Message-ID: <60621818.1c69fb81.ebcf8.c293@mx.google.com>
Date:   Mon, 29 Mar 2021 11:10:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.263-54-g3c2295cc6be3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 106 runs,
 5 regressions (v4.9.263-54-g3c2295cc6be3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 106 runs, 5 regressions (v4.9.263-54-g3c229=
5cc6be3)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.263-54-g3c2295cc6be3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.263-54-g3c2295cc6be3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c2295cc6be320f7598a3ae9da3abc98230bd931 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061decc2d4bb32a46af02e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-54-g3c2295cc6be3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-54-g3c2295cc6be3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061decc2d4bb32a46af0=
2e1
        failing since 134 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061dec62d4bb32a46af02d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-54-g3c2295cc6be3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-54-g3c2295cc6be3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061dec62d4bb32a46af0=
2d3
        failing since 134 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061dec52d4bb32a46af02cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-54-g3c2295cc6be3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-54-g3c2295cc6be3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061dec52d4bb32a46af0=
2cd
        failing since 134 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061ea5e04ee065274af02b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-54-g3c2295cc6be3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-54-g3c2295cc6be3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061ea5e04ee065274af0=
2b5
        failing since 134 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6061e05a02f854451eaf02b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-54-g3c2295cc6be3/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.263=
-54-g3c2295cc6be3/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061e05a02f854451eaf0=
2b2
        failing since 131 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
