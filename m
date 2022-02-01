Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944AE4A67A2
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 23:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236890AbiBAWSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 17:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiBAWSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 17:18:01 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977B8C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 14:18:01 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so4053122pjb.5
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 14:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yZa/AitUtffGKClgF+hg4CJ053tcYYvHrUaHk/H087A=;
        b=q4RMKVWrYugnPKCr/aAVKC+4Mum50Te1DRiNWwz3bFrQZeal7eTV4Nq4gevpI1DC4Z
         EEMi9jsWAyWNcuWYY4FdHIPbr4z2gLFD7paCawJMziwhQbkJpdm/3Ly8FFG30oBRfTYx
         /preOxPgaKa+31u7syBVU2NHwuJeFQmhVMJifn9tGQg7Eu6RkcU0LrtwlCvvXirWTEJS
         F/wmBG2eKvxU2IxTyPntdKNesQt6infS8doN/oqZXWUS5z9IpuAu7rBfILo9zqrDR7Gw
         nt0p6/CWee7+FcWwOULGURt/vyHAVAdsktUgJSNgv6OkXYPHMul76IsWAgbKNVplShI8
         l3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yZa/AitUtffGKClgF+hg4CJ053tcYYvHrUaHk/H087A=;
        b=lIEZdi16RoeThurkOWWJJ6P/mlw9RO2mZiNciDUTTusU8sJV6CuxPaY7WgQnQaCAaE
         agk0YjTbl54cB4E+z7ZbiOYswaAsN09aeWEi8IopKPMkhKMZb1aVkxOjsEiKGGp1Iopg
         kXLoY3cdKIisThDgmHiymj0k4gHSEXlpLVczhnrLFnmCZvzt4kwyY2vktFLVBKAYjWpu
         +R3HLinQKfsEcMlamKllrkVaaLOwYv008ZlTF3zvS6HP7taMdgPWcjwgO3r6svDnn4mz
         EOItmFKQaAT3hIlCaUkorR7HAnQRVCSR6HZIQevRTE1hEExAHzCFExf+wossEbA7dMGT
         NluA==
X-Gm-Message-State: AOAM5337/okl62jF6k/MlXyKmhN4RNjeQfQjo5g7UyVhZnDSpX/Q4u4L
        r8LjXsPaMychJUq8tl9D2md3zPVL8fLYIHWo
X-Google-Smtp-Source: ABdhPJyqZwRP8fvsbcVYfe0mAvRsuiMSTB9cjyZbdZ7Ccz4KmfvpveziRZpYhhCNupCK7MB3HoTIaQ==
X-Received: by 2002:a17:902:ac97:: with SMTP id h23mr28000543plr.82.1643753880873;
        Tue, 01 Feb 2022 14:18:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1sm23225740pfh.167.2022.02.01.14.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 14:18:00 -0800 (PST)
Message-ID: <61f9b198.1c69fb81.144f4.d37f@mx.google.com>
Date:   Tue, 01 Feb 2022 14:18:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.301-22-gd8d7961f5bb2
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 119 runs,
 1 regressions (v4.4.301-22-gd8d7961f5bb2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 119 runs, 1 regressions (v4.4.301-22-gd8d7961=
f5bb2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.301-22-gd8d7961f5bb2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.301-22-gd8d7961f5bb2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8d7961f5bb25c1b80492440b577dbd12fd6efb1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f9796ceb30fb86595d6ee9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
2-gd8d7961f5bb2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
2-gd8d7961f5bb2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f9796ceb30fb8=
6595d6eef
        failing since 0 day (last pass: v4.4.301-21-gf1b3a01fec55, first fa=
il: v4.4.301-21-g4b4eb3554fea)
        2 lines

    2022-02-01T18:18:00.314881  [   19.134613] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-01T18:18:00.364781  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/115
    2022-02-01T18:18:00.373995  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
