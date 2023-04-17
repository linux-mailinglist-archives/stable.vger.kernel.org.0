Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DEE6E4A9A
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 16:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjDQODA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 10:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjDQOCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 10:02:48 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30410B766
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 07:02:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id z11-20020a17090abd8b00b0024721c47ceaso12451697pjr.3
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 07:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681740133; x=1684332133;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Xw5CDjZD2ukKzVVTfUPCwOSY6ja4+nw6i8o1iFK8Q84=;
        b=1cTIM2iexGge2dhoiQDtWgba2rGiYOH4KUZekdLqJgGcJK+2dTSk2Sst8KezPgGJjX
         92O8C33WBF7uHkuDzwNZLSP0XRgkDjGFF99AicNinLHNu7e8sv3yz84jrBLUWnEB7h14
         Hjj32hkd7unh6dUdn+s1rIwVzIpiZNX1JHGZORM/Lq4tOTmY6WRAS9FP0Ijba7Kw+chd
         wQrlvLFrnxFio40v7f9AHbkuqdLNaJoeVHbQBN5rGv0FaZ/SCLSiuKW8btSz+McKpp07
         myNAt5omgMA80uA2arKPzUbq4i7mQ0SEwvB+luDiqYSPXtlxDxMQDEN1opy1WgkyS8pj
         Xcbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681740133; x=1684332133;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xw5CDjZD2ukKzVVTfUPCwOSY6ja4+nw6i8o1iFK8Q84=;
        b=h4dQrmyAtIJmhyU/bGGjaQ3wbF4Bri4AluCgmEvZgjlWO3l2kQdB0PYlm6XC0dUjw2
         4MIXMkR+zH6Jaf2QKSUqdZQmDh0qH9zFyZDcRKNuGt8nbPwjeihoj3YTHpW4/232sVYI
         gQ7XrWsq9fgFKvLY2vIJQv7NL4gvcZ1JX0/yKOlIzPkXFZIJ4hyCPp8kv4SGFpUpkq9v
         urQ1xnNWWQvATgsNzC6HY7dArm52S3BukPfTPbQOj7a2A2TfSEHxw2A3k6vqBM4J7Ybh
         DeB40UQfHp0fv2txkMzMQ8kg5n2Frns2ip5PrTU50H7svZfHf+DytnBhfnACIuQq3ng6
         muzg==
X-Gm-Message-State: AAQBX9ebfEcauEofyx6z6aa3OmUoaTQlamHYUFe0rA3sI469oXzzFVFw
        cOceCNpZ0F3WzK+pcJ+LfoEHfSE2r2Ic9kzHRvCX4R6u
X-Google-Smtp-Source: AKy350aOMuuqzdrqR+nLgBsXHfPuyEaAkCmf1Uk91t08kd7hpmsm6IgBNASBj+ewabrwwXTg95n+wA==
X-Received: by 2002:a17:90a:644c:b0:241:c25:14bb with SMTP id y12-20020a17090a644c00b002410c2514bbmr14514759pjm.24.1681740133190;
        Mon, 17 Apr 2023 07:02:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090ade0400b00231227781d5sm9156971pjv.2.2023.04.17.07.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 07:02:12 -0700 (PDT)
Message-ID: <643d5164.170a0220.7440b.34a6@mx.google.com>
Date:   Mon, 17 Apr 2023 07:02:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-254-g9b84e4a2f259
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 181 runs,
 18 regressions (v5.15.105-254-g9b84e4a2f259)
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

stable-rc/queue/5.15 baseline: 181 runs, 18 regressions (v5.15.105-254-g9b8=
4e4a2f259)

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
nel/v5.15.105-254-g9b84e4a2f259/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-254-g9b84e4a2f259
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9b84e4a2f2599bc9a55d91a8b08b712d27e3618e =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1f1293667f00532e8644

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d1f1293667f00532e8649
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T10:27:06.495476  + set +x

    2023-04-17T10:27:06.502146  <8>[   10.812649] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10018205_1.4.2.3.1>

    2023-04-17T10:27:06.609629  / # #

    2023-04-17T10:27:06.712404  export SHELL=3D/bin/sh

    2023-04-17T10:27:06.713282  #

    2023-04-17T10:27:06.815225  / # export SHELL=3D/bin/sh. /lava-10018205/=
environment

    2023-04-17T10:27:06.815701  =


    2023-04-17T10:27:06.917154  / # . /lava-10018205/environment/lava-10018=
205/bin/lava-test-runner /lava-10018205/1

    2023-04-17T10:27:06.918241  =


    2023-04-17T10:27:06.924540  / # /lava-10018205/bin/lava-test-runner /la=
