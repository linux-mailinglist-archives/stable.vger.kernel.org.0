Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63A03F1515
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 10:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhHSIXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 04:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbhHSIXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 04:23:02 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8B0C061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 01:22:26 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id c17so5177954pgc.0
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 01:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s4Ur7cb+fXi+2rdVMNSv/J/AsZ/ExwnlO90dto+6/B0=;
        b=zhS1/gCvAIu6cATm1c+dLBA8neEpuUCT0tqQCGeiG42bmxR+WrHMIlaUwtmQo0FVS0
         EIP4WpY7p9Jiiw9xI4sXk13LhRIcTPGe6rQph/a4hNS07R4RLJC/+IpYuO1ZUcHk98Ku
         24yjnjtFax8etoAUj4TGhZmQqactHkv6fccmo2BgLRVU1ufGJMBDCfeHQMlWZaDL874s
         b246rf7kp1h/ljKX42mSFxALZZIou/ybTptuKrBlUr4l3BVxtYUaD30UY/iVsHho77Pu
         FO21cqj/CCq2S/MJeJkeQci8qtA/743SevYFY/HwqsoIxJlAQiMqKEZVrxqccQrR+14l
         zfGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s4Ur7cb+fXi+2rdVMNSv/J/AsZ/ExwnlO90dto+6/B0=;
        b=DHiq7vF+8teKJjfCjdJw/k/EmvuoVgAiLpDWqJFVpedFniL/qBpEMYteA4B/WYHM6O
         O6iLRCSJcpMylU0CGcoNLGeZN6eWGdqyO3yI4H1ffii4pgT85SQkpw9PCHA9YACvncdE
         a3E7EiCwVImiJdrMTzGAcb5U1Y8psrlDDuDfHyulgdeb60DQMvbNE106NoEe6pBp60sb
         qjxO4DaeL7IbFEPa8cR3CdyUt1rXuFEwd1DlhXMRrO08pQoSQ6/0D2ikDUQ8Gd7cZWob
         Q0X2KyfMtO66dtwcdJVuVmAL2xZgMdd8js0cQdycUkbXYptyCuYk6xYapX8Dq+y0/3Go
         33Ug==
X-Gm-Message-State: AOAM533/eWqWlLavBYK3Z5Zh09JGakzjp/WJkjXSFprPJfCqU8OCfggD
        /ZcDb/k/O1TGdFQGJHAcqgkbYwFkZ//mEC+2
X-Google-Smtp-Source: ABdhPJym1z96JcUQ5hL8QaINqs48YwZvnTWhUtyltpAQETFTyhOYtxOrg7ZCa+rO9bwc25Y3SjTDVw==
X-Received: by 2002:a63:ee03:: with SMTP id e3mr12999989pgi.386.1629361345597;
        Thu, 19 Aug 2021 01:22:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12sm2907322pgi.21.2021.08.19.01.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 01:22:25 -0700 (PDT)
Message-ID: <611e14c1.1c69fb81.45c99.9b9a@mx.google.com>
Date:   Thu, 19 Aug 2021 01:22:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.280-22-gf3c59f891218
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 82 runs,
 4 regressions (v4.9.280-22-gf3c59f891218)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 82 runs, 4 regressions (v4.9.280-22-gf3c59f89=
1218)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx6qp-sabresd       | arm  | lab-nxp         | gcc-8    | multi_v7_defconf=
ig  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.280-22-gf3c59f891218/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.280-22-gf3c59f891218
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f3c59f891218ec79963896a2d5d8b130e3478dcb =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx6qp-sabresd       | arm  | lab-nxp         | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/611deb06bcc471dcdbb136bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
2-gf3c59f891218/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabres=
d.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
2-gf3c59f891218/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabres=
d.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611deb06bcc471dcdbb13=
6bc
        new failure (last pass: v4.9.279-40-g387b5b3e0726) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611de0ce19a6459c74b13664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
2-gf3c59f891218/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
2-gf3c59f891218/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611de0ce19a6459c74b13=
665
        failing since 278 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611de1630b9376705db13698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
2-gf3c59f891218/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
2-gf3c59f891218/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611de1630b9376705db13=
699
        failing since 278 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611df97793d52fc5ffb136cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
2-gf3c59f891218/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
2-gf3c59f891218/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611df97793d52fc5ffb13=
6ce
        failing since 278 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
