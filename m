Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B216E47D5
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 14:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjDQMdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 08:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDQMdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 08:33:42 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEF240E3
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:33:29 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a667067275so10155495ad.1
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681734809; x=1684326809;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gHB8ymy2vhEU7smgtngx0xAsjWUizMpP/AiDqAX2e4g=;
        b=EcbxcFXKFC0P9CWJBPbXTolZlTRdCteMZhbPJYfI+oco9okBTtgIAFh7HaVX4jYkMV
         upGuCLWx86Wvl5voQG7ShhSv1Zd6MtnYQNBwPaiH69cJx3kRl4mF5Rskg1q5XxGw3VVQ
         +Tm5WtuRB1zkKJcGgjhACnojy0a67krp+SD259S0Ls60p7QTJ562UAyRTMwnyfFtRBNk
         8slNnNGXAnFNYhbCEX+d95tGBFdFuVvsyyoyEPIg6I49rhSMfHk2Pgp1NVYnmXhPjJiy
         3g/E5kfT8gC1ts+EP+arKdE4iPeAz5Z/q3naehL8ydSwM9RclnAObz9VOf05UAobVMhe
         h12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681734809; x=1684326809;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gHB8ymy2vhEU7smgtngx0xAsjWUizMpP/AiDqAX2e4g=;
        b=btxPBjI0LRkry0OSDpKvecfUvxAcR6L2zmqglgSKKS0dtNNUm+SGBySlYcz/IGnxvG
         jWIbGEGSdMX3jAOiRFxaGa2qi4s3uNI+rhI30CfL5KjSl1A3sK4SsPbQBivOotc2MLIT
         7prQnhgBrSCR/A5Sc528+Nr7ioGpCUJWsY+8ASNwL71tpitfOATFBNE84gs5VoH9XwnB
         ku84N/pQECa1kS8yrTsBCIi6ZptmCQFNI91vJfY3AjkFH8xjNN92CoayswCAX/jDNy1r
         KtrAUJ/x+E0ibki8H7xtGuwWPs8JjzcF0sZRF8ELl+W9kz8GauwzDNs3ywlI6zxFYTyB
         sRkA==
X-Gm-Message-State: AAQBX9fyN6xeM0eCuU267kQFJgsHG42ZUSR6rZ/o1Sq0aBTlq9f4e/qN
        J/RBPlzqEVYPXBa31BhcXuYIQ1H6N/bF/ZhAlrawxMTY
X-Google-Smtp-Source: AKy350b81+GdgxrMkfTqYxGb5zLmYl1v5nrETf/w3wHQ+V7t+ySsyYDpRt5KuSeOTBtcNnG3RuXs3Q==
X-Received: by 2002:a05:6a00:2eaa:b0:638:edbc:74ca with SMTP id fd42-20020a056a002eaa00b00638edbc74camr22414021pfb.0.1681734808637;
        Mon, 17 Apr 2023 05:33:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s20-20020aa78294000000b005921c46cbadsm7720112pfm.99.2023.04.17.05.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 05:33:28 -0700 (PDT)
Message-ID: <643d3c98.a70a0220.455fd.07ef@mx.google.com>
Date:   Mon, 17 Apr 2023 05:33:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-251-ge618cb6cad09
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 180 runs,
 18 regressions (v5.15.105-251-ge618cb6cad09)
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

stable-rc/queue/5.15 baseline: 180 runs, 18 regressions (v5.15.105-251-ge61=
8cb6cad09)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
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

hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

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

qemu_riscv64                 | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_riscv64                 | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_riscv64                 | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-251-ge618cb6cad09/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-251-ge618cb6cad09
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e618cb6cad092556cebbe797c48b847b4b85b4ef =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d0811ffa9e8db0b2e861e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d0811ffa9e8db0b2e8623
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T08:49:10.210313  <8>[   10.788542] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10016929_1.4.2.3.1>

    2023-04-17T08:49:10.213771  + set +x

    2023-04-17T08:49:10.322468  / # #

    2023-04-17T08:49:10.425346  export SHELL=3D/bin/sh

    2023-04-17T08:49:10.426133  #

    2023-04-17T08:49:10.528190  / # export SHELL=3D/bin/sh. /lava-10016929/=
environment

    2023-04-17T08:49:10.529008  =


    2023-04-17T08:49:10.630984  / # . /lava-10016929/environment/lava-10016=
929/bin/lava-test-runner /lava-10016929/1

    2023-04-17T08:49:10.632222  =


    2023-04-17T08:49:10.637997  / # /lava-10016929/bin/lava-test-runner /la=
