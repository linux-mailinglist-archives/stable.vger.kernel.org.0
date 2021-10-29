Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC02443FDD8
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 16:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhJ2OIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 10:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhJ2OIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 10:08:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26ABC061570
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 07:05:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k2-20020a17090ac50200b001a218b956aaso7472897pjt.2
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 07:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q3RWABVu2GyHMCYHQz59DTplL0FEOF8xjPmlthTxeJY=;
        b=04QWFis7+7xA2lb6+muHJhyQGl3Ixx2mgyBkHBdRCvzxLQFcl9yrslTpsraOw2Ac6g
         2brKHkAVl9HMzAhRNZ41un5g5NcvFSO+SmkzmgIqDlRzZqmYI4VI9yqrta1whSXqnF4M
         PswTs/nOR8faqEWnxFXt7CWi95B1bUQylVDxu/LcINr2G1jfQG7slq5cK0LiQlbacYrd
         lxqlSTniycLUpR4/Je5fYwBHFo/+S7c+pkasUxt7UqDqOidCivvoam/jY73r5Nl/6TXH
         13F1UuZp3slGjFhZyQa39vMVKPYgxkCe/G66iHSQ/ynkY5er1wr5qZL2Z1ZogLMuoJPE
         T0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q3RWABVu2GyHMCYHQz59DTplL0FEOF8xjPmlthTxeJY=;
        b=1phrC/zeASDuv5zfK1tI5mhQsI55lS167LYcPgqFRXU303eszj94cobt9a4bli4jjk
         Yo35pivCqgJnwIrqUxkzpsr2SNa2TXn0J1j2ZZj6Py+d+H9bxW9zIKamr26xBOCiupGj
         zaiV+07QeBTvWkg8e+GCOVY7laWe2kKLKkmGzfoPOWBfi8wPTHNhSNdYEC1lF+UIicdV
         gaCtRyeqJ5tS5Inxc/482AO5aka+IOCapZblGbVyNFf/qCgR61tnOELuDPQWhJJBCVJf
         SdSvG3T6PAQmNJbl1D8/K4hcTA3voo95ztC4LHQR8DPdDYGfX7obwcLqLNWEvY7ocAIS
         Q0wg==
X-Gm-Message-State: AOAM533uAK4NEH2ttzYeYJZ6i1XUA1XSYoZXSjSpxhSeOuRvKh26za/T
        ysDGbsm1ZnSv8opJjM9LAyOpne3QqqKx/yZU
X-Google-Smtp-Source: ABdhPJykTAsUbO4QLXMjJkHB/hlBHEwCtKdSKC9MdJoYZ4/vTvaenV+VEieqlRplx+sr8eiFMgkplg==
X-Received: by 2002:a17:902:be0f:b0:13a:19b6:6870 with SMTP id r15-20020a170902be0f00b0013a19b66870mr10058922pls.64.1635516348062;
        Fri, 29 Oct 2021 07:05:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x202sm7159107pfc.170.2021.10.29.07.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 07:05:47 -0700 (PDT)
Message-ID: <617bffbb.1c69fb81.6acb.488e@mx.google.com>
Date:   Fri, 29 Oct 2021 07:05:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.288-10-gf1357734f92f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 125 runs,
 2 regressions (v4.9.288-10-gf1357734f92f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 125 runs, 2 regressions (v4.9.288-10-gf135773=
4f92f)

Regressions Summary
-------------------

platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1 =
         =

qemu_i386-uefi | i386 | lab-collabora | gcc-10   | i386_defconfig      | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.288-10-gf1357734f92f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.288-10-gf1357734f92f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1357734f92faeb8d8bb18ac5552fc2aeea758a9 =



Test Regressions
---------------- =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/617bc91420f2ae40853358fc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-1=
0-gf1357734f92f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-1=
0-gf1357734f92f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617bc91420f2ae4=
0853358ff
        new failure (last pass: v4.9.288-5-g4843ca122328)
        2 lines

    2021-10-29T10:12:20.079541  [   20.210479] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-29T10:12:20.123088  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2021-10-29T10:12:20.132239  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
qemu_i386-uefi | i386 | lab-collabora | gcc-10   | i386_defconfig      | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/617bc93baddc3f870f3358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-1=
0-gf1357734f92f/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-1=
0-gf1357734f92f/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617bc93baddc3f870f335=
8e9
        new failure (last pass: v4.9.288-5-g4843ca122328) =

 =20
