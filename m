Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D27544FBD5
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 22:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbhKNVdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 16:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236389AbhKNVdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Nov 2021 16:33:16 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD7BC061766
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 13:30:22 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id o4so13242748pfp.13
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 13:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C+ILvLA2NgorPMcwLV8tAbRx4am2b1WAbVKI0D/w21Y=;
        b=N6sm17QQIE8L60P5N31weKXhPCeZ4jTB6s3EvilIJKcZ1TwXP79X+DuYa08CzBDclZ
         3itWXfm4L8L6zNJ/KBXyQqEqGn6KDUdGNcgCOt0Y3/CaaiDNONyRSRJwEf3s1fON0nhY
         omRjYc2kjI3fUarj4N7sg8/QXQ+W4AKGQ6V40p45HEDrcBK4Opm+gspxORXNaG/qxjlb
         fcaD7wvmIotmMjwabSJWgHt74R9DV+AxfvtjY6mRLfNEk4Nc5Qe1rc2qgPYtSFBW2RJG
         wT47SiFfybBIxH++wMfnX+BYqr6tp2iVVhzGgnpSS76p6UB/UwTXtN0Nt95Z3qOTxlWI
         9Nwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C+ILvLA2NgorPMcwLV8tAbRx4am2b1WAbVKI0D/w21Y=;
        b=DYV5M6OExux5D1p2NCOdd+7GzQtjH51hT7xMvd5jLn7KaelTBTas8VtMLQXUl2YHxP
         7Qs4+LuEf9u23K7eHPFRXR5BOxaUyueMksTJgn7tvHI/Q6qaMu2VOlGCah8KAzQqx60x
         l2Ax4QJYvDSBxe97EGl3UK9TwUJYjpZnftz0nNy4aGzGrPcakSWPD9OHRplEMaeh/pJw
         LVhd9ppuicBXKcBB+uIhNE+LhBmO1UUxBaVRzNebS9AtlFZlCB9K6uKPKUBOecueX3d3
         mMK9LZSOwkOHnmHkv1D92+TBlf74eN23rno40xI2khbDogeUQapGfyLjCaZRuMRWutGP
         UOaA==
X-Gm-Message-State: AOAM5300JWmYoXQUOy1Dnv+nffNwv6c/9RnIYglT2bdktuD1uB4n9NQD
        z350orInGAshKZrLIatdv9wbhN4drA7UARFn
X-Google-Smtp-Source: ABdhPJz3MP8J3lwqMww36ofsoV6EExXehe7IXBO9+1m8UyCidd5sS41t2U3zQe/HPM05R3DIqZroAQ==
X-Received: by 2002:aa7:811a:0:b0:44c:b9ef:f618 with SMTP id b26-20020aa7811a000000b0044cb9eff618mr29210723pfi.9.1636925421695;
        Sun, 14 Nov 2021 13:30:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11sm10437116pjl.20.2021.11.14.13.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 13:30:21 -0800 (PST)
Message-ID: <61917fed.1c69fb81.3abbe.e7e5@mx.google.com>
Date:   Sun, 14 Nov 2021 13:30:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-56-g5c0fdc0dbedd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 1 regressions (v4.9.290-56-g5c0fdc0dbedd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 1 regressions (v4.9.290-56-g5c0fdc0=
dbedd)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-56-g5c0fdc0dbedd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-56-g5c0fdc0dbedd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c0fdc0dbedd6b7a6d893af309f99c3d5b87ae61 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6191469b6c5b39de683358e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-5=
6-g5c0fdc0dbedd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-5=
6-g5c0fdc0dbedd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6191469b6c5b39de68335=
8e3
        new failure (last pass: v4.9.290-48-g92f20f391c5f) =

 =20
