Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9762A3DDE74
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 19:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhHBRY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 13:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhHBRY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 13:24:27 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7BCC06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 10:24:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k1so20409210plt.12
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 10:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e7OpDOX7PNCvZaq7MEXCOJq+D3B8mgnMy+Liq3e5Nu8=;
        b=YmTLbxR258rPvxJ0J6NYQyAPAGFohv/xd+OLRvsFxHvGRoVdGq6BRxZ9/3ibRflSeI
         Vs32A9qZfu4tNumJ3aREleV30JPGyhMcEt7TwesWdb2YJPNlNDX9vivFbmY2L3fbOfrN
         Ixv7tve2ZfCwPOaBx5qfKsXQ3d94lb/WuBQfGBsGfwn4MfOlMPySUfLJbLiZ3luDG+uo
         lVkKu7JcorXAtfWys97Y++NWjwKehf7ZkVaMCbjnSaq3+s9+YoRlgYLhNhRtwk/Z5QZj
         y0smfaTc5COX2gzvFVkzBTUL3zSNIMTjVOmkz9zTz7j5a/D7nKX2t1l2n5aLbHo0br5i
         01nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e7OpDOX7PNCvZaq7MEXCOJq+D3B8mgnMy+Liq3e5Nu8=;
        b=GRMjX7cjTFp7BiN+c8EcFs16b5b35u+Ukoe+Sv/6aa3wbdAnyR9qpBG0DxySliMvib
         PdZgQvWhapUyfnBFnViW5Oxc9YMAUWuXddMuxhaUMWsQznRItitqbV1TTk1+qjzN2u/9
         zpOgVyD+81Nxr8JkRQDGF/XZuAlMhBcq5MBrGWoqbVtRN92wvc6K78gy5BKp2YyZgQEk
         w4EaRl4zUgCcdLD/79BQlTY6IwuXy7p7yyrDFzJjbVdEYHAiXvzzLR0/+YZBT4svy4kf
         mgS5R9ReJY23nBcsTOhlJcYzsUoFXUymFFnypmfctSF4adrMpTTUiwKE5jjh2rUWKtOY
         fdOA==
X-Gm-Message-State: AOAM533xt9RySqbmfTCTzfAurzv3yUUpw1S5c3pB4Ta+a/btAlmEN0x6
        s6LpgXgTsgT3WagOK/AvKOdpJ8fhiXd0trKH
X-Google-Smtp-Source: ABdhPJykzlLGNPGqwmuxaL+YatLc/mmiWnFU5c/guD1Xw8Zgl+2L7kAzPIqoujOh2K1QFinZkhzs/w==
X-Received: by 2002:a62:7f0e:0:b029:3af:e2a6:f838 with SMTP id a14-20020a627f0e0000b02903afe2a6f838mr16387631pfd.7.1627925057251;
        Mon, 02 Aug 2021 10:24:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l10sm11029789pjg.11.2021.08.02.10.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 10:24:17 -0700 (PDT)
Message-ID: <61082a41.1c69fb81.4e743.fa49@mx.google.com>
Date:   Mon, 02 Aug 2021 10:24:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.241-38-g65895f292abd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 139 runs,
 4 regressions (v4.14.241-38-g65895f292abd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 139 runs, 4 regressions (v4.14.241-38-g65895=
f292abd)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
qemu_x86_64       | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig   =
| 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.241-38-g65895f292abd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.241-38-g65895f292abd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65895f292abd1f09ff8d656ada9b4bd2d6698c1b =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
qemu_x86_64       | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6107f4208c3b68cc79b1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-38-g65895f292abd/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-38-g65895f292abd/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107f4208c3b68cc79b13=
67b
        new failure (last pass: v4.14.241-37-g57db7e340609) =

 =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/6107fb26a0e3c75bf3b1369f

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-38-g65895f292abd/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-38-g65895f292abd/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6107fb26a0e3c75bf3b136b7
        failing since 48 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-02T14:03:00.805021  /lava-4306574/1/../bin/lava-test-case
    2021-08-02T14:03:00.822239  [   16.524159] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-02T14:03:00.822687  /lava-4306574/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6107fb26a0e3c75bf3b136d0
        failing since 48 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-02T14:02:58.375285  /lava-4306574/1/../bin/lava-test-case
    2021-08-02T14:02:58.391997  [   14.094065] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6107fb26a0e3c75bf3b136d1
        failing since 48 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-02T14:02:57.357505  /lava-4306574/1/../bin/lava-test-case
    2021-08-02T14:02:57.361516  [   13.075276] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
