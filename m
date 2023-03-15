Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EAE6BBD42
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 20:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjCOT3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 15:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjCOT33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 15:29:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD8D6F4AC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:29:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id cn6so7424409pjb.2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678908563;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QSqhGUnyzubE81KnqzAJtS6VPbJU0LWmFrU52Zxw7PU=;
        b=WcdBUPnjxrJ/ywI6YTAKOGUsVcJhKPhRl7vZDM7DWHpo5p3Sv/uymsKFHeWyKxBWyz
         Zb6zUXoJ3fFL2DdlAqOAuuJ0nB8MC94mT0IH2c64QRi6gm7nszEn3RJ3AE/uuN8K43DO
         rs24N0vWqJR3FwkhTsBU2ypccxxOilKtKiZTYiO9NEUiVaI3OlAsy9kagg4jDktO8O7U
         Zoud9x242reOo/6diaVhvcYUun9BRxgJHxctr/vGgPoTq+hG3/ZPy/Oqg0kCg02lB4nK
         P0VcE9ZR8az4NEGkLTC057TtL5KKowzt/e38CeYGNgPg/ZZvOlUzig2EzWSkrjDyYQWL
         tlwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678908563;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QSqhGUnyzubE81KnqzAJtS6VPbJU0LWmFrU52Zxw7PU=;
        b=hsyKR03/2L3DDxfUtIEmNr1s5/ZrfSY4mXANean4ExTYDUp9IQnbAeoea1p7HwL+pP
         W0f6/I2NnlX+KPy3V8Ls9InmH8E4LsqtI+acX+YQ4xn25QSnUOZIvjIZQflxoCRyS76h
         Q4BSwxIdpQt6azMEtM5MNN1nv5/ouyOQUy4rH3XHgEjQqDvbVaJs2/E3RombWpnE+hox
         OTntrqZ0tZaIpDAuUn2rKMXRObW0cz9nL+bURqzlQIANuqTyygHaZPnbY3yov+z9lH1Q
         nerhdWXIEyJePRMSdHH/WdCekb/TZJC8cxTf1hhu6xmQE2x4eygyg4gLwINUcbU3gLsg
         vAqw==
X-Gm-Message-State: AO0yUKWUiIl+kQ2Ew8M+rAWUDgbCdDoeNbJn63p2FQAW9SEier23t00c
        Uz1kI96kJ0KkuYyTGQBWB696r/dJ32D9FcZEoMPkIy34
X-Google-Smtp-Source: AK7set/9m5mBDqwYscK3gC/SvheuQy641Wrh8qGymusHSJPr83lI4EXhkbSPjDjqUH4Tu/m6BqhMYA==
X-Received: by 2002:a17:902:d486:b0:19a:839d:b682 with SMTP id c6-20020a170902d48600b0019a839db682mr833404plg.17.1678908563387;
        Wed, 15 Mar 2023 12:29:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v7-20020a170902b7c700b001991f3d85acsm3949092plz.299.2023.03.15.12.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 12:29:23 -0700 (PDT)
Message-ID: <64121c93.170a0220.99fd4.936a@mx.google.com>
Date:   Wed, 15 Mar 2023 12:29:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.101-150-g158686d9d0fd1
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 180 runs,
 2 regressions (v5.15.101-150-g158686d9d0fd1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 180 runs, 2 regressions (v5.15.101-150-g15=
8686d9d0fd1)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
cubietruck      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =

fsl-lx2160a-rdb | arm64 | lab-nxp      | gcc-10   | defconfig          | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.101-150-g158686d9d0fd1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.101-150-g158686d9d0fd1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      158686d9d0fd1611f5fed8138b31ceea82254c07 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
cubietruck      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6411e7c2c1fcd312458c8659

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-150-g158686d9d0fd1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-150-g158686d9d0fd1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411e7c2c1fcd312458c8662
        failing since 57 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-03-15T15:43:46.691009  <8>[    9.986148] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3414530_1.5.2.4.1>
    2023-03-15T15:43:46.801332  / # #
    2023-03-15T15:43:46.904879  export SHELL=3D/bin/sh
    2023-03-15T15:43:46.905892  #
    2023-03-15T15:43:46.906329  / # <3>[   10.113461] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-03-15T15:43:47.008268  export SHELL=3D/bin/sh. /lava-3414530/envir=
onment
    2023-03-15T15:43:47.009340  =

    2023-03-15T15:43:47.111609  / # . /lava-3414530/environment/lava-341453=
0/bin/lava-test-runner /lava-3414530/1
    2023-03-15T15:43:47.113351  =

    2023-03-15T15:43:47.118359  / # /lava-3414530/bin/lava-test-runner /lav=
a-3414530/1 =

    ... (12 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
fsl-lx2160a-rdb | arm64 | lab-nxp      | gcc-10   | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6411ec65653b3f64878c86e5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-150-g158686d9d0fd1/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-r=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-150-g158686d9d0fd1/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-r=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411ec65653b3f64878c86ec
        failing since 11 days (last pass: v5.15.79, first fail: v5.15.98)

    2023-03-15T16:03:07.033883  [   10.386701] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1173943_1.5.2.4.1>
    2023-03-15T16:03:07.139846  / # #
    2023-03-15T16:03:07.241957  export SHELL=3D/bin/sh
    2023-03-15T16:03:07.242436  #
    2023-03-15T16:03:07.343948  / # export SHELL=3D/bin/sh. /lava-1173943/e=
nvironment
    2023-03-15T16:03:07.344411  =

    2023-03-15T16:03:07.445896  / # . /lava-1173943/environment/lava-117394=
3/bin/lava-test-runner /lava-1173943/1
    2023-03-15T16:03:07.446692  =

    2023-03-15T16:03:07.448340  / # /lava-1173943/bin/lava-test-runner /lav=
a-1173943/1
    2023-03-15T16:03:07.467981  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
