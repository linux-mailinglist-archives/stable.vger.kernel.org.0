Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216D91FAAA1
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 10:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgFPIBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 04:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgFPIBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 04:01:03 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAFCC05BD43
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 01:01:02 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n9so8042315plk.1
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 01:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h/u76bfGyzmAUwsLtGelJO5jzp+l6nF7Ug3OjvIbN4o=;
        b=hkJQuDqhNOcvHKWNDQIo9WGKYG+UjIpbM77TmNFzEwsQuigvSzwgU+AomNrpVW87qi
         hCBEpL3wV03gMe14OPBHXv+LjFgwX0GNGqxIFRg9Q1I2sVHlFBeQr4Zof6Ff1Wq407Cr
         0H00sdz9KbV6f16g0R5itlVLLBNOYh2jAi/dNZ7S/Ray4IHZyRRDmn1zAVU2ygoPm8VJ
         JVUVybLetymUNTaX3G1OJpvXC9alLZz+69I2KDtDqWs1txEDKEjN6Fg7E8rjNxKhiEm9
         J+lCa9eLe/imTt8Ml7Rs0QdZWnMyBglsMFkPYPycnJQp+igRCjDn72NlrKL0agKMr8bl
         mCsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h/u76bfGyzmAUwsLtGelJO5jzp+l6nF7Ug3OjvIbN4o=;
        b=XYD66wHSzks9aTEy5cAsMD64tgkTfOaNPS+7mBvuih2BCVM2lLA/BAVt9XQk3ykl6i
         PSso8Vtgo4+PUdh5u744mBmcVxf2maVbDUP6ZIhz4pez+rHPosusWtuyk+lrYOF3AzGl
         8Nr3a467jXRS+wSx2drCkHwu/Jittpm2zenU+SLlY0Hmf3Icdp9bulgp/sL4xK3d7vly
         4YEvSsC6Rz5jOW/K8Qkj06dgWjo3PApIoWbnlVcZdlf+mwsNJBfGTYNhOwZTxLsTmuX4
         Y5x4bWcdfdcZrKrEvuhQMEREnHVfwgZKWuZ8V45CvmMJgr407s1snzyKbz763iu+BdyM
         dJKQ==
X-Gm-Message-State: AOAM533okcJqX+AxmQkq10/iIzYqMKco/vYaoUgXeSrWPya8Od85lyVD
        /75Ve91kyd0O/XJ0rFMc1tiIjMGQ5cw=
X-Google-Smtp-Source: ABdhPJyw/yl3xXgpscS184sZGBUwToA4Jnv029EIFV4FtJnSmTeOLUdYC4j9wKOiwRd9x+wxZtOOpQ==
X-Received: by 2002:a17:90b:3746:: with SMTP id ne6mr1673373pjb.166.1592294461880;
        Tue, 16 Jun 2020 01:01:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b3sm15974076pft.127.2020.06.16.01.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 01:01:01 -0700 (PDT)
Message-ID: <5ee87c3d.1c69fb81.2b3e9.5f53@mx.google.com>
Date:   Tue, 16 Jun 2020 01:01:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.126-113-gd694d4388e88
Subject: stable-rc/linux-4.19.y baseline: 94 runs,
 3 regressions (v4.19.126-113-gd694d4388e88)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 94 runs, 3 regressions (v4.19.126-113-gd69=
4d4388e88)

Regressions Summary
-------------------

platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
 | 0/1    =

qemu_i386             | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
 | 0/1    =

qemu_x86_64           | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.126-113-gd694d4388e88/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.126-113-gd694d4388e88
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d694d4388e889e15298d8de938fb4e61e4df75bf =



Test Regressions
---------------- =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee8463668c5ce8cdf97bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-113-gd694d4388e88/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-113-gd694d4388e88/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee8463668c5ce8cdf97b=
f0a
      new failure (last pass: v4.19.126-55-gf6c346f2d42d) =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
qemu_i386             | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee84430395f206d1697bf40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-113-gd694d4388e88/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i=
386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-113-gd694d4388e88/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i=
386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee84430395f206d1697b=
f41
      new failure (last pass: v4.19.126-55-gf6c346f2d42d) =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
qemu_x86_64           | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee842a5bed9c0394697bf29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-113-gd694d4388e88/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-113-gd694d4388e88/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee842a5bed9c0394697b=
f2a
      new failure (last pass: v4.19.126-55-gf6c346f2d42d) =20
