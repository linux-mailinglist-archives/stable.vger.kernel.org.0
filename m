Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB02455177
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 01:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhKRAJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 19:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240507AbhKRAJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 19:09:24 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCE0C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 16:06:25 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id h24so3667690pjq.2
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 16:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e5wSG8QDMqHjKPldXjgqyrCR3WONzFJ7Fn+0SPgsViw=;
        b=qrtjTPbt4fPvv47IOoeb/nnCyx64IBLaDYxJK523omr3WSJuxvqnWYMTvYF6THghPf
         6hAN2kgbLflhLx6hl5Dqr5tFvhpNqigDm2KI0BjhJHpWxHBmMRB1gbeQqKyT8sNM0VZp
         G+KY26+Pnh05PT5XKQjKljBBlJ63zM6gio3kbhqGpm9UqaxvJJJV5UTMJxUpOg0kXNNI
         69TRHRnnZMoM0VVBFpWncp7p0snWfZEnJVvABkoVTaXHcuvjY5zHI/ZXPgWgs97OGaIf
         0jqo1Ydcdmji1cb6mep8omk0BN54vSNeOQprqmhdD7q1MvEZj6J5Hy5gsPimE9Y998aT
         4vOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e5wSG8QDMqHjKPldXjgqyrCR3WONzFJ7Fn+0SPgsViw=;
        b=XXbHUPkg77WcQSqqbLvlQ0H+hybCn6f/tntqYZ8PJcTF0dODvkbJlqrbUrRnS1tuvB
         gBZz6xAVPLQ8bmwJiOoz+VjPMU4fQkENEipiZImgnExxQMrvj+NljLw05qNnR6vyb17d
         uN2FdczajzZyWY2tewtsLFla/dJfs2vHlP4IK3x54XdaAIcor7gdj5QKqFeuQNKUopDF
         qQcFcJizdKmFW9ShapqzTBfBkRpt2pf1upFJziU7Xo8WS/CTbpp0ZZamFE4dmjfUNVTI
         sDB4zFnDEyDwx8TihFPmS/uUwGXyvAAb8dfMuIZymOSvbWYXdFjTeEWZbNE5u88sFb2X
         RxBA==
X-Gm-Message-State: AOAM532bkTW6KoZMj3ruEY6SB362hlAr8uWuSL9U+Es8no0wear4xOnL
        rLb4irySVkqJFLjZ+ofKisXo/hBBYB0FsVxN
X-Google-Smtp-Source: ABdhPJykwI9s5X5sDPBGt/a8x1hyOCkMm12bV4bKIkYs8xflpKveYPUI+VEt0FFkQt6ovb0H6QWHyw==
X-Received: by 2002:a17:903:245:b0:143:c5ba:8bd8 with SMTP id j5-20020a170903024500b00143c5ba8bd8mr36361214plh.64.1637193984779;
        Wed, 17 Nov 2021 16:06:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o28sm602151pgn.85.2021.11.17.16.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 16:06:24 -0800 (PST)
Message-ID: <61959900.1c69fb81.336ce.3200@mx.google.com>
Date:   Wed, 17 Nov 2021 16:06:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.255-197-ga09e356b405d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 123 runs,
 2 regressions (v4.14.255-197-ga09e356b405d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 123 runs, 2 regressions (v4.14.255-197-ga09e=
356b405d)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1  =
        =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-197-ga09e356b405d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-197-ga09e356b405d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a09e356b405ddc04719397000d35715aa1db9476 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/6195602894016d25df33590f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-197-ga09e356b405d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-197-ga09e356b405d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6195602894016d2=
5df335912
        new failure (last pass: v4.14.255-199-g07b05cbc7a1c)
        2 lines

    2021-11-17T20:03:33.528473  [   20.094085] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-17T20:03:33.572558  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-17T20:03:33.582358  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61956ee9a8ffafc854335907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-197-ga09e356b405d/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-197-ga09e356b405d/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61956ee9a8ffafc854335=
908
        new failure (last pass: v4.14.255-199-g07b05cbc7a1c) =

 =20
