Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFF6338068
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 23:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhCKWgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 17:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhCKWfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 17:35:44 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40EBC061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 14:35:43 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so9787565pjq.5
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 14:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XvICeYYxgOFrTvcDwH2Q5g3YW42Py3nmQxgUnAnn0T8=;
        b=AAFN81+DlHoX4xxVLAv2yBG01q6rBGqDNneXOhZIz0wDlBXeA0c2P+X1yQ1bSQQ30y
         OBFj0Lgq1DvT70eY2fXpeiXtIC2klcZW2eoHt2nCBetr7ckNN5yf2Lwbz33R/BLeNuqy
         3Yh3gyRtlALIiSOnhMDNmBUc8hZrL+NGvNdPcBF0SRniY1aPn8VcXGPhqLaMcQuD3ok2
         tlQtP2es+VI4yjmq16yBpBhtbGaf0MpaK3YdcjCDAerxo6v/STUXFCRtIEncPvSlDt9S
         Ac+8H0hz6Mpe/xxx1cKfgTKs2w3n3MT6abTh/HkKjLToFZhop4NYIONyxfcUipG7pRE4
         +GRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XvICeYYxgOFrTvcDwH2Q5g3YW42Py3nmQxgUnAnn0T8=;
        b=DjMazPSq8FBkpELe2Bx/7m6nEvzwE9JwntaYyAVFuvR4TEGtr8AKTSBVwk7VmNPeJe
         X7gwLK/c47VEYdkdsuw6Dj6K0iUvHIzG0OAZErhe6+rXmeHqV3RzosoQ8jNUNMbPXLF4
         5vC14Hqyv+jDc9WC6wyO6SSqrsqlt4RPKsAacvsWoZnKEqCsX5ecfIR+306k4qopmuLH
         RjY9Judga9RcDQJdWPySaTYINumTcjtVepJ3lnhu2aVhRSTc15qgOkt5M1t4Rv7uG6c2
         DzXqXZzsvSz0Tqd3ZzGl6GsKtBvHhz2RSOdd7PJ8a1xPCQotnYoDstsdnyQQRK1LRoZh
         s7QQ==
X-Gm-Message-State: AOAM530xi4KBKNQV4VVh3S3hVDZixjR9yNzkKWEnC3zxTUc8BymCN3eQ
        eQQDPPHlYCTh5d1mvo17Po8O00gwc/oGtC5f
X-Google-Smtp-Source: ABdhPJwmGreotKlFb+6SxecqoGffYvjfv41BlR/llA63JGZ6VwMrLwwplb3IM5AbsYJcT8ua/FVQCw==
X-Received: by 2002:a17:90a:6282:: with SMTP id d2mr10509356pjj.168.1615502142923;
        Thu, 11 Mar 2021 14:35:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23sm3341704pfn.94.2021.03.11.14.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 14:35:42 -0800 (PST)
Message-ID: <604a9b3e.1c69fb81.adf03.996e@mx.google.com>
Date:   Thu, 11 Mar 2021 14:35:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.105
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 80 runs, 3 regressions (v5.4.105)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 80 runs, 3 regressions (v5.4.105)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.105/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.105
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce615a08404c821bcb3c6f358b8f34307bfe30c9 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a65d1fd324c1bc8addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a65d1fd324c1bc8add=
cba
        failing since 117 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a659c562f20afd7addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a659c562f20afd7add=
cb9
        failing since 117 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a656a02cd36acdcaddcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a656a02cd36acdcadd=
cd3
        failing since 117 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
