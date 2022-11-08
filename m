Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3ABE621E30
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 22:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKHVCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 16:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKHVCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 16:02:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA1F60695
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:02:03 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso14525938pjc.5
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 13:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=EIuVIGEjh1T2v9kq3RXQrmUC/3kljp/6mb9K+6nlfpQ=;
        b=7OioEqq4uHfPIXvS/AZbCSQMWju2orO9F+Ryx0ywYvmdKl6OhwxlmH3cIvWX7J9zvZ
         ONyaGQdQg3ARYce2ULlnKqTzVIs2vI7Se8rTJemLYEsqI58IexfIeKchsB6FWBsp+ZZ9
         ZS6kdwvM1aSY7kPvl98kMONs6+MQUjV4vnEKnM8RVpiM2GcS1lM+opqIk3qQO/RkhvDh
         3rwRqTp1uQUbL8kYu2jHJxp5VJeJGM2RaYXXRoWJ8qViiI2fP8TR8ntOWSm5fDAwUvuV
         FQ3+KrAAM9KwUMcobZD03eStqkSFT8YaFrHFIHGl0zOu9gjE+p+MoD9ZhnsCKke2l9en
         dPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EIuVIGEjh1T2v9kq3RXQrmUC/3kljp/6mb9K+6nlfpQ=;
        b=pUW2hgjtc7d1vlxatoaRp3MvrfiVmMb0N0CDuiUTzufKll9dXd0TjgVtq/0A4giG1K
         1fO7SKCt+IBGUOmYfsCA0NsEAWmwpWLzYOrcOg2hB5QYJyQuKIy4XiMjGlE2rNUZcgqQ
         1sO/h9cNz/2csabVseEuEX5WBqER+vOStt0Mx3U/zHM9cMMNbbjbOiFdmXXboa7ZmNb1
         Iv/JF8zsmXv18uy9PB9ZdUTk43BKfCUddcHjiVEwsfDWS2j4TIRWBiBV/UdjgdsvH+0y
         u3cPAVWAL3ZKRK6ro4PT/pUdc+qBE8Sil3eVftHj7RpgY3MdHjE7Ilcb1wymSL9Jl9uZ
         JUJw==
X-Gm-Message-State: ACrzQf31YP9KYf5FM/WFRG+uQsjFzK/toaxlH7muereSMsUVgXQ24o5y
        9FruZnsTyrl+5noIOIQycsjJ/pRyK8ta9YNf
X-Google-Smtp-Source: AMsMyM555cQ8KsyVaS6iHbLypGP4wrKo/GQiYLxl6ZLMbzw7xAEUwvTnljORa9wa64kbKpxPqWXpTA==
X-Received: by 2002:a17:903:1112:b0:179:ce23:dd57 with SMTP id n18-20020a170903111200b00179ce23dd57mr59552230plh.114.1667941322986;
        Tue, 08 Nov 2022 13:02:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9-20020a17090aab8900b00217ce8a9178sm4065286pjq.57.2022.11.08.13.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 13:02:02 -0800 (PST)
Message-ID: <636ac3ca.170a0220.14c1c.7835@mx.google.com>
Date:   Tue, 08 Nov 2022 13:02:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.264-48-g6f1c51b0d83e
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 123 runs,
 11 regressions (v4.19.264-48-g6f1c51b0d83e)
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

stable-rc/queue/4.19 baseline: 123 runs, 11 regressions (v4.19.264-48-g6f1c=
51b0d83e)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
da850-lcdk                   | arm   | lab-baylibre  | gcc-10   | davinci_a=
ll_defconfig | 2          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
             | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
             | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
             | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
             | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
             | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
             | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
             | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
             | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.264-48-g6f1c51b0d83e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.264-48-g6f1c51b0d83e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6f1c51b0d83e50292e692f9f2d1abaa78f4b9142 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
da850-lcdk                   | arm   | lab-baylibre  | gcc-10   | davinci_a=
ll_defconfig | 2          =


  Details:     https://kernelci.org/test/plan/id/636a79acc6f567761ce7db6c

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/636a79acc6f5677=
61ce7db73
        new failure (last pass: v4.19.264-29-g4581d949f2cb)
        4 lines

    2022-11-08T15:45:26.430740  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-11-08T15:45:26.431046  kern  :emerg : flags: 0x0()
    2022-11-08T15:45:26.431242  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-11-08T15:45:26.433758  kern  :emerg : flags: 0x0()
    2022-11-08T15:45:26.500581  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/636a79acc6f5677=
61ce7db74
        new failure (last pass: v4.19.264-29-g4581d949f2cb)
        6 lines

    2022-11-08T15:45:26.244494  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-11-08T15:45:26.244764  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-11-08T15:45:26.244987  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-11-08T15:45:26.245150  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-11-08T15:45:26.245306  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-11-08T15:45:26.247596  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-11-08T15:45:26.289216  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =

 =



platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/636a7a32d7f555eba7e7db60

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a7a32d7f555eba7e7d=
b61
        failing since 203 days (last pass: v4.19.238-22-gb215381f8cf05, fir=
st fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/636a79f299c4efd640e7db7f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a79f299c4efd640e7d=
b80
        failing since 105 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/636a79deec2cf7a184e7db5d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a79deec2cf7a184e7d=
b5e
        failing since 105 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/636a79ee99c4efd640e7db74

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a79ee99c4efd640e7d=
b75
        failing since 105 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/636a79dd0b806cf127e7dbd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a79dd0b806cf127e7d=
bd1
        failing since 105 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/636a79ef34a149e9ede7db8f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a79ef34a149e9ede7d=
b90
        failing since 105 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/636a79dc0b806cf127e7dbcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a79dc0b806cf127e7d=
bce
        failing since 105 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/636a79f199c4efd640e7db7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a79f199c4efd640e7d=
b7d
        failing since 105 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
             | regressions
-----------------------------+-------+---------------+----------+----------=
-------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/636a79deec2cf7a184e7db63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.264=
-48-g6f1c51b0d83e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a79deec2cf7a184e7d=
b64
        failing since 105 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =20
