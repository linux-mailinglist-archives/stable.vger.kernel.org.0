Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FD148677C
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 17:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbiAFQPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 11:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241059AbiAFQO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 11:14:59 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFFDC061245
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 08:14:59 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id v25so2993510pge.2
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 08:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XTdUWqmg/7MuImHY4tz2J2w2M2CBhHb/c7YJ4gqJ21w=;
        b=YFUI5q/w1TV6d+yXwvq2Qt5UwraY/Ga5OuKRG/2kALAYkq/NFJCigoFue6MjlPpUwO
         d49LvwSjFw9fbDIA63s/gOYUb7WZH9IJg/d8Ve/4vmtvG9l4UEahMdkiQ1+dZZDlGAnr
         ItpFXXcuAN2H5hXCe4kHF19B+9crJtRkqxGDHoEO/vo+RwiF80+hHE6gp1UKESkEGDIm
         CIaEY9TTKuuoBlPeR6iUno3bX51rMIA1XKba/7VXClwi7JG/4j2KFO0/ig1O43IZqIvl
         TkrInAAa86tCngvoXzPeyXQdXoYWvha3pq8LMDlZoIFLyQaimX9ScHuREHGfD/QgZOrF
         0r4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XTdUWqmg/7MuImHY4tz2J2w2M2CBhHb/c7YJ4gqJ21w=;
        b=t1A7gv5hWo/CtP4tke/FcSDXZF2NDX6atc2OyfdyCUAvGNnRYUcstsgau24763xpaH
         F2z3tR9fe8G6vuJWlrxcZc/XNnzs2FuRYq16HRVF5Us3UbOrT4+URXFbZpZZehEKnDbl
         wV+bczHK7ci29Am8xyiuvCKdey6u5RVnGIRvyxLOAI8RRKfZRPFjoe2WtHLE28ECJIE+
         GH6K/rJodk5AjtL9c+DxOydJ+LwE2JIlqwt1xg95B5AsLrAJQHKhU2mjozdwYZpogsEo
         fXLZ+WeYYbRJS09FXXZg/1S4CQ9ADOQWnioyx7mGCCAU9pyrixoNl7lfKZuYHSdZP8hi
         oLiw==
X-Gm-Message-State: AOAM533YOcR78twjz2NOVJZPKp01zb5zBxxgG7mu26d4XXbVFss+0K0h
        L1H+rwxQ8i18yXBj+by8qcAV3K1aCXhWx9PZ
X-Google-Smtp-Source: ABdhPJxUF0hFytDwKkkBXA00bE6hn8pETjGdHOVvyk+9P+UB5mY5ARa6NFz/qdOZpQgVDkVme2oukQ==
X-Received: by 2002:a05:6a00:2316:b0:4bb:231c:1b92 with SMTP id h22-20020a056a00231600b004bb231c1b92mr60818230pfh.27.1641485699204;
        Thu, 06 Jan 2022 08:14:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k10sm2853046pfi.52.2022.01.06.08.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 08:14:59 -0800 (PST)
Message-ID: <61d71583.1c69fb81.50fa6.6e9e@mx.google.com>
Date:   Thu, 06 Jan 2022 08:14:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.170-3-gb93ebf281310
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 170 runs,
 4 regressions (v5.4.170-3-gb93ebf281310)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 170 runs, 4 regressions (v5.4.170-3-gb93ebf28=
1310)

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
el/v5.4.170-3-gb93ebf281310/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.170-3-gb93ebf281310
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b93ebf28131037c93644ca507b2124bbd2b82792 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d6d8175beae30970ef674b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-gb93ebf281310/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-gb93ebf281310/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d6d8175beae30970ef6=
74c
        failing since 21 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d6d825df86c14980ef67b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-gb93ebf281310/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-gb93ebf281310/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d6d825df86c14980ef6=
7b9
        failing since 21 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d6d8155beae30970ef6747

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-gb93ebf281310/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-gb93ebf281310/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d6d8155beae30970ef6=
748
        failing since 21 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d6d820df86c14980ef6754

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-gb93ebf281310/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-gb93ebf281310/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d6d820df86c14980ef6=
755
        failing since 21 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
