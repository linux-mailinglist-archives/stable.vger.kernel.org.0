Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3566913D1
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 23:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjBIW65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 17:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjBIW64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 17:58:56 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F82B59EB
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 14:58:55 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id x10so2595962pgx.3
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 14:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xv5uisFV9fzF7ArMmv7B2M5OjAx8Rx0gMCOnweW0l/0=;
        b=SQV+5SDLBCiFnBL27mNe3CzPjtArLi/oOrOVOD1OJAfZ7/fx/4JIp5p652LQqIKcq5
         N6d8+WErt82izVUSSbd8UMUqrbQORMtbjhGctovb7yycvmLm/TyFmQ71hPvkshXF83lg
         XQ2XMppSyvwMJAH7vM7PSU4iS2qucD1D2V0uM0g2U5HZRiuxehZuoyGeqSA1UE1lg9l/
         b5hnWkytdIO/WCq16TPgTLFpgs/o5keesj6MFPXPsbZDpQmVm6uso7JYRsL3Sk+O6M2Z
         tjF4f2c2wg8wYls0QqLE5G7JUZdSDjFAuQSZolkWHJjVwUckdhqG38rXjjIoO9j4sJH3
         Iwng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xv5uisFV9fzF7ArMmv7B2M5OjAx8Rx0gMCOnweW0l/0=;
        b=BEPe3LJ4nDYGgWjd5T4WV/XAXJE8L55xq3sqSJtaV/GlyvVMCp/rd4QWp3CygwfHJ0
         5VOujlRVIm8TqDIEEpnDInjMoZObulRpFWHXr5VWCgS6NiadM5QFkIm/OVlDO97hpUSS
         Dt4Zq31i7QXlEKajUBaOK1b2YePr+pff952Ozplri0//uDOGOmoWmOLNNzfWRiLQLW05
         78BKPLHqPXeMBz7mmkLGy2EGKTLqnIFM6SAJTbL/orW8dwfnId8Oue/0XVlgejrKgkGQ
         i0Ib2SghdvAj9OzXID0+yNijG42zmZjVXpFjfXyomXPcK+B43MbkGLQC12cTLk6lf3dP
         mAZw==
X-Gm-Message-State: AO0yUKVwUwnhJsMlK6H7o2yKhs4yw8eTYu2Z/S2up5f/+cixP6zHuHfj
        QO+13qhVXNBH0lmQK1t1BRZi0vQBO7KDZq5F+hAQ2A==
X-Google-Smtp-Source: AK7set9uxcxQ1IbUrs6DxeCEzQngTawh4022PjSCGQ/snPYwoLAy7Fo/BbHzdonTR+cweg7dtGlKBA==
X-Received: by 2002:aa7:9798:0:b0:5a8:58b5:bfa5 with SMTP id o24-20020aa79798000000b005a858b5bfa5mr3264771pfp.4.1675983534731;
        Thu, 09 Feb 2023 14:58:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9-20020a62b409000000b005a84e660713sm1946420pfn.195.2023.02.09.14.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:58:54 -0800 (PST)
Message-ID: <63e57aae.620a0220.3dffe.39fa@mx.google.com>
Date:   Thu, 09 Feb 2023 14:58:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.93-5-gca59c04d1ed61
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 154 runs,
 2 regressions (v5.15.93-5-gca59c04d1ed61)
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

stable-rc/queue/5.15 baseline: 154 runs, 2 regressions (v5.15.93-5-gca59c04=
d1ed61)

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
nel/v5.15.93-5-gca59c04d1ed61/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.93-5-gca59c04d1ed61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca59c04d1ed61926dc783c4a340226971bdf7d78 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
cubietruck | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63e548ad4012d8693a8c866b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
5-gca59c04d1ed61/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
5-gca59c04d1ed61/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e548ad4012d8693a8c8674
        failing since 23 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-09T19:25:19.767394  <8>[   10.081052] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3314143_1.5.2.4.1>
    2023-02-09T19:25:19.877735  / # #
    2023-02-09T19:25:19.982152  export SHELL=3D/bin/sh
    2023-02-09T19:25:19.983095  #
    2023-02-09T19:25:20.085395  / # export SHELL=3D/bin/sh. /lava-3314143/e=
nvironment
    2023-02-09T19:25:20.086525  =

    2023-02-09T19:25:20.188922  / # . /lava-3314143/environment/lava-331414=
3/bin/lava-test-runner /lava-3314143/1
    2023-02-09T19:25:20.190726  =

    2023-02-09T19:25:20.195577  / # /lava-3314143/bin/lava-test-runner /lav=
a-3314143/1
    2023-02-09T19:25:20.273598  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
imx53-qsrb | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63e54888e65eab546d8c8640

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
5-gca59c04d1ed61/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
5-gca59c04d1ed61/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e54888e65eab546d8c8649
        failing since 13 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-02-09T19:24:32.496470  + set +x
    2023-02-09T19:24:32.496660  [    9.379360] <LAVA_SIGNAL_ENDRUN 0_dmesg =
902168_1.5.2.3.1>
    2023-02-09T19:24:32.603862  / # #
    2023-02-09T19:24:32.705370  export SHELL=3D/bin/sh
    2023-02-09T19:24:32.706148  #
    2023-02-09T19:24:32.807645  / # export SHELL=3D/bin/sh. /lava-902168/en=
vironment
    2023-02-09T19:24:32.808788  =

    2023-02-09T19:24:32.910484  / # . /lava-902168/environment/lava-902168/=
bin/lava-test-runner /lava-902168/1
    2023-02-09T19:24:32.911229  =

    2023-02-09T19:24:32.913628  / # /lava-902168/bin/lava-test-runner /lava=
-902168/1 =

    ... (12 line(s) more)  =

 =20
