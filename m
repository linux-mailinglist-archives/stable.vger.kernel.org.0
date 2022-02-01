Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D754A6113
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 17:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240867AbiBAQLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 11:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240889AbiBAQLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 11:11:40 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B33C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 08:11:40 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id r59so17541366pjg.4
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 08:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N02a2NmClloOhkqBJZlLZl1YqkAhiNGJF46vOjTsFJc=;
        b=WV7U0+QHF2jEkA5GIPYO4poEa602IrdI7Pr65446HRj+Q0ZYkg2gfXp1od5m63s1m5
         Ss0o5XEvpH3w5wgsAnupuPJdJEp7cDjSV2jzhUidxVPFbUTRVpmuBg4k5CvKgFdGR2R2
         N3e16hJp6ggLSBMBSYuptGm2cgwTizRhyYbVXZtG1VxGrMTDaBBPrxMiS2S0rT9CUZAI
         Gq1J60CXjnvi9eM+1nycgXSFTzUrfFHMw8UV1uiN1lQt7DsFoH75xwlv3xXzaSvwPfQM
         9RZS20b1qqW0hvIZnRNpmo/xpNR63d6+DDPv0pazKtq6oig+1crAP3THdmOFag4Be7zf
         dRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N02a2NmClloOhkqBJZlLZl1YqkAhiNGJF46vOjTsFJc=;
        b=uj0FeBey376zGTIyk42cuSjqOtRuIQz9YrBESJqz0dicqFafXCR5zf3LknqXDZn9em
         I+4FB2pOzAhKMWIpI0GRweS8MQbYkGcbJdIFXKK9aEkPlpI5enmVNO5OFrw9VAoHa8/i
         EbB8LgBDRrOsccm0l/t991xmaZd7SBmIW2pM7w2X53Dk8HuoOjMmLOf57B+xR2CRvTAA
         q1xUOlzdfS2yvFxkj0NLaSJu9GIycAnrDrl0G78Vt/abMlaSkJP+Ph69afpmX+e8F2wf
         pNXT+2hpM6eSwldyLJoozTddJlIPbJg4uz0uDoD2jNFVRzXXZCEIFGJPdR7PqUeNsLoM
         P5zA==
X-Gm-Message-State: AOAM5331dvt+47dUHOcotW3AaO/P4S36dd8inQFn3hoi1hQ+3ZK5/DrR
        oYw94EGjYAFUUnM4gUcF7ITilXDYxgawIaZ7
X-Google-Smtp-Source: ABdhPJyZF7WRuokgClp8XXSl90SmbrzhdjCXkx/e0hl+DQhiAjmgrHNTOeY8GNKPjuvkIP1PCAEs7A==
X-Received: by 2002:a17:90b:4c8e:: with SMTP id my14mr3092274pjb.243.1643731899949;
        Tue, 01 Feb 2022 08:11:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k16sm23848841pfu.140.2022.02.01.08.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 08:11:39 -0800 (PST)
Message-ID: <61f95bbb.1c69fb81.99b8d.e029@mx.google.com>
Date:   Tue, 01 Feb 2022 08:11:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.175-63-g06a1c9d6fcbb
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 176 runs,
 4 regressions (v5.4.175-63-g06a1c9d6fcbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 176 runs, 4 regressions (v5.4.175-63-g06a1c9d=
6fcbb)

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
el/v5.4.175-63-g06a1c9d6fcbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.175-63-g06a1c9d6fcbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06a1c9d6fcbb947c26006f098fa69c10955beea7 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f9272f6c9402803d5d6efe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
3-g06a1c9d6fcbb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
3-g06a1c9d6fcbb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f9272f6c9402803d5d6=
eff
        failing since 47 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f926f9c1e4f884405d6efe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
3-g06a1c9d6fcbb/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
3-g06a1c9d6fcbb/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f926f9c1e4f884405d6=
eff
        failing since 47 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f926ef8adcfea9425d6f40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
3-g06a1c9d6fcbb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
3-g06a1c9d6fcbb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f926ef8adcfea9425d6=
f41
        failing since 47 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f926f55ed7c829f95d6eed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
3-g06a1c9d6fcbb/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
3-g06a1c9d6fcbb/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f926f55ed7c829f95d6=
eee
        failing since 47 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
