Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C14349ACDC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 08:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376703AbiAYHE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 02:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S248878AbiAYECo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 23:02:44 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0085CC0617A7
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 16:40:20 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so600371pjt.5
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 16:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N8Es+PPrxyrr7mBmb3ZC85ZFQTl/cPjQ8/mvpUd+lPo=;
        b=c5UNaEpQ6N2elUpicVg73h2ixJwEhRN8AlaMCSHMUgTSyVoKskRs1Oc8teZw0btcxD
         CPvItTK+LTqhYeGwyK9+J7mxgHnn6+yGaPYo/3FUVsda0JMPt/X/As8CdQjfmuhLbXdk
         LNmadgNRnAK8WGNI/XaQS4N4wcoPjANP0Z5M+CcUZTVID6VqNTqsejXwwnIdSNPApEja
         fmaoaobWHDusFgjsKrO4gQezwEOaJoQCycavbD8MWMfoYEuKevgEHgtfzOQlGlOxc/gd
         lQc6h2UnD+ZtuJgSCMBEYHkM6QGLlaLaxmj5MdfK6VieXbO0eHjO+dJnthQw3+I9+SbJ
         lzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N8Es+PPrxyrr7mBmb3ZC85ZFQTl/cPjQ8/mvpUd+lPo=;
        b=ZXBFGURlEov/zGoCteW8mnBUGt+UMy/jbYJDewc1TsCBeK8Mu7nXsli51xfoijGIKv
         UGC4Bu0+ZsC9uaOFtHp6jK1d+yvKn6SXWxcIrxMAe8eClVZPi7zvA+UwkpF7n1qs2AR4
         FSBD0krLbarSlXYb4Mj3cE/HMLVaUUIPQWTv8Gf1g60WnEXxof6D9zmEeU1ffpURshYm
         bTm7sSX85iFa3nOQTwkeWsm071tQzvS9ot6ZgNVbdTgRfMOKzKekq7trra0GxiPQAuzL
         Vumcxsaxo8q+xCjydzgqyp0nbRZ0cijizWywG1F9owVw8kzXH4kKwtDpk88VutcAtFu7
         TDhQ==
X-Gm-Message-State: AOAM531esXC3PArTGd+EcSAyU2k4s81V7C6dRJHbsMfG3JuWhQJhYwH6
        SMLkd4e/FXDp9ABKN0ZJqR0XRrwM4G3KMppe
X-Google-Smtp-Source: ABdhPJxG3MONcKIh/Y0+YutO+J6bAqorJkGukocKWV8X8CQXcsZ7NxU4ymh2W5qKi35slcrGZUmP9Q==
X-Received: by 2002:a17:90a:4482:: with SMTP id t2mr855622pjg.133.1643071220327;
        Mon, 24 Jan 2022 16:40:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l22sm17721255pfc.191.2022.01.24.16.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 16:40:20 -0800 (PST)
Message-ID: <61ef46f4.1c69fb81.a0b39.0450@mx.google.com>
Date:   Mon, 24 Jan 2022 16:40:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173-320-g8b109ad9c84a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 158 runs,
 4 regressions (v5.4.173-320-g8b109ad9c84a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 158 runs, 4 regressions (v5.4.173-320-g8b109a=
d9c84a)

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
el/v5.4.173-320-g8b109ad9c84a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.173-320-g8b109ad9c84a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8b109ad9c84a7fec121f2d2da72901129cc9a715 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef0f0beb9c8b65d2abbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g8b109ad9c84a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g8b109ad9c84a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef0f0beb9c8b65d2abb=
d12
        failing since 39 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef0ef322c6c45fffabbd16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g8b109ad9c84a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g8b109ad9c84a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef0ef322c6c45fffabb=
d17
        failing since 39 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef0f0a22c6c45fffabbd4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g8b109ad9c84a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g8b109ad9c84a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef0f0a22c6c45fffabb=
d4e
        failing since 39 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef0ef0d3d4b14740abbd3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g8b109ad9c84a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g8b109ad9c84a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef0ef0d3d4b14740abb=
d3b
        failing since 39 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
