Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8E432DA2C
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 20:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhCDTO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 14:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbhCDTOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 14:14:23 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC67C061760
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 11:13:42 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y67so1769511pfb.2
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 11:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mV2AqSSN1t85JoPGZn42Mzxb1nlJ8QfaLJd+WQUnxbY=;
        b=1/QSxx/da7TnDQaFId+3hnefx/YYhHdP120u0zIUhY4P4tEVaZ8waawvnYdfb+7pBh
         qvhTAZ+OTZtIgOSPXAcZrHnY72mBf/KLwZYHtuDGk4R5OK6WOCxlB3D9VfBBYMFBMZ1d
         w8dNWJeQT4+xXZTj0rURIWloU1s09x55xxNKnqgDk0l8W1XzTAcnOaG7EC+oCqAJ6XSc
         eiWxAlx3ePQaqX4DuaUT4pEBj0F5csBw6+UT9VUhc93UZzruQygxr27QLgu7qsNm7e6J
         Hy0Na96m2q1qFFVaNemTKaSC5VO+Y4/NVun/15k3lQgB5yIua7F6N0HWF+ZdhngU1IjS
         6QAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mV2AqSSN1t85JoPGZn42Mzxb1nlJ8QfaLJd+WQUnxbY=;
        b=kjI6VtJIrlg0QLshbrVhEz3BDgKazquw1eqtLq8E7xj9OvjPcIYMVLo8m2ZdQ+vkTA
         y7BUfUpiZLfz9fYAZX//oQDm4aIrOxBmx5jCR7EByeUThxsMgTJ3p7wJK1YzWc5ryvCg
         Ev5H++eibaPJhSi1qNI1+rtP2UW4TOiw7A65ZLMpwe3Ox56X3gFHNxMMNfOy19c00Lm6
         sSrzgODP1qJuM8PUPlsCnvTv0zFgcKOfohGNijBkZfGVaM9JgZfm87KMSn7Erc5qqS6x
         yjeIaPJpJC2doIaPYSwRNI7VKPs7aLbyjnFpfcCnJF1uE9yfbgfL/wRZwl/1/aaxS2ng
         AwzA==
X-Gm-Message-State: AOAM533kjFJpvz5lEY0GV5qR4JzhKzo7EE2lGg1LRj3v3PV6pRlzYebg
        Hzbc350D9W5pJCtG588s1eQ80fmjgKEcrgK+
X-Google-Smtp-Source: ABdhPJxe8Za3ReiwaVPKgoWmUQijZzAitdrDqP8/fTj8Jme2+pqRwP0pZkWnvxIZGQGp3rH5c+HRew==
X-Received: by 2002:a63:465d:: with SMTP id v29mr4787150pgk.225.1614885221858;
        Thu, 04 Mar 2021 11:13:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s1sm43966pjo.36.2021.03.04.11.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 11:13:41 -0800 (PST)
Message-ID: <60413165.1c69fb81.11aec.0325@mx.google.com>
Date:   Thu, 04 Mar 2021 11:13:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-17-gcdbd413fa275
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 111 runs,
 4 regressions (v5.4.102-17-gcdbd413fa275)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 111 runs, 4 regressions (v5.4.102-17-gcdbd413=
fa275)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-17-gcdbd413fa275/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-17-gcdbd413fa275
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cdbd413fa275e42408a83c2339f65c990c8bbd7a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041252846d57607daaddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-1=
7-gcdbd413fa275/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-1=
7-gcdbd413fa275/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041252846d57607daadd=
cc7
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040fdb4719307055caddcd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-1=
7-gcdbd413fa275/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-1=
7-gcdbd413fa275/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040fdb4719307055cadd=
cd5
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040fd6231bd056c1caddd1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-1=
7-gcdbd413fa275/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-1=
7-gcdbd413fa275/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040fd6231bd056c1cadd=
d20
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604128361cbaa73fb5addcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-1=
7-gcdbd413fa275/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-1=
7-gcdbd413fa275/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604128361cbaa73fb5add=
cca
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
