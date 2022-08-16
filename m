Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BC95961BA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 20:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiHPR7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 13:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236371AbiHPR7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 13:59:20 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3507683043
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 10:59:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 17so9920838pli.0
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 10:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=OUIRAh0G++qJ4CzEdbIemtey5LJ5xYEa0QyiuawCTKA=;
        b=gzLnuKqcVbbzXj/jR6q3vUEAtPhp9afLkiVyWAeHHR6M0JTk1ETjzvc3xtuvYV7i+6
         BgRxzU1YZErnJtH+IwIwjMecU6umzVNc5obS8Uw9KODP8VzUY5IsyNiK1SLN5CY5HyN7
         jSmMBxKTtdxAWR4CVraO5AtpW2GAZHRiJhw+gnToF20Vu3PQkaWVQFd8a7A0uWkI8YL0
         oMXdGrAANXnJ3j/DOAbQX+fBIkaVGywlpvbULnQA5RV9RYHH3YK7LuiE3psgmKT2UXkN
         xvpd7+rG8wZs2Q5EY2HYiZnU3cfNXnmVPL/5PqeVxwSbq3cw3eIbgHJ8DLEptdTDR5Dt
         0N3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=OUIRAh0G++qJ4CzEdbIemtey5LJ5xYEa0QyiuawCTKA=;
        b=CofvzwG5Iw+lz2BesCObQpG48lUOgSKTYJbnNT1qUXF8/Xg28ttIhxSbZlyblFt6Gw
         RGIAkF+N2jFnKRvLDw4lXSyqBLvUC+JwNbpcxSvi8EnCmffMLCqZ9qk2/MS0GRSGYTyG
         DrzVCMZ0ka/M0T7hBnamq1TPm8CYecqex1OeshvxQlwgmnKESg3Ww1b5bY+Xfo3UfQpk
         omiwBaNhoLHH2gj9ILml2AtJWWmVBqUvjjMowj/Wjdt6rjsGFut2ieaujXTmjnG4I1Sp
         MaRYyB5YNNWvG/5lo93P79M1KbQMCWI29YeGD/EtIv5UNnDe8UKwhxfP6coUORpbtLn+
         wgfw==
X-Gm-Message-State: ACgBeo2mw6D+jF2WIaT2HH3Y032Onv21zz+DxEhEGcE4BUxyYsGdlARE
        dm8HYkMvIF6rCjNDCEB7tSljyaKeC8PV5J7n
X-Google-Smtp-Source: AA6agR6+xk2a/aVO1lRQGvGzP5FmWafU45Sa3B6Xmn5ACMk5z989zrJLbImrBvO6Nf1KrBycHAddaQ==
X-Received: by 2002:a17:902:9882:b0:172:793b:ccc3 with SMTP id s2-20020a170902988200b00172793bccc3mr5514348plp.27.1660672756072;
        Tue, 16 Aug 2022 10:59:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 128-20020a621886000000b0052d200c8040sm8718899pfy.211.2022.08.16.10.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 10:59:15 -0700 (PDT)
Message-ID: <62fbdaf3.620a0220.ea231.ec14@mx.google.com>
Date:   Tue, 16 Aug 2022 10:59:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.17-1095-g8e2f0ee8f479f
Subject: stable-rc/linux-5.18.y baseline: 146 runs,
 4 regressions (v5.18.17-1095-g8e2f0ee8f479f)
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

stable-rc/linux-5.18.y baseline: 146 runs, 4 regressions (v5.18.17-1095-g8e=
2f0ee8f479f)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
bcm2835-rpi-b-rev2           | arm   | lab-broonie   | gcc-10   | bcm2835_d=
efconfig          | 1          =

kontron-pitx-imx8m           | arm64 | lab-kontron   | gcc-10   | defconfig=
                  | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

panda                        | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.17-1095-g8e2f0ee8f479f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.17-1095-g8e2f0ee8f479f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8e2f0ee8f479ff0a9978613fd90b3f3fc9b9c6d3 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
bcm2835-rpi-b-rev2           | arm   | lab-broonie   | gcc-10   | bcm2835_d=
efconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62fba6c8283f15075635566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1095-g8e2f0ee8f479f/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm=
2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1095-g8e2f0ee8f479f/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm=
2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fba6c8283f150756355=
66e
        new failure (last pass: v5.18.12-232-ga04b1a5cb7d28) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fba98a589bc6015435565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1095-g8e2f0ee8f479f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-p=
itx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1095-g8e2f0ee8f479f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-p=
itx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fba98a589bc60154355=
65e
        failing since 0 day (last pass: v5.18.14-248-g7e8a7b1c98057, first =
fail: v5.18.17-1096-g56bd9e4c28e9e) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fba7740b6f7f6154355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1095-g8e2f0ee8f479f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1095-g8e2f0ee8f479f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fba7740b6f7f6154355=
644
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1096=
-g56bd9e4c28e9e) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
panda                        | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbb0da37de6214e4355673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1095-g8e2f0ee8f479f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1095-g8e2f0ee8f479f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbb0da37de6214e4355=
674
        failing since 1 day (last pass: v5.18.14, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =20
