Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582AF4DBB16
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 00:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350069AbiCPXdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 19:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245693AbiCPXcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 19:32:50 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543C0167C0
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 16:31:35 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id c2so1314815pga.10
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 16:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pKPsuLqZVmaxmrz0j6Zg736NjK7qKv4htMSoIi3Uv9o=;
        b=dZT7uJcO2Q8abGrcZ8m24RgZAGTPLv0niXrty0CPZiaWKjUlLyK6dUQCRV1ZKDgf19
         NnHfui5OMr4hZtH4KettYMkNKTipHJXCouIyk5+6cCZMTBlDrH1vlwwWOIFhmVYK+b62
         HaNZR9bv43e0GNCkjRXruEB28IR9YfJw4Xqlmr/VaCsqyOItgJN9IIgogfgRanwUqFfw
         5S8rOPOJu7AsRWs118+TloOybKruvwVpdrpApKGemERcjpV1VWKhR3q1KicYMYIqffcG
         /vmQQpINdHSA0RLEu+MxmMNq02aLXz8tZf8HykIatl182sTO4Aq1Z4NjDUxUPNZmeFEw
         ulLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pKPsuLqZVmaxmrz0j6Zg736NjK7qKv4htMSoIi3Uv9o=;
        b=x6Lj8Xo/nTUvov9XuIXSTl+5zpLH28aWk8n55EQAgLmfs6UXptcANak89I3qbngoJP
         QvyMl+lj1ozhwH2DfG1Fhya0IIjbAmJ81xzO16t6hc0INsp6SC154DgVuoWXNoCyqoT1
         UykGnuCGEZ8MP5zbKBLi/plrI3rB6NC1Y0YCubp+uhZbuHe6IXAkgn4hnR3EKVVOsU/D
         2YJBsl8K7E3DoexY1ZiRgSuGEdHQXnkzTKmum5HMF9LQWkF7wYdP+sd3A1b874krEduy
         gF2q7QyeQYbNR0cAMQsv7RKp8+Cwbw1JataCbf61qkdTVW7X7oN0fClCFM43vtZN2Ck4
         tamA==
X-Gm-Message-State: AOAM532rX4BVCqEXJQKRldu9YB3HM7SyuwSilK3l+0420g7hWHGp9vtp
        3Vx2TVpmWWS3cFiGsFWf7yKr3a2PuIXJIeOUc70=
X-Google-Smtp-Source: ABdhPJzABIBZReplZ0lqWwdQf+Hsy4aMaEw07vHXfsAc4CfwrPxdFOn6Muo0eXn0Rfisfnyt4z4kQQ==
X-Received: by 2002:a63:fa0d:0:b0:372:d581:e84 with SMTP id y13-20020a63fa0d000000b00372d5810e84mr1478976pgh.414.1647473494622;
        Wed, 16 Mar 2022 16:31:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s141-20020a632c93000000b0038134d09219sm3674098pgs.55.2022.03.16.16.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:31:34 -0700 (PDT)
Message-ID: <62327356.1c69fb81.513dc.960b@mx.google.com>
Date:   Wed, 16 Mar 2022 16:31:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.185-43-gdb2e9a81bab9
Subject: stable-rc/queue/5.4 baseline: 90 runs,
 5 regressions (v5.4.185-43-gdb2e9a81bab9)
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

stable-rc/queue/5.4 baseline: 90 runs, 5 regressions (v5.4.185-43-gdb2e9a81=
bab9)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
hp-x360-14-G1-sona       | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

meson-gxbb-p200          | arm64  | lab-baylibre  | gcc-10   | defconfig   =
                 | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

rk3399-gru-kevin         | arm64  | lab-collabora | gcc-10   | defconfig+ar=
m64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.185-43-gdb2e9a81bab9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.185-43-gdb2e9a81bab9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db2e9a81bab9e300e71927057b3903150331d36c =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
hp-x360-14-G1-sona       | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62323bd51b9f97e060c62a16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gdb2e9a81bab9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gdb2e9a81bab9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62323bd51b9f97e060c62=
a17
        new failure (last pass: v5.4.185-43-gd7cd4833efab) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
meson-gxbb-p200          | arm64  | lab-baylibre  | gcc-10   | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/62323e3bf111adb1dcc62979

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gdb2e9a81bab9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gdb2e9a81bab9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62323e3bf111adb1dcc62=
97a
        new failure (last pass: v5.4.185-43-gd7cd4833efab) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62323db3bc2223bb0cc6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gdb2e9a81bab9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gdb2e9a81bab9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62323db3bc2223bb0cc62=
96b
        failing since 90 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62323dee6649611944c6297f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gdb2e9a81bab9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gdb2e9a81bab9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62323dee6649611944c62=
980
        failing since 90 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
rk3399-gru-kevin         | arm64  | lab-collabora | gcc-10   | defconfig+ar=
m64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62323cb50349c51c33c6296a

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gdb2e9a81bab9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gdb2e9a81bab9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62323cb50349c51c33c62990
        failing since 10 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-03-16T19:38:14.872836  <8>[   32.140092] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-16T19:38:15.883656  /lava-5892994/1/../bin/lava-test-case
    2022-03-16T19:38:15.891837  <8>[   33.160596] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
