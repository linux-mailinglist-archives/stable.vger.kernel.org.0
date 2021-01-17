Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FE02F956D
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 22:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbhAQVVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 16:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728859AbhAQVVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 16:21:39 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED57C061574
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 13:20:58 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id x20so3045375pjh.3
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 13:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XcdJmAUczVO6qrC9xmFadncYNz9u085m6hEPCWgkBYw=;
        b=bqaexFw9/n7OeddnEBEMIF8fwNTUO5qNlUDv/PtFLBSOrclz05L+Hxni4me6WEb7Go
         0c/Z45xu0K4OOrseSqmgkGmsFIG38WRqbmfLqT4L37UngN12Be2VP9Nb6dgmSlCJnc6R
         uRhvoA6zOcFpgWAIuFyOF9NlOApNwEePwHv0s+AqOt5OMFTYg23wR4z6RbPaPVGGK6vQ
         U1M+EUSFPSFUiyumfnEaYDA+vKyLHAGEUjBNk505j3sGHeq5EgdyR6UlgHJwwWMiYGvB
         +KyCq2hS1h/kQKgrgjp8KgMsubUDr1CRKdF01kD7DCwYHcOyQ39mLHBZGm86PPL5j9vt
         6ebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XcdJmAUczVO6qrC9xmFadncYNz9u085m6hEPCWgkBYw=;
        b=KTNtwS1Pt0+B13dnyoyLaPcXUKBIbWv93uKbkHISJg4mAjnCUP3ELdORj8+5xBFf3+
         Myy/SoxLV/ZgKnz8iJvuyTw+etLWvj8gVCahjF4qN+pru3j1h36Ci0MWP7OvznfgGhgW
         Si7Gbentn8oK/SvGzZPdpdsHWpi5SEEz0hjtlcErAmfkblhSm3FcL13YeH54DZwqib1H
         PlpC//+8sbFvuGoIggdwTfsOrxqglh8CUBKW5GdImdCvPex4LQ/ruwExSTcydgEA+1nX
         juUB7M6+NU+ASwFPBzUgjKAo6x2KESiX8qHLXs3O2qjVh4hBeMBr84LwuAK28ljnu0GQ
         yjKA==
X-Gm-Message-State: AOAM531mjo1MskhDaJ29tuFfI3dajjEdjLznFwjQvWXmgrgK1/cOWzo3
        Pgh7AF12AUu4fTtur/594deI68DhB/HBAQ==
X-Google-Smtp-Source: ABdhPJyFf9Xp1Moru3gYuaACd/rLthssQj8+uoltfMxii2esc3zEc2sLeX0h+peQ065uUnGfTkWumg==
X-Received: by 2002:a17:90a:bd12:: with SMTP id y18mr22990371pjr.146.1610918458116;
        Sun, 17 Jan 2021 13:20:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l197sm14169312pfd.97.2021.01.17.13.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 13:20:57 -0800 (PST)
Message-ID: <6004aa39.1c69fb81.ad106.327b@mx.google.com>
Date:   Sun, 17 Jan 2021 13:20:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.90-24-g72a35fa7230d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 174 runs,
 5 regressions (v5.4.90-24-g72a35fa7230d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 174 runs, 5 regressions (v5.4.90-24-g72a35fa7=
230d)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.90-24-g72a35fa7230d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.90-24-g72a35fa7230d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      72a35fa7230d8a7442a0bd93e4ddfd9c9d12def5 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60047004c9b6e9aeb8c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-24=
-g72a35fa7230d/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-24=
-g72a35fa7230d/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60047004c9b6e9aeb8c94=
cc4
        failing since 58 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004710d93b65091fdc94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-24=
-g72a35fa7230d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-24=
-g72a35fa7230d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004710d93b65091fdc94=
cd7
        failing since 64 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004719978d6c5e3a0c94cfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-24=
-g72a35fa7230d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-24=
-g72a35fa7230d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004719978d6c5e3a0c94=
cfb
        failing since 64 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60047141d38f68dde5c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-24=
-g72a35fa7230d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-24=
-g72a35fa7230d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60047141d38f68dde5c94=
cbe
        failing since 64 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600471e7ffb1c4a52fc94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-24=
-g72a35fa7230d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-24=
-g72a35fa7230d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600471e7ffb1c4a52fc94=
cd2
        failing since 64 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
