Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323EA4311E9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 10:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhJRIMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 04:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhJRIMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 04:12:33 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717DAC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 01:10:22 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gn3so6132706pjb.0
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 01:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SxF+nK94374PMfs2fEe7lfBjbsaNUTvWzxncvttHZEE=;
        b=TyapDWXvK65kEX8UX6UBcog76rnj8k7rshT91yvjyta51R+B8VIb4Tg5ij5GY/aGHQ
         kczX432UFN32pkSRKoW2YiI2O9xo07bUHetawOwtvCv3lL586fsd8TLbPbi4ctc+U6Fk
         WRJsqrkCQVPulx8PrZB1EYjjaMMeHisYP1b4iJxzr6dUANcnUI6ttXot0i/fv80HCYgh
         cT9YnYQgrB57stnV9dSkoXAoyzKup2cYZXpV5i9KNgl3/NZoX5ZzVUmRwoKAH0AsJil5
         zwk4IvFFChTXKPLccAE86qzvSLDgckAW1Dwt+zn3zOYvgd5czeJCM6nKMSSlPs3bxWCf
         3pDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SxF+nK94374PMfs2fEe7lfBjbsaNUTvWzxncvttHZEE=;
        b=7x2ZWg4kA44N2dWU/mXhp2Pnsk0M/ZiFHLI0WnZ1pi+SSWlFoB2yKlVIHdndOxcB1D
         4p/oNu2ryqiRP2WdrnFqehdRe77od/JDWkSuLlo/yhizeKMCBFxM7nSIziHhm9A1CeGi
         SMS4vRr0WCUCM5olCjyc/XjloisNwlTesuLreZWIK0ZeGYtb9qYACLiywbDPNi1AUoXw
         rNT0QxoeR6772/zOia1Mzx/6cFS18DBYdasOlTPFPsWxN2avwn990d5E5z0rlhfJbmUZ
         uqcAFGdL592r/AvshZz4NmYtkLLqziK6Cu2prmEDoT4O0wgTe3uFqddEVwK2i5g3Vjx9
         ILZw==
X-Gm-Message-State: AOAM531XIAzlTq4mQBO9qOgW261uRWPkQEJ7CjQApqBFkWhGzmBTdAnn
        9hHUIWCSDb2UVGJo9tfoo49LMM0aj/SHLxlb
X-Google-Smtp-Source: ABdhPJz++fKOye8x5NuQrWpQbCiRC6wumSclHa045uUzMB4QP6vhc2XvliuoMOMlnwpnpx1rRznOrA==
X-Received: by 2002:a17:902:9b8a:b0:13f:c286:a060 with SMTP id y10-20020a1709029b8a00b0013fc286a060mr2690547plp.66.1634544621795;
        Mon, 18 Oct 2021 01:10:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i127sm7849004pgc.40.2021.10.18.01.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 01:10:21 -0700 (PDT)
Message-ID: <616d2bed.1c69fb81.6f582.4208@mx.google.com>
Date:   Mon, 18 Oct 2021 01:10:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.211-24-ga4e9886b9c29
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 51 runs,
 3 regressions (v4.19.211-24-ga4e9886b9c29)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 51 runs, 3 regressions (v4.19.211-24-ga4e9=
886b9c29)

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
nel/v4.19.211-24-ga4e9886b9c29/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.211-24-ga4e9886b9c29
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a4e9886b9c29dcd9ef76992221421b54632ba36e =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616cedb15b111a7cb63358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-24-ga4e9886b9c29/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-24-ga4e9886b9c29/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616cedb15b111a7cb6335=
8e9
        failing since 333 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616d005488bc6a745f3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-24-ga4e9886b9c29/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-24-ga4e9886b9c29/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d005488bc6a745f335=
8dd
        failing since 333 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616ceda50869852fa2335916

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-24-ga4e9886b9c29/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-24-ga4e9886b9c29/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616ceda50869852fa2335=
917
        failing since 333 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
