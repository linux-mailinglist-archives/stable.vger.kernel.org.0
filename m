Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A4A5F4AF3
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 23:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiJDVbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 17:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJDVby (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 17:31:54 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB0A6CD3D
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 14:31:52 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id f140so8958289pfa.1
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 14:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=Vj0oOhcNdSUcH7rZ7KuGAsfrJIJrNGkHwNKiluzrZ3w=;
        b=nQAW4W4fdbJoHzewWduS47lYpmNyt1mDCaq1tBn+aT2JquwUhclKqV9FjX/Ke0iA0B
         mEmY7mp7sSVnPCDxrIQilm6Ox69/Z3BmfJ1prYmWkWdUYtcoFDykK1YmsIrz1rQTPbl+
         SPQpda9jbng3sgeeZoUrctVVfp0G1TIp2KUuNQEwXdRZaB54RMjM6hZjHTg5aEbdeTMF
         2tdJZvJg0idxMU3RRPQGMrS+dahrUvBT6hwFo4uWYFcjbukr9jJoWniyIewLilhvVj7r
         qhhJYFREgt96qb+kFsf+6+F7X6JJCg6LUJq4domzwEygRI1bCTAfMGVCWjcsQ2ybawZw
         vfMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Vj0oOhcNdSUcH7rZ7KuGAsfrJIJrNGkHwNKiluzrZ3w=;
        b=I1ALMoqW9vXx833crYnRTbRzw1dM9xO9qIwwNxDQQ6qmOhcKd1LZX1pN1tXFGhCNzl
         u/862l//jcATlDl8eNHtE9Hxwb0ro+PNv9SbI7dasq9Sa5oteBgWxOpTeqBRENJ3C6Kv
         osSpOc6OhTnkKTKXVwKOWwp5ljhwJu252rUKcSmsz9NCSX/6Q3Kq46urUa/oJTDSDoQb
         XdLTZ6FDrtjK6Xe6NoZlmI91c833QqYN+9FiGh2s7Wl71m5Ssh/7YASw21WN0ljl/5Pm
         spsV+h4J4BFlwpwxqda7LFVObe/TGz2taPS4FUPlpsLNA/UGPcBjjRxe6j+vlgB3bXIp
         Geyg==
X-Gm-Message-State: ACrzQf3XwVNKgGPXViVGVOG5/vN6x7XdRGZKHZWiIvS0G0QZasOox+IR
        IwLstWby6p3ILAz6h4sqPTsDSLZtycgu0bsUpTU=
X-Google-Smtp-Source: AMsMyM48IJeMeuQKuA8ppaBQUf/cCXDoNoy3x0qgGb/Of8nPOqzyGzeOENsM221dj80A/hfeuiUuMA==
X-Received: by 2002:a63:451a:0:b0:439:246e:807e with SMTP id s26-20020a63451a000000b00439246e807emr23777007pga.347.1664919111879;
        Tue, 04 Oct 2022 14:31:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l8-20020a170903244800b00176683cde9bsm6983500pls.294.2022.10.04.14.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 14:31:51 -0700 (PDT)
Message-ID: <633ca647.170a0220.80821.b77d@mx.google.com>
Date:   Tue, 04 Oct 2022 14:31:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.146-52-g074785c2639cd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 93 runs,
 4 regressions (v5.10.146-52-g074785c2639cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 93 runs, 4 regressions (v5.10.146-52-g074785=
c2639cd)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
panda                 | arm   | lab-baylibre  | gcc-10   | multi_v7_defconf=
ig         | 1          =

panda                 | arm   | lab-baylibre  | gcc-10   | omap2plus_defcon=
fig        | 1          =

qemu_arm64-virt-gicv3 | arm64 | lab-collabora | gcc-10   | defconfig       =
           | 1          =

rk3399-gru-kevin      | arm64 | lab-collabora | gcc-10   | defconfig+arm64-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.146-52-g074785c2639cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.146-52-g074785c2639cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      074785c2639cdd60ccc8126198aa78ac68c37076 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
panda                 | arm   | lab-baylibre  | gcc-10   | multi_v7_defconf=
ig         | 1          =


  Details:     https://kernelci.org/test/plan/id/633ca58ea8e3a83eeacab60b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-52-g074785c2639cd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-52-g074785c2639cd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ca58ea8e3a83eeacab=
60c
        failing since 42 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
panda                 | arm   | lab-baylibre  | gcc-10   | omap2plus_defcon=
fig        | 1          =


  Details:     https://kernelci.org/test/plan/id/633ca3ad2c0c4d8c02cab600

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-52-g074785c2639cd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-52-g074785c2639cd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ca3ad2c0c4d8c02cab=
601
        failing since 42 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
qemu_arm64-virt-gicv3 | arm64 | lab-collabora | gcc-10   | defconfig       =
           | 1          =


  Details:     https://kernelci.org/test/plan/id/633c761fca07344a6dcab632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-52-g074785c2639cd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-52-g074785c2639cd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c761fca07344a6dcab=
633
        failing since 70 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-10   | defconfig+arm64-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633c7501dc1863b1dacab609

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-52-g074785c2639cd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-52-g074785c2639cd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/633c7501dc1863b1dacab62b
        failing since 210 days (last pass: v5.10.103-56-ge5a40f18f4ce, firs=
t fail: v5.10.103-105-gf074cce6ae0d)

    2022-10-04T18:01:21.932856  /lava-7498695/1/../bin/lava-test-case   =

 =20
