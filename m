Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A259B339016
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 15:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhCLOc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 09:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhCLOcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 09:32:41 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F6DC061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 06:32:41 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id r16so664593pfh.10
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 06:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ct8YK2S86zi196CBtUFBuJAAZbSHkmBx/7tlo7FNWxA=;
        b=P8fwAt0ShG/xLbQyFfrwbbZWvbFT60CF+Blui9+W2fB8zFhdoS6h7JzYiSLhxrRAKh
         p3QqqE/uwkpLTMMQu56xmlkA+Q5Pg073WGXsVteh7Z19d/z8SBCfkMOHTM0Ztjvx0Ay8
         Hxye46MeozovvnjVwTQKTO6ckP/tbY0LiRK82wTXWxjp8stpcrjCxpO0U/t3VldeSE1j
         S85yxD1UXNhLqcNArPDG3KDR6HNtFYkgyYQPS3Hx8mNuU1pftQeFD3J5pbqYjNWjArqx
         Ypndhje94qy+x2HpndkXi8Ea5hgPZA8FYk2a3WBTsDDS4/zozkkFqRTbdy8ZA8bsRphQ
         QQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ct8YK2S86zi196CBtUFBuJAAZbSHkmBx/7tlo7FNWxA=;
        b=YKySZacbSXQJ7/vYthNAyd8gS25oPp8zN4TePGI8E7CbuoqSmzaeR2iNiGIWGF4fdR
         J831kMZDzPqK00tCPZcCXGz4nuMixsgIH3SYgxLLwf+xvXjha5/hj2SFO/tHFE99MKdQ
         /M7e9RR05eO/Q9onmN5tpQDOc/OEfMwwT/fGG8Dse5bBgtZ6+W+ro9MqgbBeSkC3Pnsb
         BQmw3TeQnzVjFTus4tbzl5pYNNLMuiKRGneD1VtFuR246ta6PQ9ayPC9QCAzAhng/Hsx
         bxzLpgM+EqxdBbNoVpPvx1GTvf7H8YE/6DpFrTuq6eKWXsMtiywGQ3Wq7SAhVH/lKpGJ
         WxXw==
X-Gm-Message-State: AOAM533UOtCa1T4X0XoPt89tzPswcC8QKlr6lme13fcTEUI8D4ms/0o9
        xqZxv0NY3b/btOg5ar6C6g4X8NRT3+U7GA==
X-Google-Smtp-Source: ABdhPJyBm3huJZa8hVJVA4EWD3anD5Ycrw0UlY1Nx1ycy761nmJSz/dGj+qaokTw2I7xN70qZqbsHg==
X-Received: by 2002:a63:411:: with SMTP id 17mr11912339pge.375.1615559561108;
        Fri, 12 Mar 2021 06:32:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m5sm5824474pfd.96.2021.03.12.06.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:32:40 -0800 (PST)
Message-ID: <604b7b88.1c69fb81.d123f.f16e@mx.google.com>
Date:   Fri, 12 Mar 2021 06:32:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.225-14-g8c618edfe216
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 73 runs,
 3 regressions (v4.14.225-14-g8c618edfe216)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 73 runs, 3 regressions (v4.14.225-14-g8c618e=
dfe216)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.225-14-g8c618edfe216/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.225-14-g8c618edfe216
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c618edfe21651df86fa62fa62d12fd6173d40a1 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604b480dbdd8bb2e92addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-14-g8c618edfe216/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-14-g8c618edfe216/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b480dbdd8bb2e92add=
cbb
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604b47e64adf7f4b47addcda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-14-g8c618edfe216/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-14-g8c618edfe216/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b47e64adf7f4b47add=
cdb
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604b47911e67de674daddcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-14-g8c618edfe216/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-14-g8c618edfe216/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b47911e67de674dadd=
cca
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
