Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977A2338387
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 03:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhCLCZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 21:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhCLCY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 21:24:58 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE60CC061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 18:24:49 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso7776243pjb.4
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 18:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5xVbfkzA6u8bEixeDZWixp6ciGCHRlNmOPjcuIp7ts0=;
        b=j7DkiHmFyH7exgbp510QwbHF/Frq0zV7KUHHULkf0lMcihe5IBg9CJRCf+Y+cQS1eF
         R5N5zDlvWyHESCajEyssdTd/5KuvnwvyUMbyt3hs1mWMA/F02PAJtY23XdS5LdE3PTjq
         RW/8FF/Z3b+UMvgxYT++U2opuaMoITHXsZ95LKXBGjhIGms3VWB6UhRzjUCAqAXcKDyl
         q86WPYTFagGybNZ6hGwjn8bjO1h2xspI17ivvEzXPrDDntOyViV7Qg7ce88CPjFQ7Jen
         gvEEHYFtetQoHE2pTHxQG/GkTy2rjc0ZEaXP2IgNyiAe7jhfk38BNg8qdjbV4WiDpMM2
         uXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5xVbfkzA6u8bEixeDZWixp6ciGCHRlNmOPjcuIp7ts0=;
        b=ZdPKZ4pLHUZNs8B+eM1isugPdkbFb4epmBeh2Nj9anGDI0ZuRB83tbe4YFQdcN2oUo
         nTQW9125YAW+o7lEEkLmy98FZWzhOiiYbqL9SuzII8SSB0I5Bj6gKOxJ1ywvrzFA0slF
         t3Ej13XtK2TDz+zz2hCebH7YEfsW65nDpozK0aIMsseYCITx5G+sRDHysOGkM70dUWIw
         y+7TaYVV96sa45HNluA0jqDZkMmWRLEwaTPrj5pigItBogF6EPLTZuOJypJdvDfCWKyO
         kjkAfotZT3TjL/7FPeZhBrMMUAh8ViBhLBTVVzchwQTZ9427Te4eWAV0yEvTn3CnL8Fi
         8vJg==
X-Gm-Message-State: AOAM531F+inQYJv/pY5LxoxsB8VSLettKFs7EcyObNB3U3hleNrP+Nwt
        Abc7JYyhj5EIRPJ3C4OiKl1GJaS5a4zbxmF0
X-Google-Smtp-Source: ABdhPJxxav8yT58nXoRb2/4v+7CT3iiB3NhWWz1xBg3YMPQAGcYFr+MjyvxJ4APKwwXxdDsxGpFPNg==
X-Received: by 2002:a17:902:bc87:b029:e3:f6a4:db39 with SMTP id bb7-20020a170902bc87b02900e3f6a4db39mr11005577plb.25.1615515889034;
        Thu, 11 Mar 2021 18:24:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7sm367297pjs.1.2021.03.11.18.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 18:24:48 -0800 (PST)
Message-ID: <604ad0f0.1c69fb81.1d8d4.1c48@mx.google.com>
Date:   Thu, 11 Mar 2021 18:24:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.105-23-gddc6c64e1db1a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 67 runs,
 5 regressions (v5.4.105-23-gddc6c64e1db1a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 67 runs, 5 regressions (v5.4.105-23-gddc6c6=
4e1db1a)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.105-23-gddc6c64e1db1a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.105-23-gddc6c64e1db1a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ddc6c64e1db1aa383fe8e2317dc04e46994cc1a7 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a9b9dbaa606cc95addccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-23-gddc6c64e1db1a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-23-gddc6c64e1db1a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a9b9dbaa606cc95add=
cd0
        failing since 117 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a9b9ecb89a2804baddcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-23-gddc6c64e1db1a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-23-gddc6c64e1db1a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a9b9fcb89a2804badd=
cc0
        failing since 117 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a9b97f30000cb1baddcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-23-gddc6c64e1db1a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-23-gddc6c64e1db1a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a9b97f30000cb1badd=
cc8
        failing since 117 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a9b3d70928f50f0addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-23-gddc6c64e1db1a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-23-gddc6c64e1db1a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a9b3d70928f50f0add=
cc8
        failing since 117 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604acc9bf1c70642a0addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-23-gddc6c64e1db1a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-23-gddc6c64e1db1a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604acc9bf1c70642a0add=
cc7
        failing since 117 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
