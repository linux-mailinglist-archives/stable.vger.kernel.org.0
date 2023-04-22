Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC47B6EB7E5
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 09:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDVHqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 03:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDVHqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 03:46:33 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C773919BD
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 00:46:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a66911f5faso25231645ad.0
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 00:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682149590; x=1684741590;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uDw2jcT6O5NxjIECBhnxJBjftBZMJjtQC/NKzFfjVCU=;
        b=UjBnxdiZdvgzrAoMVgptpxIYv+VLi/zNERAjDQ/EozS37NpTRKjCqr+PvRORJrmXRQ
         u0DFcqmQ/NrxSOjWiVlgx1RO1x1YBzSsfBabNkYN2VSxcJwbZncbYUYUMnwbUNpf+Nro
         2zaooA3oNRsGEWxJ59wqouE6TWcnihIZADR2osADGRTXORZY+8b1eR0F84vZau7XwFG9
         Bcu/BrBViOgTu0AdZIpp2oW52bFWJL+6rnMbVivpC+FaruAky2BowPTLEkRppYGH7KCO
         h48rNVVPWXR08vaXe3JNpf3dy58pkA3oK/nQxjuRjeRDiYcvdeCqZINuknnsJWZOK3DL
         igZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682149590; x=1684741590;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uDw2jcT6O5NxjIECBhnxJBjftBZMJjtQC/NKzFfjVCU=;
        b=VbRnVwa9lX9pazI9paMmWzmj6ZuMektyr2/wCZE5+VGeUKL8T5IsMA2ZCtTJ6TeB7z
         xGDYwdnOY8FL+bVfHl39ePS3cVHfymPQAwvQRJVh2+uHU5RxXz8pXGOY5gCnsHSCcn2s
         e7S7IM1a5ay6u4BW38dw7WdU1JLBFvDTDRfqrNoYqoQ6Q8ovumdbz5UExg6ShYJdcqPz
         2dDbuYcKnwH0zex0YKTKI/4JSAb1kMuBxAhuxvCsEtesSXigvEujGcggS7SZZGC61v33
         hU05nKkyntn7oo+mVNmZzQZ1wKO/7lUSQlad40t84eVvHPnCDYkankN8qXMae6TuusCi
         J0GA==
X-Gm-Message-State: AAQBX9dbQizhnRrEzXYxvWLYy+ncYQ04cXga2JLhrFVE7rd/dn7ckkXD
        K0a0x7Gny9ba/hGQjyj+rWBU8TGH7I8ojjbSNZWA8k30
X-Google-Smtp-Source: AKy350ZGFoODR131uT14VBPkB5W3ygV6ijS2okIOEch3FuxGrrA4LqZwvTiqLIUEXgvlpFzRtXv5SA==
X-Received: by 2002:a17:903:22c7:b0:1a5:f:a7c7 with SMTP id y7-20020a17090322c700b001a5000fa7c7mr8545165plg.0.1682149589794;
        Sat, 22 Apr 2023 00:46:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902ff0100b001a5059861adsm3606938plj.224.2023.04.22.00.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 00:46:29 -0700 (PDT)
Message-ID: <644390d5.170a0220.9441f.804f@mx.google.com>
Date:   Sat, 22 Apr 2023 00:46:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-308-g10ef2c038d533
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 141 runs,
 11 regressions (v5.15.105-308-g10ef2c038d533)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 141 runs, 11 regressions (v5.15.105-308-g10e=
f2c038d533)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
acer-R721T-grunt             | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-308-g10ef2c038d533/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-308-g10ef2c038d533
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10ef2c038d533df52dccbae44c10475665fce2be =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
acer-R721T-grunt             | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64435d8516198814cb2e85f8

  Results:     18 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-acer-R721T-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-acer-R721T-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.tpm-chip-is-online: https://kernelci.org/test/case/id/6=
4435d8516198814cb2e8607
        new failure (last pass: v5.15.105-272-g462a824b77c9)

    2023-04-22T04:07:07.292192  /usr/bin/tpm2_getcap

    2023-04-22T04:07:07.339377  <4>[   11.671689] i2c_designware AMD0010:01=
: timeout in disabling adapter

    2023-04-22T04:07:07.366780  <4>[   11.698979] i2c_designware AMD0010:01=
: timeout waiting for bus ready

    2023-04-22T04:07:07.394544  <4>[   11.726689] i2c_designware AMD0010:01=
: timeout waiting for bus ready

    2023-04-22T04:07:07.401199  <4>[   11.733316] tpm tpm0: i2c transfer fa=
