Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158EA6923DF
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 18:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbjBJRAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 12:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbjBJRAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 12:00:38 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B779D1A664
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:00:32 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o13so5796893pjg.2
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8Zsrz4KpSDXIgEY5gfWsB/IaJRXsUvZr88rFPN5LtbQ=;
        b=wVE/ioHJwLvLt73STid3TfoEoaWGdAyEo7uPfgLOZu+MEOdDs7D2UKdpD1mQIkOLCh
         xRJ3fyhHd3ZQOomyx2vsSmOjY0PMPhXKrhdC3SeEQ9XYd8MtyqkY82gKLNcx7p9+4Sja
         atvrf4lwX/RCbdcXra2CLXyW8rldeLaR4KiLvUlddC+c5mqEzKi+MqUiXqDJRJw97hqL
         VT0RwvCcgKIKCDhPl3+FLk2kGNTA66l9GzAuEKn2JKbxQQ944ce4DRdz4lJwhdvpDtKe
         Z2j7XTL/0xBNHU4dq4YJKx8z3FV9DozMOrfaL0OD74/BpCSfcRoqN+ECilGLgfW/KNYy
         vx0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Zsrz4KpSDXIgEY5gfWsB/IaJRXsUvZr88rFPN5LtbQ=;
        b=lf3e7bH9riJ/t+91AVSWYzQ6NE3wa3xHRwfsPViSrDF7tvTzPFxgW2g2cK4wR/1pPX
         H/XONIGVgYrn+Dm2P9+0UQ3O95MMO8vz/E9Jz5rX3nHyFj2REG8Vh8DDwuqdsxdBRGsG
         WaDgz9/CbfccvQnp0ONUFNhssWZhmckF7tfDyTykYhL9djvoY3nuhSFuHFZjaJjr9V+k
         s+ztFZub9Wsei+B1CKnAiPMysMY30uPykmIMwMFHD0oR1ItZBffJBrauzguq6+3ZUaOY
         lWX5m/vKblG856DrARyOhkzkIHi4Luc/eoSNh4Ouyyx3XWncOk/ttDG5F/CerXuwyIep
         JnKQ==
X-Gm-Message-State: AO0yUKUYH2ZvU5saBCCrvYMCGLX5ODgv2jcoQUCn3Shv+kIRLmfJ0UWl
        vdTP48SxQRzcRM85aR/fpprZpppZcItYBAgQQAI=
X-Google-Smtp-Source: AK7set9F/8NTAlnVXn/GPtKbyFxhS7/BFWYEbgwXimEJUH3zpG1vmW5DVB5DATLvgmv/ofXTbd6o7g==
X-Received: by 2002:a17:90a:31a:b0:230:efe:69c3 with SMTP id 26-20020a17090a031a00b002300efe69c3mr17730048pje.25.1676048432052;
        Fri, 10 Feb 2023 09:00:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4-20020a17090a348400b00233aacab89esm1529504pjb.48.2023.02.10.09.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 09:00:31 -0800 (PST)
Message-ID: <63e6782f.170a0220.e2ff5.2e4f@mx.google.com>
Date:   Fri, 10 Feb 2023 09:00:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.93-5-g4237544554f5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 153 runs,
 2 regressions (v5.15.93-5-g4237544554f5)
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

stable-rc/queue/5.15 baseline: 153 runs, 2 regressions (v5.15.93-5-g4237544=
554f5)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
cubietruck | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | 1    =
      =

imx53-qsrb | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.93-5-g4237544554f5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.93-5-g4237544554f5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4237544554f5793ae0253cb9931984fa711a68be =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
cubietruck | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63e647da820684c8358c8661

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
5-g4237544554f5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
5-g4237544554f5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e647da820684c8358c866a
        failing since 24 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-10T13:34:09.590227  + set +x<8>[   10.018276] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3321664_1.5.2.4.1>
    2023-02-10T13:34:09.590454  =

    2023-02-10T13:34:09.696626  / # #
    2023-02-10T13:34:09.798245  export SHELL=3D/bin/sh
    2023-02-10T13:34:09.798751  #
    2023-02-10T13:34:09.900079  / # export SHELL=3D/bin/sh. /lava-3321664/e=
nvironment
    2023-02-10T13:34:09.900697  =

    2023-02-10T13:34:10.001763  / # . /lava-3321664/environment/lava-332166=
4/bin/lava-test-runner /lava-3321664/1
    2023-02-10T13:34:10.002576  =

    2023-02-10T13:34:10.002778  / # <3>[   10.353796] Bluetooth: hci0: comm=
and 0xfc18 tx timeout =

    ... (13 line(s) more)  =

 =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
imx53-qsrb | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63e645e897c3f374288c8679

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
5-g4237544554f5/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx5=
3-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
5-g4237544554f5/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx5=
3-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e645e897c3f374288c8682
        failing since 14 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-02-10T13:25:35.030875  [    9.372478] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-02-10T13:25:35.038469  + set +x
    2023-02-10T13:25:35.038701  [    9.383261] <LAVA_SIGNAL_ENDRUN 0_dmesg =
903060_1.5.2.3.1>
    2023-02-10T13:25:35.146305  / # #
    2023-02-10T13:25:35.249343  export SHELL=3D/bin/sh
    2023-02-10T13:25:35.250327  #
    2023-02-10T13:25:35.352098  / # export SHELL=3D/bin/sh. /lava-903060/en=
vironment
    2023-02-10T13:25:35.352791  =

    2023-02-10T13:25:35.458702  / # . /lava-903060/environment/lava-903060/=
bin/lava-test-runner /lava-903060/1
    2023-02-10T13:25:35.461043   =

    ... (12 line(s) more)  =

 =20
