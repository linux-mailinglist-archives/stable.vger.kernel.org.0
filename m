Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92693816EF
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 10:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhEOIeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 04:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhEOIeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 04:34:05 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C58C06174A
        for <stable@vger.kernel.org>; Sat, 15 May 2021 01:32:50 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id i5so1043739pgm.0
        for <stable@vger.kernel.org>; Sat, 15 May 2021 01:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9xNjYxomrlmBmQzk2D9rizwSMnGmrfe8RowrEL/7b1c=;
        b=xKUgI6q9KKvXhiSfQaRMvX3cdL7CeuSWoG5Y6EbNfjbp2bEF2fYeYodsBOIYW/0Tsp
         Dc0LpufqXz0etyAtCAlH3+pHcLYBzgX0ciQx2ropIt4ugkOvh+tLjC52XSraZQHFbrv4
         0bqyKqeTzskla4i7Qn2EfMlt8Fyx/b+Y4wTBw7ah3gJfEB8+YMiE5A0kmX+YHj46peyF
         5uq+dpeMhC9EdHErjofuzQSj8DRzaLTg2RqNlik/klZhGRHswtQmBd7ImVpEqQ52j+cX
         O+Wav0sS4oAtlUZdPIyNFKVrqQohXbyNP6J9ZGh9o5qz95i4bHbXQ7NkSzfNMEnvtSkz
         /I/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9xNjYxomrlmBmQzk2D9rizwSMnGmrfe8RowrEL/7b1c=;
        b=KwkL2Hn9tAyhfOlARvkwlfXwa6/QpDkXVexyM89z13r8CkiZze6vHEzuzdd0I1fvgk
         CW4I1GgNp6H2jULELg5aWi9jCZGV3D8YxMjxw0m1Uww2d4b1RdR94s5G4JXV71m93/JS
         EMMKgqzIYSo6Ysqadn5G1CtS7fhtoS36rKGVEWj+7cSIcKrnZxs5iStUAC+lSXuITlR+
         XGPhuWbBzWqd5Of5/OB48cGa9Ly+rAcWQLLFIbl0TvkpcNEXoR3ZHHZZTVvip1jHazYk
         E6MVYFP+88HD7Mo8ph3BzCgFfYLh9wLA/C2GrG/1ylqZIcvKU723to5iHsls1zmpkbg3
         ADlA==
X-Gm-Message-State: AOAM531RPy2X8f+ciY/2wo6kw8s17kLC7rv2mab1FxLwM2n9HEIqcDD3
        njkefOqmstJNllorsORI7N/x0VCd+K+OszTu
X-Google-Smtp-Source: ABdhPJyuTHqOX1BGI69yeU2pl9Mw5vpEbWnBRC0nenR1HgvIlm+4qLlGza++JhXb0yik5oScq2Xe2w==
X-Received: by 2002:a05:6a00:234f:b029:2c4:b8d6:843 with SMTP id j15-20020a056a00234fb02902c4b8d60843mr27097727pfj.71.1621067569712;
        Sat, 15 May 2021 01:32:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x79sm5627584pfc.57.2021.05.15.01.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 01:32:49 -0700 (PDT)
Message-ID: <609f8731.1c69fb81.e6fb2.3a98@mx.google.com>
Date:   Sat, 15 May 2021 01:32:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-204-gb2f33474a479
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 89 runs,
 4 regressions (v4.9.268-204-gb2f33474a479)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 89 runs, 4 regressions (v4.9.268-204-gb2f3347=
4a479)

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
el/v4.9.268-204-gb2f33474a479/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-204-gb2f33474a479
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2f33474a4794f4eaee8955172100d0a3d7c29a2 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f541069cf670e62b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
04-gb2f33474a479/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
04-gb2f33474a479/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f541069cf670e62b3a=
fa6
        failing since 182 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f541669cf670e62b3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
04-gb2f33474a479/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
04-gb2f33474a479/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f541669cf670e62b3a=
fae
        failing since 182 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f546ddada60fc93b3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
04-gb2f33474a479/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
04-gb2f33474a479/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f546ddada60fc93b3a=
fb0
        failing since 182 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f53d1dbeee3cd72b3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
04-gb2f33474a479/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
04-gb2f33474a479/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f53d1dbeee3cd72b3a=
f9d
        failing since 182 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
