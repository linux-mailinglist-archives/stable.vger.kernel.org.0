Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994276D6B12
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 20:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjDDSB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 14:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbjDDSB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 14:01:58 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AF5469D
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 11:01:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s19so20203686pgi.0
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 11:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680631316;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=laEH/Vzu/BKyz02SZpStFnm+TDxj8zp/vBbZ1DZnu3U=;
        b=gKeWddspTm4Yh4P+EZ4YcYdb2AAY/nycKHmILiuVzf+4B45bWDUDoPx5Xuiu6GG3Ov
         aM8osKynqOeziK8z+dQTLstowHYyCepwgHAJI8E1bOEuXLKmrvjyjbEJrKk24Q3RUrqR
         fEBnJ+mc6tsZzo+rd/6PxskrZBAG/jQdEB/35kyDw+QkbksRML2tYqjdEJyNQuu6txWC
         qNfDYkqBOTd/fJXhij7OXdGmelbGO4iMZ1QR6WjJRWVdtguj6aZrRf9bjL4L+kEJwABP
         uPL98FAKcnDzkgOBBpuKLFmRgmaugKPd90lt2yn80y/MTfoParG+3UDTRMBTiSfFDLdQ
         5fOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680631316;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=laEH/Vzu/BKyz02SZpStFnm+TDxj8zp/vBbZ1DZnu3U=;
        b=aG0vATTLIpYbh1nL34/eP6gAnpqV9LwSclW9XqNHTUYFJ6imMH/avBahXEyc2eFEp1
         jrhFZLMaXuA9GxPYM3yzo9gGDTo4B9G+YJXKvBDWt44l/pJqIpEMNnSQVJ5Gmr6IJ0a4
         6lY0Rjiu2akWMfLoXakKA8VScXVYiH6CeCJxfHVKemreywV8yGmNmgoFa2cwQNfqoKAE
         4y0wzAaErBdF6lSbeiV2nh9EiQp1WUrIDkpnt+dZcE/qsWovJAXevnZ8gzIe/oPPCfog
         OhY5Tmvi5LWohSGAh5YySfj8wE5mNqHeHO3aXQxtSeq7jUMQVump7plf8gVV7XQ2g0WQ
         rkoA==
X-Gm-Message-State: AAQBX9cQdhn+8hXlDPtrxiGLoMGjLqKHo9QsLX/u3GkDeEa1v5Cs0le1
        yNTfG/GnpZE2w9wo/5p3zCJoqnAhSQ4szyDO/wr/TA==
X-Google-Smtp-Source: AKy350bbJmImtsb5UqZGtOpRuIg3zjdL7EXKn2Zv6xRxos0b8Mja7xk52FFvSg5aKiTl/VUNOQhRww==
X-Received: by 2002:aa7:9dda:0:b0:627:f639:5bf1 with SMTP id g26-20020aa79dda000000b00627f6395bf1mr2815733pfq.7.1680631315574;
        Tue, 04 Apr 2023 11:01:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x4-20020a056a00270400b0062e36fb2f0dsm1115317pfv.144.2023.04.04.11.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:01:55 -0700 (PDT)
Message-ID: <642c6613.050a0220.5ce8c.23a5@mx.google.com>
Date:   Tue, 04 Apr 2023 11:01:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-99-g1b9d0ee1e7eb0
Subject: stable-rc/queue/5.15 baseline: 155 runs,
 9 regressions (v5.15.105-99-g1b9d0ee1e7eb0)
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

stable-rc/queue/5.15 baseline: 155 runs, 9 regressions (v5.15.105-99-g1b9d0=
ee1e7eb0)

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
nel/v5.15.105-99-g1b9d0ee1e7eb0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-99-g1b9d0ee1e7eb0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b9d0ee1e7eb00305621e3c6cdcbbc5d3b6061e6 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c2eb592be53f6c079e95f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c2eb592be53f6c079e964
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T14:05:20.609733  <8>[   10.638207] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9862354_1.4.2.3.1>

    2023-04-04T14:05:20.612809  + set +x

    2023-04-04T14:05:20.717958  / # #

    2023-04-04T14:05:20.819015  export SHELL=3D/bin/sh

    2023-04-04T14:05:20.819242  #

    2023-04-04T14:05:20.920171  / # export SHELL=3D/bin/sh. /lava-9862354/e=
nvironment

    2023-04-04T14:05:20.920358  =


    2023-04-04T14:05:21.021294  / # . /lava-9862354/environment/lava-986235=
4/bin/lava-test-runner /lava-9862354/1

    2023-04-04T14:05:21.021587  =


    2023-04-04T14:05:21.027837  / # /lava-9862354/bin/lava-test-runner /lav=
a-9862354/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c2ebd64edcccaed79e94e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c2ebd64edcccaed79e953
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T14:05:28.612342  + set<8>[   11.732046] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9862363_1.4.2.3.1>

    2023-04-04T14:05:28.612565   +x

    2023-04-04T14:05:28.717544  / # #

    2023-04-04T14:05:28.820531  export SHELL=3D/bin/sh

    2023-04-04T14:05:28.821369  #

    2023-04-04T14:05:28.923205  / # export SHELL=3D/bin/sh. /lava-9862363/e=
nvironment

    2023-04-04T14:05:28.924016  =


    2023-04-04T14:05:29.025823  / # . /lava-9862363/environment/lava-986236=
3/bin/lava-test-runner /lava-9862363/1

    2023-04-04T14:05:29.027008  =


    2023-04-04T14:05:29.032032  / # /lava-9862363/bin/lava-test-runner /lav=
