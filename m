Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585DC479FED
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 09:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbhLSIne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 03:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbhLSInd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 03:43:33 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC8AC061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 00:43:32 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so9909522pja.1
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 00:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IookQSK2CoKf3WEts3Aj1Kefe3nslro6DoUolCtWapk=;
        b=tJKryf3EVUEyJxctDz+t7TxOtlmdy5+yfBQNABf7VjNkfchf1qEOJEqrNQ04ty73NK
         MoKuhp5iKJnyHSAu+qVjBwibMSOK71y52OJVNju9iDE1ioZYLB5OGpyWplxlfAOSzcrp
         6Jfbgw8by7mAG8m5EE8sE3xKOhu7GXsUV6v8AB1GPenfAm1asv5oHIvlHXBYi8LLy2iw
         C0tjCFDs7g3nmAyY9FYsbMQAPm2S6N2D5CXOjZnDGjF9rSm8firmdwvMKTPCRykCI2Pr
         rejkCtZ/4Y5ooXRFAVwa/xfxKOZWPfZmBswlJMNhp7SYecv3dfzOF3AeqE4TBVdDHOAa
         zSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IookQSK2CoKf3WEts3Aj1Kefe3nslro6DoUolCtWapk=;
        b=JDYaQtyyBWfkMo7nd08uf0aF9v0iGRnZAx9DhwdKVZ19sw6TQiyz3Bg9qc1U8oQntD
         EzBoLV/jXwtB+y3CDff/waxUT+ZY4lnOtcdfM48cyiVyeiP7K/G1B3dZltpmhEtiDYjn
         WuNDwzAWxjHOBz005Rt6jZjCuY+RKuIyqc1K+XJVhi3+MvRzEcBJwcHHVDKRoC4olNyk
         XnUxe+gAsFIVdz2LpX60GAgrV6hS0W2O7hm7pKL7OuZen4kQSQZtbhhYb8S7LzqYE3xY
         mQ19NgYqghYFtQQ5if+49FdWUR9DHlRnuyVQfS4R0ZU1AL5suAiaTKKpUGfDJtjvVdO+
         XQng==
X-Gm-Message-State: AOAM5300HBsQQuNzUr+2BsEdyIlP79Kj0uXZTMKx6QdBDCVBFvSDvAzr
        9xYjrCtOPvLWF7aFgne6/y9TaLxk1TDM1HWO
X-Google-Smtp-Source: ABdhPJwVyISdmMyY1xyBSkMAWjZZcX9n+p51mxwgn2V7oJNHQ72yOD6je6KKbYah4s6rUbbM61oMiA==
X-Received: by 2002:a17:90b:4f4e:: with SMTP id pj14mr21378957pjb.61.1639903412257;
        Sun, 19 Dec 2021 00:43:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y21sm5733448pge.41.2021.12.19.00.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 00:43:31 -0800 (PST)
Message-ID: <61bef0b3.1c69fb81.d2c26.ff54@mx.google.com>
Date:   Sun, 19 Dec 2021 00:43:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-11-ga3118690cea0
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 115 runs,
 2 regressions (v4.4.295-11-ga3118690cea0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 115 runs, 2 regressions (v4.4.295-11-ga311869=
0cea0)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-11-ga3118690cea0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-11-ga3118690cea0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3118690cea0fe1a468239d606b896d452e4784b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61beb74c0f73f3869339713c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
1-ga3118690cea0/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
1-ga3118690cea0/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61beb74c0f73f38693397=
13d
        new failure (last pass: v4.4.295-9-g7d306649b59e) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61beb76264a00e9afa39712b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
1-ga3118690cea0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
1-ga3118690cea0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61beb76264a00e9=
afa39712e
        failing since 0 day (last pass: v4.4.295-6-g6cb713214ea5, first fai=
l: v4.4.295-9-g7d306649b59e)
        2 lines

    2021-12-19T04:38:37.386804  [   19.109008] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-19T04:38:37.436469  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-12-19T04:38:37.446580  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-19T04:38:37.466563  [   19.189270] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
