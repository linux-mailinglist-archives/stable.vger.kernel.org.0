Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C93932FDA9
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 23:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhCFV7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 16:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhCFV7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 16:59:19 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F29EC06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 13:59:08 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u18so3098922plc.12
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 13:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bzeM2rCXJGX1MjN/dDpgaNx5WIgmLfPZLdzsc0sB/uc=;
        b=LzKpJ9A5GYOtUn4wWrCc0he+6/2RO5pMWw70Be5O3KOkSGHKL2KRg9kRlRo1GHzSfv
         JS/v6XDVMVxBY9Lx5ezV9E5K5pW6ZvynqTrYxFcsZcuBQxlo3mjfbX/46n5+iS6MU8Br
         w8m0wF1hjvP9L/MH751lJeG/cG2pKvcIOPQZBQyVcIUWAuD9bEzirSiJ3De6syeCJQRo
         Rzu9qnj8jnH7665xvUpKAdqTOEumy7dbDuVZQHUsMlU1Y79gWyI5ytldTLZlN9CKQwVN
         CKSnlwRR0VMSLKFENirspJQDKNlsCPThmIgz/QhiyHs8Fjs5gFpqDYKo4746vn3KbPuz
         aOBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bzeM2rCXJGX1MjN/dDpgaNx5WIgmLfPZLdzsc0sB/uc=;
        b=VsFj6vwwL1Kpz5ruL5rHG81i1/lTLENZ+97DZn2Sd3imCQiVBeTlXP+JRVVTo4y2WS
         SVUFbcvZodP1bObB8/PA3bTvGylIGK9yC6SV2jpfxJwjvDh3PqWASp3Cs95k6PTBPQTY
         K4ETVP8ehvaHlrSovyad7RD7yauJqdau1eAneKPE+giaV2A/KUC/uvwmc+Y8DHWfPL2j
         J83rAsKNX3SR60pQdI6iG+DkJTqcu4qJR16sggyFdOikoQdsLvq1GhXi8PnETA/FU/wM
         rQcHf9eLt/ri7uPTAL/yYS31C9luHELMG67gV62ks48SgL+dUWjuu31eICwmHiWskpFT
         B2tQ==
X-Gm-Message-State: AOAM532Mn3bBYNReTU6l37u4vg3oPtM8eGhN0KfW6SRvDqCjmXfZH4VM
        g8YdsusFskA6CtYMuRu/5tY9CYUR/nEFsA==
X-Google-Smtp-Source: ABdhPJzyTUzL9H/ghew6zETdi2/N6BRsaCU3/dDYmDacsUqTK51Gctq/iRMREjM5MPvM83RRdZTqeg==
X-Received: by 2002:a17:902:6b87:b029:dc:3402:18af with SMTP id p7-20020a1709026b87b02900dc340218afmr14651173plk.29.1615067947480;
        Sat, 06 Mar 2021 13:59:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z4sm6024977pgv.73.2021.03.06.13.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 13:59:06 -0800 (PST)
Message-ID: <6043fb2a.1c69fb81.8498f.fe5a@mx.google.com>
Date:   Sat, 06 Mar 2021 13:59:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-71-gf45eb2cd7ca3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 108 runs,
 4 regressions (v5.4.102-71-gf45eb2cd7ca3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 108 runs, 4 regressions (v5.4.102-71-gf45eb2c=
d7ca3)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-71-gf45eb2cd7ca3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-71-gf45eb2cd7ca3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f45eb2cd7ca366c9a154b1253cb5d17786095d27 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043cbc88cd2ac6746addcd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-gf45eb2cd7ca3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-gf45eb2cd7ca3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043cbc88cd2ac6746add=
cd7
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043c9ea0b6f6cd34eaddcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-gf45eb2cd7ca3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-gf45eb2cd7ca3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043c9ea0b6f6cd34eadd=
cbe
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043c62457fac0e105addce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-gf45eb2cd7ca3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-gf45eb2cd7ca3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043c62457fac0e105add=
ce7
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043c63ff7f1b0fe12addd1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-gf45eb2cd7ca3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-gf45eb2cd7ca3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043c63ff7f1b0fe12add=
d1e
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
