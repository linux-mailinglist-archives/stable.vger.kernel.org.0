Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3A5363493
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 12:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhDRKOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 06:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhDRKOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 06:14:16 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D77C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 03:13:48 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id m11so21263648pfc.11
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 03:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pigLWECkKu29BXi6TvA1VT+yg8qBCoZnkqZieHON4dE=;
        b=aWHyzMarNXqrVaxOcRg66BNxuZ+/bbWoGtmqWPenKHZAlKYwB1XaAnAoDbH8q8Xv3+
         WZ4FC2we0NFEF5kcA865aRgXsGif2gaEokIsuzyKWRozs/G7j816fm2A/luqZuO4MG83
         uZav0t1eE0UX+TV1cWs+nS9aQ2jGOd2j6n29AZn8QefR6J8J8qwnAgUJu0OVc0BDj9rR
         kNn2WnxgpAIM8n6LPlQwKbaN3YNBhTsecjEtoitlIePz2khTWI3Yz6VVht3pGkHkqzgo
         PMcbnx+oDxbEKVwxzrCab0FsoONzXI9ZEOUI/Lrd6/DW22Tl2edxbOZ/Q0pK1pqTfRH5
         4hRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pigLWECkKu29BXi6TvA1VT+yg8qBCoZnkqZieHON4dE=;
        b=hTfs265hTYPkeHOWpLDOi0tEYRHAwnhNROo8fJd5EU6v8ucVGAo9tED04bc+jsNB7N
         xWgplvoI2ZAFORsDhDTp8weM3uq5xsep8L1EGXjvM2eq22tB+1M5swDXNUL4TGaH7VD6
         cDbOKe14rh7mNt8SEWJ1VO6NBCarippuBiWPK7xAV4KuUMI/8DsUHHoUas/3S3ygCNHs
         SKnX9IdkxBMwo/2cGJ4A9vU0LK3laESU84k/UK4Lzfk16Ns4pCADV2keV0QpvEW0w3JB
         zgeIrpmf8p6e07THC9CxyxELj0jGdjMzDfNPLC+k/WwxIeaWDRWoXXeyYinoKf6tKNQJ
         sW1A==
X-Gm-Message-State: AOAM533A2U16QtJgkz9nupmB+X1qSwIfNy/d319x2VTKQmtyoHNq8T72
        sqSJ1UlSIjuIvEYWUcNZadPCcSoXR1XCk3AW
X-Google-Smtp-Source: ABdhPJw0oVzE9xmUMI02uNdCETeMOHcwEMvhYkFF/ylizhkqcmMVWJ2EXUB7O9D1ob2vHS0woxDxZA==
X-Received: by 2002:a63:eb12:: with SMTP id t18mr6946800pgh.349.1618740827882;
        Sun, 18 Apr 2021 03:13:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gt22sm10643396pjb.7.2021.04.18.03.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 03:13:47 -0700 (PDT)
Message-ID: <607c065b.1c69fb81.892d8.9292@mx.google.com>
Date:   Sun, 18 Apr 2021 03:13:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.31-45-g3f647a3134219
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 152 runs,
 3 regressions (v5.10.31-45-g3f647a3134219)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 152 runs, 3 regressions (v5.10.31-45-g3f647a=
3134219)

Regressions Summary
-------------------

platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6q-var-dt6customboard | arm  | lab-baylibre    | gcc-8    | multi_v7_def=
config  | 2          =

imx6ul-pico-hobbit       | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.31-45-g3f647a3134219/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.31-45-g3f647a3134219
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f647a31342195eb87dc3d908785e88b47712245 =



Test Regressions
---------------- =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6q-var-dt6customboard | arm  | lab-baylibre    | gcc-8    | multi_v7_def=
config  | 2          =


  Details:     https://kernelci.org/test/plan/id/607bd43abe6f2d918cdac725

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.31-=
45-g3f647a3134219/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.31-=
45-g3f647a3134219/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/607bd43abe6f2d9=
18cdac729
        new failure (last pass: v5.10.30-24-g4542aa1254a3d)
        4 lines

    2021-04-18 06:39:07.021000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000313
    2021-04-18 06:39:07.022000+00:00  kern  :alert : pgd =3D (ptrval)<8>[  =
 39.626566] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-04-18 06:39:07.022000+00:00  =

    2021-04-18 06:39:07.022000+00:00  kern  :alert : [00000313] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/607bd43abe6f2d9=
18cdac72a
        new failure (last pass: v5.10.30-24-g4542aa1254a3d)
        47 lines

    2021-04-18 06:39:07.074000+00:00  kern  :emerg : Process kworker/0:2 (p=
id: 76, stack limit =3D 0x(ptrval))
    2021-04-18 06:39:07.074000+00:00  kern  :emerg : Stack: (0xc32c7d58 to =
0xc32c8000)
    2021-04-18 06:39:07.075000+00:00  kern  :emerg : 7d40:                 =
                                      c3ae79b0 c3ae79b4
    2021-04-18 06:39:07.075000+00:00  kern  :emerg : 7d60: c3ae7800 c3ae781=
4 c144a008 c09c4d04 c32c6000 ef86bc80 c09c60c4 c3ae7800
    2021-04-18 06:39:07.076000+00:00  kern  :emerg : 7d80: 000002f3 0000000=
c c19c77e4 c2001d80 c39e1500 ef86bc20 c09d245c c144a008
    2021-04-18 06:39:07.117000+00:00  kern  :emerg : 7da0: c19c77c8 2509ec7=
e c19c77e4 c39e4280 c39d9600 c3ae7800 c3ae7814 c144a008
    2021-04-18 06:39:07.118000+00:00  kern  :emerg : 7dc0: c19c77c8 0000000=
c c19c77e4 c09d242c c1447d30 00000000 c3ae780c c3ae7800
    2021-04-18 06:39:07.118000+00:00  kern  :emerg : 7de0: fffffdfb c22d8c1=
0 c39dc5c0 c09a8354 c3ae7800 bf048000 fffffdfb bf044138
    2021-04-18 06:39:07.118000+00:00  kern  :emerg : 7e00: c39d0b80 c3b50d0=
8 00000120 c39d9340 c39dc5c0 c0a01f3c c39d0b80 c39d0b80
    2021-04-18 06:39:07.118000+00:00  kern  :emerg : 7e20: 00000040 c39d0b8=
0 c39dc5c0 00000000 c19c77dc bf141084 bf142014 0000001b =

    ... (33 line(s) more)  =

 =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6ul-pico-hobbit       | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/607bd554fc0235bed1dac6bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.31-=
45-g3f647a3134219/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.31-=
45-g3f647a3134219/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607bd554fc0235bed1dac=
6c0
        new failure (last pass: v5.10.30-24-g4542aa1254a3d) =

 =20
