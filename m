Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C749C6D71F9
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 03:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjDEBar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 21:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbjDEBaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 21:30:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FCB30E2
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 18:30:44 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id r7-20020a17090b050700b002404be7920aso33973256pjz.5
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 18:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680658244;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=V9C1/w7q1g/PRTXaTKXq6HahLiiA8Qr6w0OKkHm0nnY=;
        b=X2lcjD/SkX/KWQqqsKYNWGWDEyJJEj7zgzpt8a8Hqj4TndaULYXoeXz95KfMwnKYsr
         0cW0uczd5q8NK9A/oH/Rqpsz6zJa/9iQwQdcZ6p5OVpM2ZJrmo7E0jJ1tRkbTQnFGOvV
         pTav17ZLERVVO7ulswTZ5EJmTW4DAxHT3H8+YQHoYKOFZzeLFGx2otXH6vMNeBseisQq
         2eYWyyroeQO8nb4K1zBrTT5yz/cUWqRZbsCrAokUJEA0dZwBUuyEKmFKxdCBymawqfcJ
         XMTPQDxqUG4LcZCyBTmlXzTeceakMT5O6YWoRw9lMRyAZhiXDLWPIlIn4nJ9T1XU+B1s
         fVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680658244;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V9C1/w7q1g/PRTXaTKXq6HahLiiA8Qr6w0OKkHm0nnY=;
        b=rxF/I14ovuuPCsCS9Jfor209ZUan2ozPfHelihvHqkuXqzYrc9x2WLCY16mIjyr9nX
         zW2C828/QwRv+Ug9kwjc3zhU0jOdJc7Xx2xrM7u0IROquKSoGuF4RMnWf7aPDyrfUqwa
         O5sSttbYHPrBuPLbECA+Dx2rhv9GvzK9b2iqPUJEQ9Qa+Q88Pnr6sL3RPlUMDJSdpoML
         pZ+dXotZNrxORQHK1kBAap8KHTmWn7chSPYdMPzNkYlGwxH4EuhlzhGqFM9SVqqkQK9a
         vMgPBnYSQXNIyck3tZSiWF+bzI8eD2fa9nBG+uSjIBshwlE/Qxm5IxGe0FxK9aqstaxz
         yrKQ==
X-Gm-Message-State: AAQBX9fzBAO+4yHr8bMVNGEcWWe+4MbqeY1VO7YxVpkRz0ZubpyOwgV8
        JhWtFBMMHtPR8GSfn0OHo6x3Kw7dPo8q1Y2MSoOg1Q==
X-Google-Smtp-Source: AKy350Z8zVFbY5I2NlIo0ballGp2S7phCIQskGbZOa718AdZ1RXuRbVPX2DTXTZjuuHx/jO1KJAbJA==
X-Received: by 2002:a17:902:c40e:b0:1a2:3802:e51 with SMTP id k14-20020a170902c40e00b001a238020e51mr6029434plk.6.1680658243697;
        Tue, 04 Apr 2023 18:30:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bg4-20020a1709028e8400b0019f398ed834sm8919522plb.212.2023.04.04.18.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 18:30:43 -0700 (PDT)
Message-ID: <642ccf43.170a0220.6083d.2afc@mx.google.com>
Date:   Tue, 04 Apr 2023 18:30:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-99-g67c07021fd6fd
Subject: stable-rc/queue/5.15 baseline: 113 runs,
 9 regressions (v5.15.105-99-g67c07021fd6fd)
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

stable-rc/queue/5.15 baseline: 113 runs, 9 regressions (v5.15.105-99-g67c07=
021fd6fd)

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
nel/v5.15.105-99-g67c07021fd6fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-99-g67c07021fd6fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67c07021fd6fd6b271756c85579dbe3fa371ba24 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c981916b265540879e954

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c981916b265540879e959
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T21:35:05.875716  <8>[   11.018753] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9869402_1.4.2.3.1>

    2023-04-04T21:35:05.878457  + set +x

    2023-04-04T21:35:05.983229  / # #

    2023-04-04T21:35:06.084244  export SHELL=3D/bin/sh

    2023-04-04T21:35:06.085012  #

    2023-04-04T21:35:06.186801  / # export SHELL=3D/bin/sh. /lava-9869402/e=
nvironment

    2023-04-04T21:35:06.187497  =


    2023-04-04T21:35:06.289302  / # . /lava-9869402/environment/lava-986940=
2/bin/lava-test-runner /lava-9869402/1

    2023-04-04T21:35:06.290497  =


    2023-04-04T21:35:06.296634  / # /lava-9869402/bin/lava-test-runner /lav=
a-9869402/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c981716b265540879e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c981716b265540879e927
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T21:34:58.478070  + <8>[   10.961711] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9869392_1.4.2.3.1>

    2023-04-04T21:34:58.478655  set +x

    2023-04-04T21:34:58.587738  / # #

    2023-04-04T21:34:58.690542  export SHELL=3D/bin/sh

    2023-04-04T21:34:58.691351  #

    2023-04-04T21:34:58.793376  / # export SHELL=3D/bin/sh. /lava-9869392/e=
nvironment

    2023-04-04T21:34:58.794235  =


    2023-04-04T21:34:58.896250  / # . /lava-9869392/environment/lava-986939=
2/bin/lava-test-runner /lava-9869392/1

    2023-04-04T21:34:58.897648  =


    2023-04-04T21:34:58.902282  / # /lava-9869392/bin/lava-test-runner /lav=
