Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC590590729
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 21:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiHKT6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 15:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbiHKT6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 15:58:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094809A97E
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 12:58:35 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso6101118pjd.3
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 12:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=7yTKgwa26Uf+to7iNGHu44Hc80YBWJhgR/xJswFgTCw=;
        b=yPmwSlM94RWsR1n18FBox5WSFCuD/B2aKEUhS5gErTbaxkSlta2CSOhrpZ/Hdaq0U+
         Zj6/qXyTD703qsP9D5h9EErYxlJeWM6UrBxqSsJLBcjIliq9oPglf1K/KimiotDQwSsR
         TQNwBlJnPMoD5a+bhr4JF4x90LMJp/txnBYyuVHtIwfVo+eEVj9aRjuSnd5BEdnUCdYc
         DO4JTK++nlf6dwl97jOgMHkosJfK963kZrqrDTAWY9+sSuWIhs2rg2mJF+ZNwGgksOJC
         t8LunYxxK06NvW+H2Z04tbHMQodT89CmCseBfRO42k1bjzUg4I5PapLViYVa6Lf9g+uq
         RTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=7yTKgwa26Uf+to7iNGHu44Hc80YBWJhgR/xJswFgTCw=;
        b=iJlfPt3ajzzcioEwyOHua3U52v9vi8hryZHVmRn+61N0z3mNv4VPmCfci65KsQbx5M
         eRyq9ruq6QAYBr332Ha73RGkgmJdSd8K3yaQtv3WLqs5LMWLo8JWthmU/kiYiKUPJ5MQ
         tOUo5bTkR8VeHuyDlISRuL3ATrqMf4R9yK1qRYTXEybG3etjUIxZOXfG573a8DeB67x/
         j0plBAuKkceEUgaKu1S/VUKzWAlLhDwLElmdUCU9aZEdPrxGhQI7Jo3SW7PeFYt617vY
         LzhoSLGp+44KslGgajf30CpVoJ5LmHz7KbDhSHEcEsa3Z17Sxn55zd0a/bx7Jz5V2lCV
         1byQ==
X-Gm-Message-State: ACgBeo1NHiXwka1XMkav8w6FKMNPFP3HYvWTSbSk7pDJbt3GmoKnBWJn
        uuTMfGMdhwus2a5wniD3tb4NQ5wRjtH719RvKKk=
X-Google-Smtp-Source: AA6agR4VD27Lxh5nvWJPYRoBocfJwkHYloXCU5jEszil3x1diEfY2R5tlP34zGu5uvAtl6Lj2FN+oQ==
X-Received: by 2002:a17:903:31c9:b0:16c:3024:69c4 with SMTP id v9-20020a17090331c900b0016c302469c4mr660788ple.81.1660247914384;
        Thu, 11 Aug 2022 12:58:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m2-20020a6545c2000000b0041d59062108sm139552pgr.9.2022.08.11.12.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 12:58:33 -0700 (PDT)
Message-ID: <62f55f69.650a0220.c088e.03c3@mx.google.com>
Date:   Thu, 11 Aug 2022 12:58:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-19-g530fdb4b7da61
Subject: stable-rc/queue/5.15 baseline: 142 runs,
 3 regressions (v5.15.60-19-g530fdb4b7da61)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 142 runs, 3 regressions (v5.15.60-19-g530fdb=
4b7da61)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2711-rpi-4-b      | arm64 | lab-collabora | gcc-10   | defconfig        =
   | 1          =

beagle-xm            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconf=
ig | 1          =

meson-g12b-odroid-n2 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.60-19-g530fdb4b7da61/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.60-19-g530fdb4b7da61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      530fdb4b7da613398d67b7649f63f897aed18648 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2711-rpi-4-b      | arm64 | lab-collabora | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/62f531731f02d1cf64daf072

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
19-g530fdb4b7da61/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rpi=
-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
19-g530fdb4b7da61/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rpi=
-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f531731f02d1cf64daf=
073
        new failure (last pass: v5.15.59-15-g9e86d04b098c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
beagle-xm            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f52951e42429cc1ddaf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
19-g530fdb4b7da61/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
19-g530fdb4b7da61/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f52951e42429cc1ddaf=
060
        failing since 133 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-g12b-odroid-n2 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/62f530db358b2d9077daf09f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
19-g530fdb4b7da61/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
19-g530fdb4b7da61/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f530db358b2d9077daf=
0a0
        new failure (last pass: v5.15.59-15-g9e86d04b098c) =

 =20
