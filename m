Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC3B6D6CF0
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 21:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbjDDTGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 15:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbjDDTGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 15:06:14 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE99B7
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 12:05:57 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n14so16395831plc.8
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 12:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680635156;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qoai2hhmSDVhYuggSXPEQh4ByFXYUm8ZPaAVsjYUjPU=;
        b=fJUYs9Ya5Fv0fiGZrh90teY306zFS6qKZkO2nf/9oYK0oNGaw27dv5SOavX743FuIW
         RdSaAEwJH8seQcV/jKp/8KJln7yDT7yVYCpTXZU15+34aL0Z7xCMJQQRjrhRCEiXifyp
         z4otnS8/dLg3G/1nbCZY1Z7GHi6BcWGMVBDxcx9OTMeRp0hOzg2qImBL1NDmhzt4KWva
         n9fQ6BNPJMVyHmrSJ+EQ87bijPFgCtQy46a+Rl8DJxqgUcPgUkCy8gQO6FEJx5EZxulI
         hqPk91EFdGNO57tkKZ+ny0IcmnlZgBLeFE0vQFkoJhtdtdVx4wQS1EAyEtEwRe6wlzXH
         l7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680635156;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qoai2hhmSDVhYuggSXPEQh4ByFXYUm8ZPaAVsjYUjPU=;
        b=4jyWbfGi3EMcpft2DOxM2pvlW28EzaODwtbxWplHTDvWn2gh1DwI4Is7lG8UHnbLI2
         6Z5cB7LQsZLwYobYhecQJKZwcGccd7VxoxwV3guPN6+TFDGOFyYDSHA1XcXkwDfv3IxJ
         i+QyTK+HclGAVidCry8lDFClgeBBSvar0oS+ZGTk340+7oA/MuPmUg3K280SNw1VeDn1
         405X9i+vIUirzrzzqUnLjTzCZAmPOnjEjbmgufpZhPxDkqSU4lm9UyyZfq6BseLZzA/D
         iSGovWje3q4d9BFtKDPElMqztkURhB259EPKuwTJ8Ijkn4fvtxAO2uACCQZK5SkeMMXT
         AKzQ==
X-Gm-Message-State: AAQBX9fTqTBnzeDPc37kJ8ogCxxoQAb9n6F8CZMzYEgKhYt95BWAou3J
        bsZjmqKXGbsJga9MSX0O56tZ67UvR8WXg3ea6HeEdA==
X-Google-Smtp-Source: AKy350YbNc6t+//U8QsBXQ5Y4taLs1RopnAOpjt3x4+j6EivkvgUitB02lBIzZJS3PT/3nKE1cwLqQ==
X-Received: by 2002:a05:6a20:ba83:b0:d3:84ca:11b with SMTP id fb3-20020a056a20ba8300b000d384ca011bmr3020365pzb.40.1680635155739;
        Tue, 04 Apr 2023 12:05:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f23-20020aa782d7000000b005cd81a74821sm9104920pfn.152.2023.04.04.12.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 12:05:55 -0700 (PDT)
Message-ID: <642c7513.a70a0220.cc96c.2068@mx.google.com>
Date:   Tue, 04 Apr 2023 12:05:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-100-gaacd621499911
Subject: stable-rc/linux-5.15.y baseline: 164 runs,
 9 regressions (v5.15.105-100-gaacd621499911)
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

stable-rc/linux-5.15.y baseline: 164 runs, 9 regressions (v5.15.105-100-gaa=
cd621499911)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.105-100-gaacd621499911/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.105-100-gaacd621499911
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aacd621499911fb2f9643a302eb98e3670b89539 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c3dc4455de9f53179e944

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c3dc4455de9f53179e949
        failing since 6 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-04T15:09:35.433081  <8>[   10.876174] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9863396_1.4.2.3.1>

    2023-04-04T15:09:35.436280  + set +x

    2023-04-04T15:09:35.541347  / # #

    2023-04-04T15:09:35.642394  export SHELL=3D/bin/sh

    2023-04-04T15:09:35.642631  #

    2023-04-04T15:09:35.743623  / # export SHELL=3D/bin/sh. /lava-9863396/e=
nvironment

    2023-04-04T15:09:35.743840  =


    2023-04-04T15:09:35.844806  / # . /lava-9863396/environment/lava-986339=
6/bin/lava-test-runner /lava-9863396/1

    2023-04-04T15:09:35.845163  =


    2023-04-04T15:09:35.851251  / # /lava-9863396/bin/lava-test-runner /lav=
a-9863396/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c3db55ca2c15f1979e959

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c3db55ca2c15f1979e95e
        failing since 6 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-04T15:09:27.594597  + <8>[   11.575864] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9863465_1.4.2.3.1>

    2023-04-04T15:09:27.595197  set +x

    2023-04-04T15:09:27.703863  / # #

    2023-04-04T15:09:27.806964  export SHELL=3D/bin/sh

    2023-04-04T15:09:27.807971  #

    2023-04-04T15:09:27.910185  / # export SHELL=3D/bin/sh. /lava-9863465/e=
nvironment

    2023-04-04T15:09:27.911060  =


    2023-04-04T15:09:28.013421  / # . /lava-9863465/environment/lava-986346=
5/bin/lava-test-runner /lava-9863465/1

    2023-04-04T15:09:28.014747  =


    2023-04-04T15:09:28.019625  / # /lava-9863465/bin/lava-test-runner /lav=
