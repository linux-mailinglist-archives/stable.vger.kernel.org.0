Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3311D48F224
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 22:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiANVyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 16:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiANVym (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 16:54:42 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A5DC061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 13:54:42 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id h23so3792038pgk.11
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 13:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JUvavF4Au0B/D0ui7t83rsL7VIwEEJfqrDYmBpF3Clk=;
        b=fkRJLnmErTpkgIAqS118yzPQbgTKImc8sj/SsFQqbieRx24ID+L3l4713Dt5cmccs+
         0N8a/9vr9dFldyjBbRrd8dARLQM0S2yQm1k3e80GkthB9HNoEWgQMXGJJL9trb9hOWyu
         ek74ecC/Hn4CqeGUpMK32DgoLgcTp769j5z8JYfQNLuzb6ZTWNUeNCmSgXEWwN0bETnW
         /LoewapN2A1z2gsYkD9SscnyDGSTLh8+4igFtaDSmnkZUYsIJ5l1Ri2RZEdFJVJX+ER8
         4hgrBdKd0lzbC567w90LD7Zqp9buvnzyh+qbF4nAopsTfBcvQdXu2ggQXt+Jd+IXUmWh
         W+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JUvavF4Au0B/D0ui7t83rsL7VIwEEJfqrDYmBpF3Clk=;
        b=dAAWCrFEiL/bo/EJueeNP/LVfwhBlB0bF5nlA3MzYaWV3ydPtIIDsvRgwKK2eV95hy
         4CnoXH8mMcj/z6ge6Ofh6U8aTK4FI2/sgsg3a012EMJSHENSioH9ZxmR/IQerusixW6Y
         HuQdpeM23eX9nr10yCgCG6TTHs2F1H4X9sKyEbDkEg4HaQEK9oWS/jvSzPANA3pLN4GV
         gilOqt+1tXwIEB/mbRRarg/qrYD7mPUwdp70xsG4k7VCfXBvUNhRjaUeGK51ED9pxWBI
         hH6iqI9etgZif1vNcJw5uTiW+5YlZZcu+tNSUhwUkYaTRWrBIqAoF+XfSg5Wd9UGojA9
         RsGg==
X-Gm-Message-State: AOAM533fS6OMXdKbFSX3+iV7biR6mtrdi7lVPew5XUZhToWzQwgtC9+7
        /AlcwizPoTOUR3pA2zV+FlhuT9xSitxiJto+
X-Google-Smtp-Source: ABdhPJxrO7Bb77zQtPiWSJwpa7duWK9Zjg7ZTOpX6myw9rzMMPpW5H0OxTSbGZvkLRTNgwRsxFG6Gg==
X-Received: by 2002:a63:9b01:: with SMTP id r1mr9571256pgd.263.1642197281828;
        Fri, 14 Jan 2022 13:54:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q19sm7071140pfk.131.2022.01.14.13.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 13:54:41 -0800 (PST)
Message-ID: <61e1f121.1c69fb81.5963f.4cf6@mx.google.com>
Date:   Fri, 14 Jan 2022 13:54:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-18-ge46ad2a98f9f
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 150 runs,
 4 regressions (v5.4.171-18-ge46ad2a98f9f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 150 runs, 4 regressions (v5.4.171-18-ge46ad2a=
98f9f)

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
el/v5.4.171-18-ge46ad2a98f9f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-18-ge46ad2a98f9f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e46ad2a98f9fe5085df1de33aaf820858fdab71d =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e1bce7e80d84eee9ef674e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-ge46ad2a98f9f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-ge46ad2a98f9f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e1bce7e80d84eee9ef6=
74f
        failing since 29 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e1bcf1321b18873def6755

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-ge46ad2a98f9f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-ge46ad2a98f9f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e1bcf1321b18873def6=
756
        failing since 29 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e1bccd8dec55274fef6779

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-ge46ad2a98f9f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-ge46ad2a98f9f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e1bccd8dec55274fef6=
77a
        failing since 29 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e1bcc898c2eeabffef674b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-ge46ad2a98f9f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-ge46ad2a98f9f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e1bcc898c2eeabffef6=
74c
        failing since 29 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
