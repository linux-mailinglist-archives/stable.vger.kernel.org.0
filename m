Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430636D0E3A
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjC3TAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjC3TAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:00:45 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F53EE
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:00:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u20so13244214pfk.12
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680202844;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ey7aeW/EL2C7d1UgbgSnT8xpkpwSIVXUxCRZpBnBlJY=;
        b=XBVP3AYlINmmlF0HupZtDHv95Mv5cCXa3c/uADe8Es0/887pGxlgErfkJtdcB5pbNu
         9mND54DHNf7ew+jEtVhnw7oyQ3V74W/vN41JoDmIHx4KIgWPX2EAtRa2BV8xdzFCSeTY
         3upm7m4+7wkWKG+EYsYLfc5kO9XoCCObyzt7/39OBrA3JXNiqUDPPxwWVmH0AO4bw7Pn
         UvAK0xdeubucDj4kgqYFHNrWrBcM7QTiDdrF6Jjiik+RDixr9Nk/ZwVHOIjxMjw6UcBV
         Ywg5W9grG3mIXNKQSjVjjFx6vPDX8BSqoe3sFQAzs4aoaU8bgrKsxwOTfSa42H2S/HeO
         G4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680202844;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ey7aeW/EL2C7d1UgbgSnT8xpkpwSIVXUxCRZpBnBlJY=;
        b=iCxE2ZPkm1Gf54UrJazAju0VmVpvVpdFftSNLpJhTJRFOF0Wyry/qvUvKarEEi1Rks
         F0Qej5gNBn0k98eI19GdJ8iq1A1mBq0odFmoloc0gik3OPnqXYoH991ED9BblcvvJCXz
         SwP1HWs/heHc05bAUkYC2KAq6ZPmfFBNJt+9xh+jYI9yucJ4g+GZ4Phk4o7CNo5pqrR/
         vgljMwHw/ld2gwPyF71S/s+o8hRyKOZR+Kx2MJlTsvN/u7dD98oUPG7Pa6N+hO19yXHn
         88nowK7VggplLC5jf6Ne5tj+fqBtmABxQL7+fUQnK2pRMmee0QoQ5sWbpq4PrOWLECCr
         jzHg==
X-Gm-Message-State: AO0yUKVw1p1UE3QnuIHLs9vb6C01oXRwlf+MBI7kzim32ScEozDcUwj1
        xSeoqAR5AdBXuOTGRJhRN2hwLn0pzIrZ0xU+9WI=
X-Google-Smtp-Source: AKy350YWq0lHL9SH4dyykwp7x61oozNlZpeKqNCatP73uAMmOQ9BE0gFl4DYgddapk6j0QduCCdlJw==
X-Received: by 2002:a62:52d7:0:b0:622:c72a:d0e0 with SMTP id g206-20020a6252d7000000b00622c72ad0e0mr22497432pfb.13.1680202843765;
        Thu, 30 Mar 2023 12:00:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e19-20020aa78c53000000b00575d1ba0ecfsm213586pfd.133.2023.03.30.12.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 12:00:43 -0700 (PDT)
Message-ID: <6425dc5b.a70a0220.138d7.0f47@mx.google.com>
Date:   Thu, 30 Mar 2023 12:00:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.279-62-g932f2c9ab1cb
Subject: stable-rc/queue/4.19 baseline: 106 runs,
 2 regressions (v4.19.279-62-g932f2c9ab1cb)
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

stable-rc/queue/4.19 baseline: 106 runs, 2 regressions (v4.19.279-62-g932f2=
c9ab1cb)

Regressions Summary
-------------------

platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig | 1    =
      =

cubietruck    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.279-62-g932f2c9ab1cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.279-62-g932f2c9ab1cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      932f2c9ab1cb25c78e567d3bb04cea6d5e0bef35 =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6425aae3ff345f46c862f86e

  Results:     42 PASS, 9 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-62-g932f2c9ab1cb/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-62-g932f2c9ab1cb/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425aae3ff345f46c862f8a0
        failing since 3 days (last pass: v4.19.279-25-g8270940878fa3, first=
 fail: v4.19.279-25-gc95d797f10041)

    2023-03-30T15:28:59.415531  + set +x
    2023-03-30T15:28:59.420742  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 250839_1.5.2=
.4.1>
    2023-03-30T15:28:59.534127  / # #
    2023-03-30T15:28:59.636959  export SHELL=3D/bin/sh
    2023-03-30T15:28:59.637727  #
    2023-03-30T15:28:59.739742  / # export SHELL=3D/bin/sh. /lava-250839/en=
vironment
    2023-03-30T15:28:59.740498  =

    2023-03-30T15:28:59.842467  / # . /lava-250839/environment/lava-250839/=
bin/lava-test-runner /lava-250839/1
    2023-03-30T15:28:59.843773  =

    2023-03-30T15:28:59.850222  / # /lava-250839/bin/lava-test-runner /lava=
-250839/1 =

    ... (12 line(s) more)  =

 =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
cubietruck    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6425a7ae88cfd9e8f662f816

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-62-g932f2c9ab1cb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-62-g932f2c9ab1cb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425a7ae88cfd9e8f662f81b
        failing since 72 days (last pass: v4.19.269-9-gce7b59ec9d48, first =
fail: v4.19.269-521-g305d312d039a)

    2023-03-30T15:15:33.976928  + set +x<8>[    7.381914] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3456056_1.5.2.4.1>
    2023-03-30T15:15:33.977642  =

    2023-03-30T15:15:34.086731  / # #
    2023-03-30T15:15:34.189568  export SHELL=3D/bin/sh
    2023-03-30T15:15:34.190864  #
    2023-03-30T15:15:34.293287  / # export SHELL=3D/bin/sh. /lava-3456056/e=
nvironment
    2023-03-30T15:15:34.294427  =

    2023-03-30T15:15:34.396677  / # . /lava-3456056/environment/lava-345605=
6/bin/lava-test-runner /lava-3456056/1
    2023-03-30T15:15:34.398472  =

    2023-03-30T15:15:34.402893  / # /lava-3456056/bin/lava-test-runner /lav=
a-3456056/1 =

    ... (12 line(s) more)  =

 =20