va-10016929/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d0810d89d4c98de2e8604

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d0810d89d4c98de2e8609
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T08:48:58.530892  + set +x<8>[   11.010538] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10016876_1.4.2.3.1>

    2023-04-17T08:48:58.531426  =


    2023-04-17T08:48:58.640651  / # #

    2023-04-17T08:48:58.743331  export SHELL=3D/bin/sh

    2023-04-17T08:48:58.744073  #

    2023-04-17T08:48:58.845665  / # export SHELL=3D/bin/sh. /lava-10016876/=
environment

    2023-04-17T08:48:58.846450  =


    2023-04-17T08:48:58.948458  / # . /lava-10016876/environment/lava-10016=
876/bin/lava-test-runner /lava-10016876/1

    2023-04-17T08:48:58.949702  =


    2023-04-17T08:48:58.955286  / # /lava-10016876/bin/lava-test-runner /la=
va-10016876/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d07f8c88021b47b2e85f0

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d07f8c88021b47b2e85f5
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T08:48:43.434611  <8>[   10.345876] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10016942_1.4.2.3.1>

    2023-04-17T08:48:43.437846  + set +x

    2023-04-17T08:48:43.540058  #

    2023-04-17T08:48:43.540956  =


    2023-04-17T08:48:43.643084  / # #export SHELL=3D/bin/sh

    2023-04-17T08:48:43.643823  =


    2023-04-17T08:48:43.745628  / # export SHELL=3D/bin/sh. /lava-10016942/=
environment

    2023-04-17T08:48:43.746356  =


    2023-04-17T08:48:43.848057  / # . /lava-10016942/environment/lava-10016=
942/bin/lava-test-runner /lava-10016942/1

    2023-04-17T08:48:43.849223  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643d0a67fae69c88392e85fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d0a67fae69c88392e8=
5fb
        failing since 72 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643d07bff2315dfa542e85f4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d07bff2315dfa542e85f9
        failing since 90 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-17T08:47:47.133249  <8>[    9.826825] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3504953_1.5.2.4.1>
    2023-04-17T08:47:47.239715  / # #
    2023-04-17T08:47:47.341135  export SHELL=3D/bin/sh
    2023-04-17T08:47:47.341582  #
    2023-04-17T08:47:47.442782  / # export SHELL=3D/bin/sh. /lava-3504953/e=
nvironment
    2023-04-17T08:47:47.443219  =

    2023-04-17T08:47:47.544545  / # . /lava-3504953/environment/lava-350495=
3/bin/lava-test-runner /lava-3504953/1
    2023-04-17T08:47:47.545211  =

    2023-04-17T08:47:47.549907  / # /lava-3504953/bin/lava-test-runner /lav=
