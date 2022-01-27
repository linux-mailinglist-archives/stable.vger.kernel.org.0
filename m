Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D7D49EEC1
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 00:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiA0XTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 18:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiA0XTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 18:19:33 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93030C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:19:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q63so4797310pja.1
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4rHyMe/s3AUumK+tLTta0r6Kh3LbAiYCzN/wzebhw94=;
        b=rECkKkeJtoTtUjt8b50AV8JttFkBIGf+lpT+e2wKm+r3LIEI6cX+Lv3sLYsgBGT8j8
         2rDGRR9tiJ0OtXtLAp3L9h/JPrhJxGRlsj7JDC0C7vF4Gc1WdAd9OMYHCdgVL0oXXRz2
         F0cnRstwO5J4WiNgPnjAno45S89dc3BeCtNxhkiqmIGhqjipUsWIqHdrIWFgAFVRRFts
         WNDzq/8snvuEOYmCCUfeWKF7HxD6lSeSMiqpLCEodcv6BUGv9beozam8zUkDrXQO2AG5
         EDXFR82VgtOm8rIQ5JQwAr4wjQq8ljzLBOs7F+GDufj2P7fw4Q8YdQPwhGIukJD7ldcg
         5l2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4rHyMe/s3AUumK+tLTta0r6Kh3LbAiYCzN/wzebhw94=;
        b=VfFloVD02XX2j83PqA8+8mlxYfGAceOZgnpHZFXk2paNHvmgoyBSbc8jmNza+4I8I8
         2Oj4AiR/AyPIFK6l0qA9F0U8EdPSTtJhYZfD9fVD/QzN4CCL7wpo9M0kvttJXZkiIG+1
         5M0dcTpug6E3svMxQy1ULIJOGY2uydsBhe004wqaQ69xhNmBwsR/bcLpSLl95KhYqejV
         MHlIugictnvQa/iuBqCh7tKz0wbo0EuxLG+Xl4LJMTP4yseZ7Zeneb2cAxHF7o2MEs5V
         7o7rHieWHn59gaNHcx2sjwFp9HSjlMmdKU0pC9yeSRtqTz8qbKJihE4+7RiyFICewICJ
         McHA==
X-Gm-Message-State: AOAM53250OxYjjUsY/s6SiWareiS+8vryuyzDXBy1fWs0N+UgYHIXKAJ
        MGXuRcLZIBx0glj6EXoid3LT4sEiKxRLn5PMYFo=
X-Google-Smtp-Source: ABdhPJxqAn0cI1Uf0iVQIsa/90BS+JqlA6saat8o38jwL9VcPlD+rUh5Slbc6ZnOVThe1dIq2GknTw==
X-Received: by 2002:a17:90b:4b52:: with SMTP id mi18mr6689551pjb.74.1643325572962;
        Thu, 27 Jan 2022 15:19:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s7sm6983216pfu.133.2022.01.27.15.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 15:19:32 -0800 (PST)
Message-ID: <61f32884.1c69fb81.7752.4140@mx.google.com>
Date:   Thu, 27 Jan 2022 15:19:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.300-1-g5b4f04e1d4173
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 101 runs,
 3 regressions (v4.4.300-1-g5b4f04e1d4173)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 101 runs, 3 regressions (v4.4.300-1-g5b4f04e1=
d4173)

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
el/v4.4.300-1-g5b4f04e1d4173/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.300-1-g5b4f04e1d4173
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b4f04e1d417332f01274718da75df3937e02903 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61f2ed4f09c7c2cd22abbd11

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.300-1=
-g5b4f04e1d4173/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.300-1=
-g5b4f04e1d4173/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61f2ed4f09c7c2cd=
22abbd17
        failing since 1 day (last pass: v4.4.299-113-g69586d700c98, first f=
ail: v4.4.299-113-g0e155d64d107)
        1 lines

    2022-01-27T19:06:37.099044  / # =

    2022-01-27T19:06:37.099732  #
    2022-01-27T19:06:37.202604  / # #
    2022-01-27T19:06:37.203186  =

    2022-01-27T19:06:37.304426  / # #export SHELL=3D/bin/sh
    2022-01-27T19:06:37.304737  =

    2022-01-27T19:06:37.405826  / # export SHELL=3D/bin/sh. /lava-1459143/e=
nvironment
    2022-01-27T19:06:37.406144  =

    2022-01-27T19:06:37.507299  / # . /lava-1459143/environment/lava-145914=
3/bin/lava-test-runner /lava-1459143/0
    2022-01-27T19:06:37.508195   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f2ed4f09c7c2c=
d22abbd19
        failing since 1 day (last pass: v4.4.299-113-g69586d700c98, first f=
ail: v4.4.299-113-g0e155d64d107)
        29 lines

    2022-01-27T19:06:37.970833  [   49.456878] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-27T19:06:38.023849  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-01-27T19:06:38.029503  kern  :emerg : Process udevd (pid: 111, sta=
ck limit =3D 0xcb98a218)
    2022-01-27T19:06:38.033929  kern  :emerg : Stack: (0xcb98bcf8 to 0xcb98=
c000)
    2022-01-27T19:06:38.042054  kern  :emerg : bce0:                       =
                                bf02bdc4 60000013   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61f2ed9879b9388cc0abbd19

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.300-1=
-g5b4f04e1d4173/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.300-1=
-g5b4f04e1d4173/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f2ed9879b9388=
cc0abbd1f
        new failure (last pass: v4.4.299-113-g0e155d64d107)
        2 lines

    2022-01-27T19:07:54.289901  [   19.414398] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-27T19:07:54.340644  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2022-01-27T19:07:54.350504  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
