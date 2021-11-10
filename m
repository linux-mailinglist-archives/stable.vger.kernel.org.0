Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B89844CAF0
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 22:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbhKJVHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 16:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbhKJVH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 16:07:29 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E74C061766
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 13:04:41 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id n8so4060918plf.4
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 13:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3ohWSy804VQ5o+M9td5ZQSxz+ekAklvQex+jTNb0768=;
        b=Zrm8A2IpSORF3saKspw9+OByS2JTZTAxJGIDaF5eiL2DDoKFXEw1GhJ994Sx020iQR
         owUAMFLlbBqrFOfuh7cqcpBJI+cewLlpSSIdkfQHnEGxtUlh8HcINDUCp9Ls22KgR5Jl
         w6CBFMBzVQ3oNW8sYBs0d4n8blkANZoW/n8WONdNsMtGWV6bFH0xZFy3dqhIGF+RVNLc
         psSydw63pNgGLi2QnGxEI+ExvKW2QgY+V4SJ2LBwS5WKUidSHdP7M6uvsvKd9sE0aWMD
         RPWzkI3DEU6dbXth2kXnhXozdUV0tFNfvaNnZvpYniEpauaUq6GBmhAZaap+aJvAdzPw
         DOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3ohWSy804VQ5o+M9td5ZQSxz+ekAklvQex+jTNb0768=;
        b=bb25vJUAXgDjER8xcTNcpSf3L+ODhPS6x6BfeGIVOhg0UkXx4hs0lzMWtG3ohfND+B
         YaHrkOgPUqBLHPAFxj4NfQGDGm4ac3rJ+8APhLoEpJJ8djbRBW2T7OVqS+XZKqqYnDYW
         Bmz/NCVxiwrR6Cg+Pv9ukk+NE77ZuFJjU1FeTaeGwKHlObfXsLpJsIkR8rHDsfEbnljo
         oJHDjWHDDTNTxZzX98Kfg+/u4Z6e4LhxCzDi1TPb1ls474lBNlbdHdWFC0e8xF0GADoD
         xBiWGsSfD3hU21qA4af3oIcYKdazO+Wzoq3XgZ4qEva+1xRxVvhJTLnAKenExLtNVL3a
         v7EA==
X-Gm-Message-State: AOAM5306GuYZfObhRwAGuwumu5TnheJXXTHHEpqcgsxqa2AlIgFS3Oet
        2swjgVj6soX+AQ+hlbhtQMS10Dp0Ko40lTZUd5c=
X-Google-Smtp-Source: ABdhPJwQDeMnu5rPc4Nn4QPzcRQt4vwqFimHNiCyHCFdBsHGO3x9ZEutvxkA4SZNHrv2zvQ8skOCiA==
X-Received: by 2002:a17:90b:3b45:: with SMTP id ot5mr2147758pjb.235.1636578280023;
        Wed, 10 Nov 2021 13:04:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a26sm503210pfh.161.2021.11.10.13.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 13:04:39 -0800 (PST)
Message-ID: <618c33e7.1c69fb81.51911.206d@mx.google.com>
Date:   Wed, 10 Nov 2021 13:04:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.216-7-g1cf3c1269574
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 168 runs,
 2 regressions (v4.19.216-7-g1cf3c1269574)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 168 runs, 2 regressions (v4.19.216-7-g1cf3c1=
269574)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.216-7-g1cf3c1269574/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.216-7-g1cf3c1269574
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1cf3c1269574547a5e3bf8b9d3feb57c4be42840 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/618bfeae71f938278c3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-7-g1cf3c1269574/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-7-g1cf3c1269574/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618bfeae71f938278c335=
8dd
        new failure (last pass: v4.19.216-7-ga721c571705e) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/618bfc8ca41e8d861a3358f5

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-7-g1cf3c1269574/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-7-g1cf3c1269574/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618bfc8ca41e8d8=
61a3358f8
        new failure (last pass: v4.19.216-7-ga721c571705e)
        2 lines

    2021-11-10T17:08:13.793995  <8>[   21.623413] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-10T17:08:13.837653  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-11-10T17:08:13.846851  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-10T17:08:13.860341  <8>[   21.691162] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