va-10018205/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1f1217eaee63b22e862e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d1f1217eaee63b22e8633
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T10:27:12.244967  + set +x<8>[   11.481515] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10018187_1.4.2.3.1>

    2023-04-17T10:27:12.245058  =


    2023-04-17T10:27:12.349447  / # #

    2023-04-17T10:27:12.450420  export SHELL=3D/bin/sh

    2023-04-17T10:27:12.450601  #

    2023-04-17T10:27:12.551272  / # export SHELL=3D/bin/sh. /lava-10018187/=
environment

    2023-04-17T10:27:12.551460  =


    2023-04-17T10:27:12.652364  / # . /lava-10018187/environment/lava-10018=
187/bin/lava-test-runner /lava-10018187/1

    2023-04-17T10:27:12.652658  =


    2023-04-17T10:27:12.657341  / # /lava-10018187/bin/lava-test-runner /la=
va-10018187/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1f0e00209a83502e861e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d1f0e00209a83502e8623
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T10:27:02.855601  <8>[   10.806207] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10018191_1.4.2.3.1>

    2023-04-17T10:27:02.858909  + set +x

    2023-04-17T10:27:02.964958  =


    2023-04-17T10:27:03.067042  / # #export SHELL=3D/bin/sh

    2023-04-17T10:27:03.067787  =


    2023-04-17T10:27:03.169636  / # export SHELL=3D/bin/sh. /lava-10018191/=
environment

    2023-04-17T10:27:03.170539  =


    2023-04-17T10:27:03.272494  / # . /lava-10018191/environment/lava-10018=
191/bin/lava-test-runner /lava-10018191/1

    2023-04-17T10:27:03.273695  =


    2023-04-17T10:27:03.278738  / # /lava-10018191/bin/lava-test-runner /la=
va-10018191/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1c7ef725724f0d2e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d1c7ef725724f0d2e8=
5e7
        failing since 73 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1e219736ee1cfb2e85ef

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d1e219736ee1cfb2e85f4
        failing since 90 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-17T10:23:18.019065  <8>[   10.001566] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3505413_1.5.2.4.1>
    2023-04-17T10:23:18.131653  / # #
    2023-04-17T10:23:18.235921  export SHELL=3D/bin/sh
    2023-04-17T10:23:18.236792  #
    2023-04-17T10:23:18.338722  / # export SHELL=3D/bin/sh. /lava-3505413/e=
nvironment
    2023-04-17T10:23:18.339600  =

    2023-04-17T10:23:18.441581  / # . /lava-3505413/environment/lava-350541=
3/bin/lava-test-runner /lava-3505413/1
    2023-04-17T10:23:18.443037  =

    2023-04-17T10:23:18.443563  / # <3>[   10.353000] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-17T10:23:18.447491  /lava-3505413/bin/lava-test-runner /lava-35=
05413/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1c2eb6035d8ecd2e86a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d1c2eb6035d8ecd2e8=
6a8
        failing since 0 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1f06b8d5c8f9aa2e8612

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d1f06b8d5c8f9aa2e8617
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T10:27:11.714202  + set +x

    2023-04-17T10:27:11.720892  <8>[    9.981614] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10018206_1.4.2.3.1>

    2023-04-17T10:27:11.825417  / # #

    2023-04-17T10:27:11.926358  export SHELL=3D/bin/sh

    2023-04-17T10:27:11.926571  #

    2023-04-17T10:27:12.027589  / # export SHELL=3D/bin/sh. /lava-10018206/=
environment

    2023-04-17T10:27:12.027761  =


    2023-04-17T10:27:12.128701  / # . /lava-10018206/environment/lava-10018=
206/bin/lava-test-runner /lava-10018206/1

    2023-04-17T10:27:12.128963  =


    2023-04-17T10:27:12.133340  / # /lava-10018206/bin/lava-test-runner /la=
va-10018206/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1f039d4863b8722e8600

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d1f039d4863b8722e8605
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T10:27:00.375490  + set +x

    2023-04-17T10:27:00.382351  <8>[   10.615394] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10018167_1.4.2.3.1>

    2023-04-17T10:27:00.484708  =


    2023-04-17T10:27:00.585645  / # #export SHELL=3D/bin/sh

    2023-04-17T10:27:00.585884  =


    2023-04-17T10:27:00.686792  / # export SHELL=3D/bin/sh. /lava-10018167/=
environment

    2023-04-17T10:27:00.686995  =


    2023-04-17T10:27:00.788102  / # . /lava-10018167/environment/lava-10018=
