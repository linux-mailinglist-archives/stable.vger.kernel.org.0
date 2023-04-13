Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C7A6E0929
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 10:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjDMImi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 04:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjDMIm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 04:42:29 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D38975C
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 01:41:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-517bdc9dd1cso604800a12.1
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 01:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681375315; x=1683967315;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aj6gbjeMOhv3vEM1jZVZzlMcQeOq0xtzYJ1qSSuNprE=;
        b=2bWaVI+xTiSDxvL2USnggDt3T19yGsgUwitdsdNcydsakmV2dqm0f1eRcPpLWrc8fo
         9CJugbdpYXid+6slJgl8aLBmqtYusrkzPmI/g5KgXuoF9f3dsCPwOveaKetQwDLEfq0c
         ekgsJKX8l6B97iAWENiSAdoEaFODH2V1vh0OR9i8nm33auuyqWyQMWV1zjmwzZFLSN7d
         EolQe8wwvwveBgHc3jmFMVcjs/x1ekWQOBj6jWzSTRbEO8qNXPY39304UdFyEHgyx4B0
         +8dmorzwa0PwlstxmydFCgE8Bopi2oYkkS457vcLV6H7BQmH3dVaRhptwQ6MELm/P7fv
         NnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681375315; x=1683967315;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aj6gbjeMOhv3vEM1jZVZzlMcQeOq0xtzYJ1qSSuNprE=;
        b=c+zBfp0vMD+oE+PyeDd9L60ngt8CNwIHaTc+qLtfauDtqz8fmW60EKzc1eOJ+x6Xbf
         g9faIy5ic44pV9JGD8onhyMehTVvbjH6nk1DxG46CklR3fbQ0XDEkZVOKoN2X2DfTmMx
         24+YdrdCA55vreX0p+wprBVelhVRHwxc1P+9aph+FhmG06rNumrq4TXcsFs9DS4evGiP
         7aGdo7rGw6iDYh2pUc5lEFqCkwc4iTp4CKvAP2ingCF3obpdHgnLolWL8E8cdsfPSbL6
         awvsJfZSibgvzSePiLBtoNVkDPvsGn1mfBz0zRwmoi9K5Es/xMrf9yjYFHPOLoRgFHi+
         qW9A==
X-Gm-Message-State: AAQBX9ciD6z+XzUk5JGJ1Wst50NEnPEMCINSCcbedladQEk7SRhVLusd
        fM7owqcI2W/AkQ14n5H0+b0QAY8/8qNufvUAYQxWdTto
X-Google-Smtp-Source: AKy350Z5fCSJkalNGaSceu3ALVh7PRFSgs7ct9UOdnr/12MRH/NJRkexb58pMojLqDKKxVjKz35ehA==
X-Received: by 2002:a05:6a00:a18:b0:63b:57cb:145f with SMTP id p24-20020a056a000a1800b0063b57cb145fmr242798pfh.20.1681375315395;
        Thu, 13 Apr 2023 01:41:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b19-20020aa78713000000b0062e10435843sm818825pfo.217.2023.04.13.01.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 01:41:55 -0700 (PDT)
