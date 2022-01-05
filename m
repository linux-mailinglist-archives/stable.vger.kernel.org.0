Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCAA485B38
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 23:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244693AbiAEWCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 17:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244703AbiAEWCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 17:02:33 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BE4C061201
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 14:02:33 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id t19so536295pfg.9
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 14:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XgMd9FwCXZ9zY7m5OKAMYGzsoCFUumepQmE10LD0F4Y=;
        b=kX7V6IBTxXyZo3317n6EZWd8sdw83/u5DKxHwJptk0lckCR4Sjrc+v8zYw7Yr4ZtR5
         3CT6tI9l/c1Z7UBoWzGan2/Z5brMhFOUyvSBzvySEM380eBOBro5HxfQ6CFF4ASVTC6I
         isETADywsDPb2Cg1RVXVDmCb2y0EaIL1hgyKdGaQjh7aCwPwxaPNU2bQH26QiVJDgZsT
         AZTUcG8crmTINHgFwNzXGH/LYWNWr9QxfOoIVBMWpXiHc85wiiRenioyoDnTwQSZ/wPe
         XGGl07kn7B5G0DE4uSmdB8pc+/N4dtO0f007+PSsu2mDq6j6K2jp8TRiNuQBtu+uxht1
         XtLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XgMd9FwCXZ9zY7m5OKAMYGzsoCFUumepQmE10LD0F4Y=;
        b=pxceTo9s6W/swtJyazRk8rgfX9OV5uyKTS6s5275+XQiaym+VU1IzCeMUE250zN0ez
         XRETyxUwyHdpmqxPfzeQpJDgmIUB1Scw3gXSWArR9RC1hL3e8z/WCbglTQeEPuS7m9YA
         ge5k5USzUvIut/qaGOt6bUIx3RyouHkoHW2uq1PFBOv6JGVl1fyswE5YKxo9+Pn5qntA
         XnvHHRkuQndAmarBlK5LdQDBWFdLvrN9CEt2yK4NZA6b6DGFGLmi0rIFv9gD3d7ZjcEM
         rCeVeNaM14rfA3ymYPXchVBN0RGGBgMf0dTE6qVxpjYgBGGQNdIAQTBKhTCtllwjcG2w
         GFXw==
X-Gm-Message-State: AOAM533lLIqotnknntPIFluFhgRNyD39DeXqAy7rgj14O1b6n8EQ4DOw
        mqm/ujuWb1UvwGghNSucUYtOSxz/X5kyC9tX
X-Google-Smtp-Source: ABdhPJyRFeZ6yT/pKhHAAt3SL8LgkpzdPxBzuh4lsXxx3OAooPqA64WXPxS1h0ACWhu5yBMNlpSPOw==
X-Received: by 2002:a05:6a00:139b:b0:4ba:a476:364e with SMTP id t27-20020a056a00139b00b004baa476364emr57650584pfg.59.1641420152716;
        Wed, 05 Jan 2022 14:02:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11sm18122pjh.14.2022.01.05.14.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 14:02:32 -0800 (PST)
Message-ID: <61d61578.1c69fb81.3b3dc.0150@mx.google.com>
Date:   Wed, 05 Jan 2022 14:02:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.170-2-g8ebc30b5d171
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 128 runs,
 4 regressions (v5.4.170-2-g8ebc30b5d171)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 128 runs, 4 regressions (v5.4.170-2-g8ebc30b5=
d171)

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
el/v5.4.170-2-g8ebc30b5d171/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.170-2-g8ebc30b5d171
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8ebc30b5d171593e37581f6356878fbad3800deb =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d5e1607bf0b9a4d3ef675e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
-g8ebc30b5d171/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
-g8ebc30b5d171/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5e1607bf0b9a4d3ef6=
75f
        failing since 20 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d5e170bffcd3401cef674f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
-g8ebc30b5d171/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
-g8ebc30b5d171/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5e170bffcd3401cef6=
750
        failing since 20 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d5e15e454bfd9519ef6755

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
-g8ebc30b5d171/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
-g8ebc30b5d171/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5e15e454bfd9519ef6=
756
        failing since 20 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d5e16d7ff2594042ef675e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
-g8ebc30b5d171/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
-g8ebc30b5d171/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5e16d7ff2594042ef6=
75f
        failing since 20 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