167/bin/lava-test-runner /lava-10018167/1

    2023-04-17T10:27:00.789493  =


    2023-04-17T10:27:00.795073  / # /lava-10018167/bin/lava-test-runner /la=
va-10018167/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1f1917eaee63b22e8662

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d1f1917eaee63b22e8667
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T10:27:12.329323  + set<8>[   11.006538] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10018207_1.4.2.3.1>

    2023-04-17T10:27:12.329446   +x

    2023-04-17T10:27:12.434543  / # #

    2023-04-17T10:27:12.535549  export SHELL=3D/bin/sh

    2023-04-17T10:27:12.535770  #

    2023-04-17T10:27:12.636712  / # export SHELL=3D/bin/sh. /lava-10018207/=
environment

    2023-04-17T10:27:12.636949  =


    2023-04-17T10:27:12.737840  / # . /lava-10018207/environment/lava-10018=
207/bin/lava-test-runner /lava-10018207/1

    2023-04-17T10:27:12.738136  =


    2023-04-17T10:27:12.742590  / # /lava-10018207/bin/lava-test-runner /la=
va-10018207/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1ca4264aa395c92e85e7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d1ca4264aa395c92e85ec
        failing since 79 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-17T10:16:58.746563  + set +x
    2023-04-17T10:16:58.746770  [    9.405347] <LAVA_SIGNAL_ENDRUN 0_dmesg =
928422_1.5.2.3.1>
    2023-04-17T10:16:58.854505  / # #
    2023-04-17T10:16:58.956098  export SHELL=3D/bin/sh
    2023-04-17T10:16:58.956543  #
    2023-04-17T10:16:59.057971  / # export SHELL=3D/bin/sh. /lava-928422/en=
vironment
    2023-04-17T10:16:59.058434  =

    2023-04-17T10:16:59.159695  / # . /lava-928422/environment/lava-928422/=
bin/lava-test-runner /lava-928422/1
    2023-04-17T10:16:59.160285  =

    2023-04-17T10:16:59.162814  / # /lava-928422/bin/lava-test-runner /lava=
-928422/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1ef800209a83502e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d1ef800209a83502e85eb
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T10:26:46.763533  <8>[    9.634074] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10018140_1.4.2.3.1>

    2023-04-17T10:26:46.868105  / # #

    2023-04-17T10:26:46.969304  export SHELL=3D/bin/sh

    2023-04-17T10:26:46.969568  #

    2023-04-17T10:26:47.070552  / # export SHELL=3D/bin/sh. /lava-10018140/=
environment

    2023-04-17T10:26:47.070699  =


    2023-04-17T10:26:47.171415  / # . /lava-10018140/environment/lava-10018=
140/bin/lava-test-runner /lava-10018140/1

    2023-04-17T10:26:47.171646  =


    2023-04-17T10:26:47.176526  / # /lava-10018140/bin/lava-test-runner /la=
va-10018140/1

    2023-04-17T10:26:47.182223  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1c1bb6035d8ecd2e85e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv6=
4.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv6=
4.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d1c1bb6035d8ecd2e8=
5ea
        failing since 0 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d24b2acc9fc39802e8645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d24b2acc9fc39802e8=
646
        failing since 0 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1bef1cb8a8fcf42e85fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d1bef1cb8a8fcf42e8=
5ff
        failing since 0 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1c06d013a970022e8609

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_r=
iscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_r=
iscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d1c06d013a970022e8=
60a
        failing since 0 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d24c6786a3565eb2e85ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_ri=
scv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_ri=
scv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d24c6786a3565eb2e8=
5ef
        failing since 0 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1bee1cb8a8fcf42e85fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_=
riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_=
riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d1bee1cb8a8fcf42e8=
5fc
        failing since 0 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643d1d0c194b9105bc2e85f7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-254-g9b84e4a2f259/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d1d0c194b9105bc2e85fc
        failing since 75 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-17T10:18:16.244562  <8>[    5.718012] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3505398_1.5.2.4.1>
    2023-04-17T10:18:16.370072  / # #
    2023-04-17T10:18:16.475587  export SHELL=3D/bin/sh
    2023-04-17T10:18:16.477098  #
    2023-04-17T10:18:16.580469  / # export SHELL=3D/bin/sh. /lava-3505398/e=
nvironment
    2023-04-17T10:18:16.582053  =

    2023-04-17T10:18:16.685416  / # . /lava-3505398/environment/lava-350539=
8/bin/lava-test-runner /lava-3505398/1
    2023-04-17T10:18:16.688130  =

    2023-04-17T10:18:16.705199  / # /lava-3505398/bin/lava-test-runner /lav=
a-3505398/1
    2023-04-17T10:18:16.839875  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
