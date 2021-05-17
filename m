Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E755386DD9
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 01:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344549AbhEQXm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 19:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbhEQXm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 19:42:56 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B225C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:41:39 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id h7so4064195plt.1
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tbZnsb6//YOFM4pGNL11dSq9GsbPsx7ljmH9IZvLaWQ=;
        b=xIau3YeeMQLLXuYYqSQAFleL746wSWQv/x3AbnZ9CURLQohpPyOCd/A8hrKYzUDJP1
         DHnCepB3IMgfnngQtgLu8ntA/EX7w3of1FsqRB8l/uYUBrmI8EYSdsbIyhjyVXAQgr0L
         7jbxLq/vcHyo7k9sp9fywIxQ2rJ1MN61b7Qn3RHe3yfCp2Ia9Vuo7YuDGjB8DM1iZQid
         0Qtkgjlp/XwLvLKidffSiEsxsR2hvkXa7yJDX6OsyZDPh6tbdSAf1ZE8iRuAnf8/eG42
         aOtHpeSmzyivm2WLBBwL6J+LWa1fylrLOxPmwTuMZHAPKsFiXxqWhDkIxUr0ugLprTRn
         RhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tbZnsb6//YOFM4pGNL11dSq9GsbPsx7ljmH9IZvLaWQ=;
        b=fQEUmm2PvZUG00MfJdvlgFFGSf75YhDl1g7NGJbYeVMPoW5F7rQgHOALSqv4ZdeKdS
         cH8UiIGGGFO4Gri4hIyyO4VufqhDzWbu3/Geyx/ATjIdGr16F3g2UCEnM/LyZsfKvnla
         zqmQ1r30Wi3G9a0M3GYflFrAI0eoo2Deama8ExpvsI9+yar4qNXVQ6u/b9mx48+6gu/P
         bUYsteQJ/P1SBRwVa5UKHTbaw+AfufR/LW63H64S6cTUm35gNVIEo8SVsPfNmGkJwzxB
         vyu3IXW/n3P0uSIvUNxujCztD/yVezWH27KlHxfZf7GXhnUQlN22KIq0Hc4MZbEQ28b0
         O7Jg==
X-Gm-Message-State: AOAM533iAuYBfkexWl+REfQzx1KtrdvhixPqujQbSDhMMdgk3YDiu5dB
        mx5Jg6rmexJSz5dc+S2wOHbJXf9/NtOv/tDm
X-Google-Smtp-Source: ABdhPJzC6V7MWq1+ZFQmvAvI0IUg2IKo6gtemai3Z0H8SvH5yn9bvLSyLVBjrljKIQPl6Za5uqBsHQ==
X-Received: by 2002:a17:902:684f:b029:ef:6725:1ad6 with SMTP id f15-20020a170902684fb02900ef67251ad6mr1093694pln.79.1621294898540;
        Mon, 17 May 2021 16:41:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j7sm10285814pfc.164.2021.05.17.16.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 16:41:38 -0700 (PDT)
Message-ID: <60a2ff32.1c69fb81.5e458.3811@mx.google.com>
Date:   Mon, 17 May 2021 16:41:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-394-g3428025b39e1
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 117 runs,
 3 regressions (v4.19.190-394-g3428025b39e1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 117 runs, 3 regressions (v4.19.190-394-g3428=
025b39e1)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-394-g3428025b39e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-394-g3428025b39e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3428025b39e1d53c4eeaec24e21454d45c6f89cf =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2cc25eb5c2d4cdeb3afa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g3428025b39e1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g3428025b39e1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2cc25eb5c2d4cdeb3a=
fa2
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2cc1ceb5c2d4cdeb3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g3428025b39e1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g3428025b39e1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2cc1ceb5c2d4cdeb3a=
f99
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2cbf68ef1ebd7ebb3afb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g3428025b39e1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g3428025b39e1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2cbf68ef1ebd7ebb3a=
fb8
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
