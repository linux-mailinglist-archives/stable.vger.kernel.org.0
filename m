Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5773D3D994B
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 01:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhG1XNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 19:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhG1XNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 19:13:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010AFC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:13:41 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mt6so7530179pjb.1
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VDw6cRY5inVWSrZ0YJscRgXXuiQRRJFNwzTknLoX4Q4=;
        b=E4oUx/Uh7ELmajOZrAvQhd4qUw5h9suoMmokTbXWg9tThTrS4hJ7q/FX3cvupqCNgC
         Efe5RSCfE+qf7t00iwAPJzQ77mb25t9XqzUifyim+Ds7nAy/FKQFSw4IOce19XuwGvZw
         5Nxd8cfC15HDpDjBE0DDzyMCBd6gxQLRY4TbX32LXOKNSs9rT9VPnpadxagBDD/SQ26M
         MLLledCHiZCtFWIeRwzeBnPWFY+i59uyf2UitIK3dXpQaalDB/kol8DF1U7LzTq70qAf
         aOP3cUU7sF3QYSAU4meHze7ngdV3WCDfienD6hzzNyyOq0y8YRhp7MmpYEXjMDK1h1H9
         TLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VDw6cRY5inVWSrZ0YJscRgXXuiQRRJFNwzTknLoX4Q4=;
        b=s2THl1arw7C5zt326LYE5j+m3qsJoz4CrYOSHtZvqFRX2BQWi7FobOwRWqGEXtujoE
         8LU69OH+78UebBqBXkA+2RJENSdlS+HndxoV79NJRfPkvc64hTpb2S0MXELWy5pJGAvm
         kjAoeQ8BgUjj19KwkssN7mkPYxxU7n8WAOBGmbHOQJ5OX5EYASJInjyJEVS6DHM2cImT
         +7rUEmThruI1Q4q/uMas6W/sstfQ4qTbex0R6CORAPNw7CRTk8uq/FT7MR+o9mclRUNp
         8ACj/8hwB3Z8f2RC9E2cGd4Pou8SaTAwo+JQVPLd+fY48JNm1fbK/Nxo1EycadF8foVO
         3ifw==
X-Gm-Message-State: AOAM533CW0kG73tRtQG81ER8DjXa7EQ44ORTjGGo0ix5WrsbOIF/OhDr
        WCGx7lxrvEdvUX6gZCuN8iDZo4Ix9TlnxHLc
X-Google-Smtp-Source: ABdhPJz05PPL84YYAOPaSVU5FpzSUCr1Bjl9D70gjimx6kFN1EGedrjlX3VIUAFFs/FxAWGi4Br8eg==
X-Received: by 2002:a17:902:b10f:b029:12b:c1d9:1ed2 with SMTP id q15-20020a170902b10fb029012bc1d91ed2mr1810274plr.85.1627514020372;
        Wed, 28 Jul 2021 16:13:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k20sm7242881pji.3.2021.07.28.16.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 16:13:40 -0700 (PDT)
Message-ID: <6101e4a4.1c69fb81.0efe.7923@mx.google.com>
Date:   Wed, 28 Jul 2021 16:13:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.199
Subject: stable-rc/linux-4.19.y baseline: 135 runs, 3 regressions (v4.19.199)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 135 runs, 3 regressions (v4.19.199)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.199/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.199
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a89b48fe9308d976d9dcb2112e264d647f7efce4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6101b2fc5cd4e817995018c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101b2fc5cd4e81799501=
8c6
        failing since 252 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6101b2f6c827d989d75018d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101b2f6c827d989d7501=
8d1
        failing since 252 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6101b7b4ca7d059fde5018db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101b7b4ca7d059fde501=
8dc
        failing since 252 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
