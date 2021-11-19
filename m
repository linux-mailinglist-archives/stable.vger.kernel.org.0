Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04C245797C
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 00:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbhKSXXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 18:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235653AbhKSXXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 18:23:23 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AECFC061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 15:20:21 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so12057027pju.3
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 15:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yH2Lroes5z1xn1rNTh/JteKWDVImqpMx3hV1fNkirec=;
        b=1ZR1mNRkctz7CvY3k3lhT75fMcizkaXL2ms755aF6XMZCCWbBYD3EmORWbYc4kAkw1
         g5pgWswRZxaFOgrkUd0W6LtAzJTF2qfMLtn5F+N3gwClVwbhMNZcqB8xnLb9ZN7P80HU
         OqnPIZ172FHGzG6q7QyJN3/BoUiEZj9FzjcXTyycamkUe9NM19eDbvbftd9DP0iXFgN/
         wkQI/SjbA9aB1Gw/4DI9qoECVrkyY6ldn07GNcE6//FJrLGlQimpLC0AYAKf90HKmC21
         d/Twq497sfuaOTuxXQSqfZ/CoKaia7UNG0wO5qoR6NWneSHQ9/CEZj5OV+P9gK5BoPcr
         rBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yH2Lroes5z1xn1rNTh/JteKWDVImqpMx3hV1fNkirec=;
        b=6G0MvwUA702D0Zvun9Ua21jJlP2uoIiu9oCFCLjZPXkpwLBqetM4M0IN0DcMzgOZ1h
         3hdfIVFfHPu8isJocpBzZg2uxiQu6UgwgIS9SwnqvGoCcdzRRPVMczpXtRfrPnde3Xem
         tbWlSHNoM3AeVrVMJat8dyx+arlMFkFjk1ukwKr4JOTwr5xuyNV7q6KmffqRcg0DgvUI
         7AjFs3f5W8lBBDn97NYaROVH/3BO4Z7AwmLg6z9x8lAqEmld2GnyanzdM4A2pXeSx4Ld
         +Ql952+dGrE15crNOmEretY5ov+hQi+yypZBUZZPOUhqM1sX/R+Zy/WnCLkhGs7hTtWs
         unmw==
X-Gm-Message-State: AOAM530tfK5pIxw8C1jpwsdTlft1Kj6/zoPjO13znDzh4p/2u5Mi2JQ/
        uGdX2i5W1Ra/Np+fTu36ZPGTUeHiRnucDpdS
X-Google-Smtp-Source: ABdhPJwMkSSPSkg47AzaoR6+MIpK7k0jmhzQUP1cjezlEKzYnAaDtVX7kntSnc7TLZ25aJS3bmtpwQ==
X-Received: by 2002:a17:90b:357:: with SMTP id fh23mr4284417pjb.238.1637364020555;
        Fri, 19 Nov 2021 15:20:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j18sm531385pgi.39.2021.11.19.15.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 15:20:20 -0800 (PST)
Message-ID: <61983134.1c69fb81.2d925.2500@mx.google.com>
Date:   Fri, 19 Nov 2021 15:20:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.255-201-g1fdcfc0283a2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 97 runs,
 2 regressions (v4.14.255-201-g1fdcfc0283a2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 97 runs, 2 regressions (v4.14.255-201-g1fdcf=
c0283a2)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =

qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-201-g1fdcfc0283a2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-201-g1fdcfc0283a2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1fdcfc0283a2375910c73bdbf66724d54a76c898 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/6197f7813ec21bf8bfe55207

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-201-g1fdcfc0283a2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-201-g1fdcfc0283a2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6197f7813ec21bf=
8bfe5520d
        failing since 0 day (last pass: v4.14.255-198-g2f5db329fc88, first =
fail: v4.14.255-198-g6c15f0937144)
        2 lines

    2021-11-19T19:13:50.104168  [   19.897705] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-19T19:13:50.145595  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-11-19T19:13:50.154766  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6197faa9b180056469e551c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-201-g1fdcfc0283a2/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-201-g1fdcfc0283a2/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6197faa9b180056469e55=
1c8
        new failure (last pass: v4.14.255-198-g6c15f0937144) =

 =20
