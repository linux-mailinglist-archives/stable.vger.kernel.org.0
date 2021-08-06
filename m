Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3183E202C
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 02:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241240AbhHFAsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 20:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhHFAsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 20:48:08 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2705CC0613D5
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 17:47:54 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mt6so13178248pjb.1
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 17:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/fdzil+Ti6YQ02VIvazSYNCZKQb+XYDJTLqEWhweSXw=;
        b=c6XSzgenhumwCTdBtZUMy9v8ie8c1JVvP9rc1+RNv++au/CsWsIDR2uGyzfQLt2C9f
         Idy0uY0qEQjha/+pkmsfT1Qwne4Plzuz9TSKmJZaDBDw5DJZc/By3YSyUBARslRWudju
         Cx61bOMLdfygTU5Qa7StTbZMXUNZIhUbJIrhCQR13kxIp4mr+uRl+iTjG1UIDHv4gLi6
         4qzaEdgORnGMRUqgAfCrB9mNANfMEdTFp0jO2HTdH9wHxj5jRcmuBA5BY+5+DWQMI7jz
         h361Vf/nmB9Uh3qYCxrYaPrpiVFJ/g+n83g6oQqwXsOg1xeVGQvGBD3OR//FV6dRs+H/
         MIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/fdzil+Ti6YQ02VIvazSYNCZKQb+XYDJTLqEWhweSXw=;
        b=LrgpF0DwhKtVUV3ryCtmiM1+FORgAWWfGTlKfwcGbBLcl8c0Iimjfp62RYAtzhM+Vk
         /V9Fv1e9GiM9m2IXZp1azsxkij9H7L+o+x2JAf9AlEn3G6WdCJ6Sv7C3u+2lFaMwjZNs
         cnuVOO0GHvnxe/rUanRJ/nw5+H+tzGrBZIHU/IQDac4Q1yj3gV0TmsRCClgLbuFMhU7V
         Yo25BeIMnzcgol3RrlJstkfPS4SR+T5R35moD/1EAwlgO/PKQAAYRYCHEj9eveMPVRIN
         87lo0Uk8HGh720PGYKEfO0vL95IuA3SCNn0aho5OKkZwU8jiZIfwx2rf9DaVfQqcIsut
         3aCA==
X-Gm-Message-State: AOAM5339hg8TEHSNWy+H3nTXrcecB8FABAmJarX4t3/TbUtPFxY4HBfj
        3O3+px+bdOXy3RoBUjzFbRK5h17IrOX8iL97
X-Google-Smtp-Source: ABdhPJwHAutUdCBqX3Idxj2GnDdaJM4KF1wyOPKb+L8m8hUDr2wbZypPFEYvZVwY+k1Ps9OnQ9MCsg==
X-Received: by 2002:a17:90a:bd06:: with SMTP id y6mr7490692pjr.6.1628210873387;
        Thu, 05 Aug 2021 17:47:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3sm10272533pjr.2.2021.08.05.17.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 17:47:52 -0700 (PDT)
Message-ID: <610c86b8.1c69fb81.6668f.1974@mx.google.com>
Date:   Thu, 05 Aug 2021 17:47:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.278-4-g6fd552aac83f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 82 runs,
 3 regressions (v4.9.278-4-g6fd552aac83f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 82 runs, 3 regressions (v4.9.278-4-g6fd552aac=
83f)

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
el/v4.9.278-4-g6fd552aac83f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.278-4-g6fd552aac83f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fd552aac83f2f09b5faf3098d93e8ab30c4bd8a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c4c7f87b73b79f0b1369f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g6fd552aac83f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g6fd552aac83f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c4c7f87b73b79f0b13=
6a0
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c4c8487b73b79f0b136a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g6fd552aac83f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g6fd552aac83f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c4c8487b73b79f0b13=
6a4
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c4ce4acbf78f604b13672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g6fd552aac83f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g6fd552aac83f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c4ce4acbf78f604b13=
673
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
