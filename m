Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C0B692920
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 22:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbjBJVSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 16:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbjBJVSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 16:18:10 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CFA81CC5
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 13:17:52 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id w5so7807931plg.8
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 13:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=k9MKQU8Zx1XG5JO5bAh49nt15S4F1reoSUzltxK7o+Y=;
        b=teRQIfitE+pN2kKz/tSZAdn+e5hKtehdPPl+jGKjQ1cZHQ1B/sK8b1Jfko/2t5qXOf
         XDSnY9lGKpOYFpc/7OtPU/VdsBiQpPzMNXbmNrKkFXHHu9qR5I7prU6KNp9O5oQSJ34N
         TtABhLmNIcmFZhTMwpTHABdy/kX/hvT/Wjn1gN7uR+H6UEcquaEaUQcd1p424LyvOLqj
         XWv+yheGmsDatnxvBce1ijUok/Ogikn87V5EeZ5EIbLZL4qxV3c7MK4h/+JnNmOMmGia
         Ql33tnbtqTlFawIG/OHme/OyTU15tRXTfKaTgcIJHmlPG6XuCCt2f/fHsTHKOpKmL9eV
         7NmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k9MKQU8Zx1XG5JO5bAh49nt15S4F1reoSUzltxK7o+Y=;
        b=G7EloSFdOjJIcXm06SrX3/D0rjPnvn9d+aZnSmPljezelddqAR55qRj/htxwb48d+u
         gV+fUg9T3dIu5igbYhm9yl8KrN+YdV8VaJ4CPdafbzsat9CmKArCVpNP9v/aWzhhXmAA
         LOJqxR3MWApVtDjv2Z0B1ipqKd53X2DzCDaON84CxrdFspKmlMA9Rii8qeqzghbLWHtp
         JfqdNrDjzlslvxAIrOIem4mdvirPAcFWpCAVUxQh/iN7tEQzw2yd+wC9888YOAjj2nuB
         0uPUG2q30jFNt39+hTV0m80yD7r1Y8sxt0nzGVf2OMFOy1vdhno4l2HI67/11Ret28O1
         eKdg==
X-Gm-Message-State: AO0yUKW21pDRMWtqAyz4QtAMZKhKXVVPQlZH8mN15NM6s7wmvPg3bm4O
        Xm3kUAsKJXbzNyJLa9mHDyzbuYEISm3Im4CkInE=
X-Google-Smtp-Source: AK7set/mttsVFgNWAN/oDNBqzeXXXhLsFYgsMmGbL7OOSs71OxDnY2UEdmvqUx1qev2n7XCv8jQU7Q==
X-Received: by 2002:a17:902:d491:b0:196:1a56:b1d3 with SMTP id c17-20020a170902d49100b001961a56b1d3mr19669699plg.11.1676063871884;
        Fri, 10 Feb 2023 13:17:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902c15100b0019a70a85e8fsm1901849plj.220.2023.02.10.13.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 13:17:51 -0800 (PST)
Message-ID: <63e6b47f.170a0220.c6b3a.44e9@mx.google.com>
Date:   Fri, 10 Feb 2023 13:17:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.93-7-g227cbcf07786d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 155 runs,
 2 regressions (v5.15.93-7-g227cbcf07786d)
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

stable-rc/queue/5.15 baseline: 155 runs, 2 regressions (v5.15.93-7-g227cbcf=
07786d)

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
nel/v5.15.93-7-g227cbcf07786d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.93-7-g227cbcf07786d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      227cbcf07786d13fe16fe2b44732594bec0b4f3b =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
cubietruck | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63e68118706e19a9458c8650

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
7-g227cbcf07786d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
7-g227cbcf07786d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e68118706e19a9458c8659
        failing since 24 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-10T17:38:14.901835  <8>[   10.072646] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3322701_1.5.2.4.1>
    2023-02-10T17:38:15.012192  / # #
    2023-02-10T17:38:15.115943  export SHELL=3D/bin/sh
    2023-02-10T17:38:15.116874  #<3>[   10.193982] Bluetooth: hci0: command=
 0x0c03 tx timeout
    2023-02-10T17:38:15.117475  =

    2023-02-10T17:38:15.219607  / # export SHELL=3D/bin/sh. /lava-3322701/e=
nvironment
    2023-02-10T17:38:15.220535  =

    2023-02-10T17:38:15.324052  / # . /lava-3322701/environment/lava-332270=
1/bin/lava-test-runner /lava-3322701/1
    2023-02-10T17:38:15.325937  =

    2023-02-10T17:38:15.331844  / # /lava-3322701/bin/lava-test-runner /lav=
a-3322701/1 =

    ... (12 line(s) more)  =

 =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
imx53-qsrb | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63e680f962e22d0e6c8c867f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
7-g227cbcf07786d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
7-g227cbcf07786d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e680f962e22d0e6c8c8688
        failing since 14 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-02-10T17:37:37.634127  + set +x
    2023-02-10T17:37:37.634424  [    9.369129] <LAVA_SIGNAL_ENDRUN 0_dmesg =
903226_1.5.2.3.1>
    2023-02-10T17:37:37.742477  / # #
    2023-02-10T17:37:37.858307  export SHELL=3D/bin/sh
    2023-02-10T17:37:37.859060  #
    2023-02-10T17:37:37.960430  / # export SHELL=3D/bin/sh. /lava-903226/en=
vironment
    2023-02-10T17:37:37.961240  =

    2023-02-10T17:37:38.062681  / # . /lava-903226/environment/lava-903226/=
bin/lava-test-runner /lava-903226/1
    2023-02-10T17:37:38.063468  =

    2023-02-10T17:37:38.065769  / # /lava-903226/bin/lava-test-runner /lava=
-903226/1 =

    ... (12 line(s) more)  =

 =20
