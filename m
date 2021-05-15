Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132293816F8
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 10:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhEOIo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 04:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhEOIo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 04:44:58 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFBFC06174A
        for <stable@vger.kernel.org>; Sat, 15 May 2021 01:43:46 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so982481pjv.1
        for <stable@vger.kernel.org>; Sat, 15 May 2021 01:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kbnCzI7r0EcpMDeMXEHvd8w5EwI6S2FKMOLDgBa9WoQ=;
        b=zYZWzL7Uvm7C28thTxMSDfB2r0BlH7l+AExv1Q8OPYLKphiIYVNg5C2Ca25eaakOc4
         kxBjIHZkDPaZIE0LufegooF5iwVz5bu48ttEvAk/pX5C9lE6E2jtbSOlaiRMMJ6qSK71
         KxCI12tSuKCpTuFaUlUd2yG0pyvx/UCdk4dyle5cay7b2JUUEI+C2zuOx8G7ccFuGDYB
         87ewFe1GwexBY0TXHe9o5ty0N1ye5gUk0lrzfyARo0Q3xiY+cSVOOrC9VBCnLtVtKbEB
         V1EetQRK5yvsEB03mzIdxe1PCMr5Dpfr2BXkH+MThlzw4OhMfMBZxfTV2ZzUTchU1VbL
         6dnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kbnCzI7r0EcpMDeMXEHvd8w5EwI6S2FKMOLDgBa9WoQ=;
        b=ckd4Ujs3v1iDYKx5jI3I3EzsHVOPprjMZXpfV2vKUn9RQkxpmJXt6ECozezEfEPxZ5
         jZhtLKeeRIETbqc5thHV1U/jCXvonMrWC0OkAyjqrgtJNlqygESOu+g852xf2goT9jBA
         Y69GHmfEKLSABUIOU10Qqn0MZEnEzVqj+8AAtzrxA/QWn1OlfGTVVQTJO+GocxLxlFxl
         GB8q9cPB5MUDTMsnWUw8+HLeT2nGMvS2D7PbcHry/VjDeJxfrggD0BENhsAUR+cJUXUD
         Lzg87IJSJfzpzdaJUSW3CZ4F7h9iryEJtrX/UcGZYWxg2VSmSzqKAkbEMNmXCSxY0XJ6
         NQDw==
X-Gm-Message-State: AOAM533FNd14runYJnBGiyvwLPpfJoyPRZOjRkkvPq9Yp+8gTwki6zyP
        rgX6/riC65ExLDVQ1pMXughUuk4MCLBWnQtU
X-Google-Smtp-Source: ABdhPJxWKsga4NswliDAMb9Cum9o/TbEbj/Rz4TtFMob3cNQRnWB3MsjbZLvXQ/jR1I3s1qQAlSL7Q==
X-Received: by 2002:a17:902:e752:b029:ed:8636:c525 with SMTP id p18-20020a170902e752b02900ed8636c525mr49690934plf.60.1621068225499;
        Sat, 15 May 2021 01:43:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a16sm5614090pfc.37.2021.05.15.01.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 01:43:45 -0700 (PDT)
Message-ID: <609f89c1.1c69fb81.76950.3c9c@mx.google.com>
Date:   Sat, 15 May 2021 01:43:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-362-g9c3a5f70349d
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 113 runs,
 4 regressions (v4.19.190-362-g9c3a5f70349d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 113 runs, 4 regressions (v4.19.190-362-g9c3a=
5f70349d)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-362-g9c3a5f70349d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-362-g9c3a5f70349d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9c3a5f70349de1f52dfd5787a015a5c058a0af8e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f55f00f63d0b4f0b3afd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-362-g9c3a5f70349d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-362-g9c3a5f70349d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f55f00f63d0b4f0b3a=
fd9
        failing since 182 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f55df17a099ae0fb3afb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-362-g9c3a5f70349d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-362-g9c3a5f70349d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f55df17a099ae0fb3a=
fb5
        failing since 182 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f56111e880ac46bb3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-362-g9c3a5f70349d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-362-g9c3a5f70349d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f56111e880ac46bb3a=
fa1
        failing since 182 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f55892741c899b6b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-362-g9c3a5f70349d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-362-g9c3a5f70349d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f55892741c899b6b3a=
f98
        failing since 182 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
