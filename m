Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E61131DE21
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 18:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhBQR0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 12:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbhBQR0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 12:26:41 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F81C061574
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 09:26:01 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z6so8860568pfq.0
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 09:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xo6qq14Tz2p5PunGL4ttPI07GCCxMKZN2mi9aO3EZcE=;
        b=MesLQUgTKuOB/kaQvS0LXqsKzS6W/oHLjzGyu3TlFLAn6B3PNRsJIWJbY9cVW9F93B
         60aj06W263s08ffzjtVV+OD3gVBcq/QhzAr5WAkgWGrGp2VHlX2D37LnKopbN9lzBoeQ
         BLBosva6XvkXlbawWNwWwAJFxuaAXwF6GcQ4H9CYkFSsOv5QPg12lKW2wr8E6NRhIYDI
         Wq3W2iorw3323lhmKdw3joOx3+B4fPJmDO34IgEJgp6CVJSEHgCSpSidtnw1kDd0i/uB
         eqlTHktIm5d/q+GSdTnhj2fm10P0G+OH5krxv5YobAMNkcbIezuHtgHNQUchaPqPl5Yk
         +ofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xo6qq14Tz2p5PunGL4ttPI07GCCxMKZN2mi9aO3EZcE=;
        b=MHA94Ct8J7EUEQOFd+1yM9rwsVAIoplDpGWHiEPsBbuduqbw/RAC+jZ6daInLZWjAT
         apRO1u5MWr3FD6RdPmD96tXA6BNuJm9NEOGO0aXSWpifaug1ZZAYb+mnb+uVGU7a5h+h
         Gz7hCS2eE04mDM+wrU8nlsmpatw0liEaFktWLyare7SWxDlp7osgldYVG9oBDamgLP+P
         96xJ6yxaLnx//rrnKKaTAjaIq0tBWfG2Y9KrDIsNsIUue/Ul4ZSfkv5D9vnQuXJRjwSV
         5qDGRwHY3+iUjb+nOS7Emvsxdx8ArpBgRWztjR024y2IgM72Z/l4IdJLHX2fnZVi6cRm
         3dow==
X-Gm-Message-State: AOAM531mbedxYKvm3scR+i1DkSjXiLQDXL1gwvpvoQfCnEAaHKv02J8B
        kb7VVhYKZGnidkZopB9qc9AH0uOKn/iDbA==
X-Google-Smtp-Source: ABdhPJwVhLG6RStQyXLuoHrdkj90JvWitfgNV4Lc+MtgGhXvP6V0c+F0xljoPwqZn4xpyjz0Gm1nng==
X-Received: by 2002:a05:6a00:851:b029:1b3:fbb3:faed with SMTP id q17-20020a056a000851b02901b3fbb3faedmr407562pfk.18.1613582760814;
        Wed, 17 Feb 2021 09:26:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w1sm2758925pjq.38.2021.02.17.09.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 09:26:00 -0800 (PST)
Message-ID: <602d51a8.1c69fb81.702ab.6209@mx.google.com>
Date:   Wed, 17 Feb 2021 09:26:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.17
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 111 runs, 5 regressions (v5.10.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 111 runs, 5 regressions (v5.10.17)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.17/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      13b6016e96f628ac1cfb3c0b342911fd91c9c005 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602d1a9c6517480a64addcc1

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.17/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.17/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/602d1a9c6517480a=
64addcc4
        new failure (last pass: v5.10.16)
        1 lines

    2021-02-17 13:29:02.610000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-17 13:29:02.610000+00:00  (user:khilman) is already connected
    2021-02-17 13:29:18.157000+00:00  =00
    2021-02-17 13:29:18.178000+00:00  =

    2021-02-17 13:29:18.179000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-17 13:29:18.179000+00:00  =

    2021-02-17 13:29:18.179000+00:00  DRAM:  948 MiB
    2021-02-17 13:29:18.194000+00:00  RPI 3 Model B (0xa02082)
    2021-02-17 13:29:18.282000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-17 13:29:18.314000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (386 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602d23d6c5e4846b70addcb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.17/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.17/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602d23d6c5e4846b70add=
cb8
        new failure (last pass: v5.10.16) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602d1b72a2ef0dccaeaddcd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.17/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.17/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602d1b72a2ef0dccaeadd=
cd5
        new failure (last pass: v5.10.16) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 2          =


  Details:     https://kernelci.org/test/plan/id/602d1a7735f9dba469addcb3

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.17/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.17/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/602d1a7735f9dba=
469addcb7
        new failure (last pass: v5.10.16)
        10 lines =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602d1a7735f9dba=
469addcb8
        new failure (last pass: v5.10.16)
        2 lines

    2021-02-17 13:30:11.907000+00:00  kern  :alert :   CM =3D 0, WnR =3D 0
    2021-02-17 13:30:11.907000+00:00  kern  :alert : [ffdf0000444bd2c8] add=
ress between user and kernel address ranges
    2021-02-17 13:30:11.907000+00:00  kern  :emerg : Internal error: Oops: =
96000004 [#1] PREEMPT SMP
    2021-02-17 13:30:11.907000+00:00  kern  :emerg : Code: f9005bff b940300=
1 f9401003 a9038fe2 (f94044c0) =

    2021-02-17 13:30:11.907000+00:00  <8>[   16.702003] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-02-17 13:30:11.907000+00:00  + set +x
    2021-02-17 13:30:11.908000+00:00  <8>[   16.706447] <LAVA_SIGNAL_ENDRUN=
 0_dmesg 734086_1.5.2.4.1>   =

 =20
