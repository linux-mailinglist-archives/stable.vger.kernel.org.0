Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9304C6CA75E
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 16:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbjC0OTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 10:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjC0OTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 10:19:23 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1DA7A94
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 07:17:34 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id le6so8549142plb.12
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 07:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679926654;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=E9oajVBf+GK/XyNOJL2PYQyJq6PxnRlkcwhy6rjUUAY=;
        b=Kjc8bOJbaSPBeSXpGK4aU5KgZhP6yHn68qs4Qx2KZP6jpUDdGgXm2ynyjCki2cw0t0
         bYQFSc7DyUpGBSDfJVsNQ3A5lbCmVoTGq84ex9fnKQB8I3uilnJosJFPB/IXKNHPcJgX
         nVH2zGte3uW97SWvzaRpTv+xGjPO6oyzR8drE0jMj4XmLQ4x9Bd5ivUl5mbMabTHXzcL
         VAKROyibWWrMlUyftHTpxfPeauGil52WksoNDuvfDZecjhIVxdNyus5I7J5hquslgrhc
         JobkBDzbRulF/qyBnjiMUaqjlWDN5gY9t3Um0Wxy45QaztAab20is2ZOmTZ96NSm/t7W
         NqEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926654;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E9oajVBf+GK/XyNOJL2PYQyJq6PxnRlkcwhy6rjUUAY=;
        b=7cXd0ghOQ4RplgszW2cavzmrLrVEGVk9zoC+K/Gh3JvnSWWZcnyyM+oNCfkiumaizl
         K0W7YWJ6bmHogKnZ9v7lPspuTGe1gRKccGFnD7Hvni2MfGbX1IS43+M3/rUx+GIP/qUX
         WPKByXEiZZSfp9vT+dbSWwRlj/Tqs7tAkVVj+8lvud0HrIN8uakLLv1JZqt2KK6T95dQ
         YQC6YKzTLeCAcD74nAAeST/gnibihx2Tyc58tIi12sFBHmSLDRouUES+w5bxwx5xufHj
         O6J0cqqhtNrMEZLv4+Cy6cyX1noiQ2ntvEkQpeMClzgRvOFksvks8XgUzLsoVoGv7zAH
         NB/g==
X-Gm-Message-State: AAQBX9czm9NUBOTYaiUdX4E0vG6AWkt0moa0lgj6GXGT44/8jlYcghQT
        yX83ujJEidNtJIdaCOmHkh3a4RFExF4trEySQV7QEg==
X-Google-Smtp-Source: AKy350Zr7lUN8XeWtWEzXwFQxGnLShBQ6CM9mwhrLinyFMVag/y8tN3yXIhq9SGwRfAogGq3R0JB7g==
X-Received: by 2002:a17:90b:4f42:b0:237:29b1:1893 with SMTP id pj2-20020a17090b4f4200b0023729b11893mr12085509pjb.46.1679926653731;
        Mon, 27 Mar 2023 07:17:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15-20020a17090a740f00b0023d28185e35sm7627291pjg.32.2023.03.27.07.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:17:33 -0700 (PDT)
Message-ID: <6421a57d.170a0220.7b321.d648@mx.google.com>
Date:   Mon, 27 Mar 2023 07:17:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.279-25-gc95d797f10041
Subject: stable-rc/queue/4.19 baseline: 111 runs,
 3 regressions (v4.19.279-25-gc95d797f10041)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 111 runs, 3 regressions (v4.19.279-25-gc95d7=
97f10041)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
at91sam9g20ek    | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1=
          =

beaglebone-black | arm  | lab-broonie  | gcc-10   | omap2plus_defconfig | 1=
          =

cubietruck       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.279-25-gc95d797f10041/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.279-25-gc95d797f10041
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c95d797f1004155cf37c23dd5a8f5d0b455d3157 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
at91sam9g20ek    | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/64216aeba7ef50384f9c9516

  Results:     42 PASS, 9 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-25-gc95d797f10041/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-25-gc95d797f10041/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64216aeca7ef50384f9c954a
        new failure (last pass: v4.19.279-25-g8270940878fa3)

    2023-03-27T10:06:59.102759  + set +x
    2023-03-27T10:06:59.107961  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 234663_1.5.2=
.4.1>
    2023-03-27T10:06:59.221305  / # #
    2023-03-27T10:06:59.324204  export SHELL=3D/bin/sh
    2023-03-27T10:06:59.324979  #
    2023-03-27T10:06:59.426953  / # export SHELL=3D/bin/sh. /lava-234663/en=
vironment
    2023-03-27T10:06:59.427722  =

    2023-03-27T10:06:59.529717  / # . /lava-234663/environment/lava-234663/=
bin/lava-test-runner /lava-234663/1
    2023-03-27T10:06:59.531096  =

    2023-03-27T10:06:59.537521  / # /lava-234663/bin/lava-test-runner /lava=
-234663/1 =

    ... (12 line(s) more)  =

 =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beaglebone-black | arm  | lab-broonie  | gcc-10   | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/64216f0b64e40e60d99c9527

  Results:     41 PASS, 10 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-25-gc95d797f10041/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-25-gc95d797f10041/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64216f0b64e40e60d99c955c
        new failure (last pass: v4.19.279-25-g8270940878fa3)

    2023-03-27T10:24:50.741042  + set +x<8>[   18.666008] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 234740_1.5.2.4.1>
    2023-03-27T10:24:50.741362  =

    2023-03-27T10:24:50.850850  / # #
    2023-03-27T10:24:50.952739  export SHELL=3D/bin/sh
    2023-03-27T10:24:50.953409  #
    2023-03-27T10:24:51.055227  / # export SHELL=3D/bin/sh. /lava-234740/en=
vironment
    2023-03-27T10:24:51.055763  =

    2023-03-27T10:24:51.157370  / # . /lava-234740/environment/lava-234740/=
bin/lava-test-runner /lava-234740/1
    2023-03-27T10:24:51.158291  =

    2023-03-27T10:24:51.162071  / # /lava-234740/bin/lava-test-runner /lava=
-234740/1 =

    ... (12 line(s) more)  =

 =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
cubietruck       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/642168c80b57ddc52b9c9524

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-25-gc95d797f10041/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-25-gc95d797f10041/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642168c80b57ddc52b9c952d
        failing since 69 days (last pass: v4.19.269-9-gce7b59ec9d48, first =
fail: v4.19.269-521-g305d312d039a)

    2023-03-27T09:58:15.533672  <8>[    7.282806] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3449006_1.5.2.4.1>
    2023-03-27T09:58:15.641170  / # #
    2023-03-27T09:58:15.742967  export SHELL=3D/bin/sh
    2023-03-27T09:58:15.743627  #
    2023-03-27T09:58:15.844969  / # export SHELL=3D/bin/sh. /lava-3449006/e=
nvironment
    2023-03-27T09:58:15.845479  =

    2023-03-27T09:58:15.946820  / # . /lava-3449006/environment/lava-344900=
6/bin/lava-test-runner /lava-3449006/1
    2023-03-27T09:58:15.947886  =

    2023-03-27T09:58:15.952671  / # /lava-3449006/bin/lava-test-runner /lav=
a-3449006/1
    2023-03-27T09:58:16.036589  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
