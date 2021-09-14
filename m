Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5F740A25C
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 03:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbhINBMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 21:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbhINBMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 21:12:45 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87D6C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 18:11:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k23-20020a17090a591700b001976d2db364so1451110pji.2
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 18:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=87Bl3Afr3nPb1dwNOCUCX0sZoBcYj8nX+Lhxw2x0C7w=;
        b=Waa8SeFuPUNBiskUmz4+Ck+YeUBJ8IiNmK5T8i6Gi+A8abawNvgbwVpiIVC4HrT5rZ
         WvYC0KLAlDXWWQZtlRdgd7CCibsAEluYybTY0NzK91nKggJY/4iWkmdi/PcOSG8+MeDY
         738ts0WgPYdDlFWmNh/tVjMbvDp6p3J9jJGhGJ22zt+GVa743LwCXUmYaVOFtbwVmruo
         kO+ypOoPty1cHSOrVD7MfugIlumzPugFOKGV/rUNNlygEmLbgGo8suH1oNCGq8i+oXyt
         FEh2AYeTkQglGZmQosGoK/NC27Mc2bx6UIavn4GZAlEadwPp18qE02/J5ZRDUZU6lvQY
         UFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=87Bl3Afr3nPb1dwNOCUCX0sZoBcYj8nX+Lhxw2x0C7w=;
        b=L3CY0WGCkayrQQPHhwN506upztP0C+AKYzeEpebqwVcSOMxdKQvG/j1mGHBpC/MuQ1
         pgOe9yV3E4eL5X5KaYapRH8hQeufSC9wJ/B6Ips3C7gEMGVwOxzDuXXhP9tnkZpKFWUS
         H9dCOBuILmpHIZ+R1/EICLZuB56JG0P00YaKEAjQsnqt7efDc3PHKBmY3DhgKEg3gQvS
         nRGy8sG0uqMZQXxV4sP4lH44V4LY8XU/WybXfgNW8bOB21VtCFhXHJOnL7anENHMhxnT
         jpIixAfLMFFhL/4p5fdsPFR6uDHy3vHmVViSs7NKm9GFAdT0AUZOXB6Z96ejCGC3e4dx
         XTcQ==
X-Gm-Message-State: AOAM533bBj5e0ySvEshk+7QQcRgjjN2p/YmEUYaTzMSqs0m4sIlWOqEs
        ioBcA2z55qijCDDEIpNrah2cJg5tx9m5ZraG
X-Google-Smtp-Source: ABdhPJxVJhkSGCgIs5ZyPfXAkLhKM/uNGoycNWMzEmaeDsuEqEiDfI+AjKhgETlMOawa58Gi0XojFg==
X-Received: by 2002:a17:903:32ce:b0:138:7c09:1178 with SMTP id i14-20020a17090332ce00b001387c091178mr12955038plr.60.1631581888113;
        Mon, 13 Sep 2021 18:11:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d3sm9436038pga.7.2021.09.13.18.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 18:11:27 -0700 (PDT)
Message-ID: <613ff6bf.1c69fb81.a03cc.c753@mx.google.com>
Date:   Mon, 13 Sep 2021 18:11:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.282-90-g32602d9f6bf3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 113 runs,
 3 regressions (v4.9.282-90-g32602d9f6bf3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 113 runs, 3 regressions (v4.9.282-90-g32602=
d9f6bf3)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.282-90-g32602d9f6bf3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.282-90-g32602d9f6bf3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      32602d9f6bf37110cca4b3a415eb233e7e66697d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613fbc120c79a1297b99a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-90-g32602d9f6bf3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-90-g32602d9f6bf3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fbc120c79a1297b99a=
2fe
        failing since 303 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613fbc050c79a1297b99a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-90-g32602d9f6bf3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-90-g32602d9f6bf3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fbc050c79a1297b99a=
2ef
        failing since 303 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613fbba3385b8df71e99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-90-g32602d9f6bf3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-90-g32602d9f6bf3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fbba3385b8df71e99a=
2db
        failing since 303 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
