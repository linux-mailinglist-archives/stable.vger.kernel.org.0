Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A2246AE81
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 00:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377357AbhLFXhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 18:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350946AbhLFXhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 18:37:47 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C25C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 15:34:18 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id f125so12012948pgc.0
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 15:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/MupJ2oI9xD8Tr/PLxDZl1ZJrc7t00wZQvmJWQcNeII=;
        b=K8VklEwQu1J2tyo4rb5DV1uKl0zJKe+fbHzLusQkw4TL4K/n+mok81aZkU0TLp8hhW
         //gvTn+2CrQMPXBJEGVjJR2Ch+DXKHrCRHPGsbBSE9ZtyQMO6OkDb92do93E+AR4pO1V
         /zX0vBfb6ZUbaHGrie71ub1n2uvYuuua0u3z9Os6SK7+Vx8SsyiPORLkS5liJ+5cgv20
         VRyj08pCWXjUzxPtVKvEd4bA5HCka8wL6nUCyug3op0inBXt829jrhklcQ1KYizcIbiv
         9mSgWld1nXdvgPZEunUWbBVF4iib98hYMNe0U0RvR4tEu8oi/T5T/AKVwfpr7Sxnkqyo
         3Y3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/MupJ2oI9xD8Tr/PLxDZl1ZJrc7t00wZQvmJWQcNeII=;
        b=KoJTx53Y8Ik/koGo7N65uwu6ZZD2eSpMAEaVG33wmMOVZrYQb0Qhp9fpkntrv7DR38
         G1B6Lkts/2lEDpP+NasQKDpwzwLRoZ2sVih2iqdkNnzYQo4aLPUKqwj87nllgRWuNcT+
         BQ6a4oVqtagBG7NcwxNycFoTn0JtWiKtMF/xrtMFTy2ZTIRUKznSiFTt2nuarHbA6fqt
         18SIk4d2QJeMODjxP2gQOh+6c2ukdkTX+Ye3ADkX2xIG5JTUEMUIDRINomX7EhtUtUTT
         pTL9HNga0PjGaca7kYOC5GJuhWzMd7JzcpGrAwxGM9qvGTIOiAH9mNY0yK/0oYvIpj5d
         Byng==
X-Gm-Message-State: AOAM530bwKM7fOT0DsItx8V3M3Z9C9Dk6dK7KrGF0zIueIvc0HVDHj6K
        U0b01xxLar1KHN7VQ3V1zQyITg3YRVI0HXFc
X-Google-Smtp-Source: ABdhPJyGPN7fdU3FTe0PoXLtMT+QBwE19G31xXdO1SDppLJURcwmCs27LO5FJji96SHEd9oGvudFDA==
X-Received: by 2002:a63:fd13:: with SMTP id d19mr13239348pgh.501.1638833657512;
        Mon, 06 Dec 2021 15:34:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h8sm10812125pgj.26.2021.12.06.15.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 15:34:17 -0800 (PST)
Message-ID: <61ae9df9.1c69fb81.f69bc.f784@mx.google.com>
Date:   Mon, 06 Dec 2021 15:34:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-53-gf5b0b7aefd9d
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 130 runs,
 3 regressions (v4.4.293-53-gf5b0b7aefd9d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 130 runs, 3 regressions (v4.4.293-53-gf5b0b=
7aefd9d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.293-53-gf5b0b7aefd9d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.293-53-gf5b0b7aefd9d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f5b0b7aefd9d2ea9170ed69c7ab2dfd751fba7d1 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61ae6566f32352d5511a9492

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-53-gf5b0b7aefd9d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-53-gf5b0b7aefd9d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61ae6566f32352d5=
511a9495
        new failure (last pass: v4.4.293-49-ga70466410dce2)
        1 lines

    2021-12-06T19:32:34.315940  /
    2021-12-06T19:32:34.419008   # #
    2021-12-06T19:32:34.419519  =

    2021-12-06T19:32:34.520747  / # #export SHELL=3D/bin/sh
    2021-12-06T19:32:34.521080  =

    2021-12-06T19:32:34.622216  / # export SHELL=3D/bin/sh. /lava-1196993/e=
nvironment
    2021-12-06T19:32:34.622578  =

    2021-12-06T19:32:34.723677  / # . /lava-1196993/environment/lava-119699=
3/bin/lava-test-runner /lava-1196993/0
    2021-12-06T19:32:34.724815  =

    2021-12-06T19:32:34.725593  / # /lava-1196993/bin/lava-test-runner /lav=
a-1196993/0 =

    ... (8 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ae6566f32352d=
5511a9497
        new failure (last pass: v4.4.293-49-ga70466410dce2)
        29 lines

    2021-12-06T19:32:35.087456  [   49.208679] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-06T19:32:35.153764  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-06T19:32:35.159433  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xcb8e0218)
    2021-12-06T19:32:35.163894  kern  :emerg : Stack: (0xcb8e1cf8 to 0xcb8e=
2000)
    2021-12-06T19:32:35.171967  kern  :emerg : 1ce0:                       =
                                bf02bdc4 60000013
    2021-12-06T19:32:35.180226  kern  :emerg : 1d00: bf02bdc8 c06a38e4 0000=
0001 00000000 bf010250 00000002 60000093 00000002   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61ae653f1e7e0988e41a94a7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-53-gf5b0b7aefd9d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-53-gf5b0b7aefd9d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ae653f1e7e098=
8e41a94aa
        failing since 1 day (last pass: v4.4.293-32-g8d63932e73701, first f=
ail: v4.4.293-49-ga70466410dce2)
        2 lines

    2021-12-06T19:31:51.316878  [   18.886810] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-06T19:31:51.366294  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-06T19:31:51.375509  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-06T19:31:51.395699  [   18.967651] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
