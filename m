Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD8F48168A
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 21:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhL2UJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 15:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbhL2UJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 15:09:35 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04146C061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 12:09:34 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id i8so10853255pgt.13
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 12:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZPPfuYXjHkgJWZfEAfD2Jn3MS2edQAzdJfkxYbuUoHc=;
        b=4kY573Twlwb3LJAum/QKSvDycn+6Hyca4mv73T+W/5337ZHEd/vm3tz7fZPeS/BSwB
         5V5AUKO9kaWbAOLAGn0AkkJ8pjW/N34XxteeUR0Ee0SbG0Wv1hyCSHF4HI0Y3OIL4daV
         1gbf1xaDpCEI6kkwprYOkxyabgVm/8OMQZQv7lgWV7M8TFyPZaIkugPO/y400ylJiN64
         +VtsZoFZdXfC77hf41xkMvJscFCxG+lIsW1+7rGzNMJx3xrV6W25joDwEWhgprgOeyYe
         ZN3Y3d+JEPdkjJg6NlZTEKYWRA7UPIBucm7fyZN9oVv/jLtbt+AToNGgIY9xhtz/2X+a
         /Ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZPPfuYXjHkgJWZfEAfD2Jn3MS2edQAzdJfkxYbuUoHc=;
        b=FFvuYh5kwXc3x4yWERqv3Ed4oKXXC/+IUNYoxFiyAameBbXwaJ/OQRyEjreGQ81hok
         Rgt2lrppxzPoGPGxsCuoJ3lm92CAQHFtvDR5+HY8T/TlD+YTRjccdSs3uwJ7spk7Ibv0
         xDX8o/vtw8HnTms1GXYiRMWfD8Zl8t4JtlDg6r7E/S3awpX6pYOVlz94jXzDYh/yIecx
         IX9SckmdPJytGVs7bZaBxYCmlyyfoU82wJ5JDSv4/nmKLImnARKT/UITqIP9WzfpCo0W
         5VD8Yc9qWd6aByDgPYFYEIM26SYE3kBf4NerFPmkIt5AEnvurFScAKJ3Y3TAVZDkstgP
         rgxA==
X-Gm-Message-State: AOAM532ygJQS+pD1QJdFZo0ZCxPtC4YsMpEoHGdvbs5SqiaqP1YpScrs
        U4DQMYcB8JmdpOTMKCvmDRriNx01whHN930O
X-Google-Smtp-Source: ABdhPJw4iWazKa7O7bFbW7TkDFZL48FzDaE+IlgqVhr4t5tDRTT+szXDgLoxhDWoDKUer9n2fTuXaA==
X-Received: by 2002:a63:8342:: with SMTP id h63mr25093925pge.443.1640808573812;
        Wed, 29 Dec 2021 12:09:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v3sm6180230pgl.64.2021.12.29.12.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 12:09:33 -0800 (PST)
Message-ID: <61ccc07d.1c69fb81.f51c5.1214@mx.google.com>
Date:   Wed, 29 Dec 2021 12:09:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.168-49-gf241ebe4310f
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 176 runs,
 4 regressions (v5.4.168-49-gf241ebe4310f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 176 runs, 4 regressions (v5.4.168-49-gf241ebe=
4310f)

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
el/v5.4.168-49-gf241ebe4310f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.168-49-gf241ebe4310f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f241ebe4310f56daeecf60e34d3f192b40145cbf =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc84e87153f77cfeef674d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
9-gf241ebe4310f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
9-gf241ebe4310f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc84e87153f77cfeef6=
74e
        failing since 13 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc851dbb2ea7b85aef6796

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
9-gf241ebe4310f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
9-gf241ebe4310f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc851dbb2ea7b85aef6=
797
        failing since 13 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc84ff00be6e2211ef677f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
9-gf241ebe4310f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
9-gf241ebe4310f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc84ff00be6e2211ef6=
780
        failing since 13 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc8531da516ca92bef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
9-gf241ebe4310f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
9-gf241ebe4310f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc8531da516ca92bef6=
73e
        failing since 13 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
