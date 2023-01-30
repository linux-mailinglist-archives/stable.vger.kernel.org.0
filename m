Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7AF680C24
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 12:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbjA3LnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 06:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjA3LnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 06:43:14 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC272B092
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 03:43:13 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o13so10838745pjg.2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 03:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=F2PXmgt9r9HKcy018nbk02H/dqc6O3So6EhrAhRt3TM=;
        b=qHszPBSjIN2liEmL99jVo5xiGCeXJnOnei02JD2nPCE36h4aIR1yQPnT1fASmXbPPj
         yfPVIvVDPdhYSDljIaCxswYRv0HyTpv0MDe61aR8YaipftzQgE+FS/q5LfzD3P2Q3uFc
         20qG8P6D4Ct8Z+X+cS3SJvLCzS5jkOwg7AL3PjWNgnoZGw0kwlTuXyAfLpSwc6BD+8mn
         OQ18VRDs/o5TI4Id++sbGkZbo1KDDtYZowuy35tOG/ug1RducyryydK/5UpCvZm2jqJm
         hHLLwSU01bL1IHFf9zuUuFtbklHgpe4pOKa2Lyn3yGRBJm1VtKR/hcqOXmB0PE6Hzi5l
         fEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F2PXmgt9r9HKcy018nbk02H/dqc6O3So6EhrAhRt3TM=;
        b=p1CNPXpQM4R4vGqASOgzpi6ZCu1EsjI6+S2TyxegTEjMMKps5NPFRmptMOc/rPG55Z
         s6bsPwZa7X7N3aVI0oCmqd9As62awKXr6QSFDprtGE7wTsjR99SI6aysT+zivj6xw9Tu
         EvksJuSikGNdHdVh3inquuL5ldkX3Nslmp676tBR6pBHA6qFmJZZ3wuif9sxTEphTk8x
         byRediLxVkttj7OLJv4u7tLbBFrY2bzcmmlMd6rSAXdYNxwqPzLvq7uL+BYPqaEULHWI
         MpXDUdY/OKReTO2uPxxn7NEIC5O3XBOIN3v+TS6e5wULD/aWYJRQf2irOJmsNK+i8iV7
         Hwcw==
X-Gm-Message-State: AO0yUKW7motr5xxSZSXfeMVZAZs2wUNTEVmECCWjHREFTqWL9d5NdAhn
        BaGRcAnLCJP7DbQCjas+PtQt+k8Vx03n/GiGV18=
X-Google-Smtp-Source: AK7set86JRKbnL75Z05ab5KaVJvw0WX5E6KzegZ6GSjlwXuimKeWHeV3FOJExh9AWnsOOMwj/MeW6g==
X-Received: by 2002:a17:902:cf4f:b0:196:844e:5f49 with SMTP id e15-20020a170902cf4f00b00196844e5f49mr2677698plg.65.1675078992262;
        Mon, 30 Jan 2023 03:43:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902820300b0019600b78487sm7595646pln.33.2023.01.30.03.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 03:43:11 -0800 (PST)
Message-ID: <63d7ad4f.170a0220.d43e7.c81e@mx.google.com>
Date:   Mon, 30 Jan 2023 03:43:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-197-ga5dcccb0d31c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 170 runs,
 4 regressions (v5.15.90-197-ga5dcccb0d31c)
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

stable-rc/queue/5.15 baseline: 170 runs, 4 regressions (v5.15.90-197-ga5dcc=
cb0d31c)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-197-ga5dcccb0d31c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-197-ga5dcccb0d31c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5dcccb0d31c2bcf6b6a2cf9e5a72364f3de1826 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d77add3e3fbe3363915f16

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
197-ga5dcccb0d31c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
197-ga5dcccb0d31c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d77add3e3fbe3363915f1b
        failing since 13 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T08:07:43.021881  <8>[    9.975855] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3243865_1.5.2.4.1>
    2023-01-30T08:07:43.128836  / # #
    2023-01-30T08:07:43.230514  export SHELL=3D/bin/sh
    2023-01-30T08:07:43.230886  #
    2023-01-30T08:07:43.332088  / # export SHELL=3D/bin/sh. /lava-3243865/e=
nvironment
    2023-01-30T08:07:43.332524  <3>[   10.194391] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-01-30T08:07:43.332699  =

    2023-01-30T08:07:43.433883  / # . /lava-3243865/environment/lava-324386=
5/bin/lava-test-runner /lava-3243865/1
    2023-01-30T08:07:43.434450  =

    2023-01-30T08:07:43.439771  / # /lava-3243865/bin/lava-test-runner /lav=
a-3243865/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d779e577d53a54dc915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
197-ga5dcccb0d31c/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
197-ga5dcccb0d31c/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d779e577d53a54dc915ec1
        failing since 2 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-01-30T08:03:26.206374  + set +x
    2023-01-30T08:03:26.206649  [    9.336394] <LAVA_SIGNAL_ENDRUN 0_dmesg =
891603_1.5.2.3.1>
    2023-01-30T08:03:26.314755  / # #
    2023-01-30T08:03:26.416510  export SHELL=3D/bin/sh
    2023-01-30T08:03:26.416994  #
    2023-01-30T08:03:26.518417  / # export SHELL=3D/bin/sh. /lava-891603/en=
vironment
    2023-01-30T08:03:26.518764  =

    2023-01-30T08:03:26.620005  / # . /lava-891603/environment/lava-891603/=
bin/lava-test-runner /lava-891603/1
    2023-01-30T08:03:26.620541  =

    2023-01-30T08:03:26.623564  / # /lava-891603/bin/lava-test-runner /lava=
-891603/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d784e524c55dcd73915f1b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
197-ga5dcccb0d31c/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
197-ga5dcccb0d31c/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d784e524c55dcd73915f20
        failing since 12 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T08:50:06.688487  + set +x
    2023-01-30T08:50:06.692357  <8>[   16.113845] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3243938_1.5.2.4.1>
    2023-01-30T08:50:06.815161  / # #
    2023-01-30T08:50:06.921230  export SHELL=3D/bin/sh
    2023-01-30T08:50:06.923413  #
    2023-01-30T08:50:07.027482  / # export SHELL=3D/bin/sh. /lava-3243938/e=
nvironment
    2023-01-30T08:50:07.029109  =

    2023-01-30T08:50:07.133154  / # . /lava-3243938/environment/lava-324393=
8/bin/lava-test-runner /lava-3243938/1
    2023-01-30T08:50:07.136229  =

    2023-01-30T08:50:07.138324  / # /lava-3243938/bin/lava-test-runner /lav=
a-3243938/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d77a66ad53c5da5d915efa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
197-ga5dcccb0d31c/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
197-ga5dcccb0d31c/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d77a66ad53c5da5d915eff
        failing since 12 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T08:05:44.782563  + set +x
    2023-01-30T08:05:44.786628  <8>[   16.030891] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 210211_1.5.2.4.1>
    2023-01-30T08:05:44.897781  / # #
    2023-01-30T08:05:45.000014  export SHELL=3D/bin/sh
    2023-01-30T08:05:45.000571  #
    2023-01-30T08:05:45.102053  / # export SHELL=3D/bin/sh. /lava-210211/en=
vironment
    2023-01-30T08:05:45.102659  =

    2023-01-30T08:05:45.204280  / # . /lava-210211/environment/lava-210211/=
bin/lava-test-runner /lava-210211/1
    2023-01-30T08:05:45.205278  =

    2023-01-30T08:05:45.209265  / # /lava-210211/bin/lava-test-runner /lava=
-210211/1 =

    ... (12 line(s) more)  =

 =20
