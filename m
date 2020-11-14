Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268ED2B2FE3
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 19:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgKNSyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 13:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgKNSyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 13:54:38 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD6EC0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 10:54:37 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id q10so10103309pfn.0
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 10:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JyKSZbVR1SL21tDtlMA47UPBeD5mEdxkRyNoCX0Hhao=;
        b=1ipD4lWvxW6Qn4P6KYZRwTKtVT3BOuXgTkpctQXa1qHRmLznxyrfS5FhRpdf5U3Rez
         z6ITXSIFPH/aFyw9/rcm3ziZL3auJcp4RPqnrafiOKbF5BRCwhDJVYwqYhISfHxVKW/J
         gyp8XjeD3qRjBzR1gVBU4piwCGkfkJcmRzlGlkrYc/xJJypuCBbhmxERPPz+/FEmZS0X
         hoEO8k/qUpWuMt2XwJFkYfh7foRMW1td6xhJ7UGHEVggG7jTDlp2pAoDEySZpGmEvd8J
         bxF24+qWmzwjiRJJ2bCn72d+++w99x8/Wed6Fxzq8BymZk8UCPHQPrjM5MpyRcn8qbBR
         uuMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JyKSZbVR1SL21tDtlMA47UPBeD5mEdxkRyNoCX0Hhao=;
        b=a2FekQJELuzfcC/+pQJTahUrj0mVi77cPL7ptee9s9RszY+OZlPnfvzHGcMop3u4Z1
         N8ynwsvmwh8KNNahxe3LGYGJBDMBDsIjVxmJ+S3cOi96sij8QXfdTyXQpIlNLUbKkSSV
         5HUuMiH0XtH95NQ4Zn+DLRI+BS2HqlVdaNoFZAuX9ZdJAjZckuzsskuEqyBMd7o2474B
         gBUJGDywBmTCd7hSJune72UCnFOaeVtTVvGmTZz3l06dgUDY5jQcfDexj/KvaTtwWYr2
         vB2p/mQay2bbsx5nHAWqRy+1LxlP85L00W4oVVUb9NjGcZfJ1rblWEhZVtgyGoc4W8fM
         N9fw==
X-Gm-Message-State: AOAM531qfczDvW089SqWucwDSSfhYnlQ8XvsW9nC3akDE+OH0hNuaJ9X
        PJGlDqM9gl/PMZ8LVOaSveygIberZU1Jsw==
X-Google-Smtp-Source: ABdhPJxD3Q/HfBYgFm5AlL5JZul+qNceasxUJ6NxpfWDsV7yfVu43cjQNqBfEPR+di/R7zM9Wa4gpQ==
X-Received: by 2002:a62:643:0:b029:18a:b225:155 with SMTP id 64-20020a6206430000b029018ab2250155mr7484176pfg.56.1605380077086;
        Sat, 14 Nov 2020 10:54:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7sm14018203pji.27.2020.11.14.10.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 10:54:36 -0800 (PST)
Message-ID: <5fb027ec.1c69fb81.e3eb1.da32@mx.google.com>
Date:   Sat, 14 Nov 2020 10:54:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.206-23-g520c3568920c8
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 33 runs,
 5 regressions (v4.14.206-23-g520c3568920c8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 33 runs, 5 regressions (v4.14.206-23-g520c=
3568920c8)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.206-23-g520c3568920c8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.206-23-g520c3568920c8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      520c3568920c84f6a2f5272d6eef112057a5c7a0 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fafe6e4cc857783f479b8b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-23-g520c3568920c8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-23-g520c3568920c8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fafe6e4cc857783f479b=
8b8
        new failure (last pass: v4.14.206-21-gf1262f26e4d0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fafe6e9497c2952b079b8a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-23-g520c3568920c8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-23-g520c3568920c8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fafe6e9497c2952b079b=
8a5
        new failure (last pass: v4.14.206-21-gf1262f26e4d0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fafe6d5cc857783f479b8a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-23-g520c3568920c8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-23-g520c3568920c8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fafe6d5cc857783f479b=
8a2
        new failure (last pass: v4.14.206-21-gf1262f26e4d0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fafe69e98244be72e79b8a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-23-g520c3568920c8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-23-g520c3568920c8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fafe69e98244be72e79b=
8a7
        new failure (last pass: v4.14.206-21-gf1262f26e4d0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faffe20cc0a4a8fce79b8a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-23-g520c3568920c8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-23-g520c3568920c8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faffe20cc0a4a8fce79b=
8a3
        new failure (last pass: v4.14.206-21-gf1262f26e4d0) =

 =20