Message-ID: <6437c053.a70a0220.8108c.1506@mx.google.com>
Date:   Thu, 13 Apr 2023 01:41:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-344-g85401f7f457f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 190 runs,
 8 regressions (v6.1.22-344-g85401f7f457f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 190 runs, 8 regressions (v6.1.22-344-g85401f7=
f457f)

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

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-344-g85401f7f457f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-344-g85401f7f457f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85401f7f457f928437728b834375d4f243a9693e =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378c850d563d3cbd2e860a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378c850d563d3cbd2e860f
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T05:00:33.030849  + set +x

    2023-04-13T05:00:33.037514  <8>[   10.579311] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9957609_1.4.2.3.1>

    2023-04-13T05:00:33.142360  / # #

    2023-04-13T05:00:33.243396  export SHELL=3D/bin/sh

    2023-04-13T05:00:33.243642  #

    2023-04-13T05:00:33.344554  / # export SHELL=3D/bin/sh. /lava-9957609/e=
nvironment

    2023-04-13T05:00:33.344768  =


    2023-04-13T05:00:33.445671  / # . /lava-9957609/environment/lava-995760=
9/bin/lava-test-runner /lava-9957609/1

    2023-04-13T05:00:33.445959  =


    2023-04-13T05:00:33.452000  / # /lava-9957609/bin/lava-test-runner /lav=
a-9957609/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378c84aa96bfad432e85ea

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378c84aa96bfad432e85ef
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T05:00:38.124584  + <8>[   11.492845] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9957584_1.4.2.3.1>

    2023-04-13T05:00:38.124670  set +x

    2023-04-13T05:00:38.229225  / # #

    2023-04-13T05:00:38.330251  export SHELL=3D/bin/sh

    2023-04-13T05:00:38.330428  #

    2023-04-13T05:00:38.431341  / # export SHELL=3D/bin/sh. /lava-9957584/e=
nvironment

    2023-04-13T05:00:38.431511  =


    2023-04-13T05:00:38.532380  / # . /lava-9957584/environment/lava-995758=
4/bin/lava-test-runner /lava-9957584/1

    2023-04-13T05:00:38.532630  =


    2023-04-13T05:00:38.537504  / # /lava-9957584/bin/lava-test-runner /lav=
a-9957584/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378c6ed075dc67522e85f5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378c6ed075dc67522e85fa
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T05:00:23.398665  <8>[   10.436330] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9957616_1.4.2.3.1>

    2023-04-13T05:00:23.401976  + set +x

    2023-04-13T05:00:23.507111  #

    2023-04-13T05:00:23.610010  / # #export SHELL=3D/bin/sh

    2023-04-13T05:00:23.610661  =


    2023-04-13T05:00:23.712328  / # export SHELL=3D/bin/sh. /lava-9957616/e=
nvironment

    2023-04-13T05:00:23.712966  =


    2023-04-13T05:00:23.814761  / # . /lava-9957616/environment/lava-995761=
6/bin/lava-test-runner /lava-9957616/1

    2023-04-13T05:00:23.815916  =


    2023-04-13T05:00:23.821146  / # /lava-9957616/bin/lava-test-runner /lav=
a-9957616/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378caac4f2564caa2e8606

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378caac4f2564caa2e860b
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T05:01:13.186449  + set +x

    2023-04-13T05:01:13.192658  <8>[    8.160579] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9957562_1.4.2.3.1>

    2023-04-13T05:01:13.297619  / # #

    2023-04-13T05:01:13.398610  export SHELL=3D/bin/sh

    2023-04-13T05:01:13.398808  #

    2023-04-13T05:01:13.499702  / # export SHELL=3D/bin/sh. /lava-9957562/e=
nvironment

    2023-04-13T05:01:13.499947  =


    2023-04-13T05:01:13.600934  / # . /lava-9957562/environment/lava-995756=
2/bin/lava-test-runner /lava-9957562/1

    2023-04-13T05:01:13.601249  =


    2023-04-13T05:01:13.606333  / # /lava-9957562/bin/lava-test-runner /lav=
a-9957562/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378c72d075dc67522e861b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378c72d075dc67522e8620
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T05:00:18.023905  + set<8>[   10.435325] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9957573_1.4.2.3.1>

    2023-04-13T05:00:18.024025   +x

    2023-04-13T05:00:18.126616  /#

    2023-04-13T05:00:18.227773   # #export SHELL=3D/bin/sh

    2023-04-13T05:00:18.227981  =


    2023-04-13T05:00:18.328884  / # export SHELL=3D/bin/sh. /lava-9957573/e=
nvironment

    2023-04-13T05:00:18.329120  =


    2023-04-13T05:00:18.430146  / # . /lava-9957573/environment/lava-995757=
3/bin/lava-test-runner /lava-9957573/1

    2023-04-13T05:00:18.430454  =


    2023-04-13T05:00:18.435494  / # /lava-9957573/bin/lava-test-runner /lav=
a-9957573/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378c864ced10c9fe2e8610

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378c864ced10c9fe2e8615
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T05:00:35.996356  + <8>[   11.181547] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9957585_1.4.2.3.1>

    2023-04-13T05:00:35.996462  set +x

    2023-04-13T05:00:36.100983  / # #

    2023-04-13T05:00:36.201985  export SHELL=3D/bin/sh

    2023-04-13T05:00:36.202197  #

    2023-04-13T05:00:36.303136  / # export SHELL=3D/bin/sh. /lava-9957585/e=
nvironment

    2023-04-13T05:00:36.303333  =


    2023-04-13T05:00:36.404271  / # . /lava-9957585/environment/lava-995758=
5/bin/lava-test-runner /lava-9957585/1

    2023-04-13T05:00:36.404587  =


    2023-04-13T05:00:36.409303  / # /lava-9957585/bin/lava-test-runner /lav=
a-9957585/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378c73183c3b82ac2e85ef

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378c73183c3b82ac2e85f4
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T05:00:22.507940  + set<8>[   11.108469] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9957627_1.4.2.3.1>

    2023-04-13T05:00:22.508076   +x

    2023-04-13T05:00:22.613190  / # #

    2023-04-13T05:00:22.714368  export SHELL=3D/bin/sh

    2023-04-13T05:00:22.714605  #

    2023-04-13T05:00:22.815719  / # export SHELL=3D/bin/sh. /lava-9957627/e=
nvironment

    2023-04-13T05:00:22.815937  =


    2023-04-13T05:00:22.916756  / # . /lava-9957627/environment/lava-995762=
7/bin/lava-test-runner /lava-9957627/1

    2023-04-13T05:00:22.917054  =


    2023-04-13T05:00:22.922133  / # /lava-9957627/bin/lava-test-runner /lav=
a-9957627/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64378c36f581a1c2532e8634

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g85401f7f457f/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64378c36f581a1c=
2532e863c
        failing since 0 day (last pass: v6.1.22-327-g5d6cb90df983, first fa=
il: v6.1.22-343-gd99c3fff7381)
        1 lines

    2023-04-13T04:59:27.725844  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eb673308, epc =3D=3D 80201ff4, ra =3D=
=3D 80204944
    2023-04-13T04:59:27.726010  =


    2023-04-13T04:59:27.750982  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-13T04:59:27.751131  =

   =

 =20
