Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A592B2C1F
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 09:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgKNIY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 03:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgKNIY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 03:24:27 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282D5C0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 00:24:27 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 81so498255pgf.0
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 00:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8FcaoN0/n+iA94n5w/x/h+tI1JPZkrw16YS0YfSyUug=;
        b=a5nJuFXH6UrcvMroXxFEu9B8dwK0ZR8qL3zWLlwu5WhoovF/GdUF1MYZRhm2Z7DNld
         yQdcI7ZeU9AnaDdFR3JqWRtm13WSPPPZPcXVAS6TaoDbGT/xrfuISBJ5y4EiVt7a0nTD
         oCuOsSYIaU0+QKqEle2JQQXJgUJ7fJKQVdED2XuVR6AZTZfqz3hTdNQTIrbJvBh4Daoh
         JCjJafZ5MaXbgtfdzXIVeppSxFeznBJxmtvI0AfMvC2qmm6zborZekveM57MSIRpP4Sn
         yJ2Om9OIEB1WON2cJ4SaXxK6LA8X+lqXveBc7nLweG7Llq6X/MJ6JNJ4UV+uHzVCgHGK
         2WsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8FcaoN0/n+iA94n5w/x/h+tI1JPZkrw16YS0YfSyUug=;
        b=Vjc+uoza0rFypeAqpfXkONRdH5DTevtLKJbGwEq08trb5t1tVhgxvbhWcGB1399gk7
         C+RZr7yGohLEfy4w855205PhZUZ9ePIC4xtjglg/jg0KMMhu/xbEK0Zo87vpv3WvKrnN
         FzZR8FgQFbvm8iJJ09i1Oh1groqadUfE01TqNWuK1SZpM/15P4Ow7Tqt5FrcyViUeXJV
         XjE48mFsD5mKVWC05CaAAwn7Ia2CpY8kYiL73wGjE/bQ+x/QI0X/AJlYdzvxE4N0Tbyg
         BmFVUytof/4Bm1pfzgl9+5/InLKmdErN7vq8RvYnyEe5P8D0HrEeafxW76pZ6i0obJ9G
         96YA==
X-Gm-Message-State: AOAM531tTa2bt6nTaf8pMjT0QEbN/ZBD93/HwCh7k3Xf0Q8NBwGV8cUy
        ZSxf5d6VrT5eLOZDbeYEAmJ8nDEtGOnM+g==
X-Google-Smtp-Source: ABdhPJwzdt7+8HltnHd4l3IGGV8dTezmbcQ9c4THCAm9qosZytElChGY+wJD5kJroHxHzVxu+hk+HQ==
X-Received: by 2002:a65:50c5:: with SMTP id s5mr4993636pgp.399.1605342266300;
        Sat, 14 Nov 2020 00:24:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j11sm11508797pfh.143.2020.11.14.00.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 00:24:25 -0800 (PST)
Message-ID: <5faf9439.1c69fb81.6485.8d69@mx.google.com>
Date:   Sat, 14 Nov 2020 00:24:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.243-25-g36f0f006c3634
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 93 runs,
 4 regressions (v4.9.243-25-g36f0f006c3634)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 93 runs, 4 regressions (v4.9.243-25-g36f0f006=
c3634)

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
el/v4.9.243-25-g36f0f006c3634/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.243-25-g36f0f006c3634
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      36f0f006c3634f6f12ceb39e1a646c2e6ab6aa3f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf5a7f867618f41879b899

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g36f0f006c3634/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g36f0f006c3634/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf5a7f867618f41879b=
89a
        failing since 0 day (last pass: v4.9.243-16-gd8d67e375b0a, first fa=
il: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf5a89867618f41879b8a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g36f0f006c3634/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g36f0f006c3634/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf5a89867618f41879b=
8a8
        failing since 0 day (last pass: v4.9.243-16-gd8d67e375b0a, first fa=
il: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf5a8a867618f41879b8aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g36f0f006c3634/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g36f0f006c3634/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf5a8a867618f41879b=
8ab
        failing since 0 day (last pass: v4.9.243-16-gd8d67e375b0a, first fa=
il: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf5a4adeb3fce5b679b8a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g36f0f006c3634/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g36f0f006c3634/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf5a4adeb3fce5b679b=
8aa
        failing since 0 day (last pass: v4.9.243-16-gd8d67e375b0a, first fa=
il: v4.9.243-25-ga01fe8e99a22) =

 =20
