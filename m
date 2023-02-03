Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8F8689E0E
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 16:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbjBCPXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 10:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbjBCPXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 10:23:23 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004F4A58C0
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 07:21:24 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso9107231pjj.1
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 07:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qwSZ+cHZ166OE53FNGWzCsFIqBKTFsPJTEBkU7aygOo=;
        b=Eu0fIu0BHQvf9oBzNJ3x80ZGp3IfiNVoWXm0vzqp0O34pqD5NPU1iJczXb9ZRuUfWv
         YEkVWtKoQG7F3mz8q/GfUxsXeqzdWlGKT31ZZ//NOXQ0DofJ6ykEkI79JBmJaqXAc3yD
         VEsHKhNU+pjGRDUF8LbzB81QkpBLCm4Z0nStaWwhIZVtdfIFmzIGqC9mSHl0NWkVtOLV
         Nfhw03HG5xITWW/UoG8xX+ubb1tFJRpRd4SarjghPMw7zqilRuAauCanArBwGVdIGiMt
         7nxLt24neeLQH44snE7uM/WWQ60yBDzgPhFegQx7W9JPMTa7Mc/MtuasGDGVVHQDS21L
         Z0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qwSZ+cHZ166OE53FNGWzCsFIqBKTFsPJTEBkU7aygOo=;
        b=J+NIdiELAPCnH26oPEqlENElRY+cKTSv0QI25tmjXiUwv9drDfLCvS0qI3abb2E4nA
         k0Hm4l1alLsO/Yu+6nC4FMIyD8ZhLUl5R/9tMGvqJ3w+x9Fa6ufN7uOTxeUDEXLVEpwq
         WkVGzy3Ten/3RXMysdQi4I3RPmhOHn4ra6yiVUxmD9kQlmUMb88DaPNZhZjm0+3+xCdl
         /mAltD8UuJn3ch37D9z+wP39O7pEdJ0OCCDWwPy4fLXjJZw1yaRXYdrentasiTDFXoGP
         ExudPrunEuLXBzB4W27qvZJ2Svlk65DfqcAnVKTVTCmKcqeKttEo03kEGTqJeZ2BQB86
         6KiA==
X-Gm-Message-State: AO0yUKVsvwW7FOYu6fuj92upVfN6sovxjOt3+2T0L5DOt6IBspwSZ0CK
        rya/hbQ4AbGy/g9wTEwolgBvIHftdG58fLZpJ+rMYQ==
X-Google-Smtp-Source: AK7set8l6fF5m7C815vl7G2RFKSznirgrM9XkLi2N4xHSatDnU1qCz//LyywKxIzQgD4Bq0g11sSgg==
X-Received: by 2002:a17:902:e40d:b0:198:e708:5630 with SMTP id m13-20020a170902e40d00b00198e7085630mr918894ple.64.1675437680821;
        Fri, 03 Feb 2023 07:21:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n23-20020a170902969700b00198e6409d17sm784538plp.116.2023.02.03.07.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 07:21:20 -0800 (PST)
Message-ID: <63dd2670.170a0220.bb4e3.1390@mx.google.com>
Date:   Fri, 03 Feb 2023 07:21:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.166-9-gcc82e3773cad
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 164 runs,
 3 regressions (v5.10.166-9-gcc82e3773cad)
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

stable-rc/queue/5.10 baseline: 164 runs, 3 regressions (v5.10.166-9-gcc82e3=
773cad)

Regressions Summary
-------------------

platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =

stm32mp157c-dk2              | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =

sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.166-9-gcc82e3773cad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.166-9-gcc82e3773cad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cc82e3773cad40fd71db2623216d510a7008ac85 =



Test Regressions
---------------- =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcf5f8ab190b44aa915ec7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gcc82e3773cad/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gcc82e3773cad/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcf5f8ab190b44aa915ecc
        failing since 8 days (last pass: v5.10.165-76-g5c2e982fcf18, first =
fail: v5.10.165-77-g4600242c13ed)

    2023-02-03T11:54:04.071549  <8>[   10.959277] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3281148_1.5.2.4.1>
    2023-02-03T11:54:04.178582  / # #
    2023-02-03T11:54:04.281690  export SHELL=3D/bin/sh
    2023-02-03T11:54:04.282694  #
    2023-02-03T11:54:04.384710  / # export SHELL=3D/bin/sh. /lava-3281148/e=
nvironment
    2023-02-03T11:54:04.385134  =

    2023-02-03T11:54:04.385356  / # <3>[   11.211385] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-02-03T11:54:04.486670  . /lava-3281148/environment/lava-3281148/bi=
n/lava-test-runner /lava-3281148/1
    2023-02-03T11:54:04.487219  =

    2023-02-03T11:54:04.491927  / # /lava-3281148/bin/lava-test-runner /lav=
a-3281148/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
stm32mp157c-dk2              | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcf5642bd1565bf2915ecc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gcc82e3773cad/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gcc82e3773cad/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcf5642bd1565bf2915ed1
        failing since 1 day (last pass: v5.10.147-29-g9a9285d3dc114, first =
fail: v5.10.165-149-ge30e8271d674)

    2023-02-03T11:51:58.053730  <8>[   12.586815] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3281155_1.5.2.4.1>
    2023-02-03T11:51:58.160766  / # #
    2023-02-03T11:51:58.262904  export SHELL=3D/bin/sh
    2023-02-03T11:51:58.263711  #
    2023-02-03T11:51:58.365547  / # export SHELL=3D/bin/sh. /lava-3281155/e=
nvironment
    2023-02-03T11:51:58.365935  =

    2023-02-03T11:51:58.467386  / # . /lava-3281155/environment/lava-328115=
5/bin/lava-test-runner /lava-3281155/1
    2023-02-03T11:51:58.468326  =

    2023-02-03T11:51:58.472930  / # /lava-3281155/bin/lava-test-runner /lav=
a-3281155/1
    2023-02-03T11:51:58.537841  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcf59ca3e3798054915ec1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gcc82e3773cad/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gcc82e3773cad/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcf59ca3e3798054915ec6
        failing since 1 day (last pass: v5.10.165-139-gefb57ce0f880, first =
fail: v5.10.165-149-ge30e8271d674)

    2023-02-03T11:52:33.839318  / # #
    2023-02-03T11:52:33.940993  export SHELL=3D/bin/sh
    2023-02-03T11:52:33.941503  #
    2023-02-03T11:52:34.042979  / # export SHELL=3D/bin/sh. /lava-3281146/e=
nvironment
    2023-02-03T11:52:34.043336  =

    2023-02-03T11:52:34.144679  / # . /lava-3281146/environment/lava-328114=
6/bin/lava-test-runner /lava-3281146/1
    2023-02-03T11:52:34.145292  =

    2023-02-03T11:52:34.150582  / # /lava-3281146/bin/lava-test-runner /lav=
a-3281146/1
    2023-02-03T11:52:34.214729  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-03T11:52:34.249458  + cd /lava-3281146/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
