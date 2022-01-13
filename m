Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3F348DD04
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 18:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiAMRiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 12:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiAMRiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 12:38:20 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541ADC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 09:38:20 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id w204so509727pfc.7
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 09:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BfWUaQMcIXD8AgpfFOTrtjSZSKQ5DqqoLetGhsQuZPc=;
        b=WE8Px2am2J35AoLvsfcgTG0y32jSA1/PXHi+Y3Y9+CgnuTxh2iSE1xjBiSHIUlKRex
         omsG8Ifsix6hf9QU6kmo3zurBiGD0oq/N+dBsdUjVqE7D58anhqe88SlavEZD8Lst66j
         H7Ed2itCLwtIZaeSAeMzvDZom1iCSVarrrAn/TIZEHZchuP/u9ADzygGJcIpN5a4fL7q
         o0x5YVtAp4Ymb2ZdQivETlcKpfmbVOxSzVcWSc2I0Iu+20MFYt7rCTNIA1YlIkn+BB7j
         xstjOt6panc8lhNiNkicbOpBIUDNM6wo8orJypHhbAO4dZ2i83e9w18cxskDaXtkWqCa
         W4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BfWUaQMcIXD8AgpfFOTrtjSZSKQ5DqqoLetGhsQuZPc=;
        b=HRn7erLL9B2zld4Uwyfh4WPx9ZnWhDUuSstVICHg5ZC53ZHB9x8YOzIQeAc8Ohxr8r
         qZdhre86khNarIxZpmR3n8tRmLjIjKN/Qv7Qg6fwTqzD1dkPnqmO+KkPoDl09W1ugpQ4
         1o+iWSWhqhFD1hrzzB12CYrA770M0h7EV8bJ920yMgzWvUP07drhKnYWXBuMID09dxkv
         /B73FPc/Iwi2/4OLFCpbhW7QbKlLy/RRDHuMSlWcI6ZtxESMHQNPp/vRlc4sIg+/SWf8
         UitFGuYaK1RXvdWInmO0A6DAqKrotpW856Qfb9/+2XNMD9Px3mPKHEJKyTmrClCedik4
         Z52w==
X-Gm-Message-State: AOAM532ulQYLfOtsNRioKyQGbHihosvCDTWPJqEzrMYSViVn4TckvQCr
        C8Mp9oC74rU5/uCF+Z3/1uaEAorOPIbcjyQ8eeI=
X-Google-Smtp-Source: ABdhPJxl2RWKiR9P/sCBzyACIeHCjZMUQlnxnbEeoBZI+7Byk12ubzAiSa5oK0x+8nhb8sEpZ5SCnw==
X-Received: by 2002:aa7:9188:0:b0:4be:3d3a:c6d0 with SMTP id x8-20020aa79188000000b004be3d3ac6d0mr5178836pfa.4.1642095499583;
        Thu, 13 Jan 2022 09:38:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y64sm2688863pgy.12.2022.01.13.09.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 09:38:19 -0800 (PST)
Message-ID: <61e0638b.1c69fb81.9ec7d.6ecc@mx.google.com>
Date:   Thu, 13 Jan 2022 09:38:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297-3-gc9c02bd1d416
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 143 runs,
 3 regressions (v4.9.297-3-gc9c02bd1d416)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 143 runs, 3 regressions (v4.9.297-3-gc9c02bd1=
d416)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-10   | multi_v5_=
defconfig  | 1          =

meson-gxbb-p200            | arm64 | lab-baylibre    | gcc-10   | defconfig=
           | 1          =

panda                      | arm   | lab-collabora   | gcc-10   | omap2plus=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-3-gc9c02bd1d416/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-3-gc9c02bd1d416
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9c02bd1d416727391669192e9cb4a9b5b5b69e0 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-10   | multi_v5_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61e0308379db7329dfef6761

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-3=
-gc9c02bd1d416/arm/multi_v5_defconfig/gcc-10/lab-pengutronix/baseline-imx27=
-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-3=
-gc9c02bd1d416/arm/multi_v5_defconfig/gcc-10/lab-pengutronix/baseline-imx27=
-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e0308379db7329dfef6=
762
        new failure (last pass: v4.9.296-21-gd19aa36b7387) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxbb-p200            | arm64 | lab-baylibre    | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/61e030e70af05428c7ef674c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-3=
-gc9c02bd1d416/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-3=
-gc9c02bd1d416/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e030e70af05428c7ef6=
74d
        new failure (last pass: v4.9.296-21-gd19aa36b7387) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
panda                      | arm   | lab-collabora   | gcc-10   | omap2plus=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e02fd2f30ba2f17bef6749

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-3=
-gc9c02bd1d416/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-3=
-gc9c02bd1d416/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e02fd2f30ba2f=
17bef674c
        failing since 1 day (last pass: v4.9.296-21-ga5ed12cbefc0, first fa=
il: v4.9.296-21-gd19aa36b7387)
        2 lines

    2022-01-13T13:57:18.356842  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2022-01-13T13:57:18.366092  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-13T13:57:18.379949  [   20.755462] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
