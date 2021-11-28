Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BEE46099F
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 21:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhK1UUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 15:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbhK1USY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 15:18:24 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506C5C061746
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 12:15:08 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id g19so14461320pfb.8
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 12:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fh3Xmz69LZjZ8b5ZFh7DsB29To7CdIZE+rJ+cmBiWYs=;
        b=vkfsH94Wj+CA3KzCBH8M7oAL06DGtIF4BbET7kY23N72PwOP8eRdleapfOMM6tRp74
         Y3nnnToFMptU65U8A+PPIVSQIZ06+MffrvtCFtBbm0Y6vHAtK++PT25999hNFkAo2cZ6
         MpjDXOnD2RxpUoohEwvTqesg9iWDDLmfOjgJyM+Qh0IC33NaEhX7uYYEMg9DMP40d7hN
         u5Q7BUJMBg6DNWiBP8VE4ZVfEP2bPXftYvYHzcLAIvm+4gPq2dGbn+y10EFIm9cZPTqN
         eOJA9S0GTd69pC7ILPwKEe4aUAkYOQfcEmgKyai0PJ6qlUTC1L4oO2vFGpkSFxauhHya
         AV+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fh3Xmz69LZjZ8b5ZFh7DsB29To7CdIZE+rJ+cmBiWYs=;
        b=Bv02xyClwcpMRbPci01Btar5w77yvUIUSegrpPaEgWz9sxqa2UG8xiK4XXIjsH+PGL
         IOxWuxkyMQ1Q6IUFKBYE25qyAu/t2K4L+8l9wxtlThj7GF1ofNZ6qedJP3zYdkv+kN0G
         ZGvQzcglEfcWpn7v7xgqNalIGpByATExykkWQU97bHpIeIa115Dt7ut50uBreg5bh0AE
         TwWIuLmP76oLg0OvaegVFqolOk+iTic68DfqNk8Kq68L3vAd1f58/9cs9nBufcAJiDNB
         3YN66/DRwkIBLncvROqH61QiQtfLbrkzzjJUrnkkMlAgML5wKLKkfMhomJ5z236KYejf
         eu3A==
X-Gm-Message-State: AOAM531/83H/w1E3R6sBra9SRWTfAnPFPW+RrAlQ8cwxHxDoWCxmHnRi
        +1bRhp73uvTb+U+7SRk/Pr8W2ab3CkOQpNjp
X-Google-Smtp-Source: ABdhPJyCyAykqF2N0cjGHQv84n5Ckv+vpsGEnPLc1NzaJmveXrxjFK3ToIOy0+aRRX370Rh6XkWDWw==
X-Received: by 2002:a63:6c81:: with SMTP id h123mr12637775pgc.313.1638130507701;
        Sun, 28 Nov 2021 12:15:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1sm15310237pfu.33.2021.11.28.12.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 12:15:07 -0800 (PST)
Message-ID: <61a3e34b.1c69fb81.1d653.901d@mx.google.com>
Date:   Sun, 28 Nov 2021 12:15:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-13-g2cd9f5eb5e7f3
Subject: stable-rc/linux-4.9.y baseline: 121 runs,
 2 regressions (v4.9.291-13-g2cd9f5eb5e7f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 121 runs, 2 regressions (v4.9.291-13-g2cd9f=
5eb5e7f3)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.291-13-g2cd9f5eb5e7f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.291-13-g2cd9f5eb5e7f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2cd9f5eb5e7f3f73535f86845cc0ba6c203e19ca =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61a3a914912ab3be1d18f6d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-13-g2cd9f5eb5e7f3/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-13-g2cd9f5eb5e7f3/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a3a914912ab3be1d18f=
6d4
        new failure (last pass: v4.9.291) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61a3a737ccc7c90eeb18f6f0

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-13-g2cd9f5eb5e7f3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-13-g2cd9f5eb5e7f3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a3a737ccc7c90=
eeb18f6f6
        failing since 15 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-11-28T15:58:28.996889  [   20.581420] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-28T15:58:29.039382  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-11-28T15:58:29.048574  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-28T15:58:29.064388  [   20.650512] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
