Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1206E39213D
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 22:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhEZUHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 16:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbhEZUHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 16:07:16 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7A0C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 13:05:30 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mp9-20020a17090b1909b029015fd1e3ad5aso962011pjb.3
        for <stable@vger.kernel.org>; Wed, 26 May 2021 13:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ebxHOp0EnFY96Dmkcp+qStdp/DpSWnLWSLv6BiONXs0=;
        b=XXswFFSnR+ngve+um0iuhV0/DR7+SALtYI8wlmUZBip4Ld24oKAVqozVRQkM8lexb2
         Xjs1l9NdhKMQah3U7ndmTCsi8IFjzhMAcX23PET0iuJKnuec6fcM3W2muliuR4NEXOeK
         hzUt9INIz8eWbvw0tP/mhYjLz0RLxONuRq0Yckp7t48kOjrhAnIkObE1fje5WhArlliK
         6zbt2cn0vEJak3h9MU/Psjy4aBIEO5eq8svTPRPlvAs9ltoc8fi/5NtDmnuoMqU6KwHK
         Q/Eg+KR2TYK4PWc6qCZE65tIGs7b5SLRAuS3ksbnIf9CLpZJqIXp53Ibw8fT99OVRnN8
         sE7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ebxHOp0EnFY96Dmkcp+qStdp/DpSWnLWSLv6BiONXs0=;
        b=S/5pZXCsV2vQeaTuN/bWGsAynjUrKwuSGGJt0j242yFewhjFTvR94lYDrSK6joyytq
         UFCh5O8vmkwHz/7m2JAaBUI9mT7rYXnwxmPkMmS7MAzMWJ/SdkPaX/GmG/lSkPeueRaA
         gjL/Z9kGgdDsp/9Q/qw3e9ulQ3lC9OdBPD0qT27KnMRB4jOoEehVG++QxWv7ZCu+31Pv
         8iJzXBbYzbwohMIs8YqH6bccNXQTHHSwCEK5KZMChgdsyXrabHHRR0m1ypj/2vyJSALV
         tr7OiODxfK3crGkPpnIsPiLQWV8BO4KP3k6w4NZ/JmVMd6jmwuv6adMkd0FI2WH5On/C
         SL5A==
X-Gm-Message-State: AOAM530e6UvVOWwjjxo0K9974YyGfA4CAiUk74J1av1gMtbRIYBGEFsA
        e5VdOBvPnNn5OvA7BgXw/4NJjXP1+JaTQRyZ
X-Google-Smtp-Source: ABdhPJx/bMwooKf/tjx9UdB6P/o1ST1LOf3AyR7ykTMRFr592jhCwH4x2NqL1e22oY0MiiQ5JS0V7Q==
X-Received: by 2002:a17:90a:8581:: with SMTP id m1mr12995814pjn.47.1622059529167;
        Wed, 26 May 2021 13:05:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t14sm187426pgk.21.2021.05.26.13.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 13:05:28 -0700 (PDT)
Message-ID: <60aeaa08.1c69fb81.dde5d.0d4b@mx.google.com>
Date:   Wed, 26 May 2021 13:05:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.233-39-gad8397a84e1e
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 89 runs,
 5 regressions (v4.14.233-39-gad8397a84e1e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 89 runs, 5 regressions (v4.14.233-39-gad8397=
a84e1e)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp       | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

qemu_i386-uefi       | i386  | lab-collabora | gcc-8    | i386_defconfig   =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.233-39-gad8397a84e1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.233-39-gad8397a84e1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad8397a84e1e425e3f8221638cee2bfa237d9b2c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp       | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae7223dda37e5268b3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-39-gad8397a84e1e/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-39-gad8397a84e1e/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae7223dda37e5268b3a=
fa1
        failing since 0 day (last pass: v4.14.233-36-g430fdf2aba8d, first f=
ail: v4.14.233-38-gf84ac0d19cd6) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae74c3d5e788b24ab3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-39-gad8397a84e1e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-39-gad8397a84e1e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae74c3d5e788b24ab3a=
f9a
        failing since 193 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae6fa1cc276d5f01b3afc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-39-gad8397a84e1e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-39-gad8397a84e1e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae6fa1cc276d5f01b3a=
fc7
        failing since 193 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae72fb7a8f147bddb3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-39-gad8397a84e1e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-39-gad8397a84e1e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae72fb7a8f147bddb3a=
f9a
        failing since 193 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_i386-uefi       | i386  | lab-collabora | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae7343ab756babedb3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-39-gad8397a84e1e/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-39-gad8397a84e1e/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae7343ab756babedb3a=
f98
        new failure (last pass: v4.14.233-38-gf84ac0d19cd6) =

 =20
