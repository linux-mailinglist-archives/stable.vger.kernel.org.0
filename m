Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011603E0BE9
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 02:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhHEA5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 20:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhHEA5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 20:57:13 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162B7C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 17:57:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d1so5075186pll.1
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 17:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iaCVSRimzfHAbLqmZn2ZHcc1pxf9RPAXlWFOjJZ8q4A=;
        b=nJ0mZtaAEM+bQ3GF6YLXrrgXvOBbh6imxbhkrWpc/C+51HSk0Xh/IOL0gRO+DAXMcO
         2dgnKR60M7QTZKPyvGZYNgaXx5Oo2FTGHXzarSvV2hUzi6ubxA47LVm+QaOPhMtXEr5O
         rYUE2hNfg1oHTLmgffdVnmEGUBc1PIy+PR/dZLm/wNTtWga9I76UhE8gKLLysopVXz+X
         ypSoAVztmftsHkKYlzMPQ7JgoNLd5MOkw0FmMFakL+r4hRCIS5cnaLJJ+D4HXwxrxuLu
         +KF4lmVR1n/3SVQiW2d4crXRsZE3B+MiUVe/3/wGSNm0Bx4OlfFF8nNzwrU9gCMThNPe
         ROoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iaCVSRimzfHAbLqmZn2ZHcc1pxf9RPAXlWFOjJZ8q4A=;
        b=eL1ZxiOD4isNXsEM3qkbNNJdBtsGhCRKv0HHk3TGqDAZR0e2ws+cAvFvAgnkBy6Kom
         7zJuOOTUcxo5AeGX7Ru+H+wKo2Nh4RhBOyRI3GuncLG0ofZdXgJhUTqLR7Su1GtYySiJ
         yHNA0hf2SIIqQhZyccxOk8h3uSxWzRME1dni45UmQOhWZz+KsNkA2xU3XMjf047ZWCzR
         qcxM1MXnEQOmj4dfyBekaJGd6l8jlFMjiXQCPnRCibinwyW599FdwjrpLKsKa8MLMe0z
         8WVH7fqOH78jjAOwXTAeiZhNIyEH+U7/VkcHcAm1/HYN3b+wLrQpXePLrMEl+ujaLW4J
         JCkw==
X-Gm-Message-State: AOAM530HVh1l0V765M7YAC2OxHAjn83STf/pn4wdWpHFH5WIel45lY4A
        QrNKCzt5dEG2r6UrReyzv4cEBntke4IizFcA
X-Google-Smtp-Source: ABdhPJzPu1jx76+AdeIo1aS+03DcCuC1iZqxB7Xoifzpe+QeLppS/izt23YEYnA7/BUrG04KYsVOxQ==
X-Received: by 2002:a17:90a:1f09:: with SMTP id u9mr1763440pja.206.1628125019163;
        Wed, 04 Aug 2021 17:56:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d14sm7550056pjc.0.2021.08.04.17.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 17:56:58 -0700 (PDT)
Message-ID: <610b375a.1c69fb81.7c81.88df@mx.google.com>
Date:   Wed, 04 Aug 2021 17:56:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.278
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 52 runs, 4 regressions (v4.4.278)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 52 runs, 4 regressions (v4.4.278)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.278/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.278
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      372cffad865ffc79132d858ab0526dd51f97b0c8 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610b18ef5d71eecb83b1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.278=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.278=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b18ef5d71eecb83b13=
670
        failing since 263 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610b04723a0f7a2441b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.278=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.278=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b04723a0f7a2441b13=
663
        failing since 263 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610b19904bc59ed0ecb1368a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.278=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.278=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b19904bc59ed0ecb13=
68b
        failing since 263 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610b04ea6c68e8c507b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.278=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.278=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b04ea6c68e8c507b13=
662
        failing since 263 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
