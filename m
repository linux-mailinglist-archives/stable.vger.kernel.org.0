Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AE745E3CA
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 01:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbhKZAwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 19:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238324AbhKZAuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 19:50:11 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB9DC061574
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 16:46:59 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id r130so7329078pfc.1
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 16:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ig0eTnG8pB4sIQOiIkslfMZfVfVIpOAt7IXwpC/9Y3w=;
        b=2dtn/uTM3X7/+5UmH+Lg9c8CtUdfubWu0MKl+Q9i3AbVm7+dCnK8PAths7XgIBh8ad
         MGb1dr0mR5QMyfIrZ2ctJ+vj5Xeo4tZYEMV7cTlFd0IAzbrkFE9WzraLJV32MmqytwU1
         6mzV4J03+8CQWNmJoODguMdTSvIDNTF8HLfTZwQIot0drc8kRXhNHWqGOoczDSwmItEJ
         hN6spNWTdf66bmOfIUaJLwM7rZLnytIolX7PjKHDqOU5kK0oACGcHSt6pu06pUWzyqqm
         FtpGwzgXDlXtKDvK1htDjJuFyfD660T8B2piRT1fuAAvwP55D8cF7935IzAFZ5+Bxczf
         VCYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ig0eTnG8pB4sIQOiIkslfMZfVfVIpOAt7IXwpC/9Y3w=;
        b=jEouWP4tWe7x6QOJmGjFmdWJUGQPbwFVpyERV7V4fz2gN6gqiPRjfdviJwFlxgU7n8
         JP/IbwluLIMHqgpEQ0snV550iEj3zbrCt7dpl41am34TqJU5mNAE/zsTSEWHhpyPoEnn
         HvAumJLo0rwBxwu+OelCL1UDABY7CgPNIIMs0QPFpQRFDcyzjJiNmxk2XV5Q5DfdwWAw
         Uj82tpLWRFzFYkrOhZ3YX81NIvrZaYqXRUhTZTwAbn9UOJToxViYmDrlKRZgqbL4T+UD
         MqHFCCxnyguScjRuIGbXS77uB0K/azIQl2js27r3ob1QvX/rAgtJ2RNjZLvN8reT50sZ
         1jiQ==
X-Gm-Message-State: AOAM531O8JiwhajbWD/LnGITp86L5kFKutE/lc0ZbdryTON+FAyS4YYp
        Rp/uJ0rZaiqEXqfB2rDabAQ60H26VhGi0qfhY68=
X-Google-Smtp-Source: ABdhPJzOEUc0CKU3fTgodUFWOaa1aEQcM1BImxa5SCJOFxlfKenT+rOOZqOaXqUjL6nD9zB41tFvkw==
X-Received: by 2002:a63:f94c:: with SMTP id q12mr5047499pgk.617.1637887618813;
        Thu, 25 Nov 2021 16:46:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i67sm4541959pfg.189.2021.11.25.16.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 16:46:58 -0800 (PST)
Message-ID: <61a02e82.1c69fb81.380b.d57b@mx.google.com>
Date:   Thu, 25 Nov 2021 16:46:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-160-g026850c9b4d0
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 104 runs,
 2 regressions (v4.4.292-160-g026850c9b4d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 104 runs, 2 regressions (v4.4.292-160-g0268=
50c9b4d0)

Regressions Summary
-------------------

platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-cip       | gcc-10   | omap2plus_defconfig | =
1          =

panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.292-160-g026850c9b4d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.292-160-g026850c9b4d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      026850c9b4d089e2bb4e9cfb10a53278a5a6fc53 =



Test Regressions
---------------- =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-cip       | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/619ff6d304a9ac3fa5f2efa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g026850c9b4d0/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebo=
ne-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g026850c9b4d0/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebo=
ne-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619ff6d304a9ac3fa5f2e=
fa4
        new failure (last pass: v4.4.292-161-g62979a1e3cbd) =

 =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/619ff57753700c9f92f2efb5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g026850c9b4d0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g026850c9b4d0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619ff57853700c9=
f92f2efb8
        new failure (last pass: v4.4.292-161-g62979a1e3cbd)
        2 lines

    2021-11-25T20:43:15.721301  [   18.914306] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T20:43:15.764448  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-11-25T20:43:15.773755  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
