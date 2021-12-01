Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D65465976
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 23:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343737AbhLAWuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 17:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbhLAWue (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 17:50:34 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633DBC061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 14:47:13 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id iq11so19132710pjb.3
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 14:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X+c7inRLiP6/BdWwwhVNp70+tlwLiD2Ot2l9LgbNgVM=;
        b=duvDXRTYBogojpUcMF5yrwZfyOhmN9PZvFpcJz3yOLX8x+R57QtRd0CJELj8X3mRIE
         U0OjF/OoJW080MfNSMfLmsT2EeVu0FuSS70+M2x4/GLUd4F4OIoJHfB0f1HW/MNft9jF
         QdGSxeycyK3vx+1zJZHg1yuMts8wS3wZ92Jc+CXca1oIrmRfHtJ/S0xKAqzTvcfRhldY
         Em1xmvqzmg2a3a9jakchAbxCbAjFnarRNpo8BOmnot/EBlxVsB3NE3xgz6vRdaHdLsHv
         NxQd9egsBMtQwcDvm2OROa8LYrJ60iwZV6bFBbMf4pxmFP0rxzahftCXDb1wiNK8pf7n
         dRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X+c7inRLiP6/BdWwwhVNp70+tlwLiD2Ot2l9LgbNgVM=;
        b=RO/01MJ3mA+u7xIgKy5ZtVHfxFeYa3aMigdBj4Ak7tGjpym4WYPb7fsdqs8Gd5xnse
         0V+bdkisf42F+vIk87+7YyPIVAj4GeTM4HZFZ9Km9qk9UXfHCks3X+8weXikLUvUjNqT
         oD4MjEmzhcLPYSJdjCXiMPVEaKVnkbm7n6TZjQaMCDPJYxWmiTMLsvx3EB+wh3dwc8JC
         km7pYa9JCKvMECti+oIJSPmjZnugWSKJugOlGCtIzw+kcxeAbQ2RUaoWnXSVaboPj2K/
         6D31tnsE553NbrzBC7cDy/3xUEYe/ckBaJ4/GgdFXP1jwKhiemhr9Oyz6EsNLs8Lo24t
         rgSw==
X-Gm-Message-State: AOAM531FnJvB3ZaMK4pcg22LDsivisrK9p9inIlHIDGqiwMRBuD6Yr4t
        sKhkD7cpg4TsJ4/dgfESx0ONXRMtpoJuKq6s
X-Google-Smtp-Source: ABdhPJzl78dl3KhQTG/jpP4wE/3RilQ528a6YuKW78T5YIA0AWwbCg/Aq9EHWUQ3HxqGHDfeu9sIPA==
X-Received: by 2002:a17:90b:33c2:: with SMTP id lk2mr1404411pjb.19.1638398832645;
        Wed, 01 Dec 2021 14:47:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h18sm872558pfh.172.2021.12.01.14.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 14:47:12 -0800 (PST)
Message-ID: <61a7fb70.1c69fb81.3223c.3f41@mx.google.com>
Date:   Wed, 01 Dec 2021 14:47:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 147 runs, 2 regressions (v4.9.291)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 147 runs, 2 regressions (v4.9.291)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.291/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.291
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fd8594b3cefd966789dfebf8eb4311574fadbb9 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61a1484f2061164d7018f6f2

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a1484f2061164=
d7018f6f8
        failing since 13 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-12-01T19:19:08.228360  [   20.641326] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-01T19:19:08.270399  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2021-12-01T19:19:08.280041  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-01T19:19:08.295219  [   20.710144] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/61a1498df34b51c0d518f6ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a1498df34b51c0d518f=
6ed
        new failure (last pass: v4.9.290-205-g54bc9d253e82) =

 =20
