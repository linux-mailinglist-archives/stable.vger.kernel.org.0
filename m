Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D412748FEAB
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 20:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbiAPT3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 14:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiAPT3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 14:29:53 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA43C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 11:29:53 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id g2so7870971pgo.9
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 11:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tGRX4xdibZy8KILGvral5iJ5f2Hz3ucK9cBx0PPGR0s=;
        b=GxkY9fv3ye/KTFPzd94ZDmTiOQ/PVhgjSZ0ROiO2W2b6cQoq2VCq9OOdBhXmDtmIle
         7CjItJxDz3DBI3rqyFwtiOG0MjMQ3th7OecI5videbMp2Iyd3UHRVhKtIkmJcNt1+rS4
         9qu1hF6Qk/+pkqIzFK3ZDDdAKo4CAskkqUu1tLMuBE8fJOzGjT5ysVug1f25uvhHkHIW
         zJbMSFfL+VwibAGSL+9Ws0DTD347w7ltpAKAeYC/2ZzShUHEzZxjpJ432Y/TeCSwrGX2
         pOtKbC2ZbFaySiJViw0u9tPYdokPj1uiKXdqRkS6Zw5uoxB2zX8qvcrmMRFeHk38+24g
         8aEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tGRX4xdibZy8KILGvral5iJ5f2Hz3ucK9cBx0PPGR0s=;
        b=K2Os+mr4rpD1u/+Y3gOWz5mITQYozm/bay+f0Qew5ZgPX/Aj6GHW+aJL9ntax736c4
         35d5opMl3avoTwaJAp6I5wsTQUsGhPkuejaUtW8cQ6Tylkyth68dGD9VbAgBvMSO2yO8
         MO8SBu6G055JsNWIeN/q4xg28ue2wwJaMzsDGI0w7jzDCQ5Lyw+6Tt2fmWnxHPDfSdN+
         ZZB2sdJ9FPBCCe1hEtwnqL9VCkSb2ooOwcyjMApJ3OOzTR3jDjD8BgD7lvUeqctZRCAy
         4zS8p/myrK9aOjxjMpN8yBpveRMTnQCGhyDDJqFSVcJm6fpeTB1XwlO7ioaDe1q4syVz
         Pd4A==
X-Gm-Message-State: AOAM531f/ooqO0L7fbq6rKfGTB2HekPZXmfj8Mzr05m3fOjNJqT4x1d0
        uGUwsHtHqBrAOKy3UOe2wl7gb23CsTkAMW8T
X-Google-Smtp-Source: ABdhPJxR+FmncOWozXs/Rvy6VJSMWyT7bpa4A55/j1i9772cwEW9uSia3curAEZ/4AvdDvQ0SxzCHQ==
X-Received: by 2002:a05:6a00:841:b0:4bf:325:de2f with SMTP id q1-20020a056a00084100b004bf0325de2fmr17766504pfk.7.1642361393233;
        Sun, 16 Jan 2022 11:29:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oc3sm11557254pjb.20.2022.01.16.11.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 11:29:52 -0800 (PST)
Message-ID: <61e47230.1c69fb81.97152.fa06@mx.google.com>
Date:   Sun, 16 Jan 2022 11:29:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.172
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 179 runs, 4 regressions (v5.4.172)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 179 runs, 4 regressions (v5.4.172)

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
v5.4.172/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.172
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b7f70762d1584a2b66e056412fd39ad6f6344c89 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e440a75a21cddad9ef6748

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.172/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.172/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e440a75a21cddad9ef6=
749
        failing since 30 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e440ba5a21cddad9ef6759

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.172/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.172/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e440ba5a21cddad9ef6=
75a
        failing since 30 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e440a66275144e78ef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.172/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.172/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e440a66275144e78ef6=
73e
        failing since 30 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e440b75a21cddad9ef6753

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.172/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.172/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e440b75a21cddad9ef6=
754
        failing since 30 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
