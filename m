Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B9E446956
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 20:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhKET54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 15:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbhKET5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 15:57:55 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A92C061714
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 12:55:15 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id iq11so3748076pjb.3
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 12:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ds7HOZA1Jb7c2ev1cLavIp7EFl0Xz8l0xLNYG7IdAOI=;
        b=OgYNC01yIW5yfN7mouCKCyQgD78xNAHGzhrAK2kId2Y4Er8tEiqBzAVs5eeXyyJXl0
         w1P/S4zSDq1SJr0pIMYrPMXsW+Iu+XHgviVRivyYSkgvtjqwEEe/EY1WrTmveKuHH8Qk
         VEQ3DFE4bgLUyKPqeo6y0i7VQrQKJaA19/Kbv4lFq/ZhXKoxuwVajdhxPjzWDLPEmpyj
         RmWYbJCtYLXaWuKiHuZbgFOMihdgumzhVKwUBUeotPDBM0EkcthZJRwMRtChiqmv6/ic
         z4ZcFLTTy4PWDxpdRA8hlZdBDJnQTP5/zn3+m+T0N5yqD6+8d5kCNF0LhA4J4xJbg/hm
         h2cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ds7HOZA1Jb7c2ev1cLavIp7EFl0Xz8l0xLNYG7IdAOI=;
        b=AoQXn3O7qEsCc+C0PvSy9jMJjeYjPE4OmIMdMKQBV2XYhciH94IrMMoS2xq+EMdWMl
         npagbLNVLPbldVy30eOnlCQIx0c5cS8cBseeJb8t5MgGrazKuVAjW3mYEN+XFjB0awL9
         6L0DpaAFgs4m6oWnfD0mKZgcKiu2tQcxrX2YHWwZHamLK5hWzNiMpXZy7ED3OTi+QWRN
         ucGPlahgxso82HnTk6M1bZ9ekCB9UKeTp7CfZELxCZeaXKJBnprlF9gCbxqjuGOV11io
         nS24ehNYrJ5KKUqa9zl/k76hBkOpHLefr4Xa1iH8izV1nMux1v60SHexAz8GfZsinCLN
         Jqcw==
X-Gm-Message-State: AOAM531+XPkOaZVy43wph6pxFxYw/7XtapOeCbNnSmK5qunYD6bXVaXQ
        GrUWmtYKq/QhHMDkWlOATSLGiYmdto6PFnHd
X-Google-Smtp-Source: ABdhPJz7ryjurZIxCi7QJ5iasiXvY+1EaOZ3tqe4M4qrjFhC4NlRrLHCOjlyI/7DoR+mMmI8XkCbTw==
X-Received: by 2002:a17:90b:3142:: with SMTP id ip2mr27548656pjb.207.1636142115081;
        Fri, 05 Nov 2021 12:55:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14sm7042922pji.45.2021.11.05.12.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 12:55:14 -0700 (PDT)
Message-ID: <61858c22.1c69fb81.b4a07.74a1@mx.google.com>
Date:   Fri, 05 Nov 2021 12:55:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-7-gb686a40d0d7e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 160 runs,
 3 regressions (v4.14.254-7-gb686a40d0d7e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 160 runs, 3 regressions (v4.14.254-7-gb686a4=
0d0d7e)

Regressions Summary
-------------------

platform        | arch   | lab           | compiler | defconfig           |=
 regressions
----------------+--------+---------------+----------+---------------------+=
------------
fsl-ls2088a-rdb | arm64  | lab-nxp       | gcc-10   | defconfig           |=
 1          =

panda           | arm    | lab-collabora | gcc-10   | omap2plus_defconfig |=
 1          =

qemu_x86_64     | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-7-gb686a40d0d7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-7-gb686a40d0d7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b686a40d0d7ef6cef5b03e16eac7a224555c34f8 =



Test Regressions
---------------- =



platform        | arch   | lab           | compiler | defconfig           |=
 regressions
----------------+--------+---------------+----------+---------------------+=
------------
fsl-ls2088a-rdb | arm64  | lab-nxp       | gcc-10   | defconfig           |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61855b247d8da54e0f3358e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-7-gb686a40d0d7e/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-7-gb686a40d0d7e/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61855b247d8da54e0f335=
8e1
        failing since 0 day (last pass: v4.14.254-5-gc9b4934a4d6a, first fa=
il: v4.14.254-7-g54e49ba3a341) =

 =



platform        | arch   | lab           | compiler | defconfig           |=
 regressions
----------------+--------+---------------+----------+---------------------+=
------------
panda           | arm    | lab-collabora | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/618554c46bede25e003358ec

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-7-gb686a40d0d7e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-7-gb686a40d0d7e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618554c46bede25=
e003358ef
        failing since 1 day (last pass: v4.14.254-2-g86b9ed2d25ed, first fa=
il: v4.14.254-2-g116ed5b2592c)
        2 lines

    2021-11-05T15:58:42.470876  [   20.003051] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-05T15:58:42.512870  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/96
    2021-11-05T15:58:42.522502  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform        | arch   | lab           | compiler | defconfig           |=
 regressions
----------------+--------+---------------+----------+---------------------+=
------------
qemu_x86_64     | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    |=
 1          =


  Details:     https://kernelci.org/test/plan/id/618554d66bede25e0033590b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-7-gb686a40d0d7e/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-7-gb686a40d0d7e/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618554d66bede25e00335=
90c
        new failure (last pass: v4.14.254-7-g54e49ba3a341) =

 =20
