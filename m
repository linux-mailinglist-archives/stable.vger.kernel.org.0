Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F0F3B76AD
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 18:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhF2QwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 12:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbhF2QwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 12:52:12 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2CAC061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 09:49:45 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b5so3707844plg.2
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 09:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C7SJ7X/9jEXxoLCfgyDNMM7uz5TUL//GAWmh/GjUYp4=;
        b=DnwBTVM73Zvj7Cm5PSKZIwSvw23HMoF3T5GYjBS+qBmwzEd40s9xAmFERw1niEcheE
         5Zt+346A1ptVSsCNRTeiYg6+5oF5FygZ1hl5XNqcyxgzwydCqhn8sQeq5RGSkwgRps24
         zqbdK1BlB1Gt1Np9hdsFjb5ks1WcSgwA4l/Lnw9YxUyZ/XMXaBNlewcMgkar0L2oMuUk
         T5wkI8no/IdrbsIoTQYnJhpH+nVfpWiGbsg54h7KoEW+WFqiYgdK0ZShbkmiIQvZSsOb
         lk+Mneg0EtNpbDZ/g4aOvua7zFqZUxNvovw+Hc0LaqxwdCT0b6YrUFFOmyeN5BfN/7vg
         A58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C7SJ7X/9jEXxoLCfgyDNMM7uz5TUL//GAWmh/GjUYp4=;
        b=Dtw6YZZrgTq748uZuxG83sr7IW4Od1EGUxu98h7ABmAxc+GZ8g7x4Zlm3aqbNL4jyK
         tUuHaTybw+miJ09P3VFvCDb/KZTTF0xqMAzba/bceYc93ZKTQ3Dp9vsNOltMMQbk5qnA
         uGxDlqksnN4apt7WLCMCaBx+R/ftniEubkgKYLghWOqPcRD9FYjnqr5fzjKZEry9MGnX
         dZBNnfzEz7XxW9mrh3DcJhrWuXPfze+DDDQ02ijy3D4gzPQKII42amLodl3KqgmvwVwk
         /GQgDOh9mBG2VAym7JfJHM6NrNHvrb+rOOrMAaF0oY0YpEXP9w1CBoWxgpUVA9Eqi4IV
         e6Jg==
X-Gm-Message-State: AOAM5339LLjETMNqnpBDxqq9eUbnjMtL1WY1a3qc9McSuopP4aYv4jZk
        w65629SM9Xz+TrmtoWG1NYOoKdvP7ZsoBPLo
X-Google-Smtp-Source: ABdhPJxvPp3TM75RN1wQa7yz+TJ+XGOfAQqP80w8nviQ5tv+svfMf8/QhtNmGB58toCktO/gMgY+aw==
X-Received: by 2002:a17:902:f282:b029:124:701f:2fe7 with SMTP id k2-20020a170902f282b0290124701f2fe7mr28146649plc.10.1624985384375;
        Tue, 29 Jun 2021 09:49:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6sm3657077pgc.47.2021.06.29.09.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 09:49:44 -0700 (PDT)
Message-ID: <60db4f28.1c69fb81.2b6db.a427@mx.google.com>
Date:   Tue, 29 Jun 2021 09:49:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273-71-ga12e333700091
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 120 runs,
 5 regressions (v4.9.273-71-ga12e333700091)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 120 runs, 5 regressions (v4.9.273-71-ga12e3=
33700091)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.273-71-ga12e333700091/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.273-71-ga12e333700091
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a12e33370009130a2628d2a2cdca0cfd421a2f5b =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60db2011c0435aa09f23bbcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-71-ga12e333700091/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-71-ga12e333700091/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db2011c0435aa09f23b=
bce
        failing since 226 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60db198d8beb9ed55723bbbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-71-ga12e333700091/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-71-ga12e333700091/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db198d8beb9ed55723b=
bbe
        failing since 226 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60db20af5e5a2b71ca23bbfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-71-ga12e333700091/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-71-ga12e333700091/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db20af5e5a2b71ca23b=
bff
        failing since 226 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60db18d84f5ac45acd23bbc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-71-ga12e333700091/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-71-ga12e333700091/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db18d84f5ac45acd23b=
bc1
        failing since 226 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60db26c20fc0a99db323bbc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-71-ga12e333700091/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-71-ga12e333700091/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db26c20fc0a99db323b=
bc4
        failing since 223 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
