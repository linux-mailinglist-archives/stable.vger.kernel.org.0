Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E7D4609B5
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 21:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhK1UrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 15:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbhK1UpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 15:45:01 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27079C061574
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 12:41:45 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso13751472pji.0
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 12:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LEkFSDRTRT6/UQt+WcIjqFqDJuaEoBMKPsER/xHAUMo=;
        b=h5oOj2dQ/srHjD5m9iKMbifQSIuYiPAtKP/PdBPhnPiAMcSK5KuHmki/uyWIs+ZOL2
         RdKhtzkEX16MVMqNlNa2f8fZvmfrSlf+3adcfbaR/gPOA7jUtIoBdFkpVaAdKdf7KNLj
         bwfrtPsEO0lpW6GoNK/vsd80GplrZkYWqJK7QGVAXPtn0yP6yrIyw0R3AolOvnGZUW9v
         UwsPy5yxX7yT+4chcuzSu95ECoZYBMr37BqcUtuWO4GggwDCyZXr6757J5VTt1o2I7nq
         kXOPIyEhT1DKBJHXOesJxoVB8ARUCwSE1vJEcl8Bb3szh5byXj1G0gOH9ulhyRwyADiX
         PbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LEkFSDRTRT6/UQt+WcIjqFqDJuaEoBMKPsER/xHAUMo=;
        b=X/2OdXp8m7wpPm89Jof3CFjPUHsfA5SNT7SptruwADWVODOBvAdAh80EH8noP+KLf6
         kh1c4GJ2xIXp/oUAXtF5wy0/oqlVyyKNlJyAxJvXlhctLzK2HD1ZfGS+TFS+Yw63JHua
         PD2vhWMURXxDPUe28lREfAHSHSr1KIgX42C+eoE1j8gmdkpKSctkeqCewUEuyGdyMPt1
         RxuBuHwVIx/SNEFuiCskaJJ+BdWNS5WY7wbOqd0hKVZSvm71ag9zwPGuvmyRWiDVmtXe
         /jNWbG2DnwBOQ+ZvlEW4sD89m7b7FEgyhnIiXmNHW4QHpOeJlNwy3kOoS7qsgqNLTboB
         nuAw==
X-Gm-Message-State: AOAM53008Vvi5Ezj+GfDZBD1PZQf1LdXLY4HcAQbDItHuXGS9WOStn6S
        7IXAX2FhWfTMjGd/c16DgGB5SvmXJsz+B6rv
X-Google-Smtp-Source: ABdhPJzTX9MSjkNNF0ZlMHl117MMFafBVXn12bNsAFXgfbQqRCX1oSUC4mLdfJby/Q81wV+4am+wVg==
X-Received: by 2002:a17:903:32d1:b0:142:1ce1:30c9 with SMTP id i17-20020a17090332d100b001421ce130c9mr54714887plr.0.1638132104430;
        Sun, 28 Nov 2021 12:41:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f18sm13618430pfk.105.2021.11.28.12.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 12:41:44 -0800 (PST)
Message-ID: <61a3e988.1c69fb81.fb8e5.62e7@mx.google.com>
Date:   Sun, 28 Nov 2021 12:41:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-11-g984784f081265
Subject: stable-rc/linux-4.4.y baseline: 83 runs,
 2 regressions (v4.4.293-11-g984784f081265)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 83 runs, 2 regressions (v4.4.293-11-g984784=
f081265)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.293-11-g984784f081265/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.293-11-g984784f081265
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      984784f08126534d4f87c92eea0ca288d1ed2817 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61a3afbeff943112da18f6ca

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-11-g984784f081265/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-11-g984784f081265/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a3afbeff94311=
2da18f6d0
        failing since 2 days (last pass: v4.4.292-161-g62979a1e3cbd, first =
fail: v4.4.292-160-g026850c9b4d0)
        2 lines

    2021-11-28T16:34:57.693391  [   19.423217] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-28T16:34:57.742728  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-11-28T16:34:57.752453  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61a3ae8d0c9d898a6018f6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-11-g984784f081265/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-11-g984784f081265/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a3ae8d0c9d898a6018f=
6cc
        new failure (last pass: v4.4.293) =

 =20
