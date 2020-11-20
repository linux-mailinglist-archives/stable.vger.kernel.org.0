Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7292BAA00
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 13:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgKTMUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 07:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgKTMUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 07:20:06 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E57C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 04:20:06 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id j19so7146503pgg.5
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 04:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lpiuNs+0jb+cbPxZZS1PZVPGJaYY/D9AevTvmpqNKyQ=;
        b=a1Xw8SLaPdjpMXIcRNgCoV/EyZ/l7UBWWF4Y9ejqpbk18VpPp23j2/mXZYz9JjAMYg
         m4qmKukrPwJBIduCcKby5ppHfTHhosRT/VJ4dsZH82D+haVq+cEMI1mWAdbQ4OBPHbNr
         upxXfq3bO/L5AYpKQdh+bW2u4gaR5g0lEuZ14yeafDESLlkzXIvSSM81rAGALbhMo97t
         G/IUdyYjWQ+h/pd1wDwyyizegIHkdS+mLjDFXwBaYaEZog17Vu34G/d5T7MbkAzwsHJb
         KWwXtuq8rj3HhZquqs9yLRUyEFnfVMg+1Y4xhIQfMdLtZ4dXa2plLNsJg0kLaWAyb124
         f2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lpiuNs+0jb+cbPxZZS1PZVPGJaYY/D9AevTvmpqNKyQ=;
        b=DpeCbqmrVIfGWFzEP4KNkGnIh/5ipBNvcQnaPq5niLc5uQ3Gv/mzDs4jxnxTo4CQdK
         8tTL06eBueQGO7lXcA4VIxjpSCgZG08IkGn9kzeEeQJ1kSXGPMF0u/3+NhcC8uwATqSv
         UGHIC+wEmfW1IjZbH93+946l+a3Su0BGO+g0ffKRhhkF+wQBVOBxWALbGfu66U5Vd+4L
         EjA84aLl9f+HmrBvfiNtqGOwJtue8nxz6ZdW4r7I6eI05vLm21Og9EGOxztvt+acEqeF
         es0Xbo2dqhbQgDLES1xMfj/EJFrdmQBu8IQk6KVN7oItXHn6RGhOVVJDLiCb1jJJBr26
         qDPQ==
X-Gm-Message-State: AOAM532oDXoaufScpdtdxe0jFuGtmHQWTGJJpfzwxA32Q0hDDrNaZ55f
        2TV8VPkT/5T+aC39cijVAQBjl04VZ8cvvw==
X-Google-Smtp-Source: ABdhPJy6wmiPRmsQ0UZHPyNoM+96VV494kXKeQTH3K7rjTRBOrW55QPA2VybKGRBLJ4twOPLBuwOrA==
X-Received: by 2002:a62:fb0a:0:b029:197:6f72:2ae7 with SMTP id x10-20020a62fb0a0000b02901976f722ae7mr13245746pfm.42.1605874805389;
        Fri, 20 Nov 2020 04:20:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n10sm3123225pgb.45.2020.11.20.04.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 04:20:04 -0800 (PST)
Message-ID: <5fb7b474.1c69fb81.c315.60bd@mx.google.com>
Date:   Fri, 20 Nov 2020 04:20:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.207-8-g06ea387328f1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 138 runs,
 7 regressions (v4.14.207-8-g06ea387328f1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 138 runs, 7 regressions (v4.14.207-8-g06ea38=
7328f1)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
panda                | arm    | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_i386            | i386   | lab-baylibre  | gcc-8    | i386_defconfig  =
    | 1          =

qemu_x86_64          | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.207-8-g06ea387328f1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.207-8-g06ea387328f1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06ea387328f1e90ae4aaf89e3b2808cde7bf325e =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
panda                | arm    | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb780abae19db61fed8d918

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb780acae19db6=
1fed8d91d
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01)
        2 lines =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb781bf4ba82938f2d8d903

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb781bf4ba82938f2d8d=
904
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb78232ffcfb62195d8d93a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb78232ffcfb62195d8d=
93b
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7823729eae318cbd8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7823729eae318cbd8d=
8fe
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_i386            | i386   | lab-baylibre  | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77f8c081a64e0c8d8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb77f8c081a64e0c8d8d=
908
        failing since 1 day (last pass: v4.14.206-85-g831af67bf2ed5, first =
fail: v4.14.206-85-ga231afb6ce9e1) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64          | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb780d95f7617be0ed8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb780d95f7617be0ed8d=
905
        new failure (last pass: v4.14.206-85-ga231afb6ce9e1) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb780debe4514b312d8d90e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-8-g06ea387328f1/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb780debe4514b312d8d=
90f
        new failure (last pass: v4.14.206-85-ga231afb6ce9e1) =

 =20
