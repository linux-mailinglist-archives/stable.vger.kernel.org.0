Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE767424AA3
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 01:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhJFXrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 19:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhJFXrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 19:47:11 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BF9C061746
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 16:45:18 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id m21so3868537pgu.13
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 16:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fyRtfKgQx85STa4ZGi+gogvw9mFyzuUfN8ioF0Jevp4=;
        b=WWG63a8b75bR0Ig4JbIqGkCjkcBhsc9ZEgzm4t5o3S6xQAHN2bs+K5O9sweiaQSFq1
         aaDZyZovLfjNbg1XkISn4LpMip8PU7kfpsWhEeUdgeONW/E4moKhp8TcmPS1PrS8Ohqs
         Ez1LBQ17YP7/BAWGJ4FemlbLXbkTzI27B0V8AKxiq9yK81oVR4p/WsAe3DUC1ndYwy90
         W9JGaYt1Du2ghdAVpwosLVcJeajhe1yDcFySsascAp4Y8KN/MTEIobj1gJ+3nw2mqi/w
         OM1JLqK+NoCRcZc1/+yGCeAiWEuJ2VXmtmE4y5xjxSeoMd1vIIcj3oR6WrqiBSZDnf6p
         5ImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fyRtfKgQx85STa4ZGi+gogvw9mFyzuUfN8ioF0Jevp4=;
        b=gKqwQmJoi8WBNVv7ufXsZqaj73zMp4I5vDrkRbMCxR3bQSoC+5zb79pmOtCkEJSMPx
         zXiJ5rSemqwK6pqWD3G44zNgwylMwOILBs4LBae4/SX6WVpU6k/bDpxe44iy/6SUD0K6
         az7GRzoM0G1fGxemt1IIjrntN+rxE88dELb28jAXaThRB7f8vNR4eGJRFx0SvygiTCp1
         bALENmQ1/jY1LoGxR/dBOqEGuU50rLrtT6TLSYmvzk9zzGmojABI2rQABisMnh9i5OTR
         usZtizKXACxYPrXf5YxPnvUDAyDmT0ueOWqInKQiKnyq8NlLnNXixsLDkzMOWdFuD6zd
         OS5g==
X-Gm-Message-State: AOAM533zPxzbuC37Krk7q4PR2V/m7PNbDP/c2OVKS7RLOlXtumIbLxZU
        FmK9Dpb3pQvfrxj/BXUiL9Hpq3HdSRaOgbr1
X-Google-Smtp-Source: ABdhPJxwXixGNXP2im1S/luxGFn08hJ/UROMkwThT4y1xM1aTqDxGagCtF+d33gV1DFRgGyl5P5raQ==
X-Received: by 2002:a62:8284:0:b0:44c:6490:4a2d with SMTP id w126-20020a628284000000b0044c64904a2dmr1176816pfd.38.1633563917838;
        Wed, 06 Oct 2021 16:45:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15sm11950183pfr.92.2021.10.06.16.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 16:45:17 -0700 (PDT)
Message-ID: <615e350d.1c69fb81.4a81e.3ed5@mx.google.com>
Date:   Wed, 06 Oct 2021 16:45:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284-57-g336dc9dca78b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 121 runs,
 4 regressions (v4.9.284-57-g336dc9dca78b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 121 runs, 4 regressions (v4.9.284-57-g336dc9d=
ca78b)

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
el/v4.9.284-57-g336dc9dca78b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.284-57-g336dc9dca78b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      336dc9dca78b16febfca94439af50dd04677c8a1 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dfad4b25b45996d99a323

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-g336dc9dca78b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-g336dc9dca78b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dfad4b25b45996d99a=
324
        failing since 326 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dfb26c32e3c4c7599a305

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-g336dc9dca78b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-g336dc9dca78b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dfb26c32e3c4c7599a=
306
        failing since 326 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dfacab25b45996d99a314

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-g336dc9dca78b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-g336dc9dca78b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dfacab25b45996d99a=
315
        failing since 326 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dfa4b485cb48bb299a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-g336dc9dca78b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-g336dc9dca78b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dfa4b485cb48bb299a=
2e7
        failing since 326 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