a-9862363/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c2eb094aad9961379e943

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c2eb094aad9961379e948
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T14:05:13.596250  <8>[    9.951834] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9862379_1.4.2.3.1>

    2023-04-04T14:05:13.599887  + set +x

    2023-04-04T14:05:13.706395  #

    2023-04-04T14:05:13.707867  =


    2023-04-04T14:05:13.810153  / # #export SHELL=3D/bin/sh

    2023-04-04T14:05:13.810430  =


    2023-04-04T14:05:13.911542  / # export SHELL=3D/bin/sh. /lava-9862379/e=
nvironment

    2023-04-04T14:05:13.912378  =


    2023-04-04T14:05:14.014158  / # . /lava-9862379/environment/lava-986237=
9/bin/lava-test-runner /lava-9862379/1

    2023-04-04T14:05:14.015522  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642c2eddbcdc4e806679e92c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642c2eddbcdc4e806679e=
92d
        failing since 60 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642c2ce6d43992600679e922

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c2ce6d43992600679e927
        failing since 77 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-04T13:57:40.719807  <8>[    9.986508] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3470392_1.5.2.4.1>
    2023-04-04T13:57:40.830876  / # #
    2023-04-04T13:57:40.933962  export SHELL=3D/bin/sh
    2023-04-04T13:57:40.934995  #
    2023-04-04T13:57:41.036954  / # export SHELL=3D/bin/sh. /lava-3470392/e=
nvironment
    2023-04-04T13:57:41.037779  =

    2023-04-04T13:57:41.139645  / # . /lava-3470392/environment/lava-347039=
2/bin/lava-test-runner /lava-3470392/1
    2023-04-04T13:57:41.140987  =

    2023-04-04T13:57:41.141404  / # <3>[   10.353066] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-04T13:57:41.145801  /lava-3470392/bin/lava-test-runner /lava-34=
70392/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c2f1e49acc04abf79e929

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c2f1e49acc04abf79e92e
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T14:07:10.085263  + set +x

    2023-04-04T14:07:10.091699  <8>[   10.628414] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9862384_1.4.2.3.1>

    2023-04-04T14:07:10.199350  / # #

    2023-04-04T14:07:10.301567  export SHELL=3D/bin/sh

    2023-04-04T14:07:10.302252  #

    2023-04-04T14:07:10.404016  / # export SHELL=3D/bin/sh. /lava-9862384/e=
nvironment

    2023-04-04T14:07:10.404666  =


    2023-04-04T14:07:10.506461  / # . /lava-9862384/environment/lava-986238=
4/bin/lava-test-runner /lava-9862384/1

    2023-04-04T14:07:10.507703  =


    2023-04-04T14:07:10.512290  / # /lava-9862384/bin/lava-test-runner /lav=
a-9862384/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c2e9b17ed9d36ed79e971

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c2e9b17ed9d36ed79e976
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T14:04:59.639669  <8>[   10.860464] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9862322_1.4.2.3.1>

    2023-04-04T14:04:59.642826  + set +x

    2023-04-04T14:04:59.744681  #

    2023-04-04T14:04:59.845911  / # #export SHELL=3D/bin/sh

    2023-04-04T14:04:59.846109  =


    2023-04-04T14:04:59.947062  / # export SHELL=3D/bin/sh. /lava-9862322/e=
nvironment

    2023-04-04T14:04:59.947245  =


    2023-04-04T14:05:00.047976  / # . /lava-9862322/environment/lava-986232=
2/bin/lava-test-runner /lava-9862322/1

    2023-04-04T14:05:00.048225  =


    2023-04-04T14:05:00.053683  / # /lava-9862322/bin/lava-test-runner /lav=
a-9862322/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c2eb49d7fb1660979e92b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c2eb49d7fb1660979e930
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T14:05:21.074959  + set<8>[   10.703176] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9862336_1.4.2.3.1>

    2023-04-04T14:05:21.075490   +x

    2023-04-04T14:05:21.184057  / # #

    2023-04-04T14:05:21.287099  export SHELL=3D/bin/sh

    2023-04-04T14:05:21.287999  #

    2023-04-04T14:05:21.389982  / # export SHELL=3D/bin/sh. /lava-9862336/e=
nvironment

    2023-04-04T14:05:21.390789  =


    2023-04-04T14:05:21.492708  / # . /lava-9862336/environment/lava-986233=
6/bin/lava-test-runner /lava-9862336/1

    2023-04-04T14:05:21.494047  =


    2023-04-04T14:05:21.499356  / # /lava-9862336/bin/lava-test-runner /lav=
a-9862336/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c2eaaaf03c2643f79e925

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g1b9d0ee1e7eb0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c2eaaaf03c2643f79e92a
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T14:05:18.707236  + set<8>[   11.786686] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9862351_1.4.2.3.1>

    2023-04-04T14:05:18.707671   +x

    2023-04-04T14:05:18.815249  / # #

    2023-04-04T14:05:18.916472  export SHELL=3D/bin/sh

    2023-04-04T14:05:18.917318  #

    2023-04-04T14:05:19.019368  / # export SHELL=3D/bin/sh. /lava-9862351/e=
nvironment

    2023-04-04T14:05:19.020095  =


    2023-04-04T14:05:19.121678  / # . /lava-9862351/environment/lava-986235=
1/bin/lava-test-runner /lava-9862351/1

    2023-04-04T14:05:19.122827  =


    2023-04-04T14:05:19.127917  / # /lava-9862351/bin/lava-test-runner /lav=
a-9862351/1
 =

    ... (12 line(s) more)  =

 =20
