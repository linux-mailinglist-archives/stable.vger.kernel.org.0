Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6914AACBE
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 22:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiBEVo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 16:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiBEVo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 16:44:59 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D953C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 13:44:58 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id s16so8142972pgs.13
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 13:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/0Zmov6xW115WMkMeu+uX9WYe/oVQ/RyqhvL975nzRs=;
        b=xg9Ci70Ky7pjwQJ/BRP6WS5Hmmm5H1RqxswMta3abnB0vp11IkjFZtfwSnkk4c3NUd
         wTacPcFd/4JXk7w2E6fUnmQFapmd1+4yMfGTOWfgyRyDyR4qFbUQokgeEbRx90eBZOgn
         H96aYB/4iFbDzKtYsXIw6G4wOyUEAKPrb0FT0yd8RuiaVqVOtfyyHTcDTWU+hf3y6JFf
         5pyU2ejrLhM+QGMRkk3iazTt+USgfZKHp5sRsqzJOezNqMHtD9z+BEcKfNM9e/8OGe+r
         c7/sgoHllxpRUEI0qKTChD58y0PNm4nNiGtSThJonkGXtfBC03Ju/Q2gbN1Pky0Zu0d/
         gBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/0Zmov6xW115WMkMeu+uX9WYe/oVQ/RyqhvL975nzRs=;
        b=njQoOUbck3Qv8KxiC/GhUAm8Fe3uJO3T7GIHXgh0F6JI90gC1asP4I2RukpmHlWA9D
         P10UO7f8rKeNt3oRkohD0PPKi79/towyMHbWHScGm8GVPST3DpMes+QBXwKtG7z7xOp1
         gR6KGmP1rOa314aGC0GinU1OWt3cfaj5eIyeLMyWJXLaqQfzSalUUDFpYKJHo1mKe+x5
         7WK7ldpVD9LROoYyX9UE7BatAqDAy8mYP6rj5wVnm/rCoIXf4wiu8my1a8Eovy6h1VFL
         1MhUKM4OK72NHEB5FKh/iBnLu4UTL/boF1UHGJ4kRQZcwwOUcauEod2qq85SC3jZH3vp
         ZaKg==
X-Gm-Message-State: AOAM5335KkwNUWACcaIx4R8HdWRfXIQy9pORc38CO4L3w4ImdNNOGdwa
        eWyIq9tYJb8qtFXe8BoKHG8rxexsjwZ0/+Bi
X-Google-Smtp-Source: ABdhPJy223DIZvJDCvrkIwgeI8JVSzCNiOXntb9K/1KcYnoptZ0kDX0Ty3laNlj7VawNDc55QyrDkA==
X-Received: by 2002:a05:6a00:1682:: with SMTP id k2mr9177367pfc.11.1644097497458;
        Sat, 05 Feb 2022 13:44:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mu13sm19338430pjb.28.2022.02.05.13.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 13:44:57 -0800 (PST)
Message-ID: <61feefd9.1c69fb81.2bb25.032a@mx.google.com>
Date:   Sat, 05 Feb 2022 13:44:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.176-24-gc8be5e06cc3b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 98 runs,
 4 regressions (v5.4.176-24-gc8be5e06cc3b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 98 runs, 4 regressions (v5.4.176-24-gc8be5e06=
cc3b)

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
el/v5.4.176-24-gc8be5e06cc3b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.176-24-gc8be5e06cc3b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8be5e06cc3bc3b4ccd06b9f39d6648d774576db =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61feb9bd69e69ec5315d6f08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
4-gc8be5e06cc3b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
4-gc8be5e06cc3b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61feb9bd69e69ec5315d6=
f09
        failing since 51 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61feb952349b5cb3d45d6eef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
4-gc8be5e06cc3b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
4-gc8be5e06cc3b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61feb952349b5cb3d45d6=
ef0
        failing since 51 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61feb98073aacb970e5d6ef7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
4-gc8be5e06cc3b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
4-gc8be5e06cc3b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61feb98073aacb970e5d6=
ef8
        failing since 51 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61feb94fc6f8877ddb5d6efa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
4-gc8be5e06cc3b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
4-gc8be5e06cc3b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61feb94fc6f8877ddb5d6=
efb
        failing since 51 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
