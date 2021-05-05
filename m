Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EA1373DD3
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 16:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhEEOnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 10:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbhEEOnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 10:43:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE00DC061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 07:42:07 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cl24-20020a17090af698b0290157efd14899so953868pjb.2
        for <stable@vger.kernel.org>; Wed, 05 May 2021 07:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kDudLaF29YugKJoM022vey7FT1K5OVn/FfBgdLc3RCE=;
        b=eSVq/KVF9SozGsKE8nekzgF6I0H5YbdC31Loosd3spLeT5BS/FlpBGt6Hs7rrX5exe
         Vbiaesc7Z4tT/R3Uk1OS+YhIM53hQHko6x6EaU1g99n6abOeOHbGQVtAyt2GWGL3gOWs
         LhAMZiw+zAtCG6S+Rbv8lttsfiJSQF42k4D59y03X1DgLGpKUtRFgmFVEbTXhLeNgTAk
         YBvD6LvbdYa/OLwsw2YbTl78/q6m4diQzUcUHR1v+b+ggSfO1spwSRpVzCVnhNldhchR
         F5EWZU1w2nFFaFAsFhJvy7Y5i7P948ZoqCdCS2aMICo6GmRb2m5nPyziMYpUK9AuRLCX
         97OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kDudLaF29YugKJoM022vey7FT1K5OVn/FfBgdLc3RCE=;
        b=BmzWuiYamM5yTVsjs8mCcm4BTuaXpGjlsilgCN+8QmPIdGxfQ0W0UDII+sF/vrSmsY
         M23zLhZbh8JT8zds39ogIQrzth9Ae7bYan3WWiYVi0erHACk9MZDpIRw7TTrpqR1tS4T
         z62du5sxhnvs+SvXAXhutY/Clf3BVJ2EBlmMhsDi/wazkSg3QV8qF/aQjVGSR9U1zjms
         ze3eBnEz7L9PtlP980kXoTq+s884hjOxGE0xvEA+Dl9YFWYXtkZoxIF70kIxeGpLl31T
         i4pmckoJdEk77t/zEp+xbKkfdJ0dHwLc8HDipBTicZLQU3VbXrZhVjfUExou0CA8ESrE
         oynw==
X-Gm-Message-State: AOAM531hpMRrnZRbP3eoKoBM7PDHrU7VOhuYykPVtYAULj8iftDiVhi3
        WpDtK2lQybjRmSho82ZDNtDTyugZDYVGw0WW
X-Google-Smtp-Source: ABdhPJzS67Ud+Rxp6aJ/S3MtKzj86bpuwb+jOZIuD6e9zIEvhB2BKf84z8EosXPG8tBFgCM29wwDmQ==
X-Received: by 2002:a17:902:778d:b029:ee:f821:f56d with SMTP id o13-20020a170902778db02900eef821f56dmr3327506pll.79.1620225727299;
        Wed, 05 May 2021 07:42:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 130sm14793001pfy.75.2021.05.05.07.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 07:42:07 -0700 (PDT)
Message-ID: <6092aebf.1c69fb81.e8ca7.65bd@mx.google.com>
Date:   Wed, 05 May 2021 07:42:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.189-15-g20a2cdc1f2ec
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 68 runs,
 3 regressions (v4.19.189-15-g20a2cdc1f2ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 68 runs, 3 regressions (v4.19.189-15-g20a2cd=
c1f2ec)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.189-15-g20a2cdc1f2ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.189-15-g20a2cdc1f2ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20a2cdc1f2ec1c786f272c02f4df0932cfb31d17 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60927a09567c991ef46f546f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g20a2cdc1f2ec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g20a2cdc1f2ec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60927a09567c991ef46f5=
470
        failing since 172 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60927a0e110511628a6f546b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g20a2cdc1f2ec/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g20a2cdc1f2ec/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60927a0e110511628a6f5=
46c
        failing since 172 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60927a0ad1c8ab3bcb6f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g20a2cdc1f2ec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g20a2cdc1f2ec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60927a0ad1c8ab3bcb6f5=
469
        failing since 172 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
