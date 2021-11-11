Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E5344D015
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 03:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbhKKCnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 21:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbhKKCni (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 21:43:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F2DC061766
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 18:40:50 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v23so3091344pjr.5
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 18:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lJv1xBqM8YjITJpvkhn5GJ32YGvltILhlnxN25wQxCQ=;
        b=WLZzRKrNRH6m5awFFzlnhbS26zK6912IEPc7VHTE8hWMYMExnKaD01nI/rOT7/nT/z
         dIsmV+i7cvGw21K704VrEj7WknueCqLYuCsDojabuoS42B1kOaEXP+2K84eiHfmUTebe
         U7JCfWrWZN+4G25mYXJh3M7XeV/k35UERVqvFBccYGXlkE8UPDPIoO5xZLuwe6gtFZ1e
         qpejjcnbgPl52tieb4/4vRfVNNvpRAq3rYKE3FcHXGDrxjRxeTpfIEjHVTI1yhcMsroW
         Qw8xBKDkrCGhlzVnqX3IG1urrImIBuTwM46NB3PUOvLOfw0BFHWdP979rtIXCDFw7XGC
         v54g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lJv1xBqM8YjITJpvkhn5GJ32YGvltILhlnxN25wQxCQ=;
        b=YUe2genFOetEJRpTIh2j16/Kx4ltTpiKp6d5WOtAkcJCHb2Fihj5O/QkH1mTZA/7qn
         /VxPGoI44L0pTcGU2ocnihNznOaOe0i1OUmyCy4xz0R0iRtju62/5d6C62V4dL9d43mT
         GYrB+tRDm2DoAjkgEG2/X4uD53xHLLg7o35tKygCOCZeQxtLbJy2HvZTiikCT4QNANy5
         ZPXiTOJ75fjnXfIf1TlWoNbdm2znMh/COtpdvZnF5xJwFj9OF1YmsmqUEwWRW8A446+n
         nDd4z3M3ioPGwB6iw9CQroKI4l0efKLxbQC16sqybmjlrCfmE6J0CdJYSGpHAVdCl20D
         O/GQ==
X-Gm-Message-State: AOAM530wGlzORDexvjG8qoWRcTZ4Rnj9y6W0iktoalKjiKUO8t7UEwLV
        OQbIXD86WJITEKEzP1VzyU2gBXsGucM1S+ce3oo=
X-Google-Smtp-Source: ABdhPJy3AynJH+xEP3LXvqPOWdkRBUjmkrG8fHyDLFaHuVAAKJ2n8Vruh18OlDZiZSLwzFkpOKfvcA==
X-Received: by 2002:a17:90b:3e8b:: with SMTP id rj11mr4463931pjb.63.1636598449792;
        Wed, 10 Nov 2021 18:40:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k19sm969088pff.20.2021.11.10.18.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 18:40:49 -0800 (PST)
Message-ID: <618c82b1.1c69fb81.d7bf0.44e7@mx.google.com>
Date:   Wed, 10 Nov 2021 18:40:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-19-g4087fc507b36
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 117 runs,
 1 regressions (v4.4.291-19-g4087fc507b36)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 117 runs, 1 regressions (v4.4.291-19-g4087fc5=
07b36)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-19-g4087fc507b36/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-19-g4087fc507b36
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4087fc507b36314fbe0f3ebd356b388e366a1d48 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618c49e3492da456ee3358e8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-1=
9-g4087fc507b36/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-1=
9-g4087fc507b36/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618c49e3492da45=
6ee3358eb
        failing since 0 day (last pass: v4.4.291-8-g748a6d994abf, first fai=
l: v4.4.291-9-gf5954069c4ee)
        2 lines

    2021-11-10T22:38:08.043640  [   19.681732] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-10T22:38:08.087585  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-11-10T22:38:08.096701  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
