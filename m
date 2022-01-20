Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB5F495312
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 18:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377302AbiATRVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 12:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377301AbiATRVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 12:21:44 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DE3C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 09:21:44 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so2121997pjt.5
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 09:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G7IwSGS2jb46y1ATiMDTbXfAXBw7bY95P73tRSRs9OE=;
        b=pO4ZVeJUJadPCwHOcWEGESTkCIjrgxdAcNIRvMyqAOj4RWYqPf9qMJ5Lxr3sZOEIKm
         K8mRqdO08tRvmusb0zFcMxbMJlgr4Nq2r+IvogxPLW0PbVmg3FugSHC1ayITeEds/z66
         Rf1JV67atcrR/loHQxm7SSi8t6hDjgquK+eLYv09UvqhNAcJPPdVWFHcFTpJ/mF9djAr
         +vhBDY8zvK5ESyohrMGMj+fkp92lknGji6Vq906vn3sKr4sOyDr/Di/PV9u7cpZ5WIc+
         qr6jIBjlvPnH7ZCjQ3s3v+V00Hg19SKkL3vRC8GqnQ0AEtnJ8mobS7lcnrksuiR4TXtC
         yz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G7IwSGS2jb46y1ATiMDTbXfAXBw7bY95P73tRSRs9OE=;
        b=U9MhbprcTqP5+EzE2s2JQkKdFF5PBhy7BQVIi0WY40ky2d/PW0C48/XKBp04tay0So
         G99qNr9kge7BDBO3ImJ3wp0F4T2GKWlq9tZLV+RYja4BLwqLUTy1MidcNAAKjCPjvhRz
         UQHm+L2O1/tV1zEpF1//xlmYlE2HoAfXjeSNY0xzzr/bqwB/MrFFfIIKkg7fDCH+T+Bf
         To9RYUiM70aaMtkJQuSUEDGIdvkiITlS8S9Qg2BftjNI1fpMiRpZaaroyJfQ5888a3kM
         PR+vASDTj5lYLw1HM+XpqQUrHJIvQzrrvxhUNYoGqfbECEr7VYvhz0vkxGjT2e0/7W6i
         4ojw==
X-Gm-Message-State: AOAM530aTAeEX+fD3E/YCXZvOp2TUAWm1hCK7JfMBDYlDCRdybV6w5TX
        qXt4I8zLRLOCgaJ0FHw9dcPDWEGgU1a0wqrh
X-Google-Smtp-Source: ABdhPJz6DtcoiosDh6OVggyhc6gtj7DvCrzyQECxA6iHPYUVxL1J8LFY/19aSretpQSgE3Lz+haS6g==
X-Received: by 2002:a17:902:8693:b0:148:a2e7:fb5a with SMTP id g19-20020a170902869300b00148a2e7fb5amr38524526plo.155.1642699303442;
        Thu, 20 Jan 2022 09:21:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q13sm4042203pfj.63.2022.01.20.09.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 09:21:43 -0800 (PST)
Message-ID: <61e99a27.1c69fb81.a55a1.ae8f@mx.google.com>
Date:   Thu, 20 Jan 2022 09:21:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 383 runs, 2 regressions (v4.19.225)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 383 runs, 2 regressions (v4.19.225)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.225/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.225
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e0cdb245b7c83cfa2939071bf0cb7a2ecd31abe =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61e962d215d3263a5cabbd8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e962d215d3263a5cabb=
d8e
        new failure (last pass: v4.19.225-22-gc200d1712464) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61ddfae688ef9e681def6766

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ddfae688ef9e6=
81def6769
        failing since 8 days (last pass: v4.19.223, first fail: v4.19.223-2=
8-g8a19682a2687)
        2 lines

    2022-01-16T12:47:02.835639  <8>[   21.239776] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-16T12:47:02.880405  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2022-01-16T12:47:02.889417  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-16T12:47:02.903223  <8>[   21.310089] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
