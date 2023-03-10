Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F26F6B52A4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 22:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjCJVSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 16:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjCJVSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 16:18:07 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CDB59F5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:18:02 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id a9so6962855plh.11
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678483082;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AmGV6wGs8y9UgbF0O3RPs89QGJgOcyOyNLaooMfmuuo=;
        b=cYWzpWM7Rn0FYtNPotCGpafkAxulSXgRfi+XRFLrTHVBfT9cx4oC3JzZn9cwgZ2a4w
         26hJ6wf5t5SfaCBcreWbWEI7ZPE96IohhX5hhBxRPJcClUopBR0OTUwqy7+ckPB/ow+s
         vvwIKVY/jJSKC6GpBzIzLgWtyFyHP2U/+UuYfxZ6979Js91GiE5m2e5qFuPUZvbkObGW
         nm6ly0s6dgs6+PF9oKTvErUxsCIOC8m2tRKVKzrfYjDMmV5cGlqHwhuixeac9BYugLrk
         t3jCv8rVMXfpfkFmOSOdTXKt40YIP2Tbhm/8sBc9UGThA19Iw2OxQt+KjjsLT7eK9Jp1
         QEpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678483082;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AmGV6wGs8y9UgbF0O3RPs89QGJgOcyOyNLaooMfmuuo=;
        b=2fZeBEaPLZrDVVfmRGhthVQQ8ziIeI9v/wtTfvIfcMq//MFb55tlKkKbB4ckBj12mO
         xQhd6EBpBYj49bS7Wn/5o2ds1Qq6v+xqFHWPM32oVLwXmk/H3yoz4FWbiXWq2aHf5DK4
         yaK44s3F3P9Qi3nMI2k0tnIuFn49ifdNZQKmBHzrhoTD59T0LGluPyXwKXPOp85xOe/b
         B/PPrZKh7lgTS7P/VPKYJ44jrwxoM9ccaRlrymoOlVyXKTe6dg5YIQkh3oaSmeRfZpOx
         DMDdYW4QVmG4d/rY2DkxC2N0/XeSsnR91RoKImyd6oDxpTRuJVKwGn6E+1GCZ5KaS186
         5AeQ==
X-Gm-Message-State: AO0yUKUR8avZChrG2h55GfAEOt4GIN3xjzPVGgNulYdr5BWrr3zvg3Vn
        L0s1V95Y11JdxvC2CKbhLxeDaVTFIvpncdeexLFE/Uak
X-Google-Smtp-Source: AK7set8IazsrV+A//fBfRCMAyfZU+Ao6ANNbilzvWwTpienjX4faLsiWYpZVSiI6ktW3fZslPHkmvA==
X-Received: by 2002:a05:6a20:7d88:b0:cd:9b0:b287 with SMTP id v8-20020a056a207d8800b000cd09b0b287mr32163470pzj.24.1678483081699;
        Fri, 10 Mar 2023 13:18:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i8-20020aa78d88000000b005e00086250asm232708pfr.125.2023.03.10.13.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:18:01 -0800 (PST)
Message-ID: <640b9e89.a70a0220.e3da6.0c89@mx.google.com>
Date:   Fri, 10 Mar 2023 13:18:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.99-136-g8868121d78d7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 170 runs,
 22 regressions (v5.15.99-136-g8868121d78d7)
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

stable-rc/queue/5.15 baseline: 170 runs, 22 regressions (v5.15.99-136-g8868=
121d78d7)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
acer-cb317-1h-c3z6-dedede    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

kontron-pitx-imx8m           | arm64  | lab-kontron   | gcc-10   | defconfi=
g                    | 2          =

qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.99-136-g8868121d78d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.99-136-g8868121d78d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8868121d78d724304145f3653095fd813083827b =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
acer-cb317-1h-c3z6-dedede    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6b40d910f5460e8c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-acer-cb317-1h-c3z6-dedede.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-acer-cb317-1h-c3z6-dedede.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6b40d910f5460e8c8=
636
        failing since 2 days (last pass: v5.15.98-545-g7d62bf096144, first =
fail: v5.15.98-567-gd8d75a314dc3) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6b43d910f5460e8c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6b43d910f5460e8c8=
63c
        failing since 2 days (last pass: v5.15.98-545-g7d62bf096144, first =
fail: v5.15.98-567-gd8d75a314dc3) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6b45914b3517628c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6b45914b3517628c8=
63d
        failing since 2 days (last pass: v5.15.98-545-g7d62bf096144, first =
fail: v5.15.98-567-gd8d75a314dc3) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6b4243a0d076258c8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6b4243a0d076258c8=
654
        failing since 2 days (last pass: v5.15.98-545-g7d62bf096144, first =
fail: v5.15.98-567-gd8d75a314dc3) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6d8103c19c45448c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6d8103c19c45448c8=
630
        failing since 35 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6acd30e4f035e58c863b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b6acd30e4f035e58c8644
        failing since 52 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-10T17:36:52.949859  <8>[   10.069762] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3402470_1.5.2.4.1>
    2023-03-10T17:36:53.060274  / # #
    2023-03-10T17:36:53.163610  export SHELL=3D/bin/sh
    2023-03-10T17:36:53.164804  #
    2023-03-10T17:36:53.267082  / # export SHELL=3D/bin/sh. /lava-3402470/e=
