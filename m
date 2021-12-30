Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A69481E4F
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 17:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbhL3Qpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 11:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240031AbhL3Qpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 11:45:31 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D02C061574
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 08:45:31 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id m15so21867159pgu.11
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 08:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jHkDLrXJXcl4U+LLi2P+Cn4xDcJi79vD5SUFRZ0pbU0=;
        b=v0s4fNWBtDqIeJBfSrWf2ne7b1K6vMEemFGxGW6MWYjKeQ9RLi3iLRe8JMdFxibTpU
         Qe4ozKVVpeIxpxAPfB/zSqn3lTyZMxFlAkIlKhpsH6uGoo4qoXy+YKRQ54n2nM6VPc4L
         2L9+SffwsyIl8ad1ifmcvQvja1p/1acG6Jvq30DIwkvTJLXu5UIR3NIIpLcrODerUteU
         mIUxPS5I/yP8bqAD+p7HSEJwTum101nbwBupaTajnmeqyYsPIn5KzDKQLbThP+7yq2In
         b0cpk6T3544zJzZTLDW2SVenblS2auUY6myI6RhRUF648wl0S6C+eI1DWl2ai2h2Y3CB
         gEAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jHkDLrXJXcl4U+LLi2P+Cn4xDcJi79vD5SUFRZ0pbU0=;
        b=gEeafWWokku3ELuGsyyMD5wLmFaL2tQoX4WvJ+IDlfGk6oCgbkHaDKB2vv4cnNnvKy
         bZ0TDlmTcwe+5y0psKpTWADVHii0x8KF78/492nT+rgm04fGdReE0OOLcOHm+L8WEosn
         y/SwM+KAIpsEJi7PPVPg4rf2/iEeLLr+wDVpVrAXm7QIftjujP4kTA+augDr/NewOBv7
         JiHtt4EKa46FDQEzaqMT5NEb4UuNOXWsny8KVwgKrE8AWoQJEydhLK45RLuofcqBG1xP
         UHa412CWmfajV2gerCp419FfIV5t95KEV7f/8Kg0YOpP97eVfeBJtS3aavylXgcBqz5t
         833g==
X-Gm-Message-State: AOAM533NlqER0J1neje2B25Ikzuy9Y3VuIXHqH2kZaH05ReUl9L1nJxz
        BriM5Nz3U+9hRvABbtkIunQ5gZ88YkOe84qs
X-Google-Smtp-Source: ABdhPJwX8mwT3E80VMkEux/pqu9XpGgNGmW8wpwy1Yhwy5IH7e95FW1qsShJfu8YNjfguoOIOgJ81Q==
X-Received: by 2002:a63:5255:: with SMTP id s21mr28311608pgl.406.1640882730379;
        Thu, 30 Dec 2021 08:45:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e15sm23229904pga.53.2021.12.30.08.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 08:45:30 -0800 (PST)
Message-ID: <61cde22a.1c69fb81.c5f41.17d1@mx.google.com>
Date:   Thu, 30 Dec 2021 08:45:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.169-9-g8119581dca11
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 135 runs,
 4 regressions (v5.4.169-9-g8119581dca11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 135 runs, 4 regressions (v5.4.169-9-g8119581d=
ca11)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.169-9-g8119581dca11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.169-9-g8119581dca11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8119581dca11ec464922e85b5eaa28ed6558d619 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cdadafa7019510e9ef6750

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-9=
-g8119581dca11/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-9=
-g8119581dca11/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cdadafa7019510e9ef6=
751
        failing since 14 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cdadca1c02fc5d6cef675d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-9=
-g8119581dca11/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-9=
-g8119581dca11/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cdadca1c02fc5d6cef6=
75e
        failing since 14 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cdadae97f734eb1aef674e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-9=
-g8119581dca11/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-9=
-g8119581dca11/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cdadae97f734eb1aef6=
74f
        failing since 14 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cdadc8a7019510e9ef6775

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-9=
-g8119581dca11/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-9=
-g8119581dca11/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cdadc8a7019510e9ef6=
776
        failing since 14 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
