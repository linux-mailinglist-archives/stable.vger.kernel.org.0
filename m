Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0B13E11CD
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 12:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240117AbhHEKA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 06:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240077AbhHEKA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 06:00:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595EFC061765
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 03:00:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso8040661pjo.1
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 03:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1aLUPntaMlWKnm5GRON6NpXlyqORjfaDF70xv3lUA5w=;
        b=Vg51SofS8o8wi2Ij82cfkQPTeT13EjMj5+3niKc2ckj8Z4L4vCE5AeZEzcu6pf5wsL
         eEfVIja0XxOustiZ9FAO91Fz4/Si1yAZQuMXoB2Oier1K1K2NfaWNcLeSWxwVQ8mYZIW
         2sq/Ya26rHbeeG605mxdFy1yEZg2Tg24aFaE5NZ/4OPG6SUKQTgYBBJdYDnHMlwLQu05
         zWFb0360TVuiOdqofH2sRWBeEq7zD1iREfDFKJjCwzg1OlMCdMi8S0zQ1wisxLjbhbjc
         L0ghpxa2CLa5kcEsTDnACERg/giopFdlvJZxtIHfkwFRAz4QtOSm+V22eahct1BB92xW
         niBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1aLUPntaMlWKnm5GRON6NpXlyqORjfaDF70xv3lUA5w=;
        b=mIhj5eyLzupzjfqZA1QOCsygJCP9MEmowy3q6cnbbETVBIUXfHgZcFYDWbHfEpOq3w
         eIzaAcIsZzTyVvJTIGmYkJcA2Gi9aPIxuK0lBhg74ryrkRyxMsNuSaiuEmefSjFMOb9N
         prAfTJQB1apNlpbS/+Rb+H3X1z4tUzOMFP9klYDAxKu2m60hz34v/juJl0y0F3NP8nIN
         kPJhnHtt+pgoE3lgEd47moBlFjQv/Lu33Qp06rTyBYrgyNDfeI6dlCHUagpC07/nKj+K
         A2gIbf28T0K+9MyvIHVNBssG53MfkJGGFvog7WdqRHNJv3eCniifZlucKu/YmwFWrpvj
         Iyeg==
X-Gm-Message-State: AOAM530HslXmFfe/H6Y2OZ77Nw9+D/dxlCbmSo99n1JFPlfPHf8AlhFH
        +GupbDdyRXgUwEpKvXVpoZLVYrr3IeCtg0AXBCs=
X-Google-Smtp-Source: ABdhPJx0KZdlF2BrLqRWW6eE+0buk4pz9vkxPCEuOn/IpGpL1LkohrlOiu1+lpk8NbJSsrJ6PsFyEw==
X-Received: by 2002:a17:90a:c506:: with SMTP id k6mr14458339pjt.198.1628157611716;
        Thu, 05 Aug 2021 03:00:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8sm7044005pgd.50.2021.08.05.03.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 03:00:11 -0700 (PDT)
Message-ID: <610bb6ab.1c69fb81.ec34a.456d@mx.google.com>
Date:   Thu, 05 Aug 2021 03:00:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.278-4-g1c685404c8b0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 84 runs,
 3 regressions (v4.9.278-4-g1c685404c8b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 84 runs, 3 regressions (v4.9.278-4-g1c685404c=
8b0)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.278-4-g1c685404c8b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.278-4-g1c685404c8b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c685404c8b0a119af6e3b222799b171c9980621 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b7c2ba02abc963eb13680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g1c685404c8b0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g1c685404c8b0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b7c2ba02abc963eb13=
681
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b7d0105b2f7f611b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g1c685404c8b0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g1c685404c8b0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b7d0105b2f7f611b13=
66f
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b7b93c03f87af1ab13694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g1c685404c8b0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g1c685404c8b0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b7b93c03f87af1ab13=
695
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
