Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4566947337F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 19:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbhLMSEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 13:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbhLMSEf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 13:04:35 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F5FC061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:04:35 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id k4so15245503pgb.8
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=INDAcB3oiwosTx6Tiow/p82KVnzjvvo+ectkMZJTncA=;
        b=Gih4XBDyQPrXPl9omXXnxEcO9SoBmBAIo4EkpZoCgrh2iNzT0bWCtXqFvNeFtSYVoH
         +9c9DjfUZGFKjNbjLvEnCvJeRf2gJdQ7HLGC7pr/EseIKmupz4GzYSOhPXcD6/55k4py
         osZlDkYZrVNfQlub5eQ4ykcruX6RngACs63SDd23Y05lCRqszXJZKWkkJtIATP/LJ/vX
         QbPmDhjL2tHpl924tbulp7myYBS2jnjXV5w85LdYUev72ZuvljrQ2SegygQGmY4gqEHe
         7tNBBUQgH92mi91kSDJelaesjl+G47Zhw6EYWRcVb/T3P2YRI4FDzADVDjT2Cz/OVeO8
         r8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=INDAcB3oiwosTx6Tiow/p82KVnzjvvo+ectkMZJTncA=;
        b=qSlsRMD8g5W57pL38mUuVUIMBPR+tWAoaeDBWydt5o/oMg/41K7q/ttCUntmyE3Q1q
         zmy9bl4GfkfmeSOzH0VmJ+tq8WHhJKymOu2/NSBvJ0OSL1CniIjKLZHJ7IQkFXnzPuVR
         bRex1UHLR+uf9YKY7pghijaV5+rRPi8b29OH89hskgEnDyzccIow5PU00FsJjqSfGhdD
         T2SRgn84Aw8AIi/o+wSWLprUwfWaZL10XSIaLPUQMSYef4645RbLESXihiLS/VBzjM3B
         oTNH/jvvBrcy35pspdYdn1ZjduwA5oGSenYr1sFlWFfXuQ2ILNbes2oQ7gdoipfZb3b4
         pjLw==
X-Gm-Message-State: AOAM532YYlvdSNhmg2ODBFsWDpaga0wH3daF7iAbxJ1l51MXCnQ/Md2t
        +C30YhoO0F+walWB3rf4fGukrAo18GM0Lp0a
X-Google-Smtp-Source: ABdhPJwgwWyYbQDxZs4pUlAHG72DyLLlorK9NoI0qVCr4cubZYblxk7rmZZTNsIe/42nqFHBPvKNzQ==
X-Received: by 2002:a63:e50:: with SMTP id 16mr77776pgo.619.1639418674655;
        Mon, 13 Dec 2021 10:04:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9sm14019384pfj.114.2021.12.13.10.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 10:04:34 -0800 (PST)
Message-ID: <61b78b32.1c69fb81.e262d.6a29@mx.google.com>
Date:   Mon, 13 Dec 2021 10:04:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.220-74-g36a00096e704
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 169 runs,
 2 regressions (v4.19.220-74-g36a00096e704)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 169 runs, 2 regressions (v4.19.220-74-g36a00=
096e704)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.220-74-g36a00096e704/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.220-74-g36a00096e704
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      36a00096e7047e3826720a1d28a51d29e3a9e5e7 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b7511659679c7b5a397133

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-74-g36a00096e704/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-74-g36a00096e704/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b7511659679c7b5a397=
134
        new failure (last pass: v4.19.220-50-g08088af69537) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b75201f8f9bcc10839711f

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-74-g36a00096e704/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-74-g36a00096e704/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b75201f8f9bcc=
108397122
        failing since 0 day (last pass: v4.19.220-27-g87731ec9404c, first f=
ail: v4.19.220-50-g08088af69537)
        2 lines

    2021-12-13T14:00:17.563587  <8>[   21.127624] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-13T14:00:17.567472  <6>[   21.138244] [drm] Cannot find any crt=
c or sizes
    2021-12-13T14:00:17.614293  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-13T14:00:17.623518  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
