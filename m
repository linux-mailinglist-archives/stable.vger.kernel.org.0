Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6EC32FC4E
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 18:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhCFRbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 12:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbhCFRbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 12:31:34 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE80C06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 09:31:34 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so884972pjb.2
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 09:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vwENKitVVeTSB8bzkh6Yv+7i8WH5VCOjotJmGxk3sSg=;
        b=tPBSmn/71DOHqCGsttaqbkA7TMZZ2QJwNxxkYRhyHk4/YXSv/cs7WrlFate+A4nn6T
         hl/VXP92Lg3FXIlvxqggD+2Qq7uFsbMqqtrcud7fU0uyFTcOtzFlyosdCaNCuEX0MHD3
         +/IFr3ZB2aka0Pc++KPbsn9puZw3G4j6In3ucMzVGIKqmx3ju2+zzwfwNw/APhMAjjHR
         sYCJBQigR8ii0y21xVLQinupWF5fc1wzFc1uUC654KHrcCGtxXeVeJNWLaNuc5HY+5hw
         BiThIn8fR4/yVlA/yn3IZkwhVPeHaXGmoH4gQH+twg/9Wux/CGYZ9yfmuFBgDI1xaVHO
         h/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vwENKitVVeTSB8bzkh6Yv+7i8WH5VCOjotJmGxk3sSg=;
        b=lkb0hF6MfiaFdgZ9jKfpijqjzTmBByLc24GIuEBFz2ODciginqnzqY1gMVyhwAJSJD
         mLxsxTwXVKIUNTuUnYPSpLcC8cQcIIBIMa9b4evpiCMW/QDyFMjcfslJSyy/0FnMPtS0
         Vtz5/nZDfDSXmdeZCkp2O8PgktInij0zRWLUKGXRYUOtIg8QpZzCjvoiZsdC08HYzA9h
         v3ydPlHAU9+uUonzWFkWrbJK1x+jzAx55ntjv94nQj3jVL3n4Fv5IJ4Ea3PQtzCqwzhS
         Yoh73lIsosjLrfN0AUGmFuuddIHE7zgeZ0oJVW6RLbGRvXJRJ07VM+fHpAQ8Bz5aug9T
         61SA==
X-Gm-Message-State: AOAM530+uyBA3jt50gge3dv87EALbaL9btrutubC72sQcUzshU+XTGLP
        DhcaN2DlDwVvjO0b42ZGNegSqrMoT6jfSQ==
X-Google-Smtp-Source: ABdhPJxHuJBwHxq3jzJj8IpTl+eoIszXQZ4MRMofr5B2mcaBGAU9sF58zb3/zeGTpRoY15vtgP+AVg==
X-Received: by 2002:a17:90a:9f43:: with SMTP id q3mr16480363pjv.50.1615051893228;
        Sat, 06 Mar 2021 09:31:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p190sm5719785pga.78.2021.03.06.09.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 09:31:32 -0800 (PST)
Message-ID: <6043bc74.1c69fb81.20573.e75a@mx.google.com>
Date:   Sat, 06 Mar 2021 09:31:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.259-41-gf3059ff21bb9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 87 runs,
 4 regressions (v4.9.259-41-gf3059ff21bb9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 87 runs, 4 regressions (v4.9.259-41-gf3059ff2=
1bb9)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.259-41-gf3059ff21bb9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.259-41-gf3059ff21bb9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f3059ff21bb995caddb05fd6a8564b3128bd6219 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60438af69a734dd1cbaddcf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gf3059ff21bb9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gf3059ff21bb9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60438af69a734dd1cbadd=
cf1
        failing since 112 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60439267446f46a023addcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gf3059ff21bb9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gf3059ff21bb9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60439267446f46a023add=
cd2
        failing since 112 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604389804de9498b64addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gf3059ff21bb9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gf3059ff21bb9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604389804de9498b64add=
cb9
        failing since 112 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604389895bea92cd65addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gf3059ff21bb9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gf3059ff21bb9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604389895bea92cd65add=
cc7
        failing since 112 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
