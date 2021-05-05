Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF96374853
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 20:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbhEES7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 14:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbhEES7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 14:59:23 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD5DC061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 11:58:26 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 10so2823799pfl.1
        for <stable@vger.kernel.org>; Wed, 05 May 2021 11:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ThzGFOzKo7Rkvzt2JTAHu1sRgGaYQlt7XM79ZTAI+B0=;
        b=bbYJw9FL9iqxblXPMyx7RgCJ+7CchjxyKKsq6a0CgtTCXwxOhBxERi2VDHS+Q39eyA
         c3wYHd+7kVpPfQadNq02PuzCrjnUVqgeboumeRlb7l0O7lkhD2xjtK+cHBi9m34G5rDF
         HufCoetRday7yd+fzmAvLREpCRIXJfdWiDhQ5bQ7fbcEvCArI4AzPDRKanNaPnVFZlgH
         D1cbamMPAaZaBqQlyrXEhPgl14lU/OQ4TRccSvw0JqfKdfY5KYRWDurSvwH0xAPcoo0E
         /MSERTvlvBmz1iIk2EJ2WGp4kqiiYAU09OZqROxilz1OmYsj3CSfHPLas+Np8jgl4KOT
         vqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ThzGFOzKo7Rkvzt2JTAHu1sRgGaYQlt7XM79ZTAI+B0=;
        b=tbxmx05kMpV06nspXIlcSlmsweUXKrEM1wQSA2XeqSJ3myjjxwhTtbf29jK1mC6tyq
         WDPOH+duaj1nYjr9MpjB5HqM5Fib/xIoIovKofoiSiRySTny8ENt3/ekb+Qm4jRRerzo
         gxZHzrd7702J5EGXiiyJF8jYPwZB2mm3AgWk49ojDAXTi1aHqyyi6ffp3KYx4vP4pnac
         7fRH67Qm0DfKW5ElaIgPOPhhj4ISNcRhQrt1RTtG69B6E9VO9QHqbQDGHhF3buDHPZHT
         kGKDr+GwrwLgNDYI2mcIaXnMbCHy9/zyUo96zb4WNPbHwF9eVh+cciwMB9SQvl0JMBkh
         QaMg==
X-Gm-Message-State: AOAM531Ku5XVEa89qRVFWPc3EA4W19Os2nmxUo2jANO+oqDSfoYz84qF
        sen0zkDJtBJXvUC3vXXZfTetqyZ4FkhWEtmW
X-Google-Smtp-Source: ABdhPJw6z5QUOf3WmW4k8FU3i86SnV4ZHdx2OcF/rJMIwRipQk7oEhZbnkLFbtb4nx5XIqZ4N/wEvw==
X-Received: by 2002:a62:cfc2:0:b029:28e:82bf:a174 with SMTP id b185-20020a62cfc20000b029028e82bfa174mr495616pfg.9.1620241105687;
        Wed, 05 May 2021 11:58:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9sm12102pfv.14.2021.05.05.11.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 11:58:25 -0700 (PDT)
Message-ID: <6092ead1.1c69fb81.e0e3d.00e5@mx.google.com>
Date:   Wed, 05 May 2021 11:58:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-7-ga894a28c73610
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 54 runs,
 4 regressions (v4.9.268-7-ga894a28c73610)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 54 runs, 4 regressions (v4.9.268-7-ga894a28=
c73610)

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
el/v4.9.268-7-ga894a28c73610/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.268-7-ga894a28c73610
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a894a28c73610c1416a47ba7c7ecb8efc3760752 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6092b7bd9eab8187476f546c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-7-ga894a28c73610/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-7-ga894a28c73610/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092b7bd9eab8187476f5=
46d
        failing since 171 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6092b688126b812b6b6f5470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-7-ga894a28c73610/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-7-ga894a28c73610/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092b688126b812b6b6f5=
471
        failing since 171 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6092b5d3f06994b6f56f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-7-ga894a28c73610/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-7-ga894a28c73610/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092b5d3f06994b6f56f5=
46b
        failing since 171 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6092b7200c2285e63e6f5470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-7-ga894a28c73610/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-7-ga894a28c73610/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092b7200c2285e63e6f5=
471
        failing since 168 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
