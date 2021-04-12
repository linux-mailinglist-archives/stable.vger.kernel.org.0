Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B9D35CA64
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 17:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242088AbhDLPtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 11:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239633AbhDLPtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 11:49:14 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25431C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 08:48:56 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y2so6590592plg.5
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 08:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ak/S1OiXu/KG4pC/WYq9nb4jYgRoDoVp7p6wRl2cE8s=;
        b=IBceKP7mUtHu0Y0slEdjQ9BQ5eSWjYbc+m/5tHsi+l4wUGgTOq6/ECEiz94CfUd2wC
         strljB4gdZvyOv8UhrLtXAz8+VKLynEyPLF6ReJNCjS1M2kGyvFvgPMIIE5L351x3saP
         tw7IiOY8kcIEod7pPSHX4zT55+p/Np6HJX6jyEtl/UKMfDOpb8sVlMQ9d+q/ONwSOZwQ
         fHNVY+jXkPGxhmrmoKtexwHJj05y03DBqpnHoqjxi1JFZardMowHzKrzo5Bhje0BrzrG
         wkXuyQn9XMMhSIAGSMCreWJS90Kg/N8yEJPH5Tz/67LNdZJkFMdO3g4+Z3mvd1NjV51g
         aNwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ak/S1OiXu/KG4pC/WYq9nb4jYgRoDoVp7p6wRl2cE8s=;
        b=X9JOIl8+OqHCIBEvSfXGktG+YW8yA7VS9kSIHU1KGT0EMd+j0+/+G3EriSQs0cCBLN
         v2AGS7Gn76Pq3m5RY3iOgr6HMy7EXdGQ2zi5sglGL9NE1xNX39hdpKCC6HEvRr5iMxwk
         KjiTtmfLo59ImGeRF+5Vi9YA+wl5i6HeKwiBdRDzmv72m6bslqSeSJ+5/8zws49G2DJs
         d7qCh/s6OH8xhbT9cKhWO22noZeRli6ZfV22A8nG0SwLvWGOVbxUhGa0K7HPcZp6qvYU
         2D9bL3YPmvBjb3w6fcTTvfOPmzS2J5Byl9LUN4qY+2ct8Xd5+hBpnatHy/BcuBa7O45d
         UAZQ==
X-Gm-Message-State: AOAM53052yhRGUCHic6ilxsr2QBedVPOztHumB6bjtL/IMEluM6quJBJ
        wgFhXrwO8yeBb8+gHclZV0osdrJzmg6/GxU+
X-Google-Smtp-Source: ABdhPJzv1QIO68G8XxJRuivW6174gAJUlowT5b7jhqXHKMVszPU8wZK7w4nGXtxSuEjZwkgDvda5nQ==
X-Received: by 2002:a17:902:c948:b029:e9:8f01:fa8e with SMTP id i8-20020a170902c948b02900e98f01fa8emr22407612pla.37.1618242535517;
        Mon, 12 Apr 2021 08:48:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e68sm9892498pfa.78.2021.04.12.08.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 08:48:55 -0700 (PDT)
Message-ID: <60746be7.1c69fb81.62bd0.7ec0@mx.google.com>
Date:   Mon, 12 Apr 2021 08:48:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.186-67-g85bc28045cdbb
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 119 runs,
 5 regressions (v4.19.186-67-g85bc28045cdbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 119 runs, 5 regressions (v4.19.186-67-g85b=
c28045cdbb)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.186-67-g85bc28045cdbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.186-67-g85bc28045cdbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85bc28045cdbb9576907965c761445aaece4f5ad =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6074351a8a15338292dac6f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
86-67-g85bc28045cdbb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
86-67-g85bc28045cdbb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074351a8a15338292dac=
6f3
        new failure (last pass: v4.19.186) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607433a04fbc25da10dac6ce

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
86-67-g85bc28045cdbb/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
86-67-g85bc28045cdbb/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/607433a04fbc25d=
a10dac6d5
        failing since 1 day (last pass: v4.19.185-19-g6aba908ea95f2, first =
fail: v4.19.186)
        2 lines

    2021-04-12 11:48:43.523000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607432a336f2fe77f9dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
86-67-g85bc28045cdbb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
86-67-g85bc28045cdbb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607432a336f2fe77f9dac=
6b2
        failing since 145 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607432a5a5cf04dc73dac6c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
86-67-g85bc28045cdbb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
86-67-g85bc28045cdbb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607432a5a5cf04dc73dac=
6c3
        failing since 145 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6074323bf2fb5eb89ddac6d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
86-67-g85bc28045cdbb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
86-67-g85bc28045cdbb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074323bf2fb5eb89ddac=
6da
        failing since 145 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
