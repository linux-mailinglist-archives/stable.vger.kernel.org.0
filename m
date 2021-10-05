Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EAF422B64
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 16:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhJEOqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 10:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbhJEOqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 10:46:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91BFC061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 07:44:24 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so2226533pjw.0
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 07:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UL/AfrWvJ4rR/gpNIvUMT7N1aFdbhgN5UaPVgyU+dPg=;
        b=T+0MIVpddMFRgcwhay+od6HiO8LDyMh7gZ2Zd9/JqiEUrAVA1iosj5aKaj2+3lN8/W
         we15n1O7hoHsc+XR6L+4MNOg19N7hDrWwIv8MbsSigerDw6sK9ZU0zS3kCFoxN2gJWgG
         Y+5c/MabQ7pdTNWYkyP3qCNPe4Wh4FT7mw6UzlinCZspIsQRaglxSTacGX8nziNzAf8E
         ZT8GH0+5d6moI/O+YM6ThuMxWgcmRhfHH79zBualPUVm5uhU3/mrejVY+ktc9bE4gTkB
         UZ3vGQa0H9/fOiQodEz43kOx3EW8RMygcvWF/dwjSR5gL8qOaVvr0gOWyMC0rEt1jkQI
         mx9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UL/AfrWvJ4rR/gpNIvUMT7N1aFdbhgN5UaPVgyU+dPg=;
        b=58ZGOLo03g5RYcH8AFg3V+/JvTWqVvQgpimocLgG11U4bnGP8BhyRzMvSORPGLJjMC
         XQGOae4kL1wDhGZQvZF/4EMd5jUmPokb1LnjsltjTp2WDYBvK129R33Bims6qrOhjk7z
         meP1FQ2p+tz79tbsUgJtD9tnI8Waa81UOXTQnIsKmf6WiJkoVU+eWolTlfpu7udBGSqk
         WbHsBp+8WEF2q3Xa4KKWIJ/DVpguYST1/LgEEmUBlwl1FQ++UY0NLHn8nGGT8kUf5rN+
         HMNleSjsNq+1uPzyM+Y4TVVJW9FMInaB9gQssENaE1DrMii3qMzQsp9wUn3NwSEWxS7S
         2rYA==
X-Gm-Message-State: AOAM533rTSyJPlwN7RG9IJ9BvMGRxhrUHPkL+ftarcVPvsAdAB3imcAC
        C3ull0Ac2VSNS/xc4fZuNEdWefULXuStGfJ/
X-Google-Smtp-Source: ABdhPJyzoKV+bFdg87Yx5STrV/U319yTkXWdvayo4yjl5YIJw0uGuxo3Ao2XwmOu34jWyZ/+q0lIDw==
X-Received: by 2002:a17:902:bcc6:b0:12d:bd30:bc4d with SMTP id o6-20020a170902bcc600b0012dbd30bc4dmr5598267pls.18.1633445064288;
        Tue, 05 Oct 2021 07:44:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r13sm17833269pgl.90.2021.10.05.07.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 07:44:23 -0700 (PDT)
Message-ID: <615c64c7.1c69fb81.46f2d.795d@mx.google.com>
Date:   Tue, 05 Oct 2021 07:44:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.208-96-g88f9c3c825ad
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 129 runs,
 3 regressions (v4.19.208-96-g88f9c3c825ad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 129 runs, 3 regressions (v4.19.208-96-g88f=
9c3c825ad)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.208-96-g88f9c3c825ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.208-96-g88f9c3c825ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88f9c3c825ad88e33c64932c60fb5c2d130a9fb1 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c314e990dba53e899a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-g88f9c3c825ad/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-g88f9c3c825ad/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c314e990dba53e899a=
2f1
        failing since 321 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c49cd3d09f0fc2b99a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-g88f9c3c825ad/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-g88f9c3c825ad/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c49cd3d09f0fc2b99a=
2ef
        failing since 321 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c314fc42b9dbb9299a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-g88f9c3c825ad/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-g88f9c3c825ad/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c314fc42b9dbb9299a=
2db
        failing since 321 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
