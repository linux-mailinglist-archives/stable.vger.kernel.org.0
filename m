Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4659D4A316A
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 19:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbiA2Spa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 13:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346259AbiA2Sp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 13:45:29 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C71FC06173B
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 10:45:29 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id p125so8266733pga.2
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 10:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SfSNqpPguFegELwIv+4AmmFfuZ3K6zGGMe5gjd5beAY=;
        b=jY9bNMn4uqjdHUtDVSE8kiV1/SjfaVZ2BS00ELcnOJLcOwVBB1jZY1WnNDrax9rlFh
         p43HcvZs/06w77KgZcEUvriit05LVrk3jwPNpwSgArowQjMLlC8YzNDC7WHaWhbu8fR2
         14HaPP0lJL17TFOo9RpXFeZ46Bar3hev+GgKDub2HdrRih3KpXZNCBAMPOlJGq4mLgsP
         tzilGqWHGLmCnBcYmCYPck1+riTaHdoIhybWTAjx29mERxfDjTzU2PFBDDWHfARUtmUd
         wBFTwVYcuioU9gW1wKnnED1cLBKUPOqValmdeH3qceylCGxZGGZf4nLRjgnHxfVJBRTo
         cBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SfSNqpPguFegELwIv+4AmmFfuZ3K6zGGMe5gjd5beAY=;
        b=HQkiS9e0AGUGhgZPzXv4rIS2cUtsRXmMmfEBotLg/v5eVy0zrZypOAt64MEmoQY7/e
         N5ivlFbYaki2V09mJaxooc1S+r4Uc53jX0gpeqwmua1w1Fmt5aO+ef/r1OgyBm6J9rmI
         d9c4COYzO1C8C5GhykgnKmFXPYe33BloFttNQKcPLuqA4BJQuTx74t/tE0X3fA3XNaWl
         Y8FLFR7dDFoXvGCY/VsPuFYa4n190RKzN95LtQWmX2Ccx6dPpCEZKbcTf79v2slDvzg1
         AEpEeKeln9eZ2/5zAJuJ3Q1zUttST71VMP8c5mJKCrayEUpbOz0RJOgWDqn+2BMedOS9
         K+uw==
X-Gm-Message-State: AOAM530+jAXP8j3/pRqlwsIM2+5EreNBOaY99uUDf1NZQ+Lyi3j+fwf4
        Gun5qi+6Z/lwtpzEzuaMudnVMuqvimDdhaHA
X-Google-Smtp-Source: ABdhPJxhEG5gPZooPw/a3wORt9SH2ytqSLM8ynRj5qUlqQb+0Mzwimn6s+rlgCrHMMK8tIbmImAdIA==
X-Received: by 2002:a65:5943:: with SMTP id g3mr11321163pgu.3.1643481928808;
        Sat, 29 Jan 2022 10:45:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r11sm13589051pff.81.2022.01.29.10.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 10:45:28 -0800 (PST)
Message-ID: <61f58b48.1c69fb81.934ff.4777@mx.google.com>
Date:   Sat, 29 Jan 2022 10:45:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.95
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 180 runs, 2 regressions (v5.10.95)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 180 runs, 2 regressions (v5.10.95)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.95/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.95
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      77656fde3c0125d6ef6f7fb46af6d2739d7b7141 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/61f556ff41dd981439abbd11

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.95/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboard=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.95/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboard=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61f556ff41dd981=
439abbd18
        new failure (last pass: v5.10.93)
        4 lines

    2022-01-29T15:02:09.439296  kern  :alert : 8<--- cut here ---
    2022-01-29T15:02:09.439704  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 75682094
    2022-01-29T15:02:09.440253  kern  :alert : pgd =3D (ptrval)
    2022-01-29T15:02:09.440784  kern  :a<8>[   39.611454] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-01-29T15:02:09.441053  lert : [75682094] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f556ff41dd981=
439abbd19
        new failure (last pass: v5.10.93)
        20 lines

    2022-01-29T15:02:09.490714  kern  :emerg : Internal error: Oops: 5 [#1]=
 SMP ARM
    2022-01-29T15:02:09.491128  kern  :emerg : Process kworker/0:6 (pid: 14=
8, stack limit =3D 0x(ptrval))
    2022-01-29T15:02:09.491652  kern  :emerg : Stack: (0xc3ae5f<8>[   39.65=
7000] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D20>
    2022-01-29T15:02:09.491927  10 to 0xc3ae6000)
    2022-01-29T15:02:09.492184  kern  :emerg :<8>[   39.668597] <LAVA_SIGNA=
L_ENDRUN 0_dmesg 1469426_1.5.2.4.1>
    2022-01-29T15:02:09.492430   5f00:                                     =
c39c11a0 c374d780 ef796300 ef799500   =

 =20
