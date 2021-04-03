Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0654535344E
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 16:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhDCOYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 10:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhDCOYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 10:24:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57485C0613E6
        for <stable@vger.kernel.org>; Sat,  3 Apr 2021 07:23:57 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h3so546502pfr.12
        for <stable@vger.kernel.org>; Sat, 03 Apr 2021 07:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AQASgs1vsEH74EEAOrvyGkYaCa1KeccR6DAGcHJZ8aY=;
        b=JpVO+GlSKd+ByJivrqq8/4KXEgFX9z6mMKAaf8kkjomU4a+LEI059YxYK3RoOQ6diA
         apKdzFLCXOtIY9amj6s/pQa7p5b/l5mCv2QOW+GQFfYsPS+jPBI6zMdgRAtqL00dYuCP
         Q4dXfIb4weiuNYPnWQyGtG8p8G4SEwTrOE0U8vKJhcqgtOqoep5485uedguKDYC1aDj8
         igeDiOwmw4F+kFOaxDi63vDGHUUIkATaEtCfNOrw0DdyEOw5O85QDGPVfm9tr+H4v3+H
         ZI50B5dqM5bJzYF07nTkfyawzkPk1DfKyPjcnUoec4B3PzARZfAz7XZiNPBC9B/UBlLa
         dBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AQASgs1vsEH74EEAOrvyGkYaCa1KeccR6DAGcHJZ8aY=;
        b=pFOWhBB0ciZfYnKCePWxX6vYV0F89MbM4YTxcCRaeqddOcc8OOfHbOrmyvTJyfL1MP
         BNLVsVjZwS1vWf6aHPDnWNF/nNwGI62HAtJMkKZlrKlXhtvay/no/tRqyIYWhTuwVhtt
         mXnuschncXcWA4ffmdUH2OdmrX1ijdsyDXwWj6z0pMHBziSWh0/PlQQrNgNMDQ3XLZDp
         IdCDNLQH4SG3zukik23I8YyYAGYnvwBjSb+Ovyx/0j03YbTnu5ArIupirBEWU6m8sYCW
         Fatnh7L3HUozylJtijOZuirXSK5HSzpImUm4KCjM1Ufunu4RWjOFYwsUFEhjFvjJUw9K
         JQPQ==
X-Gm-Message-State: AOAM531fnZeYoYfJdm28II598IN7/P+ecGH8ypmqMyHGuN8wCqmHtJPT
        JCGobmUGLI5FtSziWpLW+l9GAWfxCfMS4laX
X-Google-Smtp-Source: ABdhPJxocPF5zNbZ6DQ1FxNslXSTXmFzYNlKBABfyOqeb4C8Y9SCIxHVwrIDTmZuG5NaxkzepWDoaQ==
X-Received: by 2002:a63:6982:: with SMTP id e124mr16233598pgc.46.1617459836773;
        Sat, 03 Apr 2021 07:23:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5sm10825061pfk.219.2021.04.03.07.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 07:23:56 -0700 (PDT)
Message-ID: <60687a7c.1c69fb81.fe24d.ada0@mx.google.com>
Date:   Sat, 03 Apr 2021 07:23:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.228-36-g9f3ce13352b5e
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 97 runs,
 4 regressions (v4.14.228-36-g9f3ce13352b5e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 97 runs, 4 regressions (v4.14.228-36-g9f3ce1=
3352b5e)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.228-36-g9f3ce13352b5e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.228-36-g9f3ce13352b5e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f3ce13352b5ea5a53c4c26ad3509a6e42f54e4d =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60683f8cfb4cb2bd74dac6e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-36-g9f3ce13352b5e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-36-g9f3ce13352b5e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60683f8cfb4cb2bd74dac=
6e2
        failing since 140 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60683f91418244a7e9dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-36-g9f3ce13352b5e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-36-g9f3ce13352b5e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60683f91418244a7e9dac=
6b2
        failing since 140 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6068724667520a23b1dac6b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-36-g9f3ce13352b5e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-36-g9f3ce13352b5e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6068724667520a23b1dac=
6b5
        failing since 140 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60683f44590d4a15e6dac6b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-36-g9f3ce13352b5e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-36-g9f3ce13352b5e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60683f44590d4a15e6dac=
6ba
        failing since 140 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
