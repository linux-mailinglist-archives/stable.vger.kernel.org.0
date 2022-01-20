Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C343A4955BB
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 22:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347351AbiATVBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 16:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347149AbiATVBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 16:01:21 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E5AC061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 13:01:21 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so2734089pjt.5
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 13:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fLgXhexBnlEl9Cvm/QgZ62SvqNIrIWgQ5teLLbDdQwU=;
        b=PLlpmlRYcBUjoY/kMzsv+/W0F4gei6ObegO4bOKOLZ8Cp9IEjwQSrJgbnRvMq2NgWm
         AgOIg7Y8i5Pxp1/BZPhXAaMncX/urAiXUabPCO/8YUhu51oRspF44nfuXKbfmPUhj9LG
         /1tv6Abq+YKHglC/oIEHkI9dC7tb0BxW+oMDzd5SKiW6pqAquaZ1Od8CfiuO58chUE2n
         z2uGnhttNve07LZOFcS3A/VwTv0qTTDLxU6X0uS3A4Tka+5sqz6+6CE/wKAcGZ17QiP6
         aXPfcbGz8MvE+KGHo24QfZwYxXIqMm4gp8WzkpUJkReGCt8Gqku9pPt6r5jEPIAlHLL1
         e8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fLgXhexBnlEl9Cvm/QgZ62SvqNIrIWgQ5teLLbDdQwU=;
        b=6A8/p2/E0lzOhxCdLbg3hEvjS0SMwc1p0BE2W4vC0t1jJeHen0xjRg2uz2vm8gvUIi
         Ps8iZA1mhAYv9FD2gwGrnmyeneWAt6NYBbz75r1VlvbUgV+Lw3TZ7Vwgaxq/kO+nwCKo
         oBoJujpxYTOxPadVhMx1/bnjiNY/BAw0/j2blXzZJizTH27dZCNSUSNHWa8tfHDUd1n+
         fCpbQmQ3BOYI1HTC5odRrtocWSO5+rA9nJhXKUVW6ua4OuTwBCFI3o0QVvU1tmU8B1Ci
         jkaPCAQzUkEV2LC4CrIRcEfxgnb9H0cgHD6OGeT+5N/J8NMNU4h/LPU1fFLp27yjZIWv
         qMCg==
X-Gm-Message-State: AOAM5335LqTbHdce+iVShS/aRpzU5D9P9QLKYr6l/s+RWFuBBu8zUdp2
        /RaVfLVM3boo2KsVuHNyC+AaTKgQs5hzTB94
X-Google-Smtp-Source: ABdhPJzeDgf0HoV9IaHjHyHp/rjwetg/CF09jTSg3d1VP3B7lUMae71ZprR6jhl89SPeALq4YH8eKw==
X-Received: by 2002:a17:90b:224a:: with SMTP id hk10mr12958279pjb.83.1642712480215;
        Thu, 20 Jan 2022 13:01:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s23sm4735483pfg.144.2022.01.20.13.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:01:19 -0800 (PST)
Message-ID: <61e9cd9f.1c69fb81.9509b.d2b8@mx.google.com>
Date:   Thu, 20 Jan 2022 13:01:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 280 runs, 3 regressions (v4.4.299)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 280 runs, 3 regressions (v4.4.299)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =

qemu_i386 | i386 | lab-cip       | gcc-10   | i386_defconfig      | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.299/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.299
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0ee52316847cf279a1028334117985a5d633c0c =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61e3ec69b3b9c29e62ef6743

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e3ec69b3b9c29=
e62ef6746
        failing since 17 days (last pass: v4.4.296-18-gea28db322a98, first =
fail: v4.4.297)
        2 lines

    2022-01-16T09:58:49.344939  [   19.041595] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-16T09:58:49.388470  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2022-01-16T09:58:49.397841  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61e998b9eb656cbe91abbd2b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e998b9eb656cb=
e91abbd31
        failing since 17 days (last pass: v4.4.296-18-gea28db322a98, first =
fail: v4.4.297)
        2 lines

    2022-01-20T17:15:14.030747  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2022-01-20T17:15:14.040203  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-20T17:15:14.057106  [   19.355377] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
qemu_i386 | i386 | lab-cip       | gcc-10   | i386_defconfig      | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61e99986297ef36a9fabbd1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
/i386/i386_defconfig/gcc-10/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
/i386/i386_defconfig/gcc-10/lab-cip/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e99986297ef36a9fabb=
d1c
        new failure (last pass: v4.4.299-10-g5f58931b34ba) =

 =20
