Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DACD3A86BD
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 18:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhFOQpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 12:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhFOQpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 12:45:09 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11965C061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 09:43:04 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h12-20020a17090aa88cb029016400fd8ad8so2595847pjq.3
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 09:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AbicjB1qkI9vpJDvVns28T4FmG/37FcUZSFncPkAvmk=;
        b=cLNOBwKRLXyeH4NroUwpVK1EYigjOJNB+89eZRfGpXLBC7XAVCMozD5p0G2SqDJrOk
         j1Io/C2LlBhva1T9CRReZDOI3onCweeCtBbY63sTLvJHDnhGzXvXrxEmm0fRzpPjJzR6
         sfkDH82VkaEpOmgkrd924+5wpfnP7sqP/e3lI6zFLhuXaj8vlXZ4QnBiHd48HBlH3yQh
         AKsVrAeW7Oi+PEeHaXd9PdWzlrWNTz9BhV0zoTE7nLZBj5UpxoGukY//f1w7RDhNYLoh
         iOPQ7zDC0VDUrdFQMOhPhYwOJeJTsmGp6ZV0QmC94pEZoKBnD+vwiibDib2cJvfixJEv
         5+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AbicjB1qkI9vpJDvVns28T4FmG/37FcUZSFncPkAvmk=;
        b=iPBO1Vy7VkEjy6tdCh5qa7zG044N17nwDr/ch1ugNXmmtlhlj4i7lHu8cTuA7eIb8Q
         iHiygphzBzJhD6Da1WswLAlOZpXbF3hQRtoWWdkP813RNMwSAQAmxmjLbh9OOoKZXaz5
         0Y4qCO+qgmcERhpx25vBfxDiGM9w7Cz3M14F10AqoqLrF5BhN1bYQ30+TVkkxxSkWeNE
         oaKxNC0WPSUcLwKZLnA5nnVoYfzt5nLdF1jFDvwdJc83EroheP9QCgUVQtS5RRPTnbvC
         4uDUqrPh6oVDpPFlvpoFGjB/xXO/50gBrmQeU9l4lzYVBcJD8Zh5XYXRkk33/6WRh1e6
         0jjg==
X-Gm-Message-State: AOAM533PGV7/cy1KUF6Pcj/3r2rBinqy3kEOp83zBermfkNH8nXs6FuZ
        R3tesblpqnnzTNyYEYarBzFDHtVKe6+6VQ==
X-Google-Smtp-Source: ABdhPJyt/X5yGFQZK/5uZHJxgona9XJQrIR8YjgfbwyFQvAzy3EtHu0QguWJF1s6HwT6M7WpamySdQ==
X-Received: by 2002:a17:902:8d97:b029:113:d891:2ea0 with SMTP id v23-20020a1709028d97b0290113d8912ea0mr5170576plo.61.1623775383206;
        Tue, 15 Jun 2021 09:43:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y39sm15269062pfa.119.2021.06.15.09.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 09:43:02 -0700 (PDT)
Message-ID: <60c8d896.1c69fb81.a689e.b3ec@mx.google.com>
Date:   Tue, 15 Jun 2021 09:43:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.194-66-gfa36e08ba9f2
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 152 runs,
 5 regressions (v4.19.194-66-gfa36e08ba9f2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 152 runs, 5 regressions (v4.19.194-66-gfa36e=
08ba9f2)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.194-66-gfa36e08ba9f2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.194-66-gfa36e08ba9f2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa36e08ba9f23afa6d6fb174495f29e95b9f29c0 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8a4afa06026b8b0413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-66-gfa36e08ba9f2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-66-gfa36e08ba9f2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8a4afa06026b8b0413=
267
        failing since 213 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8a4d02d6b021d7d41326e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-66-gfa36e08ba9f2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-66-gfa36e08ba9f2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8a4d02d6b021d7d413=
26f
        failing since 213 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8a4b4a06026b8b041326e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-66-gfa36e08ba9f2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-66-gfa36e08ba9f2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8a4b4a06026b8b0413=
26f
        failing since 213 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8ab16b306ee529e41328c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-66-gfa36e08ba9f2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-66-gfa36e08ba9f2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8ab16b306ee529e413=
28d
        failing since 213 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8a5b1c524492fb3413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-66-gfa36e08ba9f2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-66-gfa36e08ba9f2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8a5b1c524492fb3413=
267
        failing since 213 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
