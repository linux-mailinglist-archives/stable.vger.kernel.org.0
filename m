Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A94445857
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 18:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhKDRdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 13:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhKDRdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 13:33:32 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937B3C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 10:30:54 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g184so6018315pgc.6
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 10:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YKVIHi2Chl+rgzJh7oxIaIciBgYNz/x1xVxwrE16/m0=;
        b=64OTJN1cAt88XhGuTw+zgHoGsqzx+kn+3y/xcpQg/PeeXRAwpY+TQykwMhlYhBypGD
         JoWrnbgFY/hP3SA8t3bnehpS4XllsHc4oDfY1bekxYb5GfUNqDdD8pILjc4LoG9Vfn8X
         qKB8IxsHEvat9IPcS8y1czJXSp0aPyBHYC5XEXN9KhJkUrG7AA5YhATTn2qqj+Q8S+Y9
         bkYOITLo+5i+4PdS6Uhq0LI5ZCquUDbX8BwMrsqrOYxvMm9s28Roc83uJehbQdESiEwN
         toaNH8g6ryLMizpEpEsr94UVnemdTi/RqMbhTIdLJekTdHsDZlimIOcDyYP1r8rKSJOx
         /2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YKVIHi2Chl+rgzJh7oxIaIciBgYNz/x1xVxwrE16/m0=;
        b=vvuMta7ZdNlKAT0MiFKmb/Rr2pzaAWWDr5DM/d/QRJAOlKw9w1Jrosxy0/tZZz7Hvu
         nP/o8e+6kHMPi7LxLc9JfPUGj/cJOaxtsyDrfuQR5FSF/OR8W1r9ZBt6aSy8aS81bRF0
         oZhaB1NNonStIpxviBEbsVqT1eBp65ZVp/WJAqW1VdNdV/IWq5ERDT677FKaCoH2D/R0
         8Qqfe9vYQ7rnXUbJsWtnLtxpRyWq/XRmcqVu0hDWlghwkuZAPjjhKyuPny2ZW+BYcA7w
         strDzzmjoRIznj1JFukcxN269V/0npMxdj7yxBPgeIjN4kwMtWBeP9La0FL8PLYyEeJu
         SF3A==
X-Gm-Message-State: AOAM531rHstdV91WlqTG+14oWL2IDxieexoFcCICAXEcboTGck21F/2q
        r2RqGhcZJCe/G6dtybGXwd8OKSLV2l8D8bjy
X-Google-Smtp-Source: ABdhPJy+jPejku1frNaF6SNLzJMRAW3IeVefd4eoX31PeAwT2bD6slvpON9zQL2FPQpYg/2g2tboQA==
X-Received: by 2002:a63:8b4b:: with SMTP id j72mr24288638pge.10.1636047053830;
        Thu, 04 Nov 2021 10:30:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mz7sm2400702pjb.7.2021.11.04.10.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 10:30:53 -0700 (PDT)
Message-ID: <618418cd.1c69fb81.ae40d.8bbc@mx.google.com>
Date:   Thu, 04 Nov 2021 10:30:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-2-g0ac26987d8a7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 122 runs,
 2 regressions (v4.4.291-2-g0ac26987d8a7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 122 runs, 2 regressions (v4.4.291-2-g0ac26987=
d8a7)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-2-g0ac26987d8a7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-2-g0ac26987d8a7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0ac26987d8a7e226422e5f65d9b12355318791f1 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6183e7f4b7ac8df6b63358ef

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
-g0ac26987d8a7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
-g0ac26987d8a7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6183e7f4b7ac8df=
6b63358f2
        failing since 0 day (last pass: v4.4.291-1-g1f67e88441a0, first fai=
l: v4.4.291-2-gade48a790ccd)
        2 lines

    2021-11-04T14:02:07.410028  [   19.094238] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-04T14:02:07.452168  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-11-04T14:02:07.461409  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/6183e5c2c4b9f549db3358f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
-g0ac26987d8a7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
-g0ac26987d8a7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6183e5c2c4b9f549db335=
8f6
        new failure (last pass: v4.4.291-2-gade48a790ccd) =

 =20
