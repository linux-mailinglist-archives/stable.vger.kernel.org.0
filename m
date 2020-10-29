Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E2F29E568
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 08:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgJ2HYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 03:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgJ2HYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 03:24:33 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C30C0613B0
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 21:52:52 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id g12so1344230pgm.8
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 21:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cIlBoKpI7SXsDFMI2ZZVZgIi1wCt4HSqPMapRGoRMGQ=;
        b=xoKciNecpc37wT4C6muMmbJraLGT5ocYIOtS22jP6ib2mECXk72NAYaZaeJY44YA2Q
         RFVfZH3+ZGHysapw5uLVV8abmQ+nHA/+UprEH7cVpEHwHtC6D6ImJN4asclaBIAboAQa
         e8d69C7an/+xiNH7YEmzp2zl/qK/Ln5yi7WBrMXIZVTH2RuRcXLZbfZzTf0/yFLuUh46
         zjEEKq5hbD7Mhcg9n0Sv3Vj9qag15FdpA2oY8s2O8okGoTtU5vJzldbrR9incPvwRzh/
         NEMTKhpuA4SwuupGgORBRlZSnlivn68SZgwI0S/R90XKsezd2tPrP+bmwTPq9FibQlLE
         ZLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cIlBoKpI7SXsDFMI2ZZVZgIi1wCt4HSqPMapRGoRMGQ=;
        b=cv0JyVTx7oTomoiuMJSDl8WB1AOwhrhL5AxiYcMAiZh00j9iSCPa5RtLVpppsVF0aC
         RBvXYM+67/sJb/Y4iLBuoPu+F54xviiJX6COcIY/C1e/GO2dJ7Ir9DQOOIIBWF6hqQlJ
         NzShmvAhzxKbD/Zfmv3ul7sgI35iaq14lmF85UL6dwXbf4rbBMNJuf4YF5C3xvCGBDVW
         k4c+a+1BoxAZATzXYlCkgEQjlEcGjar8UwLgck6CfpKwiD73QDD799jkM9iJdVqIUHIp
         /+/ByP2shc5mpx3U6TonPwflSt3g0/4oD7H/7UTlWCVqz6jwpgCszBzUaq/rnLrQww1G
         vXaA==
X-Gm-Message-State: AOAM533byrxc0XnYhn5n07R46ErgO6VmnEZDfn5XRlug0sl7c4+q4J0T
        pgzMLXDzke8+afkplNf+5yfkcDrQTod5rQ==
X-Google-Smtp-Source: ABdhPJw2nJHRXWiF0pcszLIbAMGtaTCcWKCWHH6Mx82NngnY6cZrmGGC/nkGpb9NmFNSi2T+Tin6kQ==
X-Received: by 2002:a63:7985:: with SMTP id u127mr2444383pgc.396.1603947172093;
        Wed, 28 Oct 2020 21:52:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r17sm1275729pfc.157.2020.10.28.21.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 21:52:51 -0700 (PDT)
Message-ID: <5f9a4aa3.1c69fb81.ced42.465f@mx.google.com>
Date:   Wed, 28 Oct 2020 21:52:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-633-gce353639e6d5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 208 runs,
 4 regressions (v5.8.16-633-gce353639e6d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 208 runs, 4 regressions (v5.8.16-633-gce35363=
9e6d5)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
imx8mp-evk             | arm64  | lab-nxp      | gcc-8    | defconfig      =
    | 1          =

qemu_x86_64            | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfi=
g   | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfi=
g   | 1          =

stm32mp157c-dk2        | arm    | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-633-gce353639e6d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-633-gce353639e6d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce353639e6d52ecfdf78f88a5b2425cac776775c =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
imx8mp-evk             | arm64  | lab-nxp      | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a16750ae5837390381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
3-gce353639e6d5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
3-gce353639e6d5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a16750ae5837390381=
013
        failing since 2 days (last pass: v5.8.16-626-gbc7f19da4ffe, first f=
ail: v5.8.16-627-ga9047ecdbcb4) =

 =



platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
qemu_x86_64            | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a14e3f8c75ceb5838108f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
3-gce353639e6d5/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
3-gce353639e6d5/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a14e3f8c75ceb58381=
090
        new failure (last pass: v5.8.16-634-gd1d01ed15406) =

 =



platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a150ed1f0870ece381016

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
3-gce353639e6d5/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
3-gce353639e6d5/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a150ed1f0870ece381=
017
        new failure (last pass: v5.8.16-634-gd1d01ed15406) =

 =



platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
stm32mp157c-dk2        | arm    | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1aa2cebfe17de438101b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
3-gce353639e6d5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
3-gce353639e6d5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a1aa2cebfe17de4381=
01c
        failing since 2 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
