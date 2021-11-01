Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB4A44133F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 06:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhKAFe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 01:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhKAFe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 01:34:28 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A97C061714
        for <stable@vger.kernel.org>; Sun, 31 Oct 2021 22:31:55 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id x5so6439905pgk.11
        for <stable@vger.kernel.org>; Sun, 31 Oct 2021 22:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UH5UwPSu4qMuNJ+NNbP4He8bKa/kkjUYjmz7DFQO75I=;
        b=y3v6PK6MhJZODhrLd6NPJIdIM1p0zdbTLeWzb/01OQoHmgs5mx5al+aAIjUAAWnbVP
         zuoihp7HOsT9En4Qo91chtCs7Ve3xkpd9//xw4GyDRwEpxukTz5Fw0gFnmvsn2i0idzj
         j2pBMDOsC5tYiEaZv/+WiPRiTGCszyhj8oTIZfvbIud6H1eVI57H6EF4/ECvUrhoBswT
         Xf3BhjiLCvBX82WnjOcnM0x7KS77FMB3IqXbhphpGNIQcmfd+31fnWwI2TXiwgyg8rtZ
         IELBgbpdyDIg1wY+jk/qXgG9hGAbbxZlpXDzucgKfrKSR1t33l+bOci+c5g93iCdh06G
         EWtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UH5UwPSu4qMuNJ+NNbP4He8bKa/kkjUYjmz7DFQO75I=;
        b=3yflCzLOnygOMliDIdjv59ThexRUA6/541HK/vLhgWjeuKO0yaTafU8wpTe7lPScaw
         Xdg1O56qHqvfendzkdcSy9/3LYNmmgZX25OuCxP2drWbYfSpckZxPpXfdb+qm7+xZNvv
         CtddWwHt9Wl4DqHxp6NXc/gU8+EEwej+WTF62NcDaukptwKzTx2HJR9+jZjexMjf+8yL
         ZTuOGfbJG/uvg0Gw4nfujthUTkUVzjZu5TUQveDeD83Ld1TmaAPoNyPZKz0VUQy5UgJb
         bIPYPtbxwFMpkr9zaAA9FJA/w5CKXcFfpObYj1Nrx/5AclbK/rjCRqoKNV6Ofw7DLas3
         mIsg==
X-Gm-Message-State: AOAM532ploJI9HxEO+d3Wm595B5TwUCxNzi/L23wm8mMSWtelcjTYZ1I
        KHEY4UaB0UP7Ep+5oMZkVW0airzGsyZimoqy
X-Google-Smtp-Source: ABdhPJxl/LlFe+pWaDuy9Wpp4TDfLZzzFX1yD2xhne1m4u1q/CSQDPAtAdfqTV5FZP+CVQRkLMBdQw==
X-Received: by 2002:a05:6a00:b8b:b0:481:16a1:abff with SMTP id g11-20020a056a000b8b00b0048116a1abffmr481471pfj.77.1635744714219;
        Sun, 31 Oct 2021 22:31:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm11588363pgf.14.2021.10.31.22.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 22:31:53 -0700 (PDT)
Message-ID: <617f7bc9.1c69fb81.a01cf.10a6@mx.google.com>
Date:   Sun, 31 Oct 2021 22:31:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.290-17-g29346b44ffae
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 58 runs,
 3 regressions (v4.4.290-17-g29346b44ffae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 58 runs, 3 regressions (v4.4.290-17-g29346b44=
ffae)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.290-17-g29346b44ffae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.290-17-g29346b44ffae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29346b44ffae4330e9b77d3d6cf70ab3218ff87c =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/617f49eb326a6e5512335916

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-1=
7-g29346b44ffae/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-1=
7-g29346b44ffae/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/617f49eb326a6e55=
12335919
        failing since 1 day (last pass: v4.4.290-15-g2a82217a1115, first fa=
il: v4.4.290-17-g18caef77d35b)
        1 lines

    2021-11-01T01:58:49.316862  / # =

    2021-11-01T01:58:49.317485  #
    2021-11-01T01:58:49.420723  / # #
    2021-11-01T01:58:49.421328  =

    2021-11-01T01:58:49.522598  / # #export SHELL=3D/bin/sh
    2021-11-01T01:58:49.522931  =

    2021-11-01T01:58:49.624034  / # export SHELL=3D/bin/sh. /lava-1009147/e=
nvironment
    2021-11-01T01:58:49.624372  =

    2021-11-01T01:58:49.725520  / # . /lava-1009147/environment/lava-100914=
7/bin/lava-test-runner /lava-1009147/0
    2021-11-01T01:58:49.726632   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617f49eb326a6e5=
51233591b
        failing since 1 day (last pass: v4.4.290-15-g2a82217a1115, first fa=
il: v4.4.290-17-g18caef77d35b)
        29 lines

    2021-11-01T01:58:50.191668  [   49.405883] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-01T01:58:50.244390  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-11-01T01:58:50.250261  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0xcb964218)
    2021-11-01T01:58:50.254520  kern  :emerg : Stack: (0xcb965cf8 to 0xcb96=
6000)
    2021-11-01T01:58:50.262697  kern  :emerg : 5ce0:                       =
                                bf02bdc4 60000013
    2021-11-01T01:58:50.275827  kern  :emerg : 5d00: bf02bdc8 c06a350c 0000=
0001 00[   49.486999] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D29>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/617f4a226c2a055c4d3358fd

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-1=
7-g29346b44ffae/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-1=
7-g29346b44ffae/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617f4a226c2a055=
c4d335900
        failing since 1 day (last pass: v4.4.290-9-g87e26bdcfc0f, first fai=
l: v4.4.290-15-g2a82217a1115)
        2 lines

    2021-11-01T01:59:28.429049  [   18.971679] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-01T01:59:28.478887  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-01T01:59:28.487712  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
