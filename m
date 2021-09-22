Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AD241423E
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 09:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbhIVHED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 03:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbhIVHEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 03:04:02 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383E0C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 00:02:33 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m21so1651142pgu.13
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 00:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nE5vkLCz69F3FL9gCd3Re7NQccnOb55WO1M072JSgns=;
        b=tLCvbWoMljA5D4DEX4OpyUejIniGDE94Kg8ng28Jxs+I6atCmZNmQqA2kDtDYtMDHd
         IPaXFY7FSbccOh7nQ92UfMnFFlvNkItsBVjTggjfd7s20TphJrYC6AS92Tbh9QXfTsX8
         5DMx+Z3OrDwudvRlW7865CiKeJUwgZo3yRATN0PyzyrV+9O+CRcT2mByZi7TXwI3HDbh
         4ohFvmqFCQX1OdXj87/GvSJzSzOfKha11XCh2aX0vTAvg9nGFKppeF4OsEHQmcCgqqfD
         kzw1Tli6DWgzz/qnCEDxWF/3HGR5f0zPZ7IjnpF9Lg80HjokbVt9YwSr2bFWy++MeMqs
         zjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nE5vkLCz69F3FL9gCd3Re7NQccnOb55WO1M072JSgns=;
        b=QaQZ4rvqWZDq7tzRzlzrtyPDBPb242ilj0N47DJj6G8kJ4akYBP5ypVwFcQSqjBbxU
         mMGrQj4GYNRR/vxO05AU6x2K8vi5rIGeMQ155g9IACIe34rCoVldp9qrMc27N3jkW7/B
         1jG4L3G0Nul8ZOy8PHGiLs7TAH0tVgzxO/Db1Z59OYdgqWhCsqMXaIjP7RGtspXb+21H
         5ONPQO5+znrzgYUwcMdeDDrI7oWMxfLqE0/llXG6knz8qICgYwzU3dMX0qw86UPlD54L
         SpFB1CpVaPGtj2ndhBuV2oqhVsCUmozb6/k/1wO9qsyJzrUWYuuHdUxrpWDPlwplOr4R
         PrCA==
X-Gm-Message-State: AOAM531z+TK/bz88qlz1clYo/NRrvwQvRi/cphjkqXBhP18CIPRRv6nO
        r1/Y0d2guUcga6NeCoP94k+rXBHnd2kq7htM
X-Google-Smtp-Source: ABdhPJyXQIastfvtSVAEt2ETM672DGeD5ZvYQc58y1cucMVRI8OwIfkD/AlvJJ6r9M8fBeOOhKwjIw==
X-Received: by 2002:a63:6e41:: with SMTP id j62mr22769997pgc.120.1632294150975;
        Wed, 22 Sep 2021 00:02:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g3sm1478678pgf.1.2021.09.22.00.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 00:02:30 -0700 (PDT)
Message-ID: <614ad506.1c69fb81.89f74.5049@mx.google.com>
Date:   Wed, 22 Sep 2021 00:02:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.246-216-g1b9215e5915b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 91 runs,
 2 regressions (v4.14.246-216-g1b9215e5915b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 91 runs, 2 regressions (v4.14.246-216-g1b921=
5e5915b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  | 1       =
   =

panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-216-g1b9215e5915b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-216-g1b9215e5915b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b9215e5915b74d943ad8182cf1ca8046e88f282 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614aa486628d1591e599a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-216-g1b9215e5915b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-216-g1b9215e5915b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614aa486628d1591e599a=
2e5
        new failure (last pass: v4.14.246-217-gad16d239c36c) =

 =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614aa291955c0e327999a377

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-216-g1b9215e5915b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-216-g1b9215e5915b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/614aa292955c0e3=
27999a37d
        new failure (last pass: v4.14.246-217-gad16d239c36c)
        2 lines

    2021-09-22T03:26:56.182750  [   20.625305] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-22T03:26:56.228008  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-09-22T03:26:56.237020  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-09-22T03:26:56.250550  [   20.694152] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
