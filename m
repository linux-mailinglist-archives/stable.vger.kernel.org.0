Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFE732DD7F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 00:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhCDXAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 18:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCDXAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 18:00:10 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDA2C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 15:00:10 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id i14so241662pjz.4
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 15:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wxzWXrNUeeI3G6AeWCzx06mw/3PefVg6iobn0Ssam04=;
        b=puejpkcp4OYVzfdfoTUCQWhS6789wmBj8NMEhMLCNr8GxTHXDor45JdhZTGvMJeGjD
         edCFDSKc7mG9assdAhdI919W6FhODQZHhqzCQJmEGQs6l4+u+0A+Y8mkV30c9wXRREdt
         TpRMtLyrzcHtjeCmXoJCW4AApPAi/Py7Nckq0dnoi+ffTMy0oLqvO4LxLaVb1VQ6PFdf
         +kDzoWwjSTk6LH+1xQh4l/+i9ToZVIpUA4FLB55Clt0UcPcvT4a254b4RLMTh3dPu8ww
         zK7CBian69UhFe3hypcjfLAy9veHXc5s18DT1/gWDLW205+/oVVSY92ZCUl2G/Yk85+D
         D0nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wxzWXrNUeeI3G6AeWCzx06mw/3PefVg6iobn0Ssam04=;
        b=TWzwOudVs+fdjkUBox+7H1e+OGWxFDkeYa7+iOQg74InKYlP0Vv6ZpSZ/bf8Y2kawu
         pUxywlrOHve9PG0VADB/YIG2KiHnofIsS72ry6VsYczXEtK1UyrSM3AMb6dRteZCFw6w
         tpp0Ozt3GWPJdaPPxgNWEauEzySUqxEX0WbT7DQOHnpCg/kAOolSAp5DfUZtaS6Zx4k/
         ufEtWCXJWPcNU5ptB5IQWREIoV15FF4i5tMui/gM6Owqmf1T6dcjdsp3/RVYwOJJJCxC
         tkKEVeo7dNR0UOUApTukXY7GPdy00vfYs4McYS8pvXmU5lLzWyUq6dtz4VMB4lw31dHs
         FzTg==
X-Gm-Message-State: AOAM531bqoK+P4RMfY8wwOcNXTZq+Io1xJrCn6N2ENDP8nrQqMVAkLVm
        7yT0PClfPZxlisQc02PrpeenXOBMpua4xmr2
X-Google-Smtp-Source: ABdhPJwj1Q0x4vr0AH1KmNQggueCXj601f5qutqU57Zc3kRy19tkCqQzq6o/mtID4oaknbx6THVVBg==
X-Received: by 2002:a17:902:8f98:b029:e5:b17f:9987 with SMTP id z24-20020a1709028f98b02900e5b17f9987mr6014918plo.55.1614898809150;
        Thu, 04 Mar 2021 15:00:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4sm413720pfo.2.2021.03.04.15.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 15:00:08 -0800 (PST)
Message-ID: <60416678.1c69fb81.bbdb5.20e1@mx.google.com>
Date:   Thu, 04 Mar 2021 15:00:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-24-g9ccec5ab607f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 113 runs,
 4 regressions (v5.4.102-24-g9ccec5ab607f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 113 runs, 4 regressions (v5.4.102-24-g9ccec5a=
b607f)

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
el/v5.4.102-24-g9ccec5ab607f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-24-g9ccec5ab607f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ccec5ab607f178eceb38ac2c0d306db42bc9d88 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604157f92148698291addcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
4-g9ccec5ab607f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
4-g9ccec5ab607f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604157f92148698291add=
cd1
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604134856f75a856f2addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
4-g9ccec5ab607f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
4-g9ccec5ab607f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604134856f75a856f2add=
cc4
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60413188dd53e6c871addccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
4-g9ccec5ab607f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
4-g9ccec5ab607f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60413188dd53e6c871add=
ccc
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604131957749384873addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
4-g9ccec5ab607f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
4-g9ccec5ab607f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604131957749384873add=
ccb
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
