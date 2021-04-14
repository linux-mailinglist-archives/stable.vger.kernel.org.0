Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA3635FAB2
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 20:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352099AbhDNSUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 14:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353027AbhDNSTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 14:19:20 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E80C061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 11:18:58 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id f29so15018404pgm.8
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 11:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LpnKQcYGYVQrtwGSVDijkU9NMPt3+wLYXr5DDUigWhM=;
        b=HBwvbWArkKChmbBmoZm1wUPO5MMKnJ7Ty1WLo1VWG7upvgrUKCKgOA2hvn27/vXWcS
         VlV25nSYv4N+hie3tS5gb9mp3owSUxkzEYKwdKAlZ81FWAlTr1y7OWtWocbZBlBRQTJb
         Gnx8S4DQjERqaVaE2qjD3OIhJyQaDhuUNmVgc4L7TRr3SgT0ntoadiOtYf7uOBiamBKp
         ruK41dqGmETpaSCjlHKTKOnTwkihZP1qcbW9CQblZgDfg4J7K6jfBSGYLSxovSKXN+Ya
         QUgsDoRNsSkV3BNbo9JN1RX5YEUcQoxMRHVlQp8BhFbeg9kN/c+TUKPbs2BLY/i751Bd
         XOQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LpnKQcYGYVQrtwGSVDijkU9NMPt3+wLYXr5DDUigWhM=;
        b=KkMJ4/j83/maOAFL7aV34y5C0CvpPw8vBQFB4D6PJx8z9K2uFCuSluR9BiGcOX+TPw
         /junVhIpxTmgJlqLoAK/DtfvvqoDY6T1vH8Itk1SVxz3+vWtDiFSaLbqc27kaM9TrOhU
         pTRkD5G9NYYU8wTGeLjvbIucL++UujJGMwcucqFTJnqEcvK0OhQyjYmvmx0Bc8Fy8jW7
         7t0AoRawaWHbrcjDDTrHreBRXWcoiXewb+6rB022FqayxHyKIkRtU/S7kYSAp+Apg9hn
         2f6HShqrCmXGw/YfYZvISdbaQbcrERh+em1XrikkOalh543KEvzRoU8gQCUMYn5LI2iB
         Zymw==
X-Gm-Message-State: AOAM531PggmV+7UB1an9MF1RMLU1MEnbPjiI6JuA+aE0WyeuyyKqVtPr
        AUkoyNIngyYyohZrhwj96d035A4Omfittg==
X-Google-Smtp-Source: ABdhPJwGEx0VUEoQfnyhAdSSmxSom05cOJI1zhrrOSzp6+FLPB/rEbV56uy+33aAM/Ebjmc88+FnkA==
X-Received: by 2002:a63:d54a:: with SMTP id v10mr38309539pgi.83.1618424337758;
        Wed, 14 Apr 2021 11:18:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h16sm112720pfc.194.2021.04.14.11.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 11:18:57 -0700 (PDT)
Message-ID: <60773211.1c69fb81.e3713.07c8@mx.google.com>
Date:   Wed, 14 Apr 2021 11:18:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.30
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 136 runs, 3 regressions (v5.10.30)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 136 runs, 3 regressions (v5.10.30)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
    | regressions
----------------------+-------+-----------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32    | arm   | lab-baylibre    | gcc-8    | bcm2835_defcon=
fig | 2          =

imx8mq-zii-ultra-zest | arm64 | lab-pengutronix | gcc-8    | defconfig     =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.30/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.30
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e798745fa8ef91ffe4fd38d443f9d44b59e3cb3 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
    | regressions
----------------------+-------+-----------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32    | arm   | lab-baylibre    | gcc-8    | bcm2835_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/6076faa5b5319d9659dac6ce

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
0/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
0/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6076faa5b5319d9=
659dac6d2
        new failure (last pass: v5.10.29-189-g8ac4b1deedaa)
        4 lines

    2021-04-14 14:22:16.207000+00:00  kern  :alert : Unhandled fault: page =
domain fault (0x81b) at 0x00016d85
    2021-04-14 14:22:16.208000+00:00  kern  :alert : pgd =3D<8>[   42.48627=
4] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines M=
EASUREMENT=3D4>
    2021-04-14 14:22:16.209000+00:00   c5b71e1c   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6076faa5b5319d9=
659dac6d3
        new failure (last pass: v5.10.29-189-g8ac4b1deedaa)
        47 lines

    2021-04-14 14:22:16.255000+00:00  kern  :emerg : Internal error: : 81b =
[#1] ARM
    2021-04-14 14:22:16.257000+00:00  kern  :emerg : Process udevd (pid: 99=
, stack limit =3D 0x8373c277)
    2021-04-14 14:22:16.257000+00:00  kern  :<8>[   42.530901] <LAVA_SIGNAL=
_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D47>
    2021-04-14 14:22:16.258000+00:00  emerg : Stack: (0xc4209d<8>[   42.542=
326] <LAVA_SIGNAL_ENDRUN 0_dmesg 95982_1.5.2.4.1>   =

 =



platform              | arch  | lab             | compiler | defconfig     =
    | regressions
----------------------+-------+-----------------+----------+---------------=
----+------------
imx8mq-zii-ultra-zest | arm64 | lab-pengutronix | gcc-8    | defconfig     =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6076ff06e5cc93248bdac6da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
0/arm64/defconfig/gcc-8/lab-pengutronix/baseline-imx8mq-zii-ultra-zest.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
0/arm64/defconfig/gcc-8/lab-pengutronix/baseline-imx8mq-zii-ultra-zest.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076ff06e5cc93248bdac=
6db
        new failure (last pass: v5.10.19-658-g083cbba104d9) =

 =20
