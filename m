Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB343F93F4
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 07:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhH0FN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 01:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhH0FN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 01:13:56 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821E6C061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 22:13:08 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso4000610pjq.4
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 22:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TJ6Ibua5OjqHkZHL5b+REPcXTeIV67eyeuTLln+lbGo=;
        b=nj89HSvg9I80ZLae2QC1XbhcaN1JRZcSxG6PqZddGyvxNAbdjUwSHsPKjYhZNuEpNW
         Q1zyCNl2vY9ilwc6pMH0k+nucjXcfHOGa4RlLcI9g8nKiJtzpZ3JceOy1lk/BqDtyHqI
         pZ1XVRbKopRuZR6KnXSDLlfNjlnmyi2DUeit0dNCuxwfNGViFx7Uol5doN3I6KsiNw1W
         KH++Mn5KG38NmDVuU1+0FaGikyB8MKN8tecx81NXGXTXOSBlL4Abd2gw0ClP4zj6UM2z
         bIK1CQVjW08u4YPTm36hvuEHGKDn1tBc6r1z+5vwJtz2CrOAdn34plAhLBGEDb5+8hWQ
         jH6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TJ6Ibua5OjqHkZHL5b+REPcXTeIV67eyeuTLln+lbGo=;
        b=Nr14EDFNDt3iKZa3Jh0QldAX0WUQhDgz6IxRL73OKaASGdNVAxmQf0nTwhESINrY/8
         1RyC9N+MXQqh76zM8MEpMTYfC31aJGTy82ifEr3QTWlBXyPpzIPG7ycLvEJYWmcyIGXH
         eaNcM+NLAe/rPx24V88Ss2iGQA+TJrm6S1gB8nvnMdFw6uGdwGlVrDHJRbDvpiIXrswL
         NUu9iyg1UHVj/exhsnwccX60s0yFM2wSZ/cggz9L/GdQiuvxLBsBOwDR2UeLlbl5dLDw
         VW1GPXro9jJZgOQSYKUcEtcN2EvivfNrC572r3r7DESd57nx7UJqNUhSOQVMyGIMuBCs
         6yyw==
X-Gm-Message-State: AOAM530jAd52Uf2airfGRlejIAEgB2149aSeSASW83oEreBjHWgMcxz/
        IY5mRn0kzZ6jFj/GrQ+FVJwYNNL1JX184h5v
X-Google-Smtp-Source: ABdhPJx+P1F7lNhfKUjtDEPMBUW2QkYm0y2CYXge4agtvc8EjsoK3ucNtRelSIqYsP2UwyhpJEH8LQ==
X-Received: by 2002:a17:902:dacd:b029:12d:7444:7f87 with SMTP id q13-20020a170902dacdb029012d74447f87mr6802996plx.77.1630041187735;
        Thu, 26 Aug 2021 22:13:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13sm4872068pfr.72.2021.08.26.22.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 22:13:07 -0700 (PDT)
Message-ID: <61287463.1c69fb81.84aa1.dec7@mx.google.com>
Date:   Thu, 26 Aug 2021 22:13:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.245
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 88 runs, 3 regressions (v4.14.245)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 88 runs, 3 regressions (v4.14.245)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.245/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.245
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      35c4ba160ab6133e548468bd0bd1109990dc7736 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/612844ff2c1409af6f8e2c87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612844ff2c1409af6f8e2=
c88
        failing since 513 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61284679459d1011b08e2c7f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61284679459d1011b08e2=
c80
        failing since 285 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61283f37533967a5db8e2cae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61283f37533967a5db8e2=
caf
        failing since 285 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
