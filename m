Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78664A86C1
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 15:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbiBCOlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 09:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245123AbiBCOkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 09:40:43 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE19C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 06:40:42 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso10222613pjv.1
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 06:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IlfKByaCgC8qjKLtwvUDiYyWSmPABFyQvqDZfbboa0w=;
        b=8WrIm9DtLhgM+9MOIQVaPqQ2TPJWvIPSmVKFUMN6fp7uRoIRNHLB+9ZRpjlbsizy7C
         bIwCwMnKDPmjAykEco3RqxM7VQtMwAoWuid2oz87VGVpqyqH10uokVSgq3LQs6KSqxYM
         pOpRyb9BydIf092NFk5U2S4zWeeXELZNmq4Kqg3EAseIp67i6zzAHyKU2a0JYl3SbI06
         Z5iyWhuatxdt2G09KNfGJVrk8rd7G7hF1+sfeoHNvThFMkJswgVA6m5p9TioBUgc34Pz
         N/ljl0LzTW9sIpq4mjrZIpvPGMSXCHLC1lAFz7NbCTD9p1hhIYQsTrRZHSz25Phep8xr
         DApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IlfKByaCgC8qjKLtwvUDiYyWSmPABFyQvqDZfbboa0w=;
        b=8BodBkeBgWCUJ/PpwbjXnkv/RLESJcdif9mtHi6SlO3n/gVbU5BkFwyS9qTasMmvfc
         T8J6/6crf2d0qhWz+I2CigFn7OFIwd1rVphE1yN3LVphCsdnW5COBlj/LcjioBtQ7EVo
         qK2/EmxCy7MEM3S1zwAElnmSIEfK0gNVyeRGfg5qE+pSNyVVGAhm9kzwImt8YLkEhf6h
         XIoClp0xLPg1LQr33O8rfg3Gln+Vue0hksSEACqaDGvnDItw3pxEz1P3RTGjEr0paP+f
         9FYSiTFHaum5CVnhglnHhuoX8waANb1JaCppwEOUYRyW9/LXnibBlda8s4fzpps5fu2u
         W2/w==
X-Gm-Message-State: AOAM53320IIBcoNdd2Rz6mJTTrXkt+s8+0MI59ZQcP35xawYCtlpcGgv
        rsefP9BXLgLhslc3sG80Oyb841mDVPagpFoI
X-Google-Smtp-Source: ABdhPJy3HKzNxpgmegvnH4WMib5+jPlzsdj9DUQvYfJuMP34PW9labiF9PSzaYubp5ECea3ETpKAGw==
X-Received: by 2002:a17:902:b941:: with SMTP id h1mr35769739pls.16.1643899242251;
        Thu, 03 Feb 2022 06:40:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23sm26423471pfh.216.2022.02.03.06.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 06:40:41 -0800 (PST)
Message-ID: <61fbe969.1c69fb81.aedb0.1bf2@mx.google.com>
Date:   Thu, 03 Feb 2022 06:40:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.302
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 115 runs, 3 regressions (v4.4.302)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 115 runs, 3 regressions (v4.4.302)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.302/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.302
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a09b2d8f61ea0e9ae735c400399b97966a9418d6 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61fbae5a7c91007ac95d6f03

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.302=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.302=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61fbae5a7c91007a=
c95d6f09
        new failure (last pass: v4.4.301-26-g806b2893e010)
        1 lines

    2022-02-03T10:28:23.688869  / # #
    2022-02-03T10:28:23.689496  =

    2022-02-03T10:28:23.792293  / # #
    2022-02-03T10:28:23.792773  =

    2022-02-03T10:28:23.893844  / # #export SHELL=3D/bin/sh
    2022-02-03T10:28:23.894202  =

    2022-02-03T10:28:23.995372  / # export SHELL=3D/bin/sh. /lava-1490244/e=
nvironment
    2022-02-03T10:28:23.995785  =

    2022-02-03T10:28:24.096930  / # . /lava-1490244/environment/lava-149024=
4/bin/lava-test-runner /lava-1490244/0
    2022-02-03T10:28:24.097799   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fbae5a7c91007=
ac95d6f0b
        new failure (last pass: v4.4.301-26-g806b2893e010)
        29 lines

    2022-02-03T10:28:24.456748  [   49.216430] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T10:28:24.521630  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-02-03T10:28:24.527609  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xcb8e4218)
    2022-02-03T10:28:24.532271  kern  :emerg : Stack: (0xcb8e5cf8 to 0xcb8e=
6000)
    2022-02-03T10:28:24.540153  kern  :emerg : 5ce0:                       =
                                bf02bdc4 60000013
    2022-02-03T10:28:24.548371  kern  :emerg : 5d00: bf02bdc8 c06a3e34 0000=
0001 00000000 bf010250 00000002 60000093 00000002
    2022-02-03T10:28:24.558863  kern  :emerg : 5d20:[   49.316131] <LAVA_SI=
GNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D29>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61fbae72903dcc8b465d6ee9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.302=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.302=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fbae72903dcc8=
b465d6eef
        failing since 2 days (last pass: v4.4.301, first fail: v4.4.301-23-=
g9b80ba4cf655)
        2 lines

    2022-02-03T10:28:45.392215  [   19.014007] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T10:28:45.439505  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2022-02-03T10:28:45.447054  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
