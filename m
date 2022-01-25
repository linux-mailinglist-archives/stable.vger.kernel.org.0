Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B7849AC98
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 07:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359048AbiAYGrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 01:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358291AbiAYGo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 01:44:56 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2F5C055AA5
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 21:04:20 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t32so17329457pgm.7
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 21:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c0t6doHwBZH6Bw/dBN8fyXc1Gt0YuVi/7gDRszG19fk=;
        b=uk6Hr42gvSfDBqyonWxEH+PYpKPNzc68tzWyo34jmWiIQ1AUWHXO6DqvTnMSvDNxCT
         J/qaHsSkuCoDR5vzB6FAST5bw95GkZLqiEmNGWHtRWnx6xTIGLvWQB7Jhp1CMlmlMxf8
         gC2BFz/NQTMRmCEIuQTxKYqwAM2dFWs3Vet2wV86fxZkHkZiHVjf37hd0+ZElNtFlqLq
         LbXEp6aVclZ1lJEFAJ2Q53eIDs76Pz5BY5RvkIVMYmiXkV995ciDvk3VJ9R9agM/fcdj
         DRwe2fiX/T+bDxK1Z8SG+V512OaMJtzixxPl5LmisxtjttR/Nu7iwohS2nlbsqDkCJRB
         ng6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c0t6doHwBZH6Bw/dBN8fyXc1Gt0YuVi/7gDRszG19fk=;
        b=D8qmFu+6GyV/BCiTWHz0rmp01lcLK+um/gf4HDaX7s2WpaBoa3VKb7lg8RRvQ0oHof
         dOVxB+S0eB3WBoXmnloBlu4dAiR5WZVoeuyQGDKrcDo00TsaKW/2yyznO9UMBWPhthIM
         63Wr+8Xp9w3TNkuk9akfmFYMskuKGHmv/nlmZCuEv84vi+Zi8vVeNOeNtHx+TnNeEkuH
         sXliITQfIvnrdXvyx2+99vipl8uKtZq4N5uO0SXtb+60efcK1yL/Y0FKvHC00MDpIMy8
         Mqs7J6Mx0A7EmuMtzbiUJJA77ZrQ69OcX4UKekztejqftnE84afc/a+T8zE1EBBBadZ0
         TY9g==
X-Gm-Message-State: AOAM530PQxUXRLVe7NX/dgiiRXD3g1sZMWeO6vsg0SAE0s3Spdtxd7QR
        JXsNM2yhvhpxiETOM6ywnS2tTrziLMJhw4V0
X-Google-Smtp-Source: ABdhPJyk/1ho0tU6Lk1BS287YV9Qa5HKxUp5+DYEwB3jci/s5JQ14eB8WMCtvelyD9JkJZA9yaAwxg==
X-Received: by 2002:a63:b545:: with SMTP id u5mr14139499pgo.420.1643087059568;
        Mon, 24 Jan 2022 21:04:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ga21sm1282395pjb.2.2022.01.24.21.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 21:04:19 -0800 (PST)
Message-ID: <61ef84d3.1c69fb81.f1a6f.5645@mx.google.com>
Date:   Mon, 24 Jan 2022 21:04:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173-320-g99c5782e5eaa
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 153 runs,
 4 regressions (v5.4.173-320-g99c5782e5eaa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 153 runs, 4 regressions (v5.4.173-320-g99c578=
2e5eaa)

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
el/v5.4.173-320-g99c5782e5eaa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.173-320-g99c5782e5eaa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99c5782e5eaa72de4b2f92479164a1b0d0304482 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef4ec188c0c3209dabbd29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g99c5782e5eaa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g99c5782e5eaa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef4ec188c0c3209dabb=
d2a
        failing since 40 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef4cdee52e70055cabbd81

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g99c5782e5eaa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g99c5782e5eaa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef4cdee52e70055cabb=
d82
        failing since 40 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef4efec4c582b6e7abbd26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g99c5782e5eaa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g99c5782e5eaa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef4efec4c582b6e7abb=
d27
        failing since 40 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef4cf3ea8458c7dbabbd19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g99c5782e5eaa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
20-g99c5782e5eaa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef4cf3ea8458c7dbabb=
d1a
        failing since 40 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