iled (attempt 2/3): -110

    2023-04-22T04:07:07.427171  <4>[   11.759504] i2c_designware AMD0010:01=
: timeout waiting for bus ready

    2023-04-22T04:07:07.433901  <4>[   11.766122] tpm tpm0: i2c transfer fa=
iled (attempt 3/3): -110

    2023-04-22T04:07:07.460207  <4>[   11.792505] i2c_designware AMD0010:01=
: timeout waiting for bus ready

    2023-04-22T04:07:07.487626  <4>[   11.819689] i2c_designware AMD0010:01=
: timeout waiting for bus ready

    2023-04-22T04:07:07.494144  <4>[   11.826311] tpm tpm0: i2c transfer fa=
iled (attempt 2/3): -110
 =

    ... (122 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64435d8763241d1d212e85fa

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64435d8763241d1d212e85ff
        failing since 24 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-22T04:07:15.629546  <8>[   10.948137] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10082618_1.4.2.3.1>

    2023-04-22T04:07:15.633131  + set +x

    2023-04-22T04:07:15.738187  / # #

    2023-04-22T04:07:15.839262  export SHELL=3D/bin/sh

    2023-04-22T04:07:15.839447  #

    2023-04-22T04:07:15.940323  / # export SHELL=3D/bin/sh. /lava-10082618/=
environment

    2023-04-22T04:07:15.940592  =


    2023-04-22T04:07:16.041437  / # . /lava-10082618/environment/lava-10082=
618/bin/lava-test-runner /lava-10082618/1

    2023-04-22T04:07:16.041755  =


    2023-04-22T04:07:16.048014  / # /lava-10082618/bin/lava-test-runner /la=
va-10082618/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64435d7738044905cf2e85ee

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64435d7738044905cf2e85f3
        failing since 24 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-22T04:06:58.390585  + set<8>[   11.721427] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10082594_1.4.2.3.1>

    2023-04-22T04:06:58.391028   +x

    2023-04-22T04:06:58.499915  / # #

    2023-04-22T04:06:58.602834  export SHELL=3D/bin/sh

    2023-04-22T04:06:58.603815  #

    2023-04-22T04:06:58.705640  / # export SHELL=3D/bin/sh. /lava-10082594/=
environment

    2023-04-22T04:06:58.706535  =


    2023-04-22T04:06:58.808714  / # . /lava-10082594/environment/lava-10082=
594/bin/lava-test-runner /lava-10082594/1

    2023-04-22T04:06:58.809782  =


    2023-04-22T04:06:58.814560  / # /lava-10082594/bin/lava-test-runner /la=
va-10082594/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64435d764238f5a97d2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64435d764238f5a97d2e85eb
        failing since 24 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-22T04:06:57.801049  <8>[   10.562547] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10082582_1.4.2.3.1>

    2023-04-22T04:06:57.804639  + set +x

    2023-04-22T04:06:57.910687  =


    2023-04-22T04:06:58.012693  / # #export SHELL=3D/bin/sh

    2023-04-22T04:06:58.013435  =


    2023-04-22T04:06:58.115456  / # export SHELL=3D/bin/sh. /lava-10082582/=
environment

    2023-04-22T04:06:58.116255  =


    2023-04-22T04:06:58.218219  / # . /lava-10082582/environment/lava-10082=
582/bin/lava-test-runner /lava-10082582/1

    2023-04-22T04:06:58.219545  =


    2023-04-22T04:06:58.224244  / # /lava-10082582/bin/lava-test-runner /la=
va-10082582/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64435c35f2be64c86a2e860d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64435c35f2be64c86a2e8=
60e
        failing since 77 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644360003be9c8af672e8659

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644360003be9c8af672e865e
        failing since 94 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-22T04:17:44.103432  + set +x<8>[    9.998388] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3521231_1.5.2.4.1>
    2023-04-22T04:17:44.103937  =

    2023-04-22T04:17:44.212619  / # #
    2023-04-22T04:17:44.316113  export SHELL=3D/bin/sh
    2023-04-22T04:17:44.316965  #
    2023-04-22T04:17:44.418985  / # export SHELL=3D/bin/sh. /lava-3521231/e=
nvironment
    2023-04-22T04:17:44.419921  =

    2023-04-22T04:17:44.420398  / # <3>[   10.272721] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-04-22T04:17:44.522313  . /lava-3521231/environment/lava-3521231/bi=
n/lava-test-runner /lava-3521231/1
    2023-04-22T04:17:44.523685   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64435d71b60b009e482e8602

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64435d71b60b009e482e8607
        failing since 24 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-22T04:07:01.004482  + set +x

    2023-04-22T04:07:01.010941  <8>[   10.012032] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10082611_1.4.2.3.1>

    2023-04-22T04:07:01.119239  / # #

    2023-04-22T04:07:01.222045  export SHELL=3D/bin/sh

    2023-04-22T04:07:01.222726  #

    2023-04-22T04:07:01.324482  / # export SHELL=3D/bin/sh. /lava-10082611/=
environment

    2023-04-22T04:07:01.325149  =


    2023-04-22T04:07:01.427067  / # . /lava-10082611/environment/lava-10082=
611/bin/lava-test-runner /lava-10082611/1

    2023-04-22T04:07:01.428675  =


    2023-04-22T04:07:01.433004  / # /lava-10082611/bin/lava-test-runner /la=
va-10082611/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64435d6f2a9d790f8c2e85f9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64435d6f2a9d790f8c2e85fe
        failing since 24 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-22T04:06:56.294243  <8>[   10.672126] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10082573_1.4.2.3.1>

    2023-04-22T04:06:56.297857  + set +x

    2023-04-22T04:06:56.402329  / # #

    2023-04-22T04:06:56.503428  export SHELL=3D/bin/sh

    2023-04-22T04:06:56.503620  #

    2023-04-22T04:06:56.604604  / # export SHELL=3D/bin/sh. /lava-10082573/=
environment

    2023-04-22T04:06:56.604791  =


    2023-04-22T04:06:56.705734  / # . /lava-10082573/environment/lava-10082=
573/bin/lava-test-runner /lava-10082573/1

    2023-04-22T04:06:56.706039  =


    2023-04-22T04:06:56.711500  / # /lava-10082573/bin/lava-test-runner /la=
va-10082573/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64435d8238044905cf2e8612

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64435d8238044905cf2e8617
        failing since 24 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-22T04:07:19.867438  + set<8>[   11.133781] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10082577_1.4.2.3.1>

    2023-04-22T04:07:19.867524   +x

    2023-04-22T04:07:19.972185  / # #

    2023-04-22T04:07:20.073145  export SHELL=3D/bin/sh

    2023-04-22T04:07:20.073289  #

    2023-04-22T04:07:20.174192  / # export SHELL=3D/bin/sh. /lava-10082577/=
environment

    2023-04-22T04:07:20.174408  =


    2023-04-22T04:07:20.275393  / # . /lava-10082577/environment/lava-10082=
577/bin/lava-test-runner /lava-10082577/1

    2023-04-22T04:07:20.275650  =


    2023-04-22T04:07:20.280208  / # /lava-10082577/bin/lava-test-runner /la=
va-10082577/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64435fcadc78ef55f62e8621

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64435fcadc78ef55f62e8626
        failing since 84 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-22T04:17:07.159250  + set +x
    2023-04-22T04:17:07.159408  [    9.409703] <LAVA_SIGNAL_ENDRUN 0_dmesg =
934227_1.5.2.3.1>
    2023-04-22T04:17:07.266270  / # #
    2023-04-22T04:17:07.368006  export SHELL=3D/bin/sh
    2023-04-22T04:17:07.368573  #
    2023-04-22T04:17:07.469949  / # export SHELL=3D/bin/sh. /lava-934227/en=
vironment
    2023-04-22T04:17:07.470482  =

    2023-04-22T04:17:07.571745  / # . /lava-934227/environment/lava-934227/=
bin/lava-test-runner /lava-934227/1
    2023-04-22T04:17:07.572470  =

    2023-04-22T04:17:07.574847  / # /lava-934227/bin/lava-test-runner /lava=
-934227/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64435d8416198814cb2e85eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-308-g10ef2c038d533/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64435d8416198814cb2e85f0
        failing since 24 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-22T04:07:06.887655  + set<8>[   11.815863] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10082621_1.4.2.3.1>

    2023-04-22T04:07:06.887836   +x

    2023-04-22T04:07:06.992249  / # #

    2023-04-22T04:07:07.093299  export SHELL=3D/bin/sh

    2023-04-22T04:07:07.093533  #

    2023-04-22T04:07:07.194410  / # export SHELL=3D/bin/sh. /lava-10082621/=
environment

    2023-04-22T04:07:07.194612  =


    2023-04-22T04:07:07.295631  / # . /lava-10082621/environment/lava-10082=
621/bin/lava-test-runner /lava-10082621/1

    2023-04-22T04:07:07.295968  =


    2023-04-22T04:07:07.300324  / # /lava-10082621/bin/lava-test-runner /la=
va-10082621/1
 =

    ... (12 line(s) more)  =

 =20
