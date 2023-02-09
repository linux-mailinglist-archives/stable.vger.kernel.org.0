Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A33690DA8
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 16:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjBIPzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 10:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjBIPy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 10:54:59 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC165D3E8
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 07:54:54 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gj9-20020a17090b108900b0023114156d36so6226213pjb.4
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 07:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2cPbhrbdnXrSPAlc07pTs3S/NuMs1VtMFWXrJfD6YVE=;
        b=QUb+fN/WM8Q5FCO1zlDLij1d/WlF2ZSon0xW5QZI/fQyTx/AARme+wVGwEJN78G1VX
         6CQqd513NohQD5/6SzNtseueOclwJAYKO32bI6XPKzgv8TpvArsmpiLBzqieoU2FzCMV
         5DVb8JhuQapGQJLG4qKi5XQNNSEuKxTjVnWtr3DAebUyLhHUrU9CW66s7ZpZPVWthF5s
         DWSpOqHM1EhUcoZRyvw0F9U+GzYAsYSEYsEvimoR8THUXNFl+eH5jbwBpHB+zC4s/yzZ
         KwvmoCOU/knFx+xW4w+LyFWb3w9h02Oli0CBV1AwK2uMXIVcz1vUPa9YxapQtMWGL2mX
         JqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2cPbhrbdnXrSPAlc07pTs3S/NuMs1VtMFWXrJfD6YVE=;
        b=whpnFTVT77pYt4QHEQ5TvijIlg8orKfSaOhispGcoxqARZLPZMY/L6MODXAKb95NNM
         mdzJVzfmvZRvsgSkd06mhGR+r2z1LDqQZqnvtzl1eVTi8Ybv19w2QD/bKsWAfmupP2Pq
         5MArOOyIAJ+QWohBcBpaHm+U76OA9wrDQ+D+PG6rx/zWJpxLeN/RJwXKUDOgGUeYSvhT
         1sj8OMO5VqBq45obP1hpSZHMll8B2tQVRpqDu/z7D4i7BHM0V/WuZiPG2LDuXLA7U63V
         rSr+Qj7H5MaDlCiaX81HAC2pyrgUO3BcsDK8taPz+20an7I16PpSyAzRn9kCAh62YbhJ
         ZnLw==
X-Gm-Message-State: AO0yUKUS5arkOFIzkKRooHncDE3rU9fmQOrruT8PraIdaBlDmtZuZSeF
        4uHpvQrVzhMnlnRidXKJxBM8zpAhiw8kxtbxMsXFNg==
X-Google-Smtp-Source: AK7set870pzXdK5/t+kTBzkU25Bpiys9ZDZ+84l5ZZ1cvix+IMqELbzmyWm4qkX6FLx/ilA7CpdSGg==
X-Received: by 2002:a17:90a:3f8b:b0:232:ce83:20a with SMTP id m11-20020a17090a3f8b00b00232ce83020amr2763858pjc.36.1675958094226;
        Thu, 09 Feb 2023 07:54:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s5-20020a17090a5d0500b0022bffc59164sm1547653pji.17.2023.02.09.07.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:54:53 -0800 (PST)
Message-ID: <63e5174d.170a0220.acd1c.2b9e@mx.google.com>
Date:   Thu, 09 Feb 2023 07:54:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.167-88-g51abf75149f2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 170 runs,
 2 regressions (v5.10.167-88-g51abf75149f2)
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

stable-rc/queue/5.10 baseline: 170 runs, 2 regressions (v5.10.167-88-g51abf=
75149f2)

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
nel/v5.10.167-88-g51abf75149f2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.167-88-g51abf75149f2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      51abf75149f20ced8c5bcd82acda595eb91be3a9 =



Test Regressions
---------------- =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e4e22ce57d96e3cc8c8665

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-88-g51abf75149f2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-88-g51abf75149f2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e4e22ce57d96e3cc8c866e
        failing since 14 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-02-09T12:08:01.269356  + set +x<8>[   11.114878] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3312362_1.5.2.4.1>
    2023-02-09T12:08:01.269890  =

    2023-02-09T12:08:01.379108  / # #
    2023-02-09T12:08:01.482271  export SHELL=3D/bin/sh
    2023-02-09T12:08:01.483299  #
    2023-02-09T12:08:01.585413  / # export SHELL=3D/bin/sh. /lava-3312362/e=
nvironment
    2023-02-09T12:08:01.586340  =

    2023-02-09T12:08:01.688373  / # . /lava-3312362/environment/lava-331236=
2/bin/lava-test-runner /lava-3312362/1
    2023-02-09T12:08:01.689973  =

    2023-02-09T12:08:01.690577  / # <3>[   11.450643] Bluetooth: hci0: comm=
and 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e4e226e6ecf835718c8650

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-88-g51abf75149f2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-88-g51abf75149f2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e4e226e6ecf835718c8659
        failing since 7 days (last pass: v5.10.165-139-gefb57ce0f880, first=
 fail: v5.10.165-149-ge30e8271d674)

    2023-02-09T12:07:25.789841  / # #
    2023-02-09T12:07:25.891557  export SHELL=3D/bin/sh
    2023-02-09T12:07:25.892058  #
    2023-02-09T12:07:25.993433  / # export SHELL=3D/bin/sh. /lava-3312373/e=
nvironment
    2023-02-09T12:07:25.993973  =

    2023-02-09T12:07:26.095568  / # . /lava-3312373/environment/lava-331237=
3/bin/lava-test-runner /lava-3312373/1
    2023-02-09T12:07:26.096355  =

    2023-02-09T12:07:26.115335  / # /lava-3312373/bin/lava-test-runner /lav=
a-3312373/1
    2023-02-09T12:07:26.203182  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-09T12:07:26.203518  + cd /lava-3312373/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
