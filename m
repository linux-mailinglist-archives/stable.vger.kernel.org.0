Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F9538BA84
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 01:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhETXpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 19:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbhETXpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 19:45:20 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C9DC061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 16:43:57 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n8so4774608plf.7
        for <stable@vger.kernel.org>; Thu, 20 May 2021 16:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EqP6sm7a4uA0NIbIkal1TX2518gmwKJH/YfA3Y8ni70=;
        b=pJUFY58/DGGL5Oj7Tbs5KDUp2L5FXPKINi7qEOINU+LKNfFJKvFJ0TA1jzIPUKX4oH
         dIRCJigVpskUzgKOhjK50QKE/SV4YK+ks0SwSBOwUkxagV7ntIcPKLq6KBrWhfezFiGd
         /mRLRb6D9qnylDZ5TkcpQzNjbF39dWakRepmI2JcerFJyriJJTaC3vpypfzxTOqTfzvs
         B+7s9eMxp28yz+S6kyacF0aEl55CMcVInaukVIOXypjopwuwNPKMrXOegeF2bwIXurcB
         ifDxOCn/O8e7SHbv8gcJZSovRVjl+NeA4cQ/WTIpoRrKsfoewraXZAmt1iNNEWdqTcEC
         /9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EqP6sm7a4uA0NIbIkal1TX2518gmwKJH/YfA3Y8ni70=;
        b=kDJSAW89n4qjJTMebk+lnl27e+xsMgwRo0zUiSX9Pmg+znxotthjDPAf7paoAb7czu
         mR+wGbFVZFGq7pxF60y0D1oqdabXBdXc6El/GXuz03Y/Q91+nkDX39ZqL0PaHTuzmNXF
         C/t559+pAheDeSRGWSsSdZNnpN2I5rc3EQGMffV4kitwb1Q7D2sm9t+tfybVfVZ7XxB1
         jEVjH1Mu0+ljXqoLOrnMcuRLZmNPAYH4GdCISZvBWJpXxRrFcZi4V07qXUGY1pjMPdYO
         cuBHpc2NUnx081ZzdQD9gDGWp+dwv6/sAENVIhftvjKETgxfAyy+zaDFCvMnu0qpG0KC
         2v3A==
X-Gm-Message-State: AOAM530kIESyhUDcA/o9q/jJ1Jq7I07i4CETipctjyjlNEVvz/3VTiTv
        9VrgBAvu+kah0Pb1jYKKA/28H/ahJo3Zn9Mq
X-Google-Smtp-Source: ABdhPJy+Pxr7J9Sh5vkn26HzLHQs3MjS38KetlVCupDbZUEaNJzMLIq/UBRYWlsKQGmN/OIyuRqQew==
X-Received: by 2002:a17:90a:5649:: with SMTP id d9mr7384131pji.163.1621554237166;
        Thu, 20 May 2021 16:43:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10sm3121040pfl.123.2021.05.20.16.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 16:43:56 -0700 (PDT)
Message-ID: <60a6f43c.1c69fb81.1d46f.b197@mx.google.com>
Date:   Thu, 20 May 2021 16:43:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-239-g6707ab3bcf1e
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 104 runs,
 4 regressions (v4.9.268-239-g6707ab3bcf1e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 104 runs, 4 regressions (v4.9.268-239-g6707ab=
3bcf1e)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-239-g6707ab3bcf1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-239-g6707ab3bcf1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6707ab3bcf1ecde65f395ab503b68cb13bb0f003 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6bfa585294d3276b3afb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g6707ab3bcf1e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g6707ab3bcf1e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6bfa585294d3276b3a=
fb9
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6bf9648bfa1c53ab3afc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g6707ab3bcf1e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g6707ab3bcf1e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6bf9648bfa1c53ab3a=
fc1
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6bf9f7c390dbc2ab3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g6707ab3bcf1e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g6707ab3bcf1e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6bf9f7c390dbc2ab3a=
fb0
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6bf5c30b7f3124fb3afd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g6707ab3bcf1e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g6707ab3bcf1e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6bf5c30b7f3124fb3a=
fd5
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
