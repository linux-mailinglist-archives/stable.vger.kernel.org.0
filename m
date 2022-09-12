Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2305B5E4D
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiILQeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 12:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiILQd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 12:33:59 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36BA1D0C6
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 09:33:58 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x1so9114795plv.5
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 09:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=vOoh5qC15wqp2NQpBa/ZqFrrrcPdNFbqWd/K0wfSJl4=;
        b=RtV3J/UjxXs1jOye1ZAD7THhAmsvhtGMN44HSECSEMMDLdOxf8LvAo7ukJLhAq2GBW
         5Du1hWnNr6/0TQU3XCgI0tnj1KukZ940nHLC+DTpXXCs+v9tblUKqgNaRZVFu7iBgAVM
         n7viq5lR93Jl5XYZ6B5oCoqTNZI+IKmgIf2kcREz94q4LWfPLg7yrIZMUq3QGMIIuuL2
         FrXNfkUWfck+nGB7VBkfhxh3vj6XozescV7Iw5oww6n5BLTNSv1xphC7PiWNJhazmaLS
         3WHCWKHzszY3cx1ek/hNEzglkjCfQV0zPDkfRiLtHlaHOND+9Vklz4PLta/00ESBmu9P
         B/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=vOoh5qC15wqp2NQpBa/ZqFrrrcPdNFbqWd/K0wfSJl4=;
        b=0R1VqYk9rRVjVca+8Qzs7lmYfbGHxHDhpjyLByGz9sXo4y/zQfmGC7mgOAJk18q2DS
         Csq0j3dFTp/TI+RPIA0BHx6HrjJJmeuN6EKUOt2lqGJyjTSi60t5HBOzXHpNo+vo2/uK
         aG1KuqfGM4cdQxwrJVCK7i7bwPtDU7CdRFMai5XGaYWiIq2tudgFVkm+PSMrgtGG5f0y
         j8bGRE37Gt7iM6okMzrhafIlqovREb89NczehcM6JTBhc07guHrAYxOkbQ0OT3t1uhdj
         WZ/p2GEVossg208+tFFkO9B2p23KljmDBUnLXWQyomIat6Oqrjlt2zSGk/X13LzsHyaS
         Emuw==
X-Gm-Message-State: ACgBeo1S7PMqDtyMzKKLdz+3LnBXIdU1wdiyujgiGQ85HhO8v9BNuqPT
        IzR1lGIWEZLo9FPQpa98uv76Y34ngk8iYRcMXDk=
X-Google-Smtp-Source: AA6agR5TW0fl89Uir3MTLJsnQEEcydGrgErIj9F0so5AXh2Tn9vClAhkOIUmS6mXc7jDyRaYaaS0cg==
X-Received: by 2002:a17:90b:38cb:b0:200:aaa6:6428 with SMTP id nn11-20020a17090b38cb00b00200aaa66428mr25054596pjb.47.1663000438126;
        Mon, 12 Sep 2022 09:33:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w71-20020a627b4a000000b00541196bd2d9sm5785505pfc.68.2022.09.12.09.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 09:33:57 -0700 (PDT)
Message-ID: <631f5f75.620a0220.b6f76.8fdc@mx.google.com>
Date:   Mon, 12 Sep 2022 09:33:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.66-115-g0b77c83157a0
Subject: stable-rc/queue/5.15 baseline: 194 runs,
 3 regressions (v5.15.66-115-g0b77c83157a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 194 runs, 3 regressions (v5.15.66-115-g0b77c=
83157a0)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
beagle-xm          | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g          | 1          =

hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

imx7d-sdb          | arm    | lab-nxp       | gcc-10   | imx_v6_v7_defconfi=
g          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.66-115-g0b77c83157a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.66-115-g0b77c83157a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0b77c83157a0d671793f3e5e2f7d59f750a97659 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
beagle-xm          | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g          | 1          =


  Details:     https://kernelci.org/test/plan/id/631f2f36b126e247d935566c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
115-g0b77c83157a0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
115-g0b77c83157a0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f2f36b126e247d9355=
66d
        failing since 165 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/631f2c32ddd3280cb2355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
115-g0b77c83157a0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
115-g0b77c83157a0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f2c32ddd3280cb2355=
656
        new failure (last pass: v5.15.63-318-g324e0ca7e112) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
imx7d-sdb          | arm    | lab-nxp       | gcc-10   | imx_v6_v7_defconfi=
g          | 1          =


  Details:     https://kernelci.org/test/plan/id/631f2e1eddad6ff77535566d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
115-g0b77c83157a0/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
115-g0b77c83157a0/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/631f2e1eddad6ff=
775355672
        new failure (last pass: v5.15.63-318-g324e0ca7e112)
        2 lines

    2022-09-12T13:02:54.902119  kern  :emerg : BUG: spinlock wrong CPU on C=
PU#0, swapper/0/1
    2022-09-12T13:02:54.902344  kern  :emerg :  lock: 0xc49c890c, .magic: d=
ead4ead, .owner: swapper/0/1, .owner_cpu: 1
    2022-09-12T13:02:54.902666  <8>[   29.590082] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2022-09-12T13:02:54.902777  + set +x   =

 =20
