Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4967868BDCD
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 14:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjBFNSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 08:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjBFNSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 08:18:10 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B24241C3
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 05:17:30 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id r8so12070573pls.2
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 05:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vteicLIHiUII49NXjMKL0jgm+8sPmE4d2iaznnOIkPM=;
        b=AhV7LPM9I8VRXYJ8NYKIoGAsjIyIX3itPWekTQTCgQANKh5S+g3akKraP59w0Doqz6
         vt5eWbyWtHoOIUczmcq+nBjAJ2xZKfEnbD63UXuDp5GlKNe9IQKN0VxglLY5Ont+ybAJ
         i6iCwu9azFMtULAJVW14TfucBEj3CTIHi7SHw/6+SbZo3qjBxcp/kzoc/l7vOoC0NJbY
         Xh9RgSPaYFW2nq7DNG0rpdR/s3aq5P7oL56R5ZvnSqBLmkVpqEChHzqLiBFfmayXNpXy
         uikxcXx18tjEOePEtJoi/pZoTngJXtKks7ZGJFo5EsGEdS2/lvvGCduhNtKZocAhHEKx
         K+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vteicLIHiUII49NXjMKL0jgm+8sPmE4d2iaznnOIkPM=;
        b=CfFDEWQBAhv8YNqQ2qnCuD70iKAo0VHVd3rstgk1HX5KCcBYPvBxOLZnaMK4JinmXm
         tLo4+zKM0oMB7iOimZ/9kfQ7XkUgv9Mk84QUEFpUzQMwPYoVfWOGRA+6FaDiJbZkjhpa
         yZ+MfScHTzBMlVxLeG5K9xvWCXd8XlXJsahb0qMfTz5feeWpvHOfY+9J0wuzfK4q6Nhv
         k66ZfPTHZdCje+eesrAaIg4QM9cMZgOv+d3pU3fhnQj0j5LHDOe0WB7Pcd3jObLsq2Hg
         CIMXMHFRxhfT9l3rTraG1W8ltJ0d1AKXQqR/HHdwRXzFmav7zYI3CyOD/AxN3evB3FBc
         w39w==
X-Gm-Message-State: AO0yUKUV0MGWkCxOZghC59DX2ljip3TtvNltWSVDG282VBidd3E8xLhL
        dptRTXeqUqfg5BIq5A4mZ9LJ9/L4p5SyKGswXrU=
X-Google-Smtp-Source: AK7set+hn9oUyCHuhuGEX9pGLjqOlia0lUAjLpoYCN3LlfwzGBMeAlkLZpmyucdjPO0tvO2cvm9ynQ==
X-Received: by 2002:a17:90b:3ec3:b0:230:d1dc:72d2 with SMTP id rm3-20020a17090b3ec300b00230d1dc72d2mr1419177pjb.38.1675689450113;
        Mon, 06 Feb 2023 05:17:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t8-20020a63b708000000b004f1e87530cesm6023922pgf.91.2023.02.06.05.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 05:17:29 -0800 (PST)
Message-ID: <63e0fde9.630a0220.ead38.9517@mx.google.com>
Date:   Mon, 06 Feb 2023 05:17:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.166-9-gd4e703ee981a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 159 runs,
 2 regressions (v5.10.166-9-gd4e703ee981a)
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

stable-rc/queue/5.10 baseline: 159 runs, 2 regressions (v5.10.166-9-gd4e703=
ee981a)

Regressions Summary
-------------------

platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =

sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.166-9-gd4e703ee981a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.166-9-gd4e703ee981a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4e703ee981a021d95b6c8915a1bcd3ca249e05f =



Test Regressions
---------------- =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0ca452bfcb32772915ec0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gd4e703ee981a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gd4e703ee981a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0ca452bfcb32772915ec5
        failing since 10 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-02-06T09:36:53.636753  <8>[   10.982049] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3294900_1.5.2.4.1>
    2023-02-06T09:36:53.744050  / # #
    2023-02-06T09:36:53.845739  export SHELL=3D/bin/sh
    2023-02-06T09:36:53.846106  #
    2023-02-06T09:36:53.947293  / # export SHELL=3D/bin/sh. /lava-3294900/e=
nvironment
    2023-02-06T09:36:53.947668  =

    2023-02-06T09:36:53.947835  / # . /lava-3294900/environment<3>[   11.29=
2064] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-02-06T09:36:54.049018  /lava-3294900/bin/lava-test-runner /lava-32=
94900/1
    2023-02-06T09:36:54.049579  =

    2023-02-06T09:36:54.054314  / # /lava-3294900/bin/lava-test-runner /lav=
a-3294900/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0ca3b0569b2c230915ee2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gd4e703ee981a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gd4e703ee981a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0ca3b0569b2c230915ee7
        failing since 4 days (last pass: v5.10.165-139-gefb57ce0f880, first=
 fail: v5.10.165-149-ge30e8271d674)

    2023-02-06T09:36:32.153146  <8>[    7.403865] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3294894_1.5.2.4.1>
    2023-02-06T09:36:32.259800  / # #
    2023-02-06T09:36:32.361841  export SHELL=3D/bin/sh
    2023-02-06T09:36:32.362382  #
    2023-02-06T09:36:32.463653  / # export SHELL=3D/bin/sh. /lava-3294894/e=
nvironment
    2023-02-06T09:36:32.464215  =

    2023-02-06T09:36:32.565677  / # . /lava-3294894/environment/lava-329489=
4/bin/lava-test-runner /lava-3294894/1
    2023-02-06T09:36:32.566481  =

    2023-02-06T09:36:32.571206  / # /lava-3294894/bin/lava-test-runner /lav=
a-3294894/1
    2023-02-06T09:36:32.676181  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
