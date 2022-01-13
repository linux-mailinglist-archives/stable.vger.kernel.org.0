Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8067D48E014
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 23:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbiAMWI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 17:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235036AbiAMWI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 17:08:56 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465DCC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 14:08:56 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id m21so1094826pfd.3
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 14:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/D6lvOmn5U9h3b4DbB/zB69euWg25CPMfxQ55jnq1h4=;
        b=jUdUG4WasHWEIJyKqb9LyULF073H+5XtE9qGAI8tlADAaJiJr47UHTV+9TFVh59GpI
         pBdiC9RCf1E8TRhAnpphS3foECVF86u5yPMnULqyA++zDj1cRKTcjeMVgluQ6C0NgAl6
         PxqFEOt+se6OcfQVCymFi7gmYNfSOa8dS0ArMwkCqE7KODPB6Gkt/uST4dbA47h0ouxf
         PBtNz0ky8gIEiyCI1HRH+AKtPrB4742FivMEm76w64nO7tM/blPLp0FUgmwBB2ZPC1Z6
         Taia+n+C5v+sSkM68CM6anvwPerCEA0ZL7OkD0kVlTgphrX+EcyzMRNhJOMrEqbrZQHS
         grmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/D6lvOmn5U9h3b4DbB/zB69euWg25CPMfxQ55jnq1h4=;
        b=Q5Ht7xOnEDQiBgSA9FRPuCt8gycu3kiJPavW58PNUbvJR5raJY57I2xanqwxHVUyiG
         pn6ok1Z9YLuHGwwIywa2Ah7xQSSCBsbF7O4UhvjigMZ0at2AtFuoL77jsZ+F23BnuzjX
         5Cj6uVJ5IEjPd/7GJEKamtVSPrp8wfbUlpN7aTsMPIqw8d9mNYdOw/iv1cGF3WjMwEOi
         9uS41tp3OBO3ZnrICD5dyPmCRhzikNVSgHF5dl4Gr0OqsIoNTrgK7eykZ0YZTUV3wk+k
         MqXuAzx7H+P9FoeNZStq8azvUxqqVYweOswVRnZro+hu5DhaZJ/TjH0sApJizJ9iWAod
         DcCg==
X-Gm-Message-State: AOAM532omr4aIasx58OFgyWaeidiY80A0tt0tCwr3D3VxWdYh9jRCSEo
        dFcchoC362U1LKLeveVgSVR/tdrZKk04GQ2XUoA=
X-Google-Smtp-Source: ABdhPJxV4xlLUkzukySJ/isu2TWtleH7+Bu5nPb7iY7XGoOPNGyepbYdo8/MVp1IyVbuWTBBsdxnFg==
X-Received: by 2002:a05:6a00:1502:b0:4c2:6802:2b28 with SMTP id q2-20020a056a00150200b004c268022b28mr2296577pfu.2.1642111735664;
        Thu, 13 Jan 2022 14:08:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oo15sm10583524pjb.57.2022.01.13.14.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 14:08:55 -0800 (PST)
Message-ID: <61e0a2f7.1c69fb81.42b7e.af36@mx.google.com>
Date:   Thu, 13 Jan 2022 14:08:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-9-gda509762c9cc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 174 runs,
 4 regressions (v5.4.171-9-gda509762c9cc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 174 runs, 4 regressions (v5.4.171-9-gda509762=
c9cc)

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
el/v5.4.171-9-gda509762c9cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-9-gda509762c9cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da509762c9ccb0d5dcd15109721c7ad4b824d174 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e06d8953915727faef6752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-9=
-gda509762c9cc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-9=
-gda509762c9cc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e06d8953915727faef6=
753
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e06da8614fe50363ef674c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-9=
-gda509762c9cc/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-9=
-gda509762c9cc/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e06da8614fe50363ef6=
74d
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e06d8853915727faef674f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-9=
-gda509762c9cc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-9=
-gda509762c9cc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e06d8853915727faef6=
750
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e06da553915727faef6787

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-9=
-gda509762c9cc/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-9=
-gda509762c9cc/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e06da553915727faef6=
788
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
