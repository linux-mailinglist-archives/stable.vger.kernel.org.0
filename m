Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6703C40CB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 03:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhGLBJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 21:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhGLBJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 21:09:36 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58D1C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 18:06:47 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d12so14835348pfj.2
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 18:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JHTxaSrI6nlvrvxFRKRPIWzunnHxiIK9608Cl3Pmbc4=;
        b=0/HPecP4LD8Hr6cCIk3kBtnQWF30ytYjBD3/ZZ9WRLUJa38JrA8DOAWlNE1R+Amf8d
         RwvKQn13nMQxRssEMCJBVJwLCLaDorlgLfchmkHl3Yn0Stz9rB5uNKsP+nZzX7xfQdoX
         wLPeJ1P5W94bjqiwNB62qq7fmsT8so7SgyhLJ5gb5w9IxzMQrumg58xprbTt/TwTxbdb
         o3mlu9dtfskqmSOIAKyvrociZEZba4yPoeLBGv9ldgbRV9t1U8mw+z4/Gc94ac9BnnOk
         SM8bgki0OkZFe/Xpt6bUsDG+d0XaXc0znUuC/jmOO9E6z9pDVGQU4B1Dowrq99em+dH8
         Lw3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JHTxaSrI6nlvrvxFRKRPIWzunnHxiIK9608Cl3Pmbc4=;
        b=ngInWY2Vnl+8FA0CFZ8+MGbxZllDx0TAqeUG+IjuzjnZZ528rpWIDUVnrrWjYYsE13
         PmbvCA061gFvSrJkMhSgv6v275gkjoQVMl0Ka0DMvjyZeSi4FrySPqV/aJv1SiX2qH6/
         nyNRSKOXsDSkaDAMaCio7Wl0Gk1KUkSe1AMfGsDFtd3Uxr3hQMPaTa0OfCcqMLbYudU9
         95Dt4MLOwCK8F8JBh4poaTwUF9IJaood/PshoaXJOjQRCFKwAj29FtHouq0C3z+kGPmN
         eN2u5UHZoRm6BFc5MsYJmQRF0O0SWsXgFo/y61CL6i0wHPWpdbAZSJS1lQHPZdkNMjdV
         QHAg==
X-Gm-Message-State: AOAM5320kdDiP0tLgePfyFtmeJ9IEpWqUH56rPoMkenmIAhPgWUCIFDY
        ObsqBWtPIPPwVVJVlvTnSPA7fp4t7GuFlS8D
X-Google-Smtp-Source: ABdhPJwEhu8sqcWeobNjJeGUP9DIVXwKvmPkpK/jeGvuznVbeOEo4F+7FHAEbYmBUj2cveErD6abKw==
X-Received: by 2002:a62:e809:0:b029:32c:2dcf:60ed with SMTP id c9-20020a62e8090000b029032c2dcf60edmr1729760pfi.5.1626052007229;
        Sun, 11 Jul 2021 18:06:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm14010608pfy.153.2021.07.11.18.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 18:06:46 -0700 (PDT)
Message-ID: <60eb95a6.1c69fb81.b66c7.9726@mx.google.com>
Date:   Sun, 11 Jul 2021 18:06:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.197-226-gf08467e5e13c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 162 runs,
 5 regressions (v4.19.197-226-gf08467e5e13c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 162 runs, 5 regressions (v4.19.197-226-gf084=
67e5e13c)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig=
    | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.197-226-gf08467e5e13c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.197-226-gf08467e5e13c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f08467e5e13c977129b0617e50e7401e90687bcb =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb6379d82c4f345f11796b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-226-gf08467e5e13c/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-226-gf08467e5e13c/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb6379d82c4f345f117=
96c
        new failure (last pass: v4.19.197-224-gd8feefb59b6d) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb5fcecc8ca957b611798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-226-gf08467e5e13c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-226-gf08467e5e13c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb5fcecc8ca957b6117=
990
        failing since 240 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb61e573a73be59011797a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-226-gf08467e5e13c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-226-gf08467e5e13c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb61e573a73be590117=
97b
        failing since 240 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb5fbecc8ca957b611796e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-226-gf08467e5e13c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-226-gf08467e5e13c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb5fbecc8ca957b6117=
96f
        failing since 240 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb6ccedf6deacd8311796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-226-gf08467e5e13c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-226-gf08467e5e13c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb6ccedf6deacd83117=
96b
        failing since 240 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
