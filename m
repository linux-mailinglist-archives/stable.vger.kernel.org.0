Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2D322A918
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 08:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgGWGr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 02:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGWGr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 02:47:29 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D7BC0619DC
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 23:47:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f16so2606287pjt.0
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 23:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J4IYmozTyRf/KfUmKqc37z4AEOvUbhrfaouLFdX9Mbc=;
        b=t1xK+b8Xm+WoAJV83a56phq7SH/zfKzlLle4TXpeBiuv5u2zG0jMYkU/ifckkABRKR
         VE6hwlwdQDwr9vYF/NletMBGv96l7zahTVu7bUtfQ213d4/kuGx/53fzGmM5axC4hWQd
         0VEe34AzPMuU3pL6OsPOZh4hOQX4Q0Ae83RUNvqBPKt5aNlDV3y4J8R+lldQRl1zi2RM
         8LBc9MAwqyLFdH/8fDsIuZTw5N25o1kUjtU6o6siiMeYNqXEbsOwS8WDSXral+FZlEko
         C5eQ9rfRdjbHu8+uzRvJ0NpshBQmmA4RsiHhgjoZcz1h7V/aUUdqkNn94r9Nzqp8Su5H
         nlJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J4IYmozTyRf/KfUmKqc37z4AEOvUbhrfaouLFdX9Mbc=;
        b=hTc1kObdAc8ne9WMHw8lwCin+PvK+/yEOsKrK2ZjvqP4hNnFmS+CZNI8QCoulhxwlA
         81EUBXlF+peFOXSYI0DM63CAy0Wu5aggaLME4uccmnw18HdGKPveMi95hzFmeUykBGfT
         U7dcJIKA5bN3ZJ5FEN7JJb7gsFaHwa5ziZzEP5REVA0E34wU++nX4rEmitxyg+wkB/wn
         X/4JENrDnnIDpz2H5tKIUP+vbQxvP+Uf7swfzFonNvTbZvOj/Yrx0Fw9ZY/0nRHn0OQH
         BotNoCh/aWHF23jQzOrUTUhpFuvomKopP4PSOko8YY31qfWpIZI8OEdJL8ucH55hd+WB
         I1uA==
X-Gm-Message-State: AOAM533Mg0hiXR1s/Okgxm09BYWaXxZ3LgF+3kgtobGA4HgnLHYp9qiZ
        EF8SV10AJGyxXzsMOpviKV0BwZuYiTw=
X-Google-Smtp-Source: ABdhPJwi5F0E2KQohK8OtR4QVNfE9OXZkbCUNAUOiE3t6DhkWKFeqwNvX8jvFU8hCNFwid52XGiWQw==
X-Received: by 2002:a17:90a:ebc7:: with SMTP id cf7mr2846727pjb.207.1595486848504;
        Wed, 22 Jul 2020 23:47:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k189sm1785344pfd.175.2020.07.22.23.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 23:47:27 -0700 (PDT)
Message-ID: <5f19327f.1c69fb81.526c6.5b11@mx.google.com>
Date:   Wed, 22 Jul 2020 23:47:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.53
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 192 runs, 3 regressions (v5.4.53)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 192 runs, 3 regressions (v5.4.53)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
 | results
----------------------+-------+--------------+----------+------------------=
-+--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
 | 0/1    =

bcm2837-rpi-3-b       | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig=
 | 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
 | 4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.53/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.53
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d811d29517d1ea05bc159579231652d3ca1c2a01 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
 | results
----------------------+-------+--------------+----------+------------------=
-+--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f18fb7fa3e44abef185bb25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.53/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.53/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f18fb7fa3e44abef185b=
b26
      failing since 35 days (last pass: v5.4.46, first fail: v5.4.47) =



platform              | arch  | lab          | compiler | defconfig        =
 | results
----------------------+-------+--------------+----------+------------------=
-+--------
bcm2837-rpi-3-b       | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f18fa58bf3a4f5aed85bb47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.53/arm=
/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.53/arm=
/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f18fa58bf3a4f5aed85b=
b48
      new failure (last pass: v5.4.52) =



platform              | arch  | lab          | compiler | defconfig        =
 | results
----------------------+-------+--------------+----------+------------------=
-+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
 | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f18fa6b0abfa0a0c585bb4e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.53/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.53/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f18fa6b0abfa0a0=
c585bb51
      failing since 21 days (last pass: v5.4.49, first fail: v5.4.50)
      1 lines =20
