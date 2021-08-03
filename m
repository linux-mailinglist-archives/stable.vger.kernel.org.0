Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EA53DE3F9
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 03:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhHCB3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 21:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbhHCB3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 21:29:48 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A649DC06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 18:29:36 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so1642242pjb.2
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 18:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vLC/vokH4ngkC6WbHMghSh3JGrqDqReYDbsSYEYolW0=;
        b=rkwRRfz4dQt7D+nWv5ae7g6j+Moq1dZ/8y4ePeA9M5uNhPyPzapDg8VNaT9VokEUDg
         DQ9gg74af3f1wBBqLEye5PyM0+6Qno7WVFwarjMGos5JliFVl8qLdqGyhdpYcf1u9+id
         9Snk/kFxBZ4eWM7BeBXwXNDThS0EwFYilcVOHXn7PNPhVq/epnsML53vbaUcQVW7+8DB
         iFJly+rQXoyI9jlOiw1bxL9pxC7GpCUhUi1RHLevxlcBknNkq5q5isb8Q5WohvTNlwOV
         CYMd6GgjnfrHdkAvyIyBMFHPLHlFjCOKHMy3DLvLrkpnUVmLjv1TbCTW2QYjJkfsw+uN
         6E+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vLC/vokH4ngkC6WbHMghSh3JGrqDqReYDbsSYEYolW0=;
        b=LjeSxUSbqdKXDwLl8wGiNvhJxmObwwBFLTGj2t/egqBGYJ0MNg4irHCO669nod30Gn
         bJer43TJviVqbqDr1gUHOZ0Us+6nbiqmR2bjyg4LG2+exntoS0Slmk1x902bdxS/hxXh
         PVOJXOT47H7SisESQwlyVPYT3/G9yKQ4ihWFzVTexAB4L8Q/3gAlHqDqhacH4HkyVLhF
         z9bniC6gY5c87QbNnZAKLCfFLClXf+A4srhPbtM+oeEUP+BYGHgrejmW3V6q+9mOO0Ao
         kO6U6Rr5Gq3hC4XJl+rIshOn8zTQNfSouDY9YLV23UwKyRtUri4rOBL5lurgo/HCbcmz
         9llA==
X-Gm-Message-State: AOAM533xdVNaQ0dOEx8kJ9zbbWIEg8AblcYuuWuEv+geuTeGUYh0eTQU
        HBH0u3XgyC60PRAT36s2j1wW6CRu7gaV4z1z
X-Google-Smtp-Source: ABdhPJzGrHy7yyFU0vnS7fnzsqTdzDWxQ0iSDplkaAbfQy2r7vOyMZ2hndZ7ciwcEPnakZr6sP+plg==
X-Received: by 2002:aa7:980a:0:b029:358:adf9:c37b with SMTP id e10-20020aa7980a0000b0290358adf9c37bmr19600961pfl.12.1627954176089;
        Mon, 02 Aug 2021 18:29:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k8sm15233504pgr.91.2021.08.02.18.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 18:29:35 -0700 (PDT)
Message-ID: <61089bff.1c69fb81.3147c.ca5d@mx.google.com>
Date:   Mon, 02 Aug 2021 18:29:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.7-104-gf0ecd7adb24d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 163 runs,
 3 regressions (v5.13.7-104-gf0ecd7adb24d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 163 runs, 3 regressions (v5.13.7-104-gf0ecd7=
adb24d)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
   | regressions
------------------------+-------+--------------+----------+----------------=
---+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig | 1          =

fsl-ls1043a-rdb         | arm64 | lab-nxp      | gcc-8    | defconfig      =
   | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.7-104-gf0ecd7adb24d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.7-104-gf0ecd7adb24d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f0ecd7adb24d1bd3cd62052885e22284ca641d22 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
   | regressions
------------------------+-------+--------------+----------+----------------=
---+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6108628e9854fffa2db136c0

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-gf0ecd7adb24d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-gf0ecd7adb24d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6108628e9854fff=
a2db136c5
        failing since 1 day (last pass: v5.13.7-34-g59fb97ea0e16, first fai=
l: v5.13.7-90-gc013d5cf65f6)
        1 lines

    2021-08-02T21:24:11.408342  kern  :emerg : Disabling IRQ #33
    2021-08-02T21:24:11.443532  <8>[   14.003536] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-08-02T21:24:11.444357  + set +x   =

 =



platform                | arch  | lab          | compiler | defconfig      =
   | regressions
------------------------+-------+--------------+----------+----------------=
---+------------
fsl-ls1043a-rdb         | arm64 | lab-nxp      | gcc-8    | defconfig      =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61086638cb0a200748b1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-gf0ecd7adb24d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-gf0ecd7adb24d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61086638cb0a200748b13=
66e
        new failure (last pass: v5.13.7-34-g59fb97ea0e16) =

 =



platform                | arch  | lab          | compiler | defconfig      =
   | regressions
------------------------+-------+--------------+----------+----------------=
---+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/610865294d35637e05b1367f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-gf0ecd7adb24d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-gf0ecd7adb24d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610865294d35637e05b13=
680
        failing since 4 days (last pass: v5.13.5-223-g3a7649e5ffb5, first f=
ail: v5.13.6-22-g42e97d352a41) =

 =20
