Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1866A47B643
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 00:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhLTXpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 18:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhLTXpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 18:45:40 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CECC061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:45:40 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id b22so5304574pfb.5
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qyn+O4Nc4r8nvmyjAqbbtSanvSWfbUGv4B7/qJM60zk=;
        b=JC702ZVvvCdSIlw3d+cvULivf0u0Fc0UNohYXuMectL6xGLj13PySNlujzyxc6c7od
         Qg52ZBNyBcHOxJgN0/MEJqVkUUZ/lOl7bEgJJG0Vydu3PQTRCwvtFxax66i9jPaIf8R+
         PbuVPeaNyVfO+2hCKdKjPBhBPilMkzGQ0RpH7+nvSGWmB/fIx0TCmkZe5r1n5HNFEMBY
         kIkjRurC+oV/yb00XSGcNLBJlP7xINfZHokSOE41EwdBg5YVqWNKlDuMKtEqWeVfuugm
         aT5HjCrnWxjjr/9tSfQ76N03P4AWPV4I9/6yEq3SszQCVapr8Y0x68f7Jl3LwWpIND0A
         7SnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qyn+O4Nc4r8nvmyjAqbbtSanvSWfbUGv4B7/qJM60zk=;
        b=hB//rRMbfrSKx1QDoGWL0xbvv2AAqFwVDScpQsvCVN5rS/LgJkxQ3NLQW5QXiP8WB1
         oWqBzWEAUsbgI5edNLwoRK7RY8aR28XzODBy0PVitIe2IN5C6l0gRXVgo0lQWcN7G6Zu
         tCjiRW9KsanVKWAFsREve1szUgNJ84cps+wahzZV/T4XS35CnIasTYD1ACPEpQ+hUYNh
         ZdY5fFMbFSGkuDTSEOdzN+s63p/VGVAM6e3tY4JDKeZgXqiNzE8iJIxhAaSvKjmecdtH
         oST92b8E5pSQOGTEP3yD7A4a8Mw4FtOkfR+QxDMOUOkP75uFOXyI1XaEWVRJM2H6gc69
         N9XQ==
X-Gm-Message-State: AOAM5317HKOV0IMF1pcT62jaZTH2V5Ma6Qpq86jRLkCEIAp1mLWb/Rsq
        yOHw5uVRjgNtkAZJdE7xJ6aUYJ1fJILGCoY7
X-Google-Smtp-Source: ABdhPJwDBOAwdfnddf7qx4YQOTL1AXO/dX0/H8Pc9SFE3SSylrMrp1pZ3w02MCIW56DWQ2IomAuArA==
X-Received: by 2002:a05:6a00:244b:b0:4ad:5852:f41d with SMTP id d11-20020a056a00244b00b004ad5852f41dmr352720pfj.29.1640043940013;
        Mon, 20 Dec 2021 15:45:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gi20sm1248445pjb.1.2021.12.20.15.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 15:45:39 -0800 (PST)
Message-ID: <61c115a3.1c69fb81.f5f66.1ed9@mx.google.com>
Date:   Mon, 20 Dec 2021 15:45:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-31-g9d50eae56b67
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 112 runs,
 3 regressions (v4.9.293-31-g9d50eae56b67)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 112 runs, 3 regressions (v4.9.293-31-g9d50eae=
56b67)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
meson-gxbb-p200          | arm64  | lab-baylibre  | gcc-10   | defconfig   =
        | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-31-g9d50eae56b67/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-31-g9d50eae56b67
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d50eae56b6763c975bcb0b09e5e30c491b414f3 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
meson-gxbb-p200          | arm64  | lab-baylibre  | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0edd1c0fa8dec12397141

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-3=
1-g9d50eae56b67/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-3=
1-g9d50eae56b67/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0edd1c0fa8dec12397=
142
        new failure (last pass: v4.9.293-15-g3fbbbaf0d213) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0e45cccd48a9b9c39712d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-3=
1-g9d50eae56b67/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-3=
1-g9d50eae56b67/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0e45cccd48a9b9c397=
12e
        new failure (last pass: v4.9.293-15-g3fbbbaf0d213) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0e3cbaa30c6c3c3397139

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-3=
1-g9d50eae56b67/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-3=
1-g9d50eae56b67/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c0e3cbaa30c6c=
3c339713c
        failing since 3 days (last pass: v4.9.293-7-gd89b8545a1fa, first fa=
il: v4.9.293-7-g534f383585ec)
        2 lines

    2021-12-20T20:12:41.949624  [   20.350311] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-20T20:12:41.999816  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-12-20T20:12:42.009567  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-20T20:12:42.029679  [   20.432647] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
