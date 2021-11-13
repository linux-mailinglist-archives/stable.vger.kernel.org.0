Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7425044F468
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 19:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhKMSIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 13:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhKMSIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 13:08:09 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691D6C061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 10:05:17 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id m24so1050014pls.10
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 10:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m01k9l8/cq9g+QkZIDSb0Rf71vz085KTmyt2dbRSD1I=;
        b=5yzg0ByYi0VGjrYhgFFWB7FefY0VqgUTgtM1XNkvGBl8UdF3qSdEinnFTV4J5sxfbK
         aFJ1Q5NQcGdOYAYH4u4hl/W0P7iccivBtLnCyKwnk7F0z7uRBfnY4cBwDabekPr8Njbv
         jQwWxvGO1ur2Xd2nbNtE/mq++IZIRmfPE60xdkqpj6TUe7toTcyhanykhVEHIYsPaLqp
         RBDkc9EAf/LGmBrbYNLYd2U7b0Tnk6S2yWaIbM6p275WcNGzC2Q4LeCBp2d/jfETSZtS
         engSYujqM+G7HhSQUDGG+W26CXo3zNisctfsE434huF0gCZYBZGKKpY6Ygwc7Il3o8lP
         nWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m01k9l8/cq9g+QkZIDSb0Rf71vz085KTmyt2dbRSD1I=;
        b=dH65oKeIURk11xhAoALVxe/hOPet3lyxjPwf7xnVSQbIcdMkfGQDiBCLcCl7qHBjpd
         OqXQlzznbegLnF/u7yxw89h+W8nWg/s5oJxA/uP5JEGxbXpw4ki6I+5sKwqp9YUNsRj5
         CHNk/7rJTARyzbh7qMcZ+woIotEdxf3P7JTu7tf/OxYIAAm7fVKaoDjcmwvyLbbuMGQd
         3NwVGGd9K4YV2YaijcS8qiOrFSdx+Pb9RyKFjVFegIQ2CSRAqVO8tTVj8Byeff627PwX
         attkUzEPtWEjjNmBhibkYMKKP2nUZnHNDrncdd6Hqzztdq8Ck5jDsnnPhw361QpkNts8
         NIUw==
X-Gm-Message-State: AOAM530pKvdwX4CLi4YXYfOBJD8m95Vkaa+XOKLTb3ta2c/ZlRxOI97O
        Of12cBMgIHDe+Drf+YAdkAEpM4NzYfL22NcJ
X-Google-Smtp-Source: ABdhPJxBtSqTauibFiqTF9rlF8CR6IHrZELgOiqC58PVWgbBirxsitRtnoROfXpdfWdH5/yqFPAhlA==
X-Received: by 2002:a17:90b:3e81:: with SMTP id rj1mr29915664pjb.111.1636826716826;
        Sat, 13 Nov 2021 10:05:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14sm10614125pfv.18.2021.11.13.10.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 10:05:16 -0800 (PST)
Message-ID: <618ffe5c.1c69fb81.1f4d3.e71c@mx.google.com>
Date:   Sat, 13 Nov 2021 10:05:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-18-g5b33a2ad4b2f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 147 runs,
 1 regressions (v4.9.290-18-g5b33a2ad4b2f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 147 runs, 1 regressions (v4.9.290-18-g5b33a2a=
d4b2f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-18-g5b33a2ad4b2f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-18-g5b33a2ad4b2f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b33a2ad4b2f654b3ae7ce5290eeb12d882e5aa2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618fc4b4805d3742ff3358e8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
8-g5b33a2ad4b2f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
8-g5b33a2ad4b2f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618fc4b4805d374=
2ff3358eb
        failing since 0 day (last pass: v4.9.289-22-g296b3dc5af4f, first fa=
il: v4.9.289-26-ga0450cbaedd6)
        2 lines

    2021-11-13T13:59:03.995500  [   20.350555] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-13T13:59:04.038530  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-11-13T13:59:04.048284  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
