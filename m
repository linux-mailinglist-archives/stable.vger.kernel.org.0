Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD43C42D753
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 12:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhJNKrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 06:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhJNKrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 06:47:16 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C5FC061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 03:45:11 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so805958pjd.1
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 03:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2BkBleVye/WQlEs/EDVO94ZCzx0Bmf26kwEz2G4eW4Y=;
        b=mZyhqphkrYuvMmC6BWPp9mwsEnLC096hv8ABxdYhwQ6yGUwxJX/cUCHgaJtDU8ZZns
         67ooRalOXRGgzSnvQw8NbWWgTAKwQCE+22CUtxOWQDD+pe7Qg1PhpsCKyh5uus/8uBO5
         NfdSs0LCwwrD7YID5MBxOUZnvRbje8ZiG1ev3MmCVz134iS0dkdQkdaqngOhlEmtN7GB
         bjNXhh11dumuVyW7b/bSAAw4LPbZmqz3n0IJuSaxda9O9qicecQ1wB2VZDrSGFVbOl8j
         vnrllNPCkxnAan21fWQtXu00fZkn72cnGiwhK9URBcJzyE5gSkRDVOF3pHtSlOhSApHq
         WPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2BkBleVye/WQlEs/EDVO94ZCzx0Bmf26kwEz2G4eW4Y=;
        b=yO3naIRiwX0ygKUq6knNmAO5QcmzMldainbf1bfD49YcHzQ069eMQc1zU8vLPspJDa
         WFzoTS2993997hWqNUuc7rToPv3v/WZMr8ovcWvaJ3/QQYr9vs23/2xZxpSZGw2DLuYN
         OQUjYPx+CxNF0O6U+oXzqUJUoKSGwEoxlidxBsAG8TOGJywpez5h/KJiFbbjAJlIM8dJ
         k/EruKfV++w3kOGkAMi4WQ/H0VKtWNEEV3zaKvXDW37tL2eszeucDDBFbxSXHB5pXc9V
         Asf+RVnTQ4kEKcf4m80DFiQEZBVcruIEXgJi/l+YnYPtg8LgDX5O79IWNV/O/PgjAHMu
         5mEA==
X-Gm-Message-State: AOAM531D/a7imbde5GMAIFQuoG4zqyjVCQkE+y7o9RNY76X9iDG9FsRi
        OfJgi4EWgdMp6N5hmqIqjIsk4bkxuIpFSLFYrzo=
X-Google-Smtp-Source: ABdhPJw4TB+mB98syc/F6LWRJnfhP74+Fts/n1HEsfaAZw8qqnH6/R+nWCnTBqj2Kq0t3joHPankRw==
X-Received: by 2002:a17:902:8d8b:b0:138:e09d:d901 with SMTP id v11-20020a1709028d8b00b00138e09dd901mr4445634plo.34.1634208311173;
        Thu, 14 Oct 2021 03:45:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y142sm2172294pfc.169.2021.10.14.03.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 03:45:10 -0700 (PDT)
Message-ID: <61680a36.1c69fb81.f027b.67d7@mx.google.com>
Date:   Thu, 14 Oct 2021 03:45:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.250-34-gcb9eaf51f06b
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 74 runs,
 3 regressions (v4.14.250-34-gcb9eaf51f06b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 74 runs, 3 regressions (v4.14.250-34-gcb9e=
af51f06b)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.250-34-gcb9eaf51f06b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.250-34-gcb9eaf51f06b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb9eaf51f06b404d5f807e408e9443f078355002 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6167cb96e063f88a6c08fad1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gcb9eaf51f06b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gcb9eaf51f06b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167cb96e063f88a6c08f=
ad2
        failing since 333 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6167cbc0b7911f8a7508fab3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gcb9eaf51f06b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gcb9eaf51f06b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167cbc0b7911f8a7508f=
ab4
        failing since 333 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6167cb9e1cdedec58808facf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gcb9eaf51f06b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gcb9eaf51f06b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167cb9e1cdedec58808f=
ad0
        failing since 333 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
