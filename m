Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E65335AF97
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 20:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhDJSaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 14:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbhDJSaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 14:30:35 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461DEC06138A
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 11:30:20 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id l76so6243695pga.6
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 11:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tVhTbpefjH2mb1/KRa2ocFOQ6IGLu65cILq60vyjMIQ=;
        b=GCRkcDpLiAqMD+MPH7pQgJzcGgBv9/Ek4rKTzViTyQUpvvE6gOfGshW9A57rtgkIQq
         cELN+3gJ9dl8FNtDQ383DIkSvCqpBXuKuGD1379LwRedN3b/szj8ltdKTlJWW+FkrH66
         9vKxPdvxsxpoZVPoSs7NvO80Wn8tAca/8TEo1S+EfdjwbJpHXwOcVnsRH63gdYA1TKGn
         gajH6Dawjj0WxNXT919WTH9ArPzGo3Z1nRxWeHWNanwImva1hGiTi+lYf0yleQzclx/V
         WDqqpnysHx6a57CqBir7qYZpJbAiqDI9QlYPq2AThWi8wS5UMoC0RpLe8Y//KrSnoKYV
         q0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tVhTbpefjH2mb1/KRa2ocFOQ6IGLu65cILq60vyjMIQ=;
        b=bw7sPikBrrctyoppG5vgtsYQloUPTBeByNqpGQCAVwMPV3+ZrC0F9KfYjzk+JreS2X
         hg8BwqKhSYvDP8L55bErwj6ZtkUSj6OnzyXzEqh/Onn3aySUNjlAIC5pNk2zvcqLbgIm
         ho4R9BCp2VP1NQs3kFjELOQAS6E7AwN9+99j+QJ7LNyBbNq5lZ6EEQ4SHvKOs2nbAz3g
         e+CCo4rvVIodXKboopj1IILBQEHZ2XvkLyOGumebDcuMq+6Uivuicj90sQzYRCnzIkD2
         Q9GXWIAwq8tO/d/npss4a9IHDBDDSkZxRR70tX9XnpuAelzsBBszgt1y+gX5jzVwwiwi
         KbwQ==
X-Gm-Message-State: AOAM531jR4ZDI8pUZxTTKtqPDSxvnkEEMM+Y4ha828DtC+sxmV82uaq3
        GVpUYXmm5xBwl8/B6DAsVrdi85O9MJd1cw==
X-Google-Smtp-Source: ABdhPJwSxpFkxVh5NzJQ7gfKWe12HESZrmY7/ek1y/XK+smY5Mv+7lwgmhDMmFerzUSRSiOMMFfCsg==
X-Received: by 2002:a63:1716:: with SMTP id x22mr19145546pgl.261.1618079419642;
        Sat, 10 Apr 2021 11:30:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7sm6010080pgq.16.2021.04.10.11.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 11:30:19 -0700 (PDT)
Message-ID: <6071eebb.1c69fb81.35fed.f590@mx.google.com>
Date:   Sat, 10 Apr 2021 11:30:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.186
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 137 runs, 4 regressions (v4.19.186)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 137 runs, 4 regressions (v4.19.186)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.186/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.186
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      830a059cbba6832c11fefc0894c7ec7a27f75734 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6071b8a5b5adfa6093dac6b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.186/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.186/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071b8a5b5adfa6093dac=
6ba
        failing since 142 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6071b8adf1a9cb635bdac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.186/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.186/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071b8adf1a9cb635bdac=
6b2
        failing since 142 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6071b8bc4b1d8f4410dac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.186/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.186/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071b8bc4b1d8f4410dac=
6b3
        failing since 142 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6071b844ffa57d6b80dac6cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.186/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.186/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071b844ffa57d6b80dac=
6cd
        failing since 142 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