a-9869392/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c97fd50cfa6fd6479e93c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c97fd50cfa6fd6479e941
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T21:34:27.247397  <8>[    9.975595] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9869361_1.4.2.3.1>

    2023-04-04T21:34:27.251036  + set +x

    2023-04-04T21:34:27.352953  =


    2023-04-04T21:34:27.453909  / # #export SHELL=3D/bin/sh

    2023-04-04T21:34:27.454093  =


    2023-04-04T21:34:27.555028  / # export SHELL=3D/bin/sh. /lava-9869361/e=
nvironment

    2023-04-04T21:34:27.555213  =


    2023-04-04T21:34:27.656144  / # . /lava-9869361/environment/lava-986936=
1/bin/lava-test-runner /lava-9869361/1

    2023-04-04T21:34:27.656487  =


    2023-04-04T21:34:27.661691  / # /lava-9869361/bin/lava-test-runner /lav=
a-9869361/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642c9a58f9c10a663779e93d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642c9a58f9c10a663779e=
93e
        failing since 60 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642c981a16b265540879e95f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c981a16b265540879e964
        failing since 77 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-04T21:35:09.932102  + set +x<8>[    9.997405] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3471195_1.5.2.4.1>
    2023-04-04T21:35:09.932361  =

    2023-04-04T21:35:10.038730  / # #
    2023-04-04T21:35:10.140652  export SHELL=3D/bin/sh
    2023-04-04T21:35:10.141143  #
    2023-04-04T21:35:10.242349  / # export SHELL=3D/bin/sh. /lava-3471195/e=
nvironment
    2023-04-04T21:35:10.242802  =

    2023-04-04T21:35:10.344166  / # . /lava-3471195/environment/lava-347119=
5/bin/lava-test-runner /lava-3471195/1
    2023-04-04T21:35:10.344851  =

    2023-04-04T21:35:10.349235  / # /lava-3471195/bin/lava-test-runner /lav=
a-3471195/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c97e5ccdbc1dbf379e931

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c97e5ccdbc1dbf379e936
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T21:34:17.529991  + set +x

    2023-04-04T21:34:17.536529  <8>[   10.616168] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9869368_1.4.2.3.1>

    2023-04-04T21:34:17.641617  / # #

    2023-04-04T21:34:17.742695  export SHELL=3D/bin/sh

    2023-04-04T21:34:17.742930  #

    2023-04-04T21:34:17.843847  / # export SHELL=3D/bin/sh. /lava-9869368/e=
nvironment

    2023-04-04T21:34:17.844041  =


    2023-04-04T21:34:17.944988  / # . /lava-9869368/environment/lava-986936=
8/bin/lava-test-runner /lava-9869368/1

    2023-04-04T21:34:17.945317  =


    2023-04-04T21:34:17.950216  / # /lava-9869368/bin/lava-test-runner /lav=
a-9869368/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c97f2ccdbc1dbf379e98d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c97f2ccdbc1dbf379e992
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T21:34:19.288217  + set +x

    2023-04-04T21:34:19.295051  <8>[   10.339524] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9869386_1.4.2.3.1>

    2023-04-04T21:34:19.397338  =


    2023-04-04T21:34:19.498469  / # #export SHELL=3D/bin/sh

    2023-04-04T21:34:19.498642  =


    2023-04-04T21:34:19.599691  / # export SHELL=3D/bin/sh. /lava-9869386/e=
nvironment

    2023-04-04T21:34:19.599866  =


    2023-04-04T21:34:19.700820  / # . /lava-9869386/environment/lava-986938=
6/bin/lava-test-runner /lava-9869386/1

    2023-04-04T21:34:19.701081  =


    2023-04-04T21:34:19.706440  / # /lava-9869386/bin/lava-test-runner /lav=
a-9869386/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c980a06e16f78a279e93d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c980a06e16f78a279e942
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T21:34:42.099263  + set<8>[   11.303454] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9869376_1.4.2.3.1>

    2023-04-04T21:34:42.099837   +x

    2023-04-04T21:34:42.208268  / # #

    2023-04-04T21:34:42.309352  export SHELL=3D/bin/sh

    2023-04-04T21:34:42.309610  #

    2023-04-04T21:34:42.410770  / # export SHELL=3D/bin/sh. /lava-9869376/e=
nvironment

    2023-04-04T21:34:42.411011  =


    2023-04-04T21:34:42.512379  / # . /lava-9869376/environment/lava-986937=
6/bin/lava-test-runner /lava-9869376/1

    2023-04-04T21:34:42.513626  =


    2023-04-04T21:34:42.518740  / # /lava-9869376/bin/lava-test-runner /lav=
a-9869376/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c9800e13b8b508079e935

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g67c07021fd6fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c9800e13b8b508079e93a
        failing since 7 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-04T21:34:43.782293  + set<8>[   11.539300] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9869411_1.4.2.3.1>

    2023-04-04T21:34:43.782379   +x

    2023-04-04T21:34:43.887115  / # #

    2023-04-04T21:34:43.988109  export SHELL=3D/bin/sh

    2023-04-04T21:34:43.988287  #

    2023-04-04T21:34:44.089189  / # export SHELL=3D/bin/sh. /lava-9869411/e=
nvironment

    2023-04-04T21:34:44.089364  =


    2023-04-04T21:34:44.190330  / # . /lava-9869411/environment/lava-986941=
1/bin/lava-test-runner /lava-9869411/1

    2023-04-04T21:34:44.190568  =


    2023-04-04T21:34:44.195696  / # /lava-9869411/bin/lava-test-runner /lav=
a-9869411/1
 =

    ... (12 line(s) more)  =

 =20
