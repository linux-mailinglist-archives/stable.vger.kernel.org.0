Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC64297E09
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 20:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1763970AbgJXSwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 14:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763969AbgJXSwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 14:52:05 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B23AC0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 11:52:05 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id bh6so2691592plb.5
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 11:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RC0Pep7Cqxi7qlMvLj7bX06cUOk0nxzfJKqf6wmXcEI=;
        b=DDTXeLh/7J8Z+KDUPrj6N2p7qmcAVZ8D5HyYnb5oHt/Jrcmky+MkNhQZ9fByiG0/T2
         0GG/xwl0YGgRp61Ii/5t5kit7q89HwqR18I7zPRFdWZHs2yOIDCEti8L9mFD3cRLlInG
         8dsoABfpabhCAIaZWYcGwh+sasgZPXtZ0Fo4y3Nlw6N2yfODxNvCd3BwgbgsyuTXXzft
         T8tje75ExtEo3Lo5oM4ymcyED97gj5/hX9fnqSoAHHMOh0bHnprE3f2iMlDCy6BI/48O
         Y/f0J2uoW1F5XG5mj67ph5ol03ebZkD3uLLq+sm2VSSZjmropVaKHHsFHKgBuu8Uj9XE
         fBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RC0Pep7Cqxi7qlMvLj7bX06cUOk0nxzfJKqf6wmXcEI=;
        b=Ch8439EeMNyzx+nheJkxAY2/WJ9kYf+nXTPW2GLsaSl6zQP/0R+x0bNtCpRHaeng6A
         nIH5gXkjp94Tc6A2joIx6WQVKk4XZkpk6+3cvPWx4S3Ue0X6tB1SVImDOdOOKjclH2tt
         uydWgJXVNrOGfsNi6MEK/cVLVx3hSqSOPSVTxTrR/ICvDiMCb6zklJVuRGxDqBnrteOv
         3ocVSqkfNTXgLWqKJdVP1ZnqdWL7Ix8scvQj/8MbbvqXArmC/iEam7f58NJ+E9PjCzcc
         OiTIsFUqYnoiSLPFSF+t5XkAWOoVaRxW9NtwkgCPsEfeRYFSvda9FeFH4CYFFsp0tiFZ
         3B9g==
X-Gm-Message-State: AOAM533Pa/WHhznUrQaxS7EX0rkEv8LtV0dpqoC9oBGnvRRaKp/07BDQ
        c4qakisZ8fPWHmBO0w9Ge35SvFwYlDQZLg==
X-Google-Smtp-Source: ABdhPJx8O20IhFFr6QJygHbwiRwxWB33LVOnE8LBqugSiC6JayAyQfaOuZ7aCAj7B2u09CjISp63/g==
X-Received: by 2002:a17:90a:b389:: with SMTP id e9mr10537211pjr.191.1603565524573;
        Sat, 24 Oct 2020 11:52:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b5sm5816094pgi.55.2020.10.24.11.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 11:52:03 -0700 (PDT)
Message-ID: <5f9477d3.1c69fb81.a01f3.9a0c@mx.google.com>
Date:   Sat, 24 Oct 2020 11:52:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.202-22-g6201dae728ea
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 156 runs,
 3 regressions (v4.14.202-22-g6201dae728ea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 156 runs, 3 regressions (v4.14.202-22-g620=
1dae728ea)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.202-22-g6201dae728ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.202-22-g6201dae728ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6201dae728ea264d55be7100ec236ce878f15acb =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f94465b82cf667a02381016

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-g6201dae728ea/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-g6201dae728ea/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f94465b82cf667a02381=
017
        failing since 92 days (last pass: v4.14.188-126-g5b1e982af0f8, firs=
t fail: v4.14.189) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f94456fd31bba4cea381026

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-g6201dae728ea/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-g6201dae728ea/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f94456fd31bba4cea381=
027
        failing since 207 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f94461e5b46f594d7381021

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-g6201dae728ea/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-g6201dae728ea/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f94461e5b46f59=
4d7381028
        failing since 0 day (last pass: v4.14.202-11-g83970012a2ed, first f=
ail: v4.14.202-22-gc247dbbd6699)
        2 lines

    2020-10-24 15:19:54.503000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/105
    2020-10-24 15:19:54.512000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
