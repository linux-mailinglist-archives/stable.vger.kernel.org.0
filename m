Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C854AAC2D
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 20:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiBETCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 14:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243624AbiBETCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 14:02:55 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79743C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 11:02:54 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id c9so7970299plg.11
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 11:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=chPRUoQMjv4OUY8w4xn5TVdK8tzNATumtKz6Ho7rn6Y=;
        b=4G/SV/5dLJkx7M9tJG2IXUosTDRjWUxJ+eaBSMsiwMdKURIay1TzH1hBm75b7XRSDU
         S8eNqzWWCxs9PWsdwG/Q04xTdgID9C9+yv5B8lRl1Ya6AJaBC5vlZZTW5FMF2/+POxRl
         /9XhxsEVnt+4x50PaqGXqpDeogR6IXpivcn3Nmv9jkgtWzlIpzR6PE+20UTj8HCd9q5n
         IjNKOHihU5akyCalbDx1oVgwG0tj/NZnyAhcIXAz6rN3G/bobqWtfYVjQLLVbK2CG5Z4
         EF2bcRY/F8Jww8Jpd5GiVznpgsqLf3ctsRQS4OY2dJ7siP3gHhGnhwzUoJZXJp318XKw
         CLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=chPRUoQMjv4OUY8w4xn5TVdK8tzNATumtKz6Ho7rn6Y=;
        b=hkmwVpnxRduADKZHF8eNxq8StdiIoBkOcD1kWJN/P157zhVxSRWuhjDLUzrwvFGF7Q
         ASnbwu3ioaMPKfGX4BAexXCYSOdw28ex/pNndhrm+5AuWkmkWIYfOmVL0Yah/YCREPdM
         nkIxp4CncNwS5c0sFafISsbr/34lz87nsoa1UA8ZIwK8w/5zR2DsaQs/NzpzDmMI3Wni
         WijzYD5ayy/+f2pBZh7xSShnjHa/ynW2tlktTaosHZ+rjfnLAZCWiTg/ti/PycJC3Z2N
         0ET41VtmaEQKvaRRHg4N2UaEVPl0HqB779bHAb60W5eU6pjsbc/ZY53/I2tvDfN7TxLp
         G1eQ==
X-Gm-Message-State: AOAM5314E6b1WuM7B3/HrpjXuC6+qN7MRcGuNzKi47HaFprqUOXhmf68
        eFq5o+6QBPJ0qVFYFH2PWdQ/xLQSILAl7sjL
X-Google-Smtp-Source: ABdhPJwdjcSGNbl0uurfmKRfZNs9d4fyJELZ4wTiJNQZJz/4LqcXrWeaK5fqJcVUkpYHNywGrvt3sA==
X-Received: by 2002:a17:902:d4c6:: with SMTP id o6mr8969538plg.83.1644087773845;
        Sat, 05 Feb 2022 11:02:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bt6sm16056328pjb.3.2022.02.05.11.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 11:02:53 -0800 (PST)
Message-ID: <61fec9dd.1c69fb81.419e2.a60a@mx.google.com>
Date:   Sat, 05 Feb 2022 11:02:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.177
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 153 runs, 4 regressions (v5.4.177)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 153 runs, 4 regressions (v5.4.177)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.177/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.177
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b8f53f91712808313bf7b5bd9947d7095968248a =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fe90eaa54356d8395d6f11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.177/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.177/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe90eaa54356d8395d6=
f12
        failing since 50 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fe90cd996a6a39935d6ef2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.177/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.177/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe90cd996a6a39935d6=
ef3
        failing since 50 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fe9115941cb154715d6f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.177/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.177/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe9115941cb154715d6=
f1b
        failing since 50 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fe90f5a54356d8395d6f2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.177/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.177/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe90f5a54356d8395d6=
f2b
        failing since 50 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
