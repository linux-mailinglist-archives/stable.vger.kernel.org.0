Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9768E354B8C
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 06:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhDFEYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 00:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhDFEYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 00:24:17 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573C3C061574
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 21:24:10 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id y32so6273606pga.11
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 21:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VLRGv+kFViIVzbZcNVmo9xTCSBnd3zJnQjGc2u+DIZM=;
        b=SuQzqSIO3gemkXKBpvFx6SA0vkbiafFvS/O8ry1TKmpG5cXnFasU/PHamVClnnqT18
         fZi9zpVDYQGyO4QPAFTtUVLNNQTJW7LDqcsd3snbVmgB2hqNY/ulx1jnZxta4E8laPMG
         88WSz0jlxximud7vYOwI3R6/5S4jnnl9q+P22T3XO9je61DpDvJNP53W+0L/Pm8nMcA7
         EF4huZrFvhSQSULmwv42iIFgkanRHbSlyE4W9Q0c4Qve3YpBKWnkFTK8+8+hz7AJPk7W
         0XdRgTzQ6AfE+sW6u2E5Q3nGXc1b+Rguc4AktlKMNiISz9o4Ee06d2ZeASC5Pi9KihCR
         JO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VLRGv+kFViIVzbZcNVmo9xTCSBnd3zJnQjGc2u+DIZM=;
        b=F7AzrHL/BEto3CwindU714ok7nTmd43yILeHXvH4CTCTQXFp+8/Uuh0o+Hl0mcCfBE
         zaWQRctLTPfZsLN/jY4SIUqvwlGLUb0AVcFqrjbHuc+GaTrLFp4ZCNJp6kDQ9bhseJTm
         UAhG34oHMqznh8ScSfIQjL/TxvcneAD64UkDRBJ4YzouYzR+8T21LwMj4viSBJXc/d3y
         MyMEIUDpWxyTP4jArSLvvmY7+OLKS5p4Vfl1p/oRUD0hsIvmhCk1g364I6J6qrYxJOWG
         TN49l4iuRMxw17cRX4EB+bbys9zAXWS3E9uz6BfCJciSx1G1jDu08cvOb4ahkPAoO/wE
         +lBQ==
X-Gm-Message-State: AOAM532hovEfaodMQFvQyxI97pXlKNOsR4FXibC0eKiR7+gc19Hi3LAR
        6h3ZnLwjEfvkoMvdTNwUfE2T41iJKF6G8g==
X-Google-Smtp-Source: ABdhPJz2eI9b0oVjbmgHZx3bPhpL1KnfiZQ8w4xqd0Y8WBk0lS5mkvrzVKj0ixdkSIAEhzrBePMSdQ==
X-Received: by 2002:a63:fc07:: with SMTP id j7mr25793035pgi.401.1617683049580;
        Mon, 05 Apr 2021 21:24:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10sm18914124pgo.75.2021.04.05.21.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 21:24:09 -0700 (PDT)
Message-ID: <606be269.1c69fb81.5b6c0.0211@mx.google.com>
Date:   Mon, 05 Apr 2021 21:24:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.264-35-g9e8200f3a1d22
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 99 runs,
 5 regressions (v4.9.264-35-g9e8200f3a1d22)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 99 runs, 5 regressions (v4.9.264-35-g9e8200f3=
a1d22)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.264-35-g9e8200f3a1d22/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.264-35-g9e8200f3a1d22
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e8200f3a1d22907022ec340188fed1ea42289b0 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606ba89681bc16bfcadac6e8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g9e8200f3a1d22/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g9e8200f3a1d22/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/606ba89681bc16b=
fcadac6ef
        new failure (last pass: v4.9.264-24-g1d82835a5e4b)
        2 lines

    2021-04-06 00:17:22.867000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/125
    2021-04-06 00:17:22.876000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606ba5b78f058a7494dac6b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g9e8200f3a1d22/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g9e8200f3a1d22/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606ba5b78f058a7494dac=
6ba
        failing since 143 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606ba5a68a6d80e449dac6d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g9e8200f3a1d22/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g9e8200f3a1d22/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606ba5a68a6d80e449dac=
6d1
        failing since 143 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606ba54f5defa7a194dac6e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g9e8200f3a1d22/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g9e8200f3a1d22/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606ba54f5defa7a194dac=
6e2
        failing since 143 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606ba55e10fe2fe305dac6bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g9e8200f3a1d22/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g9e8200f3a1d22/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606ba55e10fe2fe305dac=
6bd
        failing since 143 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
