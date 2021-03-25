Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9491134926A
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYMvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhCYMvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 08:51:41 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BBDC06174A
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 05:51:41 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y200so1960986pfb.5
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 05:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IaJ8FvXrduhIkVruCKL0jV0BiG8CsZQQhmfkZcpRRTM=;
        b=ymWSncSbO2yW1bh3WhFhtdfdG/o7HxxYJAHeopoROxILgXdOJpgzmU/NHWZ0z+7Fp1
         Iz0mz4UPel/GZutosMiPJcTg/rvCfnoVFnei2kvnmdkxQ56J53hnDLW+wIVXlUgNyV3t
         nyGuRym+fEgQ2fSzYR1w70fIRvXf10kAzn79L8eqkqPfA4LX57HW9S34Fg92DKD64/cc
         uMcMENxh6yCS85rmJWN4cXrDzXBakvy/BhL2q4T+sgsipA/KElaO9l402tWUptVSnKta
         OnkLZ8sqcuTh8IGJfghTHBYw4OCmHD4YK+RsHZd981m7m3nkWuduCBmHTTqFx13j7lxI
         B0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IaJ8FvXrduhIkVruCKL0jV0BiG8CsZQQhmfkZcpRRTM=;
        b=NGcwkO9Su68AYZMbhg3sf6Z6U6foN7N2rkgw3byIUjvxDfcXRPmxMWoLp/WLbQ75x7
         iJCDvd02Mrq6d7JJ3g3g7yC+r7tqU/fNDamQ8wlWHrHaopq1Yakh/XhirafV7EFfWXzH
         Hjt3zucsWppYJOiXNNZDNWLje69a3N5+tbTWXe99DpC/ya8i2HXYSZnPSiRl/gVDN3+I
         2XHynVITdgNdDmhD4H0y587ebkkS75Y48wnI1snUzN3+cRnrR/1U2lzp6BWx5yi7kT7O
         /VQJ9/lQW/4TmUbDyZoFxqkhoOY5Ys8vgb0M80E50/59dP6khwjFyZ8mXXw9zPE5Fz/8
         UQdw==
X-Gm-Message-State: AOAM530TQ5ECP7ieoTvy3bnUw8QvXX7/Gk/x5vm1/Ten1HuAxNhkhRST
        394LGJcd2tKrvXDAM/TRoldubcoXgpAdCQ==
X-Google-Smtp-Source: ABdhPJzP3xClPG/unycNqFxkhJoIRMYOF86f+lolLU7JX1O2xTvbZrN/sWnOoyjD2LcOHG9jDs820g==
X-Received: by 2002:aa7:9e5b:0:b029:1f1:5ba4:57a2 with SMTP id z27-20020aa79e5b0000b02901f15ba457a2mr7970753pfq.59.1616676700383;
        Thu, 25 Mar 2021 05:51:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k27sm5597399pfg.95.2021.03.25.05.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:51:39 -0700 (PDT)
Message-ID: <605c875b.1c69fb81.6f3fc.dec5@mx.google.com>
Date:   Thu, 25 Mar 2021 05:51:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.26
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 151 runs, 6 regressions (v5.10.26)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 151 runs, 6 regressions (v5.10.26)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig  | 2          =

imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =

meson-gxbb-p200          | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.26/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      856cd02bbdd412bf91ce327a3c97c52066f11c79 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig  | 2          =


  Details:     https://kernelci.org/test/plan/id/605c54ade6adfb8006af02b9

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.26/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.26/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/605c54ade6adfb8=
006af02bf
        new failure (last pass: v5.10.25)
        4 lines

    2021-03-25 09:15:09.457000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address a065978c
    2021-03-25 09:15:09.459000+00:00  ke<8>[   42.517067] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/605c54ade6adfb8=
006af02c0
        new failure (last pass: v5.10.25)
        54 lines

    2021-03-25 09:15:09.464000+00:00  kern  :alert : [a065978c] *pgd=3D0000=
0000
    2021-03-25 09:15:09.509000+00:00  kern  :emerg : Internal error: Oops: =
5 [#1] ARM
    2021-03-25 09:15:09.510000+00:00  kern  :emerg : Process udevd (pid: 97=
, stack limit =3D 0xea52d383)
    2021-03-25 09:15:09.512000+00:00  kern  :emerg : Stack: (0xc417bca0 to =
0xc417c000)
    2021-03-25 09:15:09.513000+00:00  kern  :emerg : bca0: c417bcd4 c417bcb=
0 c03edf04 c017fb24 c417bd9c c0903afc 00000000 c0e04248
    2021-03-25 09:15:09.514000+00:00  kern  :emerg : bcc0: c417bdf0 c417bd9=
c c417bcfc c417bcd8 c017fc84 c03edec8 c017fb18 c0120728
    2021-03-25 09:15:09.515000+00:00  kern  :emerg : bce0: 00000000 c0903af=
c c417bdf4 c0e04248 c417bd94 c417bd00 c0181150 c017fc44
    2021-03-25 09:15:09.552000+00:00  kern  :emerg : bd00: 00000001 c0f3663=
4 c0e0fac0 c062052c 00000000 c0e0f658 00000000 bf01910c
    2021-03-25 09:15:09.553000+00:00  kern  :emerg : bd20: c417bd54 c417bd3=
0 c01464fc c0620538 00000000 c0620538 c33edfb0 c0e0f658
    2021-03-25 09:15:09.554000+00:00  kern  :emerg : bd40: c33edfb8 c0e0f68=
8 c417bd64 c417bd58 c0146748 c013a350 ffffffff 00000000 =

    ... (40 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/605c5596da2f062bedaf02da

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.26/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.26/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/605c5596da2f062=
bedaf02e0
        new failure (last pass: v5.10.21)
        4 lines

    2021-03-25 09:18:24.225000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-03-25 09:18:24.226000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-03-25 09:18:24.226000+00:00  kern  :alert : [<8>[   39.356503] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-03-25 09:18:24.226000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/605c5596da2f062=
bedaf02e1
        new failure (last pass: v5.10.21)
        26 lines

    2021-03-25 09:18:24.278000+00:00  kern  :emerg : Process kworker/3:2 (p=
id: 79, stack limit =3D 0x(ptrval))
    2021-03-25 09:18:24.278000+00:00  kern  :emerg : Stack: (0xc33ddeb0 to<=
8>[   39.402881] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-03-25 09:18:24.278000+00:00   0xc33de000)
    2021-03-25 09:18:24.279000+00:00  kern  :emerg : dea0<8>[   39.414383] =
<LAVA_SIGNAL_ENDRUN 0_dmesg 31520_1.5.2.4.1>
    2021-03-25 09:18:24.279000+00:00  :                                    =
 1e9b10fe bf8e0ec1 c237a480 cec60217   =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/605c570533eb69c2d5af02bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.26/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.26/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605c570533eb69c2d5af0=
2bc
        failing since 7 days (last pass: v5.10.22, first fail: v5.10.24) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxbb-p200          | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/605c561a751e66480baf02d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.26/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.26/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605c561a751e66480baf0=
2d3
        new failure (last pass: v5.10.21) =

 =20
