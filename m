Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29ED4783B8
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 04:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhLQDkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 22:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbhLQDkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 22:40:11 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4995C061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 19:40:11 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id m15so872630pgu.11
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 19:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NGq+orlifztIslpkCpPSMcWKid3mG5SdZXWNlytbauE=;
        b=X4eqMC6OXp4v/GKSpUyEGU/FiyAMiYdpGdqHdeALAkkBEOjxM4I96Lvq8aqkFvGJIK
         inRKj/ctST+9Ht+vpifm5aTsy9NS7EtMGGFUhVjTBechZ0zavhyFg8vgm63POJ+c1u4M
         FVieOgDyh4IEwxCTdA6WD8gPIzCGHoE3z+AiZ1R2xCUxKKwOsZn4mtXm5a3UitiwzXwM
         9TnLWqtHFz5kt1mYhnU4IpszLb6rQejhuEjHwpVKLbsHNjt+CsrgHZ8GMVNhDetRlXZZ
         O3hytwAMzRPrg/N/zAfJxQed+vNRdxhPN7yp54VtWDZ6rLpOTw9jea49SqEBN0EnyEQ/
         NqTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NGq+orlifztIslpkCpPSMcWKid3mG5SdZXWNlytbauE=;
        b=ghewD6Xsf44Uz1KwKAj56EHh4tsOBANSAzCUpkDQsc18yxBTY+4XYsjLIEL6KXKPi3
         HpfxQ4h40B7zrwvy6Z4ut5lqJUhZ3eDdugCD+E80M5aRbX5RqoKuqWiPFn50zfj4WvdP
         2ChSMrvBqTanev3BW0HdUqUnx4W04gNJzxyLa17OptA7FnLbheLeutvcbxEoHP3SbBkI
         T9kTMfjUHMdm7ZPnnYvcIlct380IkVvsKITzH4xHYwlJQzcZ7LnWZZnla87doX16sh2F
         55966lXPIbzrg4qHp701LZh9EfkYnn1oR9F93AEIqcG6SN5iro1dtPjqiE7Rsyz4tYAa
         XsjQ==
X-Gm-Message-State: AOAM530hpV9Sq3DMn5KdwwY5dJdQ8C6OpUeYh7FM8mKee0W0jSlOIwNt
        aIV/abkRxVadtFPPCaRAtVRo19osd8om6E56
X-Google-Smtp-Source: ABdhPJzpruhWsZLrZgEcs9B6U0Psyte4DR3W3h+b9LSKaVw0u5RU/QaLdP9SRq+FG+d5nvNNVvmByA==
X-Received: by 2002:a63:5f0a:: with SMTP id t10mr1221739pgb.11.1639712411039;
        Thu, 16 Dec 2021 19:40:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q2sm8102806pfj.62.2021.12.16.19.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 19:40:10 -0800 (PST)
Message-ID: <61bc069a.1c69fb81.fa0fc.7846@mx.google.com>
Date:   Thu, 16 Dec 2021 19:40:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-9-gf2f6b95b385b
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 120 runs,
 2 regressions (v4.19.221-9-gf2f6b95b385b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 120 runs, 2 regressions (v4.19.221-9-gf2f6b9=
5b385b)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.221-9-gf2f6b95b385b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.221-9-gf2f6b95b385b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f2f6b95b385b4cc8ae044b8e0e0fcfbd0aba1d20 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61bbcb2595ade423f739711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-gf2f6b95b385b/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-gf2f6b95b385b/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bbcb2595ade423f7397=
11f
        new failure (last pass: v4.19.221-9-gf48d5f004d75) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bbcb7709c455c40b39715a

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-gf2f6b95b385b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-gf2f6b95b385b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bbcb7709c455c=
40b39715d
        failing since 0 day (last pass: v4.19.221-9-ge98226372348, first fa=
il: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-16T23:27:36.410496  <8>[   21.531036] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-16T23:27:36.455357  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-12-16T23:27:36.463716  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
