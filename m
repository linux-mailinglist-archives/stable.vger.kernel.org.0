Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D3F491085
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 19:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiAQS4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 13:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbiAQS4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 13:56:47 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1D0C061574
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 10:56:47 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id hv15so21192758pjb.5
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 10:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mcqwfMMvcMPEBsr9XQDHmCKGUsFnrkGSIJrcYcMV8mg=;
        b=ILOb79QiHtRU1QHGJhUarVpMj4Q/PS+suQyIXmZFLFTmf+i1QnvJ/UfB1LVJEbbQcb
         UwJCr69DQHIV1PKmYGMzBdc42fSuTNw6gyFeP4cA+Rg0lWjDJaHIZ7bO9PSE4lfr/SmC
         1iVtFE33xolkTH0L5xtb+sm8e756sx5c+8IJd497y0TgMSKp7nFQjdJIVaOuvxQKM4Qu
         kIq9M0UKNsvas05S2EtO/GHcXfz0vVDzk4XuR71Nh4f9lHq4/WI3kO6JpDr9eLnE/Rhp
         wJ5TKjzTWeCLuXQ8ryHl2GLa2QdTM/lJhNE7UblcJn9JWpa3QyOB65HtJb7TtH/Xmsx0
         27bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mcqwfMMvcMPEBsr9XQDHmCKGUsFnrkGSIJrcYcMV8mg=;
        b=pzDYJqW4YPDi/Z9oezG9Q4Il4S5wNsvMDYpX89zI/BjVLDtjfrgNvSRv2kQq9voFm+
         bIXaXx7FDh5Dvxq/dPEbbUmm3wMWJEQi6tK2UTFNomJBuVUdk2d5o5ZIWOQC+I/0lrKe
         JmJfVyLdx8s7s/dl432l8vU2MCVewORDX6prfGrs34EO5DllGN3eRB5hNguSFxTtkX1U
         /S18n3BXbcFK6kwUucToGXnAYEFOd5C1ClNPUb2xMZS33GQZPVPjEuw90iNt+/I5MLvE
         wQCtHZy4cNEcMopdt4g3SAaEfZOC2LAV+zFCyrk/iEYG7bUHv5/Q4QiocIwu8wMP+p09
         mESA==
X-Gm-Message-State: AOAM532S/YMFLlh5nG+OhKq/ufRFdxc+bylggiekhhYi63kQsKKbLplz
        zqVuLxHa/mhMtXtjVoMhNYath3O08UosbRLu
X-Google-Smtp-Source: ABdhPJyPaTPDTBmv3RVRUKbTrZAx0GcFtDuwdk6POtHel+8eGYYwbh7t05eowqf2Yc5x9NAUWeecfQ==
X-Received: by 2002:a17:90b:1c91:: with SMTP id oo17mr36097523pjb.58.1642445807188;
        Mon, 17 Jan 2022 10:56:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d5sm15227475pfj.188.2022.01.17.10.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 10:56:46 -0800 (PST)
Message-ID: <61e5bbee.1c69fb81.cf197.892d@mx.google.com>
Date:   Mon, 17 Jan 2022 10:56:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-21-ga69854f3bb39
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 115 runs,
 4 regressions (v5.4.171-21-ga69854f3bb39)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 115 runs, 4 regressions (v5.4.171-21-ga69854f=
3bb39)

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
el/v5.4.171-21-ga69854f3bb39/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-21-ga69854f3bb39
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a69854f3bb39f34bc8cbd301103a06a0b0810104 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e587482feb9a20f3ef676b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-ga69854f3bb39/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-ga69854f3bb39/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e587482feb9a20f3ef6=
76c
        failing since 32 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e587312c26012b46ef6765

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-ga69854f3bb39/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-ga69854f3bb39/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e587312c26012b46ef6=
766
        failing since 32 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e58718cfbef98f43ef674c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-ga69854f3bb39/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-ga69854f3bb39/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e58718cfbef98f43ef6=
74d
        failing since 32 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e587302c26012b46ef6762

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-ga69854f3bb39/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-ga69854f3bb39/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e587302c26012b46ef6=
763
        failing since 32 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
