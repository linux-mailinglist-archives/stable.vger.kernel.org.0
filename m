Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CF83F59A4
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 10:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhHXIH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 04:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbhHXIHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 04:07:19 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8F2C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 01:06:36 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u15so11722467plg.13
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 01:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QxIjwYN0wJMW1fp9jjUNBUHsl3S747zvV/y3+JQ+gX0=;
        b=nFUn4XFyWfolln0Yo60zGZTDUMSm2fPaRCIxxDyEcRE5F+tqyeulDeOQ8rsYB4uB4G
         YGiI8i9cKI8EB4sS6imGXgTvBe2IDHpUbYhHR9mL0rown4hLw31NKMii7xDMuEYLnPbk
         WWGoYsvDtBS5W++vddFLps/y0gcd+qZIYsIieCf54ahC99ejo3fPeqh0E64SyfqvGxJR
         RTP8vA9QEvwYbxHencGbv8zwPPvJqJEOOObarFyt4ELwoZ4/Bhw14lnksV3snJKfSx/q
         DhBq978AY2YsuuMOwtVvneUcp+DF0imAV8oZ6mzrgOo08663a4nwCBZXU1Bf2K81N0bH
         UAuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QxIjwYN0wJMW1fp9jjUNBUHsl3S747zvV/y3+JQ+gX0=;
        b=AouqWaqLGINHYFQOV7mnzmIsfbpNXpuYFu+SqQKTjz3lbjCHRxd5VRNr5IJ7bvPIBL
         kTjkVjga0ISrTLMi57LNzxvO9G4Tqgtn60MaTMiCnzimQ+eozOoDdCLh2AlGcdwy83fj
         +EpvPBbToC0OYOLTitlV8PKzT4+D3xfrY+hIyoBXRHYclFmMMEs+VNW2QgS03msHX+Z5
         sXZlF1u90FddZtorPmpmYwAFs1iQgx0ZU+RKbyPTW5qrNXS7XCJ1fijRjzYJQPnIry9I
         3XyKyn1kr2Xz2HOWp/4zzW+d7iOpzvFLaINbLbnxqk8Qy7QOA3Sbl0/39r0mgmjKYCUP
         AbOA==
X-Gm-Message-State: AOAM531n3se+k3iZCZDabbIqv4QUWgxSpqBkeSslIrDpRHHT5YQshNt4
        +siyATusurS3sViigNoS4BJsyaIx7QhweR2i
X-Google-Smtp-Source: ABdhPJxuD026RtqSXMRdd+svX1HjzGGMODa+lswTSQTd8Z7dWGBD+YbemGoglX4NL7fGb9fG7N716Q==
X-Received: by 2002:a17:90b:395:: with SMTP id ga21mr3124407pjb.159.1629792395409;
        Tue, 24 Aug 2021 01:06:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23sm1655905pjn.12.2021.08.24.01.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 01:06:35 -0700 (PDT)
Message-ID: <6124a88b.1c69fb81.6a797.49bf@mx.google.com>
Date:   Tue, 24 Aug 2021 01:06:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.280-42-g13ad08c714b5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 117 runs,
 4 regressions (v4.9.280-42-g13ad08c714b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 117 runs, 4 regressions (v4.9.280-42-g13ad08c=
714b5)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.280-42-g13ad08c714b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.280-42-g13ad08c714b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      13ad08c714b5b3dea21c699132f529926c6cb475 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6124751fe8b600bc188e2c82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g13ad08c714b5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g13ad08c714b5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6124751fe8b600bc188e2=
c83
        failing since 283 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61247511b194a4a09f8e2c85

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g13ad08c714b5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g13ad08c714b5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61247511b194a4a09f8e2=
c86
        failing since 283 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61247520e8b600bc188e2c85

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g13ad08c714b5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g13ad08c714b5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61247520e8b600bc188e2=
c86
        failing since 283 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612474db4f26d740fc8e2cfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g13ad08c714b5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g13ad08c714b5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612474db4f26d740fc8e2=
cfd
        failing since 283 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