a-9863465/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c3db5fe7d88b22c79e933

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c3db5fe7d88b22c79e938
        failing since 6 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-04T15:09:23.144823  <8>[   10.134374] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9863458_1.4.2.3.1>

    2023-04-04T15:09:23.148183  + set +x

    2023-04-04T15:09:23.253673  #

    2023-04-04T15:09:23.254686  =


    2023-04-04T15:09:23.356840  / # #export SHELL=3D/bin/sh

    2023-04-04T15:09:23.357506  =


    2023-04-04T15:09:23.459206  / # export SHELL=3D/bin/sh. /lava-9863458/e=
nvironment

    2023-04-04T15:09:23.459856  =


    2023-04-04T15:09:23.561567  / # . /lava-9863458/environment/lava-986345=
8/bin/lava-test-runner /lava-9863458/1

    2023-04-04T15:09:23.562828  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642c3e5112cd7bb0ba79e929

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642c3e5112cd7bb0ba79e=
92a
        failing since 327 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642c3ec835759c333479e947

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c3ec835759c333479e94c
        failing since 77 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-04-04T15:14:07.628718  <8>[    9.980086] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3470616_1.5.2.4.1>
    2023-04-04T15:14:07.735857  / # #
    2023-04-04T15:14:07.837958  export SHELL=3D/bin/sh
    2023-04-04T15:14:07.838687  #
    2023-04-04T15:14:07.940316  / # export SHELL=3D/bin/sh. /lava-3470616/e=
nvironment
    2023-04-04T15:14:07.940688  =

    2023-04-04T15:14:07.940838  / # . /lava-3470616/environment<3>[   10.27=
3112] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-04T15:14:08.041921  /lava-3470616/bin/lava-test-runner /lava-34=
70616/1
    2023-04-04T15:14:08.042537  =

    2023-04-04T15:14:08.047504  / # /lava-3470616/bin/lava-test-runner /lav=
a-3470616/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c3dbf455de9f53179e925

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c3dbf455de9f53179e92a
        failing since 6 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-04T15:09:32.872058  + set +x

    2023-04-04T15:09:32.879104  <8>[   10.383360] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9863470_1.4.2.3.1>

    2023-04-04T15:09:32.983493  / # #

    2023-04-04T15:09:33.084545  export SHELL=3D/bin/sh

    2023-04-04T15:09:33.084774  #

    2023-04-04T15:09:33.185748  / # export SHELL=3D/bin/sh. /lava-9863470/e=
nvironment

    2023-04-04T15:09:33.185975  =


    2023-04-04T15:09:33.286933  / # . /lava-9863470/environment/lava-986347=
0/bin/lava-test-runner /lava-9863470/1

    2023-04-04T15:09:33.287251  =


    2023-04-04T15:09:33.291909  / # /lava-9863470/bin/lava-test-runner /lav=
a-9863470/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c3da2f4e05d6df779e93a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c3da2f4e05d6df779e93f
        failing since 6 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-04T15:09:06.888516  <8>[   10.329492] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9863463_1.4.2.3.1>

    2023-04-04T15:09:06.891694  + set +x

    2023-04-04T15:09:06.993272  /#

    2023-04-04T15:09:07.094513   # #export SHELL=3D/bin/sh

    2023-04-04T15:09:07.094702  =


    2023-04-04T15:09:07.195580  / # export SHELL=3D/bin/sh. /lava-9863463/e=
nvironment

    2023-04-04T15:09:07.195804  =


    2023-04-04T15:09:07.296683  / # . /lava-9863463/environment/lava-986346=
3/bin/lava-test-runner /lava-9863463/1

    2023-04-04T15:09:07.296955  =


    2023-04-04T15:09:07.302400  / # /lava-9863463/bin/lava-test-runner /lav=
a-9863463/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c3dbc5ca2c15f1979e980

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c3dbc5ca2c15f1979e985
        failing since 6 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-04T15:09:26.996797  + <8>[   10.863811] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9863395_1.4.2.3.1>

    2023-04-04T15:09:26.996908  set +x

    2023-04-04T15:09:27.101170  / # #

    2023-04-04T15:09:27.202263  export SHELL=3D/bin/sh

    2023-04-04T15:09:27.202467  #

    2023-04-04T15:09:27.303575  / # export SHELL=3D/bin/sh. /lava-9863395/e=
nvironment

    2023-04-04T15:09:27.303767  =


    2023-04-04T15:09:27.404844  / # . /lava-9863395/environment/lava-986339=
5/bin/lava-test-runner /lava-9863395/1

    2023-04-04T15:09:27.406000  =


    2023-04-04T15:09:27.410771  / # /lava-9863395/bin/lava-test-runner /lav=
a-9863395/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c3dafd1ad53071679e97e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-100-gaacd621499911/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c3dafd1ad53071679e983
        failing since 6 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-04T15:09:14.099962  + set<8>[   10.869854] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9863439_1.4.2.3.1>

    2023-04-04T15:09:14.100052   +x

    2023-04-04T15:09:14.204892  / # #

    2023-04-04T15:09:14.305910  export SHELL=3D/bin/sh

    2023-04-04T15:09:14.306126  #

    2023-04-04T15:09:14.407140  / # export SHELL=3D/bin/sh. /lava-9863439/e=
nvironment

    2023-04-04T15:09:14.407551  =


    2023-04-04T15:09:14.508940  / # . /lava-9863439/environment/lava-986343=
9/bin/lava-test-runner /lava-9863439/1

    2023-04-04T15:09:14.510350  =


    2023-04-04T15:09:14.514834  / # /lava-9863439/bin/lava-test-runner /lav=
a-9863439/1
 =

    ... (12 line(s) more)  =

 =20
