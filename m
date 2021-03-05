Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3958632E7C0
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCEMRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCEMQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 07:16:56 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5D1C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 04:16:56 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id a188so2025684pfb.4
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 04:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HXRUgLsJfBVkoAtHYD3hsvgqUoPqApvynKmJBGsGciM=;
        b=pMTZUQYKuBWVfpGOUJa3TUrCQ+D1kqgV0/sSIJdlxGsFZR1bvF1OhrYzoYg+V2ddc/
         J0za3SlbYiEQULkCUUYMVPGdLyc0XH1qQZTVJ9RJHLQ9UBI6m0LXL88hNR79OPdttO6Z
         1v7xPZqocrYHGKvW7fZZq5HFXbGUpoZ+fx2zXzpEZJZ93KV/wS6odvbOtt2d7yfIgIBh
         sSbfTPraIwNzSFgRhOzmlUtGsC+1zsM5UnOy+GjSO3G3FFLIkGMd3U4ot8Mcow1g6Xwj
         CdvumVJYC3B9h7oXvUYf84grW1AgQNkfe3Svk257efXykrLG4KagDjRmeb5lPGkK+6oc
         JErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HXRUgLsJfBVkoAtHYD3hsvgqUoPqApvynKmJBGsGciM=;
        b=nydVqBmoMYqhHORTXeLKki4n9lA5jrGtbYxJdVmhwDRmv6VZnpMxChxBTh4k/37H7P
         BDNc/d5UDojrXEKkLfVA4E1AxCo4OPtDdNLDO+qqZlqONQI6Ghwn3yNWCj7oFzJIhJhg
         w37u3S5G8sh4n1H6TUHCwd7OM7VXYZ30nbEXH15BUo58gDH7fIxPVUYg86UzvF7Q9eW7
         bKNEnSJe8SBhZaw/Q8G/nAXJJMmMrguu6k9oImSFjf1PfX0+X5XQImNDEpfSLJxvamXo
         yIbiBGDKnYdYKOh1hYOh1dsa4BIjpK+1ZEV/INUTnT83oScadnONDGGKbI3uHtKTGdRa
         jOyA==
X-Gm-Message-State: AOAM531RVLh4cAX0wuODrRjYdjbWRctXyOt1jajGXO9hWbGVHXduztfd
        7j0HMEddfBRdA5qUr1VweOPLK1Dw6qkjqOfr
X-Google-Smtp-Source: ABdhPJxVHgYaI9zsqM+GrK7z0epwzmRUCCmgeQCKO7DgQY64O+fV5MU+fRkVAiwn9TLrJCEhF8t10g==
X-Received: by 2002:a65:5c48:: with SMTP id v8mr8380334pgr.400.1614946615434;
        Fri, 05 Mar 2021 04:16:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm2255834pff.61.2021.03.05.04.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 04:16:55 -0800 (PST)
Message-ID: <60422137.1c69fb81.70a40.63e7@mx.google.com>
Date:   Fri, 05 Mar 2021 04:16:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-60-g699fe2d957c4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 175 runs,
 6 regressions (v5.4.102-60-g699fe2d957c4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 175 runs, 6 regressions (v5.4.102-60-g699fe2d=
957c4)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-60-g699fe2d957c4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-60-g699fe2d957c4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      699fe2d957c4808957553ccfd6a43dc9e467aa1e =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6041ec0a88ec9199deaddccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041ec0a88ec9199deadd=
cce
        failing since 104 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041ebc6310df1306baddcd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041ebc6310df1306badd=
cd8
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604212d4ffd7f89eb4addcd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604212d4ffd7f89eb4add=
cd8
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60420223a02e421c73addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60420223a02e421c73add=
cbf
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041eb84ab721a142baddcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041eb84ab721a142badd=
cd2
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041eb633115769b29addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g699fe2d957c4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041eb633115769b29add=
cbc
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
