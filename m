Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51BC32C844
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377769AbhCDAfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391905AbhCCW62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 17:58:28 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25559C061760
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 14:44:50 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o6so5332824pjf.5
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 14:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gMY7lmYBFxmCOq8ygRQ5Ry8VMn5JEXMALVbWmjA1MeI=;
        b=dDH/YKZ+43NH/1dpJ7APUpPd1xnhM15fyKNNrPZPIkzxVjcP5VmgA7cv0OZYFGec52
         lA4p9wX3dYTeXF9zwNJTjzWiilAeVU/9yhCUDHg3b4nXITOJKaBG8PP3Oy5qspGj+K8s
         O5KHWcGjCdRtUIQga1ma/+WAJeZwYIcT6qe/VdciyQNz8CjzCd8CUHP9TJ7tl89T2WRC
         hKFK8l3FX9aI7XZ7yOOj6nf6ir5T70/X2uMWO0h21h38l8sufrr/pCF3A7ibFEAtlu3x
         8wo9XdsKuc4BN3YU+l6k4wIuyoEPKJ7VWCOHtuBTG28RUs8CJa/V55fHCaQS7NGgcgsc
         BOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gMY7lmYBFxmCOq8ygRQ5Ry8VMn5JEXMALVbWmjA1MeI=;
        b=ugbkKVbYG9R8fjrK9X/JkNKUnwjdaA7OYKzNrEBCh2V3kyu3qD/Ya/38WDe+Rjf/8v
         jrqgvNKuaI6s5ay6GB5I+6ZqF3JLw8q2aPjx2+Vpxk88s5kvR+jGKGweUaZITLOmP1bn
         3t48z9vnsEVDjWzXUXifgvWOFv7nAt1/2eF9617KYg4rtxFSh/OluF/1YEKxP4FCuje3
         zCbXpsABcyl/VpYTLHjfV6lQhoI37bBTJTn1VTeSGiOVETkRHeX1xYN8YXPI7GuWxLKg
         cJ5lukkO13nlY+vI1A5Z9GV51sClXXiaTJ06169ZiVnxcYkfh/s0oYrDontODgE1FzhB
         wB6A==
X-Gm-Message-State: AOAM532Z2V0dl5XvQ6qNEdFwRRnw0Ss3HwjOAFp7jXJxzv62xb8m4bKC
        f0XoSJBh3Hyk8JtWLRV42zy/8I0JBgqG4d0j
X-Google-Smtp-Source: ABdhPJxdtfP8OKAxzv+0hGOvWmzB4oVIj2RRZBHbZ7roN/+7bjM+QXUdXR4TXF7inHK2d/voyvbdMQ==
X-Received: by 2002:a17:902:8a96:b029:e2:fecd:e3a3 with SMTP id p22-20020a1709028a96b02900e2fecde3a3mr1263742plo.79.1614811489458;
        Wed, 03 Mar 2021 14:44:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm4615962pfm.214.2021.03.03.14.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 14:44:49 -0800 (PST)
Message-ID: <60401161.1c69fb81.5d945.ac3b@mx.google.com>
Date:   Wed, 03 Mar 2021 14:44:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-175-g90f554cc70c8d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 84 runs,
 3 regressions (v4.14.222-175-g90f554cc70c8d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 84 runs, 3 regressions (v4.14.222-175-g90f55=
4cc70c8d)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-175-g90f554cc70c8d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-175-g90f554cc70c8d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90f554cc70c8da3216b716d7b0b2de96ea47f16e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fde81d8016944b0addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-175-g90f554cc70c8d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-175-g90f554cc70c8d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fde81d8016944b0add=
cbf
        failing since 109 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fd942cf253b2d7eaddcf1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-175-g90f554cc70c8d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-175-g90f554cc70c8d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fd942cf253b2d7eadd=
cf2
        failing since 109 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fd9443cbfe12868addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-175-g90f554cc70c8d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-175-g90f554cc70c8d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fd9443cbfe12868add=
cbe
        failing since 109 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