nvironment
    2023-03-10T17:36:53.268157  =

    2023-03-10T17:36:53.370081  / # . /lava-3402470/environment/lava-340247=
0/bin/lava-test-runner /lava-3402470/1
    2023-03-10T17:36:53.370700  =

    2023-03-10T17:36:53.375837  / # /lava-3402470/bin/lava-test-runner /lav=
a-3402470/1
    2023-03-10T17:36:53.418426  <3>[   10.514288] Bluetooth: hci0: command =
0xfc18 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6b41914b3517628c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6b41914b3517628c8=
637
        failing since 2 days (last pass: v5.15.98-545-g7d62bf096144, first =
fail: v5.15.98-567-gd8d75a314dc3) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6b58993698bdb78c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6b58993698bdb78c8=
634
        failing since 2 days (last pass: v5.15.98-545-g7d62bf096144, first =
fail: v5.15.98-567-gd8d75a314dc3) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6c6e013f3e1a9a8c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6c6e013f3e1a9a8c8=
638
        failing since 2 days (last pass: v5.15.98-545-g7d62bf096144, first =
fail: v5.15.98-567-gd8d75a314dc3) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
kontron-pitx-imx8m           | arm64  | lab-kontron   | gcc-10   | defconfi=
g                    | 2          =


  Details:     https://kernelci.org/test/plan/id/640b6cb3f0cf0abe3d8c865a

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b6cb3f0cf0abe3d8c8661
        failing since 3 days (last pass: v5.15.96-12-g79a511b0130e, first f=
ail: v5.15.98-545-g7d62bf096144)

    2023-03-10T17:45:13.537213  / # #
    2023-03-10T17:45:13.639310  export SHELL=3D/bin/sh
    2023-03-10T17:45:13.639881  #
    2023-03-10T17:45:13.741179  / # export SHELL=3D/bin/sh. /lava-291696/en=
vironment
    2023-03-10T17:45:13.741867  =

    2023-03-10T17:45:13.843380  / # . /lava-291696/environment/lava-291696/=
bin/lava-test-runner /lava-291696/1
    2023-03-10T17:45:13.844386  =

    2023-03-10T17:45:13.849064  / # /lava-291696/bin/lava-test-runner /lava=
-291696/1
    2023-03-10T17:45:13.910092  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-10T17:45:13.910397  + cd /l<8>[   12.154796] <LAVA_SIGNAL_START=
RUN 1_bootrr 291696_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/640=
b6cb3f0cf0abe3d8c8671
        failing since 3 days (last pass: v5.15.96-12-g79a511b0130e, first f=
ail: v5.15.98-545-g7d62bf096144)

    2023-03-10T17:45:16.231246  /lava-291696/1/../bin/lava-test-case
    2023-03-10T17:45:16.231623  <8>[   14.570490] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-03-10T17:45:16.231866  /lava-291696/1/../bin/lava-test-case   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6b9ad63a1526488c8681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6b9ad63a1526488c8=
682
        failing since 24 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6d81ae877308ef8c865e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6d81ae877308ef8c8=
65f
        failing since 24 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6a08a7d165aecc8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6a08a7d165aecc8c8=
630
        failing since 24 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6b461ca8d159238c8663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6b461ca8d159238c8=
664
        failing since 24 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6ca462e1057b128c864e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6ca462e1057b128c8=
64f
        failing since 24 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6d08d13c1a27548c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6d08d13c1a27548c8=
630
        failing since 24 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6a0aa7d165aecc8c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6a0aa7d165aecc8c8=
636
        failing since 24 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-gf3091fc0051b) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6b481ca8d159238c8666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6b481ca8d159238c8=
667
        failing since 13 days (last pass: v5.15.95-33-gc82275c7e6c8, first =
fail: v5.15.95-37-gda3256d1340e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6cb7f0cf0abe3d8c8694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6cb7f0cf0abe3d8c8=
695
        failing since 24 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-gf3091fc0051b) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b6d80ae877308ef8c8658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b6d80ae877308ef8c8=
659
        failing since 13 days (last pass: v5.15.95-33-gc82275c7e6c8, first =
fail: v5.15.95-37-gda3256d1340e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b69efa6cab11a178c86b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.99-=
136-g8868121d78d7/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b69efa6cab11a178c8=
6b7
        failing since 24 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-gf3091fc0051b) =

 =20
