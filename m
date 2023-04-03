Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BBD6D4D34
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjDCQHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjDCQHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 12:07:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C94A2D79
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:07:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso31076885pjb.2
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 09:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680538041;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=d3JJaMpyozjYgLnvXQMMb3jPSvtqqg0AnrdtiJ3RoVY=;
        b=jyNKMLQq+4kbtdGcVMxzD+h0sEzsdlc7L3uSSvJrpIiBUiYolbC5ttxAMkK9U/1+Ez
         Z/yO6rh7dZ2PJueTQOOFOP1Rf0MPWYgsexrHNbe1phsjba9D7xM0o9Pg3NYjx4Dugu0U
         sMyr04cqj6L8p8IMHJ+mrGkqUbKOalwThtFMZw+0PxKMNABOj1YHdBxjeNnPDT+V6GNC
         PvNnVMDqaiha9aA8N76ttLKa4h3Ny+nCy0473IDvjEgVYyQZK31gb62ucQk0DZmzsCJK
         hLOMUcOKNkwst5sjYZ0kA1WFeQ+dIp4AQXV5rxzl0BTZYdyExHxlOBUYn5+GS3BZbPV3
         bDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680538041;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d3JJaMpyozjYgLnvXQMMb3jPSvtqqg0AnrdtiJ3RoVY=;
        b=VhnrEuzkkru1C5c6K6DX+qcV5uj2bvI/TtrTb8Efv9RMkzFz6JYI27ekfcag340yO4
         cmwi2jKK6b4GgW0DNkLdLB9C2oWwSkkd/o+sQbHTvtMq013QEpIpcjXyrcvOhPe9apZo
         XrnmahVRU2fP6sciFiClSYXbQ95Xf+lq4WPC7t6QltSTPR+Fkcgn7oORzVsGSZ2/r+N2
         LOAN83Vif4xjX1CUJjw4XPDk8+8+SqgUQuu7KMCx5DZC8FcueiMOkke+OOyOg8Z5cUl9
         2kN7oKupLXlbnqd3Y1Ht+yE6LkjPL1n8KtxO2dC9XhzpXTsUmEVcBjnQ9fIlVTAGDr6T
         pgCA==
X-Gm-Message-State: AAQBX9egKEp4yvJ7EWNmC21bM7HMKTDmiBi2rZnXt6RNQly8+qPpjdIi
        eNW6LSVNRzwhWtlmTxlRBowtnukkbiuz4tN2Cr/uZA==
X-Google-Smtp-Source: AKy350ZY9rWokhhgdAO79xXsRHHfZ2gilBvBmDKT2Q6mESGW2eoa4jE5htd59FoZIYKsdw5M9zqdBg==
X-Received: by 2002:a17:90a:e7cf:b0:23e:f855:79ed with SMTP id kb15-20020a17090ae7cf00b0023ef85579edmr40871078pjb.28.1680538041116;
        Mon, 03 Apr 2023 09:07:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq6-20020a17090b380600b00233864f21a7sm9861011pjb.51.2023.04.03.09.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 09:07:20 -0700 (PDT)
