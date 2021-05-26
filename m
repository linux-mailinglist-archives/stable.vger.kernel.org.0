Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CF0391998
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 16:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhEZONp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 10:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbhEZONp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 10:13:45 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA67C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 07:12:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so392413pjp.4
        for <stable@vger.kernel.org>; Wed, 26 May 2021 07:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1EY3KmHqTWFklNMHtJIGcxXIM3otXNembOHwTh2ReoM=;
        b=xvXfbmXFDNc+j6dk1LB/h3amgm6rANIPfJdqdj0BnF6Sx24cU0QUWefjkr/57Bqu8V
         bf0PXV8CpNFA1GFF7HsQrx8y1Z9pZ4Kf/Ic7Uq9MIOFRNLpUpcvuU9c/7EjZpMcDYxfd
         4Pw2n1PBFHlAkBnpdlLuF0e64qNJkMDACtej1R4N0Jlhc+SyI3XuZpIK6p97NGFkxywM
         Wwn/HkZM2MN70u1ihG8C5XujA1Oyk5VMG+hoH0rLXWKBGmXXkXHomAOGzdiu/oo0O8OU
         6ve1V05MHErm40/EdgN9OVZkF3wkwaYJkAyPxKUd4INzTrc4HlA0vgf7L1JVKjbzV+Oa
         PS8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1EY3KmHqTWFklNMHtJIGcxXIM3otXNembOHwTh2ReoM=;
        b=g9lgTBOHpsTNpMkO8QLgdChH/MEO6Arju0MRBFliX+UzXK0k7AFV8azpuHP69kKpUY
         9dFO0GGuBm8RbGN55bmZx5UMtLqlbRuXkF78So59EEIEQ6qq+chn5o8uD9iU+bzXFrvT
         5XuyM0NHNbF3lDXiJ7izHwUpJM2EMzH1M16TYW1fTHsRSwchBnRsMde3t0E/GZBUZipA
         ojowTJae1rrxkY3Q3z8yPqZ8NdNiUt04yVlvYa/FXRn1XSpT+NNS/Iwr8aL7UDAmOtcA
         pgYFL/L399CRk4KWM3RfD01g997XfaMW/pCYXU/6bLg9iTBJRcQFVjiBrmt1gX08sKIa
         9sRg==
X-Gm-Message-State: AOAM530rUbFLQK6JDcVACJR3rOaDVoLNjfSprtaFB1YReXH5SfKIQEna
        8PmGyEL14lFyxGweFCunrnQjWM9ID6HdVA76
X-Google-Smtp-Source: ABdhPJwwY+dCMERphS5Vz5AZzR0ogxyXXav0hcXGFGrZKo0w5SBTHzSMjqHU8wlFDNStCY6h+o15aQ==
X-Received: by 2002:a17:902:d90e:b029:fe:5139:898d with SMTP id c14-20020a170902d90eb02900fe5139898dmr88799plz.61.1622038333586;
        Wed, 26 May 2021 07:12:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm14326518pjr.32.2021.05.26.07.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 07:12:13 -0700 (PDT)
Message-ID: <60ae573d.1c69fb81.e62a0.fed0@mx.google.com>
Date:   Wed, 26 May 2021 07:12:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.233-38-gf84ac0d19cd6
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 91 runs,
 4 regressions (v4.14.233-38-gf84ac0d19cd6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 91 runs, 4 regressions (v4.14.233-38-gf84ac0=
d19cd6)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp       | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.233-38-gf84ac0d19cd6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.233-38-gf84ac0d19cd6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f84ac0d19cd6381001aff59bb467008223c64690 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp       | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae246ba8db39b6aab3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-38-gf84ac0d19cd6/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-38-gf84ac0d19cd6/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae246ba8db39b6aab3a=
fa9
        new failure (last pass: v4.14.233-36-g430fdf2aba8d) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae2e9dddf8c31c24b3afd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-38-gf84ac0d19cd6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-38-gf84ac0d19cd6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae2e9dddf8c31c24b3a=
fd8
        failing since 193 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae2cb80af9db724cb3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-38-gf84ac0d19cd6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-38-gf84ac0d19cd6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae2cb80af9db724cb3a=
fa6
        failing since 193 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae2f59e90c388b46b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-38-gf84ac0d19cd6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-38-gf84ac0d19cd6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae2f59e90c388b46b3a=
fa6
        failing since 193 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