a-3504953/1
    2023-04-17T08:47:47.633109  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d06568f02f512512e8622

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d06568f02f512512e8=
623
        new failure (last pass: v5.15.105-244-g4632bdfc359d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d080faa6300f86f2e8610

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d080faa6300f86f2e8615
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T08:48:57.141498  + set +x

    2023-04-17T08:48:57.147727  <8>[   10.560069] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10016914_1.4.2.3.1>

    2023-04-17T08:48:57.252930  / # #

    2023-04-17T08:48:57.353872  export SHELL=3D/bin/sh

    2023-04-17T08:48:57.354047  #

    2023-04-17T08:48:57.454908  / # export SHELL=3D/bin/sh. /lava-10016914/=
environment

    2023-04-17T08:48:57.455069  =


    2023-04-17T08:48:57.555934  / # . /lava-10016914/environment/lava-10016=
914/bin/lava-test-runner /lava-10016914/1

    2023-04-17T08:48:57.556216  =


    2023-04-17T08:48:57.560270  / # /lava-10016914/bin/lava-test-runner /la=
va-10016914/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d07fc2043aa1a482e8636

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d07fc2043aa1a482e863b
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T08:48:43.366834  + set +x

    2023-04-17T08:48:43.373533  <8>[   10.587827] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10016955_1.4.2.3.1>

    2023-04-17T08:48:43.481944  =


    2023-04-17T08:48:43.584141  / # #export SHELL=3D/bin/sh

    2023-04-17T08:48:43.584861  =


    2023-04-17T08:48:43.686898  / # export SHELL=3D/bin/sh. /lava-10016955/=
environment

    2023-04-17T08:48:43.687741  =


    2023-04-17T08:48:43.789542  / # . /lava-10016955/environment/lava-10016=
955/bin/lava-test-runner /lava-10016955/1

    2023-04-17T08:48:43.790689  =


    2023-04-17T08:48:43.795664  / # /lava-10016955/bin/lava-test-runner /la=
va-10016955/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d080faa6300f86f2e8605

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d080faa6300f86f2e860a
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T08:49:05.464803  + <8>[   10.630440] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10016911_1.4.2.3.1>

    2023-04-17T08:49:05.464887  set +x

    2023-04-17T08:49:05.569546  / # #

    2023-04-17T08:49:05.670539  export SHELL=3D/bin/sh

    2023-04-17T08:49:05.670717  #

    2023-04-17T08:49:05.771348  / # export SHELL=3D/bin/sh. /lava-10016911/=
environment

    2023-04-17T08:49:05.772073  =


    2023-04-17T08:49:05.873691  / # . /lava-10016911/environment/lava-10016=
911/bin/lava-test-runner /lava-10016911/1

    2023-04-17T08:49:05.875168  =


    2023-04-17T08:49:05.879748  / # /lava-10016911/bin/lava-test-runner /la=
va-10016911/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643d079d6ac09887ac2e860e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d079d6ac09887ac2e8613
        failing since 79 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-17T08:47:09.064188  + set +x
    2023-04-17T08:47:09.064348  [    9.438443] <LAVA_SIGNAL_ENDRUN 0_dmesg =
928322_1.5.2.3.1>
    2023-04-17T08:47:09.172041  / # #
    2023-04-17T08:47:09.273494  export SHELL=3D/bin/sh
    2023-04-17T08:47:09.273918  #
    2023-04-17T08:47:09.375136  / # export SHELL=3D/bin/sh. /lava-928322/en=
vironment
    2023-04-17T08:47:09.375563  =

    2023-04-17T08:47:09.476868  / # . /lava-928322/environment/lava-928322/=
bin/lava-test-runner /lava-928322/1
    2023-04-17T08:47:09.477675  =

    2023-04-17T08:47:09.480119  / # /lava-928322/bin/lava-test-runner /lava=
-928322/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d07fd2043aa1a482e8658

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d07fd2043aa1a482e865d
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T08:48:55.741364  <8>[   11.741821] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10016891_1.4.2.3.1>

    2023-04-17T08:48:55.851087  / # #

    2023-04-17T08:48:55.953975  export SHELL=3D/bin/sh

    2023-04-17T08:48:55.954664  #

    2023-04-17T08:48:56.056424  / # export SHELL=3D/bin/sh. /lava-10016891/=
environment

    2023-04-17T08:48:56.056985  =


    2023-04-17T08:48:56.158404  / # . /lava-10016891/environment/lava-10016=
891/bin/lava-test-runner /lava-10016891/1

    2023-04-17T08:48:56.159736  =


    2023-04-17T08:48:56.164223  / # /lava-10016891/bin/lava-test-runner /la=
va-10016891/1

    2023-04-17T08:48:56.169765  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d064a8f02f512512e861d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv6=
4.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv6=
4.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d064a8f02f512512e8=
61e
        new failure (last pass: v5.15.105-244-g4632bdfc359d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d0c3ab20b3788b92e8608

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d0c3ab20b3788b92e8=
609
        new failure (last pass: v5.15.105-244-g4632bdfc359d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d061fc3fadf8ee22e860e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d061fc3fadf8ee22e8=
60f
        new failure (last pass: v5.15.105-244-g4632bdfc359d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d064816141adbad2e85fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_r=
iscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_r=
iscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d064816141adbad2e8=
5ff
        new failure (last pass: v5.15.105-244-g4632bdfc359d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d0bfea38d4a63062e861b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_ri=
scv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_ri=
scv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d0bfea38d4a63062e8=
61c
        new failure (last pass: v5.15.105-244-g4632bdfc359d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d061fa4254f401a2e85fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_=
riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_=
riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d061fa4254f401a2e8=
5fd
        new failure (last pass: v5.15.105-244-g4632bdfc359d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643d06b09c6b4a44b82e862b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-251-ge618cb6cad09/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d06b09c6b4a44b82e8630
        failing since 75 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-17T08:43:00.679098  <8>[    5.688318] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3504906_1.5.2.4.1>
    2023-04-17T08:43:00.800293  / # #
    2023-04-17T08:43:00.906594  export SHELL=3D/bin/sh
    2023-04-17T08:43:00.909808  #
    2023-04-17T08:43:01.016533  / # export SHELL=3D/bin/sh. /lava-3504906/e=
nvironment
    2023-04-17T08:43:01.019895  =

    2023-04-17T08:43:01.124368  / # . /lava-3504906/environment/lava-350490=
6/bin/lava-test-runner /lava-3504906/1
    2023-04-17T08:43:01.127860  =

    2023-04-17T08:43:01.139128  / # /lava-3504906/bin/lava-test-runner /lav=
a-3504906/1
    2023-04-17T08:43:01.329376  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
