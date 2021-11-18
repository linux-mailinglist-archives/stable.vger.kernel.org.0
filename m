Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755D8455E45
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhKROjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbhKROix (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 09:38:53 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E91C0613F2
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:35:35 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id u17so5399848plg.9
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R/TAIBjeP3dJgZPUxvL7tYlIKRoYO2gZmRjuyJ6bPD8=;
        b=WAn3vFkMbiSDVwGXJQP99LX/jtLwRF4DvQn3T/1c9CeDjDRN9ZXI6vrPvqrNYBRiMy
         8yDdVx4OQLmojQ5Nqh9OHogR6Y6WBkDbxsljIU035n/8ai91+CN9GaacYCDrtyOTgVQB
         6KAj1WEdDRxcwAVp3CXxnPJs1K21fVkvLgj6XLJNHSkyp8nOWp27kav/Wo7Q0DkX4NKl
         F/urqM5vXNvlpbAMG/T07sQAUcktUui/EuRHklOQz+nsGQrPpoYNRlUDeuvX2cg1dxi2
         RjLqGMz+mKJpGOn+rBXeR8bB9Kca14gwfy+eEG8aTWdIqa8QaFXd5NY0flaZ4zA0/CDp
         WWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R/TAIBjeP3dJgZPUxvL7tYlIKRoYO2gZmRjuyJ6bPD8=;
        b=SZIinYzZ98nDMK4EvPkWrG3TlKR+o8ls+RgL8tRgCgbkKCweCnaIhrqO3wJMuYAbFQ
         uMaLCCRLtTtMxCxS9dbPJdIaNmAyoAPAwCoheHLg/6ftqFIx+4OYcYjS3g3WMdm2ZFzd
         xc+Cuah0uZj+aRrAaoRYSKCMxjGRyWGFkOd3P6gYmyvrPdOKTsdMvd93q7fMXEae2O65
         KLsIbqIYNRB1oA7awNm2Iv5S707oENsoMxfIh2qvD3Qz49O9Cqlx9c8YOC91PanDshkq
         mPPpn1rP/7tMXEI23D9kTgxvJfWuvcJ0U/BPRUaP/YirKVBCJUdclM3Dv7bgKLwvm8nU
         x6WQ==
X-Gm-Message-State: AOAM533Mqj9R6fhxcH1iJWA5QSsxVTl2X++MhkxQ8QcALmfnTJTuzZF5
        VNMSyxvAae3NHaZ23CDIbhTxL332GdWsHcHd
X-Google-Smtp-Source: ABdhPJzy3viNr3oxoMAvECpHl+0vfgaZRWcs8zVPvGsf5qkjEhxP8u71DI+c2X4/qyK5Uax/BKObow==
X-Received: by 2002:a17:902:e851:b0:142:19fe:982a with SMTP id t17-20020a170902e85100b0014219fe982amr67213804plg.13.1637246134782;
        Thu, 18 Nov 2021 06:35:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id np1sm9165415pjb.22.2021.11.18.06.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 06:35:34 -0800 (PST)
Message-ID: <619664b6.1c69fb81.b9611.967c@mx.google.com>
Date:   Thu, 18 Nov 2021 06:35:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.217-251-g23a8ec96a20b5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 135 runs,
 1 regressions (v4.19.217-251-g23a8ec96a20b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 135 runs, 1 regressions (v4.19.217-251-g23a8=
ec96a20b5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-251-g23a8ec96a20b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-251-g23a8ec96a20b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      23a8ec96a20b58f1f6613872ea213a4d42c5fbf3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61962985761cf69550e551cb

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-251-g23a8ec96a20b5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-251-g23a8ec96a20b5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61962985761cf69=
550e551d1
        new failure (last pass: v4.19.217-250-gf784924221ad)
        2 lines

    2021-11-18T10:22:42.431637  <8>[   20.941589] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-18T10:22:42.476192  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-11-18T10:22:42.485623  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-18T10:22:42.499304  <8>[   21.012145] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
