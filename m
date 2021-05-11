Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C4C379CFA
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 04:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhEKClK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 22:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhEKClK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 22:41:10 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67E8C061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 19:40:04 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so264306pjy.3
        for <stable@vger.kernel.org>; Mon, 10 May 2021 19:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wRHqNg28vlUweRLfr0gYJ8MYpqnhLwBzG5WIH5MLTAI=;
        b=YfQz0ZpgzwPuIaldsZAsfE+jqFUvbna08eb4i38SmSwlZga5xc51u1/z7AGeansHME
         MJ9PtavJrxq56aZ4Cs9eHG5sAq4I0eFdf1jyM7TgBUZ9SoPBktk3Iy5VIWdDcqB5mtKH
         guvGvbgp0stzgMD9DW1Z7uRfti9DrNtJQSU8ds/R0ZzrNqWvxkSHGhPsWYm7hUXuytS4
         C2m6RA6n7uW/vvlxmOpjEl19blLHNvIfuiVf955lwK+5O2vQnlJW82FZqfdQS1MOtDUw
         gNJQROLtudHUZPvzrJA1VepCkYebNkH3pgDmxAT2hcEaTzwGB5Ha9Uxwmp31OjvuwEK2
         ZKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wRHqNg28vlUweRLfr0gYJ8MYpqnhLwBzG5WIH5MLTAI=;
        b=olG1bGj7PsdNnX4k0IqPJJyecSMx2C78Je1Fz3GMf17gTuIZykGgtJoYOogdFe1bTk
         wvJN7XOpc3Q3Xp6A6jfVBbb65zdPjWGTTT71jvRv9FEHxod1sq/g9Hs9cteiXP+Msmbw
         DmM/TkKmWIo1Xuf7AoWD3/pRHAW6siRG6/EAnVlYB3EmMjj5GbJLHYV4MOfpnla8GXkJ
         GXEJmGkzTzdlTqvSxjqPoyMPyX3gD1msEOmwZViQ/xrWnrqV79GrvB/GzpFuKEImzBjH
         KUWRM6A5/HMyA6ZrlPLj5ykk6i83/SEBTQ2XhAvsgdexcSq84yqS29c9q7wQdzW/Mh9P
         zPqw==
X-Gm-Message-State: AOAM531mog4ZzRv73s3RXGW6HQ/MhUXEpNoA3AmbL6eQxhmljfVdy+2L
        0cSJVLSnbCXvvIC6GMRgrtFzsljR23/ljVRe
X-Google-Smtp-Source: ABdhPJzxHBJpTsJeRfIOWgFJDxL1etOiXRB69VaviMXzFFQK1bJwvsxFC6rq8IHYIZdLZM6C5uWfcA==
X-Received: by 2002:a17:902:7c91:b029:ed:5748:901e with SMTP id y17-20020a1709027c91b02900ed5748901emr27457232pll.27.1620700804011;
        Mon, 10 May 2021 19:40:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i62sm12379645pfc.162.2021.05.10.19.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:40:03 -0700 (PDT)
Message-ID: <6099ee83.1c69fb81.79ab3.6b55@mx.google.com>
Date:   Mon, 10 May 2021 19:40:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.268-53-g5bc5b67b6dd5
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 92 runs,
 8 regressions (v4.4.268-53-g5bc5b67b6dd5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 92 runs, 8 regressions (v4.4.268-53-g5bc5b67b=
6dd5)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.268-53-g5bc5b67b6dd5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.268-53-g5bc5b67b6dd5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5bc5b67b6dd55f2f45f97363a97f401633e3158c =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6099bb88c69c38f4b66f54a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bb88c69c38f4b66f5=
4a1
        failing since 178 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6099bbb08a70e4920b6f546f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bbb08a70e4920b6f5=
470
        failing since 178 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6099bb8cdeaa9d42426f5476

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bb8cdeaa9d42426f5=
477
        failing since 178 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6099bb7ac69c38f4b66f5488

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bb7ac69c38f4b66f5=
489
        failing since 178 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6099bb87deaa9d42426f5470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bb87deaa9d42426f5=
471
        failing since 178 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6099bb9c6ccb80feae6f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bb9c6ccb80feae6f5=
468
        failing since 178 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6099bb95c69c38f4b66f54a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bb95c69c38f4b66f5=
4a8
        failing since 178 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6099bb78c69c38f4b66f5485

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-5=
3-g5bc5b67b6dd5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bb78c69c38f4b66f5=
486
        failing since 178 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
