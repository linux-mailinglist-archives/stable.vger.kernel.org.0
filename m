Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B033D2BAC3C
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 15:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgKTOwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 09:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbgKTOwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 09:52:50 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73EDC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 06:52:50 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id j19so7471746pgg.5
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 06:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2gjJdRKuAfuHzIAfK++oJw26sz7/E7q26myyCbC3mog=;
        b=ej67BQF8eNr8GZHQUsUoSP4MHFObhFRPRXX3dUPnufi6F4bc9wNd006Jzn2bGS+QrJ
         ZQ0l+957Q58mr5lBmNyBMyY3QOdB8yrh+slgupnzYIaWP07wql1Kv4Vc1y+cCSlWE70n
         MZh+5bMwEChWIBIjf99ms1Wzjn/W6DkxygyFx+iXNPKDjwW8zOVsQydT5398BwGdwdBu
         llfaQstQ1FVVjWo29QsYtYyDXqsS2Q/YKbdE1lfMEA1VcOR/Uf4KU3w+x1UYhDOsNxR6
         xk3vTDg4OWTFWnVoidvRo7Vxt4YmLzkkiaaloGMP7EiRzAy1tVYVyz4HGFiOSNbq5nhv
         Pptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2gjJdRKuAfuHzIAfK++oJw26sz7/E7q26myyCbC3mog=;
        b=Cc3qD5/Va57m4Ur/kT+KOum1ndnw7xd35kfPC7JVA3PwJmXDHizCw/UazqAh/1hPa8
         tvmLWraBIbqQeU1brZYBVO0Tl7djcsFm2Ae/as8WEyuq8zUww1XFAnWWYmwBmICXWI0g
         ILrwuk70nWzWMytU7yQGznCwtIkO2xtg1/2FFur5yHbFREyZ9GYxwSqvexT0dF2nuLhp
         TVR5xI1FF8cDm0pkDIsEkfeEalj0ES9r6L6cpMdiklRyxU5y//s4U1ijwYze9nV/aIlV
         9J7fnxc90cxMjcFCdUx7//CbMU8TE7k6/+ANQAVucg3zA4SZzsybwXXUFNoVkTI/vPmv
         1BaQ==
X-Gm-Message-State: AOAM533pUxNLQRhYC4QfaKM/5zk5GFfRjpWWOVrddO6jRGTbRYnhv8yv
        JjfeKxnf/EhfZy0ItYehUxh6z6OD+ehw7A==
X-Google-Smtp-Source: ABdhPJxNQn1QvWe7bdRMmEBDV5fnYt+OChtqtlm8BNj0UjvBkfoMyO3yky21LAGeaRn83Oai6GzJHg==
X-Received: by 2002:a63:e74a:: with SMTP id j10mr17814837pgk.208.1605883970019;
        Fri, 20 Nov 2020 06:52:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm4295374pjn.26.2020.11.20.06.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 06:52:49 -0800 (PST)
Message-ID: <5fb7d841.1c69fb81.39bf4.8084@mx.google.com>
Date:   Fri, 20 Nov 2020 06:52:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.158-15-g9eae57180402
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 93 runs,
 4 regressions (v4.19.158-15-g9eae57180402)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 93 runs, 4 regressions (v4.19.158-15-g9eae57=
180402)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.158-15-g9eae57180402/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.158-15-g9eae57180402
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9eae5718040242d60c15ac85c837fb4e15e4099a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a68e57b39a61cad8d925

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-g9eae57180402/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-g9eae57180402/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb7a68e57b39a6=
1cad8d92a
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55)
        2 lines

    2020-11-20 11:20:41.542000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a569ded96eff44d8d91e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-g9eae57180402/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-g9eae57180402/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a569ded96eff44d8d=
91f
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a57a77497f66ced8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-g9eae57180402/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-g9eae57180402/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a57a77497f66ced8d=
908
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a51b1e41abb9c5d8d90b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-g9eae57180402/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-g9eae57180402/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a51b1e41abb9c5d8d=
90c
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =20
