Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DE845DE95
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 17:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhKYQZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 11:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349922AbhKYQXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 11:23:22 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89530C061792
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 08:09:31 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id x7so5508874pjn.0
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 08:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X30UP1/pedisYQ8h+o1VUi4R65Q7UbDKbHGFUwKoLz0=;
        b=JEPXCfBFywaRq1aksEBuBaS7Hceo72GP7FKd+oIrTdYbJGmr37C4h8ii7sH6x3aqAB
         0VhxQq+GTEQc8O6e7lsUrQ22Sby+GlPTN5OaiJsQd5h9mQu0n1DmVUr0MdbgBXwtJR66
         kBJkYWo//YI6Ck5XoMS5e3OMOAhEXkuW5NggUi2+cj3MlWHKQtfSt0s9HYsVti9RDzn0
         ceqX4NrI5kby3YTzpn78LXSbJwu7wPAGglACk6RfyQj0h7+RvXKJ/UbtTF4CX0mzBKnh
         aQS4usTOTu2CzjT40bJAJnqbatrXUMBqKSXkCPzlzVoTYO+hmMnSySMZjBnNpFZczgCt
         3YCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X30UP1/pedisYQ8h+o1VUi4R65Q7UbDKbHGFUwKoLz0=;
        b=aRqNyKMqqLokggSXazXEqwgR/WAmcpn1ocPv78EO3Ei8cltshUWENodw39UC7F9svh
         nmzAaAThDnApWRXEJzUFQgIgEleUwK/WYPcrc+MNco+a4Y3mPsweGaVAmuHsGOutraQX
         K7z0XWaXs4b9h9bQo+7UXh7W5sgtcKQK7j8X51dnVs6IcPdw7u145MxqtE8v8YuL5dse
         xMrlWocdUg67RBHRN2HWAz4xzRvC9ftfBfTwQAaZ8iQkB5ZaUzW9qR5C4CTT96KM4o3V
         x3ZgK5yAc7XnC18f9zysfm7/xdMWcsKqdZyUlDW6FYdgiWJwnT3mNPSx3zj2XLlDv0do
         +EYA==
X-Gm-Message-State: AOAM530pfdoPjwTx+ulQVbjXB5nOtl77Ve0mQ0P25MLabKjZtBSme771
        OOj69hPYn3KR0itwxvGnpElYBvbIyjixgnf96sw=
X-Google-Smtp-Source: ABdhPJx5g9T7DDnJev1uoMi81ldiGBl+k74UcZlDjwIbd4ViawPaFj8ZOcWYWrnCXiysCn+KcLVFjQ==
X-Received: by 2002:a17:90a:1a55:: with SMTP id 21mr8415503pjl.240.1637856569770;
        Thu, 25 Nov 2021 08:09:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t4sm3538595pfj.168.2021.11.25.08.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 08:09:29 -0800 (PST)
Message-ID: <619fb539.1c69fb81.33498.93cd@mx.google.com>
Date:   Thu, 25 Nov 2021 08:09:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-160-g4d766382518e6
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 103 runs,
 1 regressions (v4.4.292-160-g4d766382518e6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 103 runs, 1 regressions (v4.4.292-160-g4d7663=
82518e6)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-160-g4d766382518e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-160-g4d766382518e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d766382518e687f4bdb0d4ce32b6b8a4da7a706 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619f7e60995997bc57f2efca

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-g4d766382518e6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-g4d766382518e6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619f7e60995997b=
c57f2efcd
        new failure (last pass: v4.4.292-160-geb7fba21283a)
        2 lines

    2021-11-25T12:15:08.835401  [   19.059265] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T12:15:08.878683  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/115
    2021-11-25T12:15:08.887279  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-25T12:15:08.910834  [   19.128601] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-11-25T12:15:08.911309  + set +x   =

 =20
