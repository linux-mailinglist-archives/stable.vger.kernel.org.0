Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F967471C6E
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 20:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhLLTDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 14:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbhLLTDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 14:03:40 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE27C061714
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 11:03:39 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u17so9708014plg.9
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 11:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r2Fybb9mTHCsTAxXgQJkyJqSkEgq6cCmYk91nyto5/U=;
        b=L1nGBU8LPW5RDtvMejWCGMxAilSniRwmJUWmyal0Ii0MvqetHoFedn1NutnXfIfssZ
         5QRkIUMyQGTnLH2CKbsNFXqIXzLZfuPOs9zenUAviC2MoDU3OpqwxvAWoHkhE14UCWmM
         f/m4GSATGw+EkIA23F0tr/avxM3n+0+QJpJ+YKVkPqX5l03Q34O/VGXc3P1Dh8tM4+3i
         GtU8BkmR/SEo23ftZ3lMT3mLb1MYgwHJilklqIdnSTNlsuUFm/p4J/GzdaptVwiWSO6T
         oSTuxzMK5Z7hQisX1mHSgm1cBoLzmnepTklKnhDsTkbJ2+ZBNd9EbCtlcyK9nRKKkZrU
         +twA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r2Fybb9mTHCsTAxXgQJkyJqSkEgq6cCmYk91nyto5/U=;
        b=Ewcs/U6I03eW1mYXG+ueDRTZN686Ab4DME1i2C7M78/+Ti1xXkU+oL4EPjAqmIQzC3
         bNMHzaeJLkM6aQx/JO8K4gsyjLBAu1TmJtE+Ah3kdTGbO0drk4Dw2B9nOccn/vLDOrCt
         Ekai8Zg8NBhT/ya87HS4ATmEP/FskhINEyVywE0CaYEFT5a2Kv1AlZ4w8Py+EdoLwgq5
         odf0YGh+efSL9Uc+5OD09TQPeUhw1U5BKtyEH5zj8TioxVc8cZ1h5ngvuIKnLk+SJwtl
         /0e8GW+q8A4e45v34FYW2jhiwoeVkBI5SvaFr6gUollAK8PdpzOS0VQGQ9BkJVTpH1Ka
         aEOg==
X-Gm-Message-State: AOAM533ewVrJKtyvko0jN6e6SEBmLzPnq6wyfuZXClkDoIJlb0+y8lkq
        O4v7BqeqOWa7YoKYHdS7gm2cfIh6chnUvsy1
X-Google-Smtp-Source: ABdhPJxvG3of+4IMxyFtaCa2QSV5M27cOizRyfjPnUjPE4V8CU5phXpLQwyDixhs2L4ypK5L9W/YMg==
X-Received: by 2002:a17:90a:be0f:: with SMTP id a15mr38601915pjs.243.1639335819023;
        Sun, 12 Dec 2021 11:03:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11sm4654843pjl.20.2021.12.12.11.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 11:03:38 -0800 (PST)
Message-ID: <61b6478a.1c69fb81.17d69.c95a@mx.google.com>
Date:   Sun, 12 Dec 2021 11:03:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.294-20-gc778b3c7e92d
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 126 runs,
 3 regressions (v4.4.294-20-gc778b3c7e92d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 126 runs, 3 regressions (v4.4.294-20-gc778b3c=
7e92d)

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
el/v4.4.294-20-gc778b3c7e92d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.294-20-gc778b3c7e92d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c778b3c7e92d89155acef5d443309de10b81186a =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61b60da2b45bb43fc539711e

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-2=
0-gc778b3c7e92d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-2=
0-gc778b3c7e92d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61b60da2b45bb43f=
c5397121
        new failure (last pass: v4.4.294-9-gc0c2458dacd8)
        1 lines

    2021-12-12T14:56:16.390537  / # =

    2021-12-12T14:56:16.391274  #
    2021-12-12T14:56:16.494086  / # #
    2021-12-12T14:56:16.494575  =

    2021-12-12T14:56:16.595876  / # #export SHELL=3D/bin/sh
    2021-12-12T14:56:16.596176  =

    2021-12-12T14:56:16.697320  / # export SHELL=3D/bin/sh. /lava-1230832/e=
nvironment
    2021-12-12T14:56:16.697712  =

    2021-12-12T14:56:16.798905  / # . /lava-1230832/environment/lava-123083=
2/bin/lava-test-runner /lava-1230832/0
    2021-12-12T14:56:16.799833   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b60da2b45bb43=
fc5397123
        new failure (last pass: v4.4.294-9-gc0c2458dacd8)
        29 lines

    2021-12-12T14:56:17.262148  [   49.435943] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-12T14:56:17.315160  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-12T14:56:17.321151  kern  :emerg : Process udevd (pid: 115, sta=
ck limit =3D 0xcbaa6218)
    2021-12-12T14:56:17.325757  kern  :emerg : Stack: (0xcbaa7cf8 to 0xcbaa=
8000)
    2021-12-12T14:56:17.333489  kern  :emerg : 7ce0:                       =
                                bf02bdc4 60000013
    2021-12-12T14:56:17.346721  kern  :emerg : 7d00: bf02bdc8 c06a39a4 0000=
0001 00[   49.516998] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D29>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61b60da16c39075ce5397141

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-2=
0-gc778b3c7e92d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-2=
0-gc778b3c7e92d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b60da16c39075=
ce5397144
        new failure (last pass: v4.4.294-9-gc0c2458dacd8)
        2 lines

    2021-12-12T14:56:13.063334  [   18.838928] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-12T14:56:13.115423  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-12T14:56:13.124880  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
