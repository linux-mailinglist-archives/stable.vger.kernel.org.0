Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4B63748F4
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 21:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhEET6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 15:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhEET6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 15:58:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE0EC061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 12:57:23 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t21so1718208plo.2
        for <stable@vger.kernel.org>; Wed, 05 May 2021 12:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A5h2Oefi2h8qBy08+12pqTq0aaZsxyq6J72b8uN9z2A=;
        b=wg82etK9pDVZBctp+rVegKIbHvlbMw80CWbFcpLq3yxzqchLy6ocFXRiciKf+1rs9E
         /kww9U5Wm7P8MtGfKfgWy5K9t9LYWdMhM68IJAwXWW8/jotgvHusXg8ZfVNAJkdVHTMX
         3Dqkxx3vusEdi2RiPIFhAxeLoNLUVOwhU7VVHe+M/MDr80m3a+mE//826Qa4stIsoeAZ
         tJdGoMjgvAH/BCTf5cHIJMODcH0X1V7vYLehqL2zMlaUkEJtdJJ7s/AN/CvMV9OJ1x4f
         Ero23zC86QGWFUQ558G6MzMZpF3KoafWE6p1dBNnm5hSd7gMVEyQ2f/AKa85ZLKba97l
         ddcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A5h2Oefi2h8qBy08+12pqTq0aaZsxyq6J72b8uN9z2A=;
        b=aGS2LUQ23+aRtbnKl9BFgEu4VfAqHmAMA6b7BYOe3LoaS2L3HiP4XfOJzU71W/sO/7
         8v/LojO1lw9mFj24AERrG6TcchxnuwW7PK7vnpXq0KnRlLLmC6Gnq6ByQoaf9++I2ffh
         zVaWbhbis9/1Qcou9RgrPzIwGpXJa8SzDYVn/WrK+ObQNml3vENqKa6pIVjYxsMFvOgy
         rMwxl04RCLvWm9KJXpAzI5sUbEghV9YBDlBb/6fop35dChPVktmBUZLPlAFKm9gkGgvh
         Cy0UlnLYiS5xS+aWd1qUU5tW/kEMyMqng6eE/giwtJErmGe9Ti1kc2d8mKSc9aaipU3+
         bi3Q==
X-Gm-Message-State: AOAM533uMHqQeWIMJhu8dKJRCNrYnYxYywSWqmNyjocOfaOO10bKESQS
        /1GUTAeaLHHhgMH4c+vYHYxCaq59X/Wmrkwh
X-Google-Smtp-Source: ABdhPJyin4A2vFJ09cFGI+cUav6ql8WDBx3mh/HNKt9i4/zV1QYgfAlXS1sITrKjheXA3Lgb1J4WvA==
X-Received: by 2002:a17:902:6b81:b029:ea:dcc5:b841 with SMTP id p1-20020a1709026b81b02900eadcc5b841mr391508plk.29.1620244642704;
        Wed, 05 May 2021 12:57:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3sm61357pff.132.2021.05.05.12.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 12:57:22 -0700 (PDT)
Message-ID: <6092f8a2.1c69fb81.36622.0575@mx.google.com>
Date:   Wed, 05 May 2021 12:57:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-6-gad06dd89e8208
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 54 runs,
 3 regressions (v4.9.268-6-gad06dd89e8208)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 54 runs, 3 regressions (v4.9.268-6-gad06dd89e=
8208)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-6-gad06dd89e8208/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-6-gad06dd89e8208
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad06dd89e8208eeb6274def2a8cf71c8f3e11acf =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092c5d09e5dfb85706f5469

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gad06dd89e8208/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gad06dd89e8208/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092c5d09e5dfb85706f5=
46a
        failing since 172 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092c5dc47a5db02e66f5471

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gad06dd89e8208/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gad06dd89e8208/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092c5dc47a5db02e66f5=
472
        failing since 172 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092c5eb748edc08486f546d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gad06dd89e8208/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gad06dd89e8208/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092c5eb748edc08486f5=
46e
        failing since 172 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
