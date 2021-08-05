Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB813E12F1
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 12:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbhHEKrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 06:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240367AbhHEKrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 06:47:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961FAC061765
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 03:47:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so13782935pjs.0
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 03:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T+E9j0WqdNFI4yxHOhyGS+WRv3tN4COHm9OULqvMQpA=;
        b=vEprwhDdk2MBnkJlCmImfIuLNohWjJm3LA8FuOwqtpXzefrEr4xytmA1EGa5Tunmx2
         NnJkIG0M5UedVOnhErbwtTgbg3l38dWaa8ezKKj/B3Z+WdvdYr0otwOQlzVBU0mcNVek
         TfWWyPT7idfX5zVso4S5zBkYBTxkiVNSdaOgrKedfLvFikrcGN3o9XlW+nsiRtTmTHQg
         l/Se3z2d1Wkswkt1VcybBd/LqHhG1kVukq9AfV26m2ZqjWvfwwOAr8sn1vMCfb2lnEWD
         OCbwb5cjGsBOSFwGBhdG46fBGyB3PSMt+gT+zHu5zNRbWlKaqdKEnDsHKsz+Un4nx7YH
         +f5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T+E9j0WqdNFI4yxHOhyGS+WRv3tN4COHm9OULqvMQpA=;
        b=SVRRI7OD5GEX1YwiL6qvOi6Doc5R8eGOKOof3UF8G4Cgg2ftHif1HI3NJEyRQwesFD
         ydFxHCrf2lNqBCDes2cpIJgJf4eCN3TZWcbgNbl7qo5KsyM+yeKWgHXuS+8ES0wFFDPf
         BUUpcCaK9p1JhoRncp9KQeDjHXq+3O9SuiT7nyzrDSSkf50vxS9kLK+qHSljm2h8WN+f
         +kGPsZpGFJOc12pjRH/K2UDyPp3EUulrCpaxkzPgbk1xkZgQycyTqSnFsSIR5E570o5P
         0zLnc4fSoxBoBLKhM2hpjC17STw62h7mvYpNddT+N4JaptVsYCebieZlpH9dpkPv9Kz0
         oAzg==
X-Gm-Message-State: AOAM531d1kYIoK9eyrY3T8XwNctFk5C5pjaZWrxxi46oVXgQIkuntfBW
        CMyIxn2if2a8ogKBHvRefzBs/epyYOMJBiiNOl8=
X-Google-Smtp-Source: ABdhPJwifALgL5jboK07ZffcHg1E3P7h00rnoMgwCEeIB2TEWtp3mcgefdeIxIB1IwTW0srbaYEt9Q==
X-Received: by 2002:a17:902:7c87:b029:12c:8f2d:4238 with SMTP id y7-20020a1709027c87b029012c8f2d4238mr3502479pll.50.1628160423019;
        Thu, 05 Aug 2021 03:47:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13sm3992726pjg.25.2021.08.05.03.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 03:47:02 -0700 (PDT)
Message-ID: <610bc1a6.1c69fb81.4a259.ae54@mx.google.com>
Date:   Thu, 05 Aug 2021 03:47:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.201-6-g92fff11bfbec
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 83 runs,
 3 regressions (v4.19.201-6-g92fff11bfbec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 83 runs, 3 regressions (v4.19.201-6-g92fff11=
bfbec)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.201-6-g92fff11bfbec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.201-6-g92fff11bfbec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      92fff11bfbec172e2a6586104ea0b491af5932e7 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b86cef7e8cf7214b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-6-g92fff11bfbec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-6-g92fff11bfbec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b86cef7e8cf7214b13=
662
        failing since 264 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b86bdf6ff4826d6b13673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-6-g92fff11bfbec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-6-g92fff11bfbec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b86bdf6ff4826d6b13=
674
        failing since 264 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b866f657b22f314b13678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-6-g92fff11bfbec/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-6-g92fff11bfbec/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b866f657b22f314b13=
679
        failing since 264 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
