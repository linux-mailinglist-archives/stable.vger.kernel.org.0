Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883494892E1
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241670AbiAJH6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241668AbiAJH5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:57:24 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD47C0253AF
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 23:48:26 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x27so1279863pfu.3
        for <stable@vger.kernel.org>; Sun, 09 Jan 2022 23:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fom0Wxx8o9etrPiQWIj1WegD4Q7aV5YiwYP3NRu12UE=;
        b=RpWG8ZuEa9H+vq6ld1S0SXVlDyD5RcyXXa3nhf93/28EwISsnuFSi50MFBe+kwhUWe
         YYVNUsFfauJNxZWz6y8F/QuJcMDvqsw2wKvwr1EyrXH1EApm6ZaiPIFFrRqMxCLhcIXD
         +aGPNlkKa/RBdJzhNSttWsEhfFUgQ5wGnBOTvzx8jbYV4Z4MsFfvrcCnZcnvfMUUV7yr
         5RNd3qF8dhTxWDnv/bn7LOyOsg6nxzL3RijPiJQzwIYMW24f56mRM12q0jau97W4Ulbi
         cAFxFPIYX8XS9Pla2GofardmZSUf0K7n8PGYvX6l4266WkPxaINvsouD38/5AxxCY5K0
         gF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fom0Wxx8o9etrPiQWIj1WegD4Q7aV5YiwYP3NRu12UE=;
        b=q6J9blOWo+XEBLN3/xfQdyaxnoEH7t5AfpQ2fd0GR1Z018KsB6sX1ycmw6I+Q5A7tc
         vLXRMzqdCJD9rpSPc8sEg4BtkxnaUylcWKWMUmTBw88D40nUGw+DmS02DPOi2zKae6dj
         uSQb01k2bqRuYM2is3kVDH21b9DhixYujOCOu41Pssp1J4lWPtBV7y2CUPl5ZTdmTGqY
         e7mrjmG42Cn7PBLphFTg4yg29ooR7hcIRCTWtQe9gQCIHkHT9nAVlI4+yrSYcm9+TUIM
         yKxfhuq9srT5MJcWT2x1pIM8t04uGczFyWYu1QnT3X+msHHxFbtFFchAlEPJjcc/u7P+
         faaw==
X-Gm-Message-State: AOAM531LJcGbWlyqWfc0eSQVA9TNpyrzogROU30sOYexONMwGeETYQJY
        aozdH2peg7kwpCEgNi53gg6MoiFXCFrAVrpF
X-Google-Smtp-Source: ABdhPJwCTud3fqLXMPAXqRDCm8l7XLQvTbxvBfdsVLOHaJV3T3sq3/YXavjDBtQVQBzydcxVkUor1w==
X-Received: by 2002:a63:3852:: with SMTP id h18mr537030pgn.512.1641800905666;
        Sun, 09 Jan 2022 23:48:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mw7sm8655260pjb.45.2022.01.09.23.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 23:48:25 -0800 (PST)
Message-ID: <61dbe4c9.1c69fb81.66d78.68ea@mx.google.com>
Date:   Sun, 09 Jan 2022 23:48:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.170-34-gdd5012b3788c
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 167 runs,
 4 regressions (v5.4.170-34-gdd5012b3788c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 167 runs, 4 regressions (v5.4.170-34-gdd5012b=
3788c)

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
el/v5.4.170-34-gdd5012b3788c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.170-34-gdd5012b3788c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd5012b3788cb0d3a63202fb6829647c0a754398 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dbb0e696a591dc09ef6750

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gdd5012b3788c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gdd5012b3788c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dbb0e696a591dc09ef6=
751
        failing since 25 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dbb10354b93e5cd6ef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gdd5012b3788c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gdd5012b3788c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dbb10354b93e5cd6ef6=
73e
        failing since 25 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dbb0e596a591dc09ef674c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gdd5012b3788c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gdd5012b3788c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dbb0e596a591dc09ef6=
74d
        failing since 25 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dbb10096a591dc09ef679e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gdd5012b3788c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gdd5012b3788c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dbb10096a591dc09ef6=
79f
        failing since 25 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
