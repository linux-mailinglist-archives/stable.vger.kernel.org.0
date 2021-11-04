Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85291445B7B
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 22:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhKDVHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 17:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbhKDVHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 17:07:47 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4ADC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 14:05:08 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id k4so9348003plx.8
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 14:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2jah4c3wrDRrwqxndGMWx7G+x9W23hyWc6vU1UnDJzI=;
        b=7v0EsaPL3VvzzCMLkZYUxII/hHaZn+zUgYn0Xa3ouSqdUbRzWzknY1+Iiv6hodLd8A
         1LG9LgeA0ZVucD7bPIBY1cwsH+F/U2DavwuG7zYfbJWQkJ1j61yvRZpqhWzm/tu1a/oM
         0OrRrKehVNi8ngYH5gR+bZzM6NCEeJJopxA+5abx24I/mGY6pN6tBimF39qJ7+b7pWHd
         Qz8Waskc1BLlt1e74TfA8AHtu5CJqOysZc0JFcMFoxq5U/6z0Rzjz5ekAerSEoswpmOZ
         gnQD7Qj8RBXcRgYnuKYqPYwq2CJhjg7iLG8l1Dmoq48wesslSGt6YOfvw3rQskXYiTs9
         2Usw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2jah4c3wrDRrwqxndGMWx7G+x9W23hyWc6vU1UnDJzI=;
        b=KGxlzB0Ji0kpXEDNqla9JyjDBXQARhEQcQnywnJ8wUjfCgHFckMVawuSqeH+e8jy4U
         p9TtTyHo4P8CKzrki2ryItnEGoaPVjdZYAHGd08plwx/v+6iNOMhzE2RTvNpZ1mqnfYm
         Lgvg7aL3QB4HtKWqwyc5tPTA7Jw9C5uDj5tyfIcORZ1LUk9bznP8pYDEsysDP6bSfPCJ
         +Mk1bkcRv/Jpc4FFG4L2d5JLLRygS44ycQoP2/9CE//6r1UwH5EdBs1xgMwaZ9KPO4HP
         Ugv5qZpxUWBVdwnkKtBKt7day0tgBC7BxD2X7CZKj8G0m7rm6mwKyEZRgSwiavhlb9aS
         yt3w==
X-Gm-Message-State: AOAM531mmtIM2TF4GjUnriC6J4rQmTAsdoIzLAUSOFHudGeN72evtydU
        x42x7qMZWHhxClOp5zy/vnwLwzXvMkmc+u7H
X-Google-Smtp-Source: ABdhPJxRyzKmatzVUM7TXB87MdJS0qn5RJC06tma5whahiahZk2P6BJRCLjfOqL5BVjeFX2xWlmQ3g==
X-Received: by 2002:a17:902:6bc8:b0:13f:8a54:1188 with SMTP id m8-20020a1709026bc800b0013f8a541188mr46296997plt.49.1636059908385;
        Thu, 04 Nov 2021 14:05:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18sm4785674pjo.31.2021.11.04.14.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 14:05:08 -0700 (PDT)
Message-ID: <61844b04.1c69fb81.82a6.01c0@mx.google.com>
Date:   Thu, 04 Nov 2021 14:05:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-3-g59c6c12a4647
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 94 runs,
 1 regressions (v4.4.291-3-g59c6c12a4647)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 94 runs, 1 regressions (v4.4.291-3-g59c6c12=
a4647)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.291-3-g59c6c12a4647/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.291-3-g59c6c12a4647
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      59c6c12a4647e7980459a27a6a232485cbe10189 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61841179bde58a1f2c3358dd

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.291=
-3-g59c6c12a4647/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.291=
-3-g59c6c12a4647/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61841179bde58a1=
f2c3358e0
        new failure (last pass: v4.4.291)
        2 lines

    2021-11-04T16:59:17.276753  [   18.899932] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-04T16:59:17.326637  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-11-04T16:59:17.335492  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-04T16:59:17.354842  [   18.980773] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
