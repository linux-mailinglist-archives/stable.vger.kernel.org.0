Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B949366FD0
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 18:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237924AbhDUQTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 12:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235948AbhDUQTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 12:19:25 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3B7C06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 09:18:50 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q2so4985112pfk.9
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 09:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eaWZoPgLFG4qJ/yq1XFE7v0aZBdH/n8Fva51iO4WB5o=;
        b=LJ7micBzY3HF3O2MpVFzM8qJNqd2zgTAgszVULLb13eSHtIhnEyuQ7DUQvHJ9YVai5
         l2AINmBpPYcyqMfzz+8qxyCkiAdZYrjFydE//GZZ12QFou4D4Iz2qQ/lVyJotIDU5lwk
         sFtTejS2qOuyY6a1AMhDmqtPWmqHGyS5MAzGmI7mu0AOPjROEDjZJf2OqVJXpXopfJbW
         oXJBFrGExbjRTlza/sQLeEXPxY4mjkUX1kj/zfMDLbB6SpLm/MIPCX6aaLyS2t0PnSsD
         6YXEfaYcasgCZr9uWIKyQIJvFijvCvCv7jvgs+DPCTuawcC5OyzLC8NKKbVXsbAShKfn
         404Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eaWZoPgLFG4qJ/yq1XFE7v0aZBdH/n8Fva51iO4WB5o=;
        b=hadXHASqhhADuJ2iqINIPj6l1NFBpfjnSapFa17TnVvvnu9dOTcWHaFfe0xH5VXlqL
         xIwr8OgyvLTt857xqHQphBcdSeY4x7H0HBnMK3S1RkAOOY/5wlJ/c8Pen/wsZiFTTCTT
         +YFgKFDslzc091JRj2SsHqpCDrw68L4zLvYynUsCDDtVJjRxTFNh1vggJTbYLWaKwhRE
         TeU6sfNKFpPocHn/TJJTrSQzX7WHjvA+4JE0nlB0nRz6g8wjR+Fa2t+PBG/6w7hrUJct
         iPFZk4UNj6DbvUJ3gquz9wsbMObjyKB8s7Em9xt9uMl/BN827BWogOgv7hWWLyEbV3Z/
         DhKA==
X-Gm-Message-State: AOAM533/Avo3pkw5TRf+G+PkyrBWvoPn0tCfvDdkZC9EzQIdwmp6VgAP
        7KK3s323PZaLVxXZjmO0uBWIV5g8DXjqUNhrRAI=
X-Google-Smtp-Source: ABdhPJy56qXhPJ/128zrSqKAwsHiraL4BVj7l0p7IFYdx1AA84WPiZfmVhIieig4aVSKsBQvbKByyA==
X-Received: by 2002:a17:90b:3103:: with SMTP id gc3mr11949405pjb.77.1619021929924;
        Wed, 21 Apr 2021 09:18:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h2sm2105233pfv.196.2021.04.21.09.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 09:18:49 -0700 (PDT)
Message-ID: <60805069.1c69fb81.096c.5c35@mx.google.com>
Date:   Wed, 21 Apr 2021 09:18:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.114
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 124 runs, 4 regressions (v5.4.114)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 124 runs, 4 regressions (v5.4.114)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.114/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.114
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a7eb81c1d11ae311c25db88c25a7d5228fe5680a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60801bf38f6ec7ef1a9b77a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.114/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.114/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60801bf38f6ec7ef1a9b7=
7a7
        failing since 153 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60801ba27490ef18739b77d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.114/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.114/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60801ba27490ef18739b7=
7d3
        failing since 153 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60801c1713208cf1919b77ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.114/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.114/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60801c1713208cf1919b7=
7ad
        failing since 153 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60801d640b70a74e659b779a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.114/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.114/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60801d640b70a74e659b7=
79b
        failing since 153 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
