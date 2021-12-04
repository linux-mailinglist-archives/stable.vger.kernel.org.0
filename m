Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E7C46871D
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 19:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbhLDSn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 13:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243635AbhLDSn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 13:43:57 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350F0C061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 10:40:31 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id z6so4362730plk.6
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 10:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r6xUhBBzWyUyNgY0IbOEbABSZRwlPIizUX8qFRj4X6w=;
        b=RMq4eXNbcUuNiJbFfJ7S586LI+J88yk9udDktHoFhVyxtSa3uY3vWfc+j8hkO4K9td
         Nrh2l+7PUkaZ8GkBqf6XuSnCCaK9LJLUjc3dU4lB4kt6GWjHSxT64gkTVAarAP+Fp4z9
         asnYq95VCMXNYGRsIfzhN962SKzhU+hKb9O7QTufZ3OlCkLlH0W0E4rTBlw1VEWHIYVc
         2qcpQR0vQVJAgvddb7Y0AhZhXuBEwKGQvuhvMOupL39+8UaDNO39hqpi4cQelNX6a3ce
         6kbR9wIc1+9bbM/M/dCkvuE01D43USeHNugP9yt0c376bcEvGJChaJTfFoPlMlc4k08Q
         SbdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r6xUhBBzWyUyNgY0IbOEbABSZRwlPIizUX8qFRj4X6w=;
        b=b0MwPwIPKFz0yIv4rrCFZI0+JbN5jrYiPCmNkTp2CCHhwMeqNp87InxYjjsKkROjP3
         twJEfBoOO/swVfn3Q+nIF8CpBC3Zm5O1uvoX7FDA2p69JHC9P0pPOiEp9LtouF+N4a+b
         cmwWxG4h2zk1zeTBfQ0mmhWB37g6SpiC4Pu7T0OLsBO9Kts95ysmwGE/QLhzqC9n3vtH
         R8qXRHUCm9L6WRmvg7FSI5yB35Glj2Mf7IN49SZWP5ykC4Ua/OZIjhPalfzG1gqXRuN+
         XlXuF8+eufyazvyki/32KeHtc3aLw47MAakpOo2621tHL1xg6BycrbOnEmiWzSWztWyf
         mHAA==
X-Gm-Message-State: AOAM531dXDZUN4ndCE/qYeJ1nACynVkDS8nKicK+oH+grlVtJ3qiqtCm
        zjygPRtD5N5w0gaZAfD0uA8Wic5sl6wH20BV
X-Google-Smtp-Source: ABdhPJxNdMInjxxg3QOpj3KAGvRPuV2XJHevhmcFmoRE3cvlISzXrd/fv5rkyOM8e5OdBYH50guqxQ==
X-Received: by 2002:a17:90b:38c7:: with SMTP id nn7mr24085765pjb.105.1638643230415;
        Sat, 04 Dec 2021 10:40:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13sm6993148pfp.216.2021.12.04.10.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 10:40:30 -0800 (PST)
Message-ID: <61abb61e.1c69fb81.77682.5070@mx.google.com>
Date:   Sat, 04 Dec 2021 10:40:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-43-gb9df7527f7e33
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 78 runs,
 3 regressions (v4.4.293-43-gb9df7527f7e33)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 78 runs, 3 regressions (v4.4.293-43-gb9df7527=
f7e33)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-43-gb9df7527f7e33/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-43-gb9df7527f7e33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b9df7527f7e336d44561e8ad0fad42b5fa548661 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61ab7e803bd39995051a94c6

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
3-gb9df7527f7e33/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
3-gb9df7527f7e33/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61ab7e803bd39995=
051a94c9
        new failure (last pass: v4.4.293-43-gab8faa58fa97d)
        1 lines

    2021-12-04T14:42:54.572025  / #
    2021-12-04T14:42:54.572757   #
    2021-12-04T14:42:54.675833  / # #
    2021-12-04T14:42:54.676302  =

    2021-12-04T14:42:54.777541  / # #export SHELL=3D/bin/sh
    2021-12-04T14:42:54.777875  =

    2021-12-04T14:42:54.879010  / # export SHELL=3D/bin/sh. /lava-1189525/e=
nvironment
    2021-12-04T14:42:54.879365  =

    2021-12-04T14:42:54.980477  / # . /lava-1189525/environment/lava-118952=
5/bin/lava-test-runner /lava-1189525/0
    2021-12-04T14:42:54.981390   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab7e803bd3999=
5051a94cb
        new failure (last pass: v4.4.293-43-gab8faa58fa97d)
        29 lines

    2021-12-04T14:42:55.497576  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-04T14:42:55.503702  kern  :emerg : Process udevd (pid: 112, sta=
ck limit =3D 0xcb99a218)
    2021-12-04T14:42:55.507957  kern  :emerg : Stack: (0xcb99bcf8 to 0xcb99=
c000)
    2021-12-04T14:42:55.516136  kern  :emerg : bce0:                       =
                                bf02bdc4 60000013   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61ab7ebf712addc2db1a949f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
3-gb9df7527f7e33/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
3-gb9df7527f7e33/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab7ebf712addc=
2db1a94a2
        failing since 3 days (last pass: v4.4.293-33-g845bf34b777ca, first =
fail: v4.4.293-33-gfe2c5280cbbe0)
        2 lines

    2021-12-04T14:43:50.968538  [   18.859680] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-04T14:43:51.013994  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-12-04T14:43:51.019767  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
