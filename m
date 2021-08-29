Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903DB3FAB73
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 14:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhH2MhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 08:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbhH2MhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 08:37:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A29FC061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 05:36:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so4984669pjc.3
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 05:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g7ROuNoneQRc6XwLvls0PO26bvOpo0FJ8Jds4Kjq21w=;
        b=wXoNgnc6EH4V0lNUPIuTpsFNPxM+zhxzTBzZiFbwDhhEDEioL0uO/vA0iqdEyyp5/Q
         yHZ6ah/vouK71GtKCkacsTb0JtmRI2AQMkcuxKCEdwi+yVHr0hK9G7E1xBIVE41dQwV9
         pKULrdodStcCqaySzEKnz5+050JB0B6QAiXmRZn7JsK5CENh9IfZPrixS8OHPt0+wDwL
         kwtbF6NkROPHLcwzBcBLHnTpYHpkAYNd+WleSprYfQMgrPUFVpsAHFOh+gEq2l+SR/9g
         aBR83R1og1oIKdUBfpyFS0spcmAA2x5CjcBugzq9BvWzt8AutUUWhyrdfe1sfFytzeHF
         QrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g7ROuNoneQRc6XwLvls0PO26bvOpo0FJ8Jds4Kjq21w=;
        b=EoKjp3QzHfJS8t9mB0n+yj5bsnY1GO95adQQvm4IKDY6i7NOkBPQFk8r/FQy5Kvs14
         9j8ov0UJ07PxsiyH/DBIXKNZKPM+LvG98PWCpUUMS1CucwSNwqxGqhpgXbM373jSoPUc
         xNrl6hquhk/l3+0wr4OcTC2Sy47FmYP7hcYevLSC6l8QOF8SnaTNW2CMXQiL34OwPFfx
         ILc74wo32OjCwc4dzayrrNqJ8rVgjf/Zk/gxSF0Gs5PaMsAcVAZh1pcgvV3qM8GFhSHG
         XdlL3xTCsM5s23Bp/oXl7PA+6bFn8da6l834Zc+o+sFnyxlc0E1kCTbrfuViyJN6m1vf
         MZ2w==
X-Gm-Message-State: AOAM531ufbfBPwK75LKK9OJiXL8aySlmlNFpI2kAJEsATORVAFiDyz3/
        GdGHklQBCditVUS1oMgks4C+9qzIsRozdcjb
X-Google-Smtp-Source: ABdhPJwIww3jqAro06XWwsa1xmNPAWvFiS4li/PKx1tri0nBUGjs3DUmFj/8frcdu6gO+60cxeAuAA==
X-Received: by 2002:a17:90b:2348:: with SMTP id ms8mr21486690pjb.121.1630240584909;
        Sun, 29 Aug 2021 05:36:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u5sm11340792pjn.26.2021.08.29.05.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 05:36:24 -0700 (PDT)
Message-ID: <612b7f48.1c69fb81.4c2ee.d445@mx.google.com>
Date:   Sun, 29 Aug 2021 05:36:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.281-5-g010bf96cf3a4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 127 runs,
 4 regressions (v4.9.281-5-g010bf96cf3a4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 127 runs, 4 regressions (v4.9.281-5-g010bf96c=
f3a4)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.281-5-g010bf96cf3a4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.281-5-g010bf96cf3a4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      010bf96cf3a47ff276430521a262fb3323bfa49b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612b4d87c4d9844f318e2ca6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-5=
-g010bf96cf3a4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-5=
-g010bf96cf3a4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b4d87c4d9844f318e2=
ca7
        failing since 288 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612b56362dad0136158e2c7e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-5=
-g010bf96cf3a4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-5=
-g010bf96cf3a4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b56362dad0136158e2=
c7f
        failing since 288 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612b50215343a71a458e2c7d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-5=
-g010bf96cf3a4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-5=
-g010bf96cf3a4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b50215343a71a458e2=
c7e
        failing since 288 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612b4c5bb32f08d0d88e2c8e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-5=
-g010bf96cf3a4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-5=
-g010bf96cf3a4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b4c5bb32f08d0d88e2=
c8f
        failing since 288 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
