Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2880400BA6
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 16:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236716AbhIDO3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Sep 2021 10:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236663AbhIDO3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Sep 2021 10:29:30 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8035C061757
        for <stable@vger.kernel.org>; Sat,  4 Sep 2021 07:28:28 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id j2so1279474pll.1
        for <stable@vger.kernel.org>; Sat, 04 Sep 2021 07:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pHnMmz/fqcfYZl+/drAwbTIp1dxdGGdkltdB0jUmsCM=;
        b=YBZxV7AWtq63D+fP9NVeeJ0QQpW5WNkfbkv6J2iFhG06ySOHWTXtFSWb2Jpna26gy7
         sSKoCjTmV+aZ3F8T5BpBu7ODTb/G2a6+xRDij758EvilxHH9mNM8Zc1Xi5SwP8ZGi8GW
         e7JlG7SX7DApChrz4W133w3E2LAI72qC9zYRMuWZslC+0s8o+hN701WZyja3WRTc61Mh
         HE2SWMFeigddYsRPsbioj246a6JSNEG0KDPCF96xnEo4FuCnPILuVFkfneY4umBOuNYY
         eslSCvKwteMUc6ZEG1rOOEQZYquak+v/XX8gEWu4WPipcRBjEyByBBnemR/zWD87P33U
         6BZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pHnMmz/fqcfYZl+/drAwbTIp1dxdGGdkltdB0jUmsCM=;
        b=lY1jRuzn+IxtKhg3KsSCR3WWIA5y7O2EgDWOB7j0Bay4XT26bty44ac9CAuy1mgzgz
         OG7wSL1b8YIDne5WMMt7iGEWTbwwjJsnsZTH5EO6RvcqZssGimZAK+Z1Dyp8DbUV5pww
         9XiiEHthhKQ9N/c6JNQEL7s6Qrrf0bu2xtkArMpbXkrvNplzhAsMU9/cVbD5R1SWl5tZ
         DS1+NBdU/XOnC9oX4EMrJcRu7KLtcjiYIIZXjohQvH6rAHlCZSUSywrQ7FDpWw2rG/TO
         sA4ZGxNrWKJPhEybk73By+okh0ps8c95k8c93LGu5OPFI5EimhzT6aBnmt/rpDcRPhAx
         eGvA==
X-Gm-Message-State: AOAM532W27O15Xp0f1MM6Y5l0XG0rXUKMxKPNdWVrOytcS+GoYBgoHju
        yKq3ZL+iJnQiWidEl1jVvezCuWOfHUD6Wyjq
X-Google-Smtp-Source: ABdhPJwEllsDQ6Apah5OO9z6Re5PezzfORA/F7g49zCzP/nwN8QanmPvb6VTmKn/G4qHUpI7PRUX7w==
X-Received: by 2002:a17:90b:4a84:: with SMTP id lp4mr4596641pjb.34.1630765708026;
        Sat, 04 Sep 2021 07:28:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g16sm2723761pfj.19.2021.09.04.07.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Sep 2021 07:28:27 -0700 (PDT)
Message-ID: <6133828b.1c69fb81.7506.767c@mx.google.com>
Date:   Sat, 04 Sep 2021 07:28:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-2-gf6ecb70da19b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 135 runs,
 4 regressions (v4.9.282-2-gf6ecb70da19b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 135 runs, 4 regressions (v4.9.282-2-gf6ecb70d=
a19b)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-2-gf6ecb70da19b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-2-gf6ecb70da19b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6ecb70da19ba4d8f44f24a31e738fb377865265 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61334f95f1cbab3b9dd596a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-2=
-gf6ecb70da19b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-2=
-gf6ecb70da19b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61334f95f1cbab3b9dd59=
6a7
        failing since 294 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61336dbe038969ad8ad59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-2=
-gf6ecb70da19b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-2=
-gf6ecb70da19b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61336dbe038969ad8ad59=
668
        failing since 294 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6133505260f8155d81d5968c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-2=
-gf6ecb70da19b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-2=
-gf6ecb70da19b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6133505260f8155d81d59=
68d
        failing since 294 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61334edf8b0d342d27d596a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-2=
-gf6ecb70da19b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-2=
-gf6ecb70da19b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61334edf8b0d342d27d59=
6a1
        failing since 294 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