Message-ID: <642af9b8.170a0220.f2d06.308c@mx.google.com>
Date:   Mon, 03 Apr 2023 09:07:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-89-g304cf5ec8cf9
Subject: stable-rc/queue/5.15 baseline: 117 runs,
 9 regressions (v5.15.105-89-g304cf5ec8cf9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 117 runs, 9 regressions (v5.15.105-89-g304cf=
5ec8cf9)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-89-g304cf5ec8cf9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-89-g304cf5ec8cf9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      304cf5ec8cf9a98a89e0e523f8b582b113dea692 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ac7e7e871fe36d662f76b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ac7e7e871fe36d662f770
        failing since 6 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T12:34:38.180941  <8>[    8.288456] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850149_1.4.2.3.1>

    2023-04-03T12:34:38.184180  + set +x

    2023-04-03T12:34:38.291045  / # #

    2023-04-03T12:34:38.393588  export SHELL=3D/bin/sh

    2023-04-03T12:34:38.394351  #

    2023-04-03T12:34:38.496043  / # export SHELL=3D/bin/sh. /lava-9850149/e=
nvironment

    2023-04-03T12:34:38.496806  =


    2023-04-03T12:34:38.598487  / # . /lava-9850149/environment/lava-985014=
9/bin/lava-test-runner /lava-9850149/1

    2023-04-03T12:34:38.598795  =


    2023-04-03T12:34:38.604845  / # /lava-9850149/bin/lava-test-runner /lav=
a-9850149/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ac7ebe871fe36d662f7ad

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ac7ebe871fe36d662f7b2
        failing since 6 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T12:34:41.426881  + set<8>[   11.000851] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9850169_1.4.2.3.1>

    2023-04-03T12:34:41.426977   +x

    2023-04-03T12:34:41.531419  / # #

    2023-04-03T12:34:41.632678  export SHELL=3D/bin/sh

    2023-04-03T12:34:41.632934  #

    2023-04-03T12:34:41.733880  / # export SHELL=3D/bin/sh. /lava-9850169/e=
nvironment

    2023-04-03T12:34:41.734107  =


    2023-04-03T12:34:41.835109  / # . /lava-9850169/environment/lava-985016=
9/bin/lava-test-runner /lava-9850169/1

    2023-04-03T12:34:41.835451  =


    2023-04-03T12:34:41.840103  / # /lava-9850169/bin/lava-test-runner /lav=
a-9850169/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ac7f885867e27ed62f798

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ac7f885867e27ed62f79d
        failing since 6 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T12:34:48.226668  <8>[   10.657348] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850114_1.4.2.3.1>

    2023-04-03T12:34:48.229718  + set +x

    2023-04-03T12:34:48.331348  #

    2023-04-03T12:34:48.432561  / # #export SHELL=3D/bin/sh

    2023-04-03T12:34:48.432743  =


    2023-04-03T12:34:48.533676  / # export SHELL=3D/bin/sh. /lava-9850114/e=
nvironment

    2023-04-03T12:34:48.533858  =


    2023-04-03T12:34:48.634618  / # . /lava-9850114/environment/lava-985011=
4/bin/lava-test-runner /lava-9850114/1

    2023-04-03T12:34:48.634894  =


    2023-04-03T12:34:48.639744  / # /lava-9850114/bin/lava-test-runner /lav=
a-9850114/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642ac8e2f6ad85f5e162f777

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642ac8e2f6ad85f5e162f=
778
        failing since 59 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642ac7667eed5d4add62f7dc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ac7667eed5d4add62f7e1
        failing since 76 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-03T12:32:24.586586  + set +x<8>[    9.979871] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3467495_1.5.2.4.1>
    2023-04-03T12:32:24.587309  =

    2023-04-03T12:32:24.699202  / # #
    2023-04-03T12:32:24.802969  export SHELL=3D/bin/sh
    2023-04-03T12:32:24.804135  #
    2023-04-03T12:32:24.804864  / # export SHELL=3D/bin/sh<3>[   10.193219]=
 Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-03T12:32:24.907152  . /lava-3467495/environment
    2023-04-03T12:32:24.908382  =

    2023-04-03T12:32:25.010775  / # . /lava-3467495/environment/lava-346749=
5/bin/lava-test-runner /lava-3467495/1
    2023-04-03T12:32:25.012614   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ac7dc84caebff7d62f76b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ac7dc84caebff7d62f770
        failing since 6 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T12:34:26.211185  + set +x

    2023-04-03T12:34:26.217772  <8>[   10.657178] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850112_1.4.2.3.1>

    2023-04-03T12:34:26.322284  / # #

    2023-04-03T12:34:26.423314  export SHELL=3D/bin/sh

    2023-04-03T12:34:26.423543  #

    2023-04-03T12:34:26.524473  / # export SHELL=3D/bin/sh. /lava-9850112/e=
nvironment

    2023-04-03T12:34:26.524645  =


    2023-04-03T12:34:26.625529  / # . /lava-9850112/environment/lava-985011=
2/bin/lava-test-runner /lava-9850112/1

    2023-04-03T12:34:26.625839  =


    2023-04-03T12:34:26.629889  / # /lava-9850112/bin/lava-test-runner /lav=
a-9850112/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ac7d0ac4f7f91be62f779

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ac7d0ac4f7f91be62f77e
        failing since 6 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T12:34:19.973089  + set +x

    2023-04-03T12:34:19.978175  <8>[   10.238323] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850090_1.4.2.3.1>

    2023-04-03T12:34:20.086185  #

    2023-04-03T12:34:20.087411  =


    2023-04-03T12:34:20.189805  / # #export SHELL=3D/bin/sh

    2023-04-03T12:34:20.190595  =


    2023-04-03T12:34:20.292503  / # export SHELL=3D/bin/sh. /lava-9850090/e=
nvironment

    2023-04-03T12:34:20.293292  =


    2023-04-03T12:34:20.395613  / # . /lava-9850090/environment/lava-985009=
0/bin/lava-test-runner /lava-9850090/1

    2023-04-03T12:34:20.396971  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ac7eae871fe36d662f7a2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ac7eae871fe36d662f7a7
        failing since 6 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T12:34:30.158242  + set +x<8>[   10.905725] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9850109_1.4.2.3.1>

    2023-04-03T12:34:30.158330  =


    2023-04-03T12:34:30.263019  / # #

    2023-04-03T12:34:30.364031  export SHELL=3D/bin/sh

    2023-04-03T12:34:30.364214  #

    2023-04-03T12:34:30.465126  / # export SHELL=3D/bin/sh. /lava-9850109/e=
nvironment

    2023-04-03T12:34:30.465299  =


    2023-04-03T12:34:30.566176  / # . /lava-9850109/environment/lava-985010=
9/bin/lava-test-runner /lava-9850109/1

    2023-04-03T12:34:30.566473  =


    2023-04-03T12:34:30.570934  / # /lava-9850109/bin/lava-test-runner /lav=
a-9850109/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ac7ece871fe36d662f7b8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-89-g304cf5ec8cf9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ac7ece871fe36d662f7bd
        failing since 6 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T12:34:32.135475  + <8>[   12.515615] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9850171_1.4.2.3.1>

    2023-04-03T12:34:32.136000  set +x

    2023-04-03T12:34:32.244018  / # #

    2023-04-03T12:34:32.346792  export SHELL=3D/bin/sh

    2023-04-03T12:34:32.347659  #

    2023-04-03T12:34:32.449563  / # export SHELL=3D/bin/sh. /lava-9850171/e=
nvironment

    2023-04-03T12:34:32.450422  =


    2023-04-03T12:34:32.552289  / # . /lava-9850171/environment/lava-985017=
1/bin/lava-test-runner /lava-9850171/1

    2023-04-03T12:34:32.553662  =


    2023-04-03T12:34:32.558343  / # /lava-9850171/bin/lava-test-runner /lav=
a-9850171/1
 =

    ... (12 line(s) more)  =

 =20
