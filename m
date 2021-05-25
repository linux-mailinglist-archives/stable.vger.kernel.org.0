Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FCC3900DA
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 14:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhEYMZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 08:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbhEYMZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 08:25:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8A4C061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 05:23:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id kr9so8657776pjb.5
        for <stable@vger.kernel.org>; Tue, 25 May 2021 05:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LKX57bztoD4zkyvS/U6h0fn0TE4nOOD/YeDHUhX6kL8=;
        b=G85Xgjxz37ZnPg+nSfSrrYB04qURRqkpIanEB1+wFY0ipgB6GbkP5Y474M2FacJ2kB
         we7TYnfm+k8wggN9jF2sf2NKbWzqehWl0zsVxAFZEKuUbbgQWXdwZnvrHj/AwqFwxNMe
         MqaXe320f7nz/zFnrqertrWq2Y1987gbfJUBHo4uqFB7/NLN/W1mG44A7s0XthTsMUy1
         nS/1cpOdYEZD7KBxrKg8vQg51kTOl5Eh9txwz0XVSzqVGNyHly5+UFir5b41zriHy4OS
         E4zCCQkQpD+ZBiia9yMR9gV0jEw3s5JdbBOVolvpoIBXYiFpmwnyrEz0kLL6rLKY7Dy5
         RT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LKX57bztoD4zkyvS/U6h0fn0TE4nOOD/YeDHUhX6kL8=;
        b=qFhtamAnZUiGIV+Iq2930o8/uUiuD65VC3DKUvdAut4op+B/PD9HoZhmVQ31R7vCuP
         X0wXYHcpn8vqP1Zl6SpJrPkXkLxIoYhNAlbVvelaFCZzF/pRyjQqzBjbXZNdz+9ehhbw
         EHKI8O1T/m4RPEO0tHy38UHcewBzdMF0lFV2Kn11j1TalRkijCXFlCEACBQUwHPkADQx
         ilmZpazYn53U9czZVYCiF3e3gjxDW50YMByJRBg++U/KnjiiI8SsSalaqK0QTblhc8ZV
         BTqFYvSTyzApVIwJELGyS81rw5y6zQjYovvmoxul1fTwij+Ghn8XHi9kUjHAiEN3PixR
         5jFA==
X-Gm-Message-State: AOAM531mAADAUhrk4Hry2yWwJPBfBr0rRSzvraJ4XC6nkYEkUZiYZgI2
        nsH0z/3fOPWqMwjYV67s0ZuQxVLf2U8mJ+s3
X-Google-Smtp-Source: ABdhPJxbyVMzvqGUTCY+cxdfm+GGNF+qby6guTWrLaOsBMtnPQAjijZhzrXDQdwKysf/ekWgPg3GxQ==
X-Received: by 2002:a17:902:7403:b029:f3:519f:21e with SMTP id g3-20020a1709027403b02900f3519f021emr30503028pll.39.1621945422538;
        Tue, 25 May 2021 05:23:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p8sm13094914pfw.165.2021.05.25.05.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 05:23:42 -0700 (PDT)
Message-ID: <60acec4e.1c69fb81.47e69.b4f9@mx.google.com>
Date:   Tue, 25 May 2021 05:23:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.269-36-ga3fce6f40381
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 96 runs,
 4 regressions (v4.9.269-36-ga3fce6f40381)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 96 runs, 4 regressions (v4.9.269-36-ga3fce6f4=
0381)

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
el/v4.9.269-36-ga3fce6f40381/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.269-36-ga3fce6f40381
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3fce6f403810f05c5bf739631a206fc6dda486a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acbe7eca061308a6b3afba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-ga3fce6f40381/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-ga3fce6f40381/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acbe7eca061308a6b3a=
fbb
        failing since 192 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acb93ad1f2169178b3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-ga3fce6f40381/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-ga3fce6f40381/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acb93ad1f2169178b3a=
f9d
        failing since 192 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acc16ee3f6c4b4e6b3af9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-ga3fce6f40381/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-ga3fce6f40381/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acc16ee3f6c4b4e6b3a=
f9b
        failing since 192 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acd24fa070885b4fb3b017

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-ga3fce6f40381/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-ga3fce6f40381/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acd24fa070885b4fb3b=
018
        failing since 192 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
