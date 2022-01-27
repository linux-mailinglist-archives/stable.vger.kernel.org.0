Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A038D49E604
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiA0P1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237542AbiA0P1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:27:25 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C56DC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:27:24 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so3297249pjb.3
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DVOhF5emJL0WIGbSSUphLDaiFzzTeensP3swIpXT7G8=;
        b=GlpKwC5YmsGo6AbnG2iwE3EF3fRbhIRVUSz/5aiQTRAby0aUD5wEGh34WCsZF8hY1V
         53Y2hQOgYUkS5aXUn2+7dG92RKRZMjeB21beh8vEx4D4Op6GHGmGL7uB+07pOqa8oYvT
         kLNb+/0/Pd/E5jlw40iRIeWzWWkGCqCVTnPKOa1CB34YBKcjoWJFke03VCsCu/N8d5V4
         XSRgI/ewRs4A2/83ATrY0/z5dAyDtO57osKF+FtCvVOXl8eYhpDbQTfsHkaqC4DiTZWu
         ehAY5Q2QMOiDzfX5SZPSUMN1jnDrbZXWV/WFSF1nTegmZfHd743iHhE4BfGxP5YvrYi7
         UBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DVOhF5emJL0WIGbSSUphLDaiFzzTeensP3swIpXT7G8=;
        b=VManTadaTcEs/QfNFiI88R2gHqI7boVP5CVvejL3bVu4lTwdIL6IXrvgkunx8Bl7W7
         urSBvsfXQJbuGByJciz66Xe8oszTTFeLJsDBOXWYRVl5uGoyVp26wZ9iO+q0IXfIEb6b
         l13uLKWL6hfsAUgQOE8FwKEPl1HjSUTv0VhHdwherlxzYGe2/HX4HrAqggWciah6Ge0S
         54qIT4IW8V9uY7PtwBoYEaFYXId8j/cdjyu8DELYo1ZaSZ/m3/eNzYMLdVyM/qrurY11
         eEVQmIiydaRpI6/MOv5eXi9W3sTcHf+K0Qnt6pu743V+r8S1OHnZBBUx2AOThrt2znRa
         8CyQ==
X-Gm-Message-State: AOAM532Q8odX3uzPBQijNh+vyFd/dT1s4tbzdqhIWCj10h+IhBdu6zyu
        85fhZ4Ze6CMQODNij//Mk8CY6XIvrc0zYWzk7Rs=
X-Google-Smtp-Source: ABdhPJyHLpa8tg/k2YCyImBT9o/HZHCDnA9XUX4rQw8QVA/4GNvyTptLfzKxxuiFPTapbm3prRTj/A==
X-Received: by 2002:a17:903:2446:: with SMTP id l6mr4052522pls.48.1643297243500;
        Thu, 27 Jan 2022 07:27:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q140sm20404595pgq.7.2022.01.27.07.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:27:23 -0800 (PST)
Message-ID: <61f2b9db.1c69fb81.ae63d.8728@mx.google.com>
Date:   Thu, 27 Jan 2022 07:27:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.174
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 183 runs, 4 regressions (v5.4.174)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 183 runs, 4 regressions (v5.4.174)

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
v5.4.174/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.174
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      411d8da1c84369f4d4eef7dd55766dffc0a169fd =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f2817a0ce0c171fbabbd3e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.174/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.174/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f2817a0ce0c171fbabb=
d3f
        failing since 41 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f28170d3da46af04abbd1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.174/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.174/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f28170d3da46af04abb=
d1d
        failing since 41 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f2817972c64cda9babbd4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.174/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.174/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f2817972c64cda9babb=
d4e
        failing since 41 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f2816fd3da46af04abbd19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.174/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.174/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f2816fd3da46af04abb=
d1a
        failing since 41 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
