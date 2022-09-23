Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917CF5E84EC
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 23:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiIWVbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 17:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiIWVbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 17:31:16 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C48413A946
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 14:30:53 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c198so1267342pfc.13
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 14:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=oP8hEfshR2XzKzc0U9LsJjpeM9hA5Fs1/7MNFMWuhTo=;
        b=Wb6u//mIrj8AWOCXq2HL4kDUtSy1Q0tG3ElXad6OlaQkacXw1B/B39gG5H2VZ/jdX1
         g4GjfoKGtBVSJqRmnvzxl6sAFCBNamW4dg0YXWDZ6DTLzdPK5PSw9ghOWwZiDipRtG4d
         Q+3kKzLTVZu1u50O5SJy3aLIiZ+CSPdaBL9YW0i8rsXvAEn3/5cG782jHMqbXO4tgV5h
         SEyQ+bh3cw4peZTjeh5gnqDf7ZYFNnOmjBILiCLJrsGcPUr1e0TcZWpLSC5kia1nskZ3
         GmQcNNtGN11SwqlUzxQq2JuulUSDh6gJFxNimViuHv/UjxXoW/D4ir8Tjl4MM68j4ywo
         rzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=oP8hEfshR2XzKzc0U9LsJjpeM9hA5Fs1/7MNFMWuhTo=;
        b=Mi2c6akHdKQGcx/GQqG0Dhtfvxt6HW/iODbEqBJR7G9DFiSm65a5qTn8F9HClqfWNj
         W0sIhYOQhAQSDrCW/laZrPpcFCYlQl1OG0EVeOWp4iAP61jIfNVx3iPaexINd6gp8Pek
         Gg9EFzlDgNokzI3vc6k2c4j0KR2mh8dM7cK57esVtbrF7HTnN7LKuPyj6ScmgatWRdBp
         KAPe8YCqawl1xAnstq28rVvoLkreQCtD/ZBW3+bz/v37oNIgva+TUu66LgvA80uBDO1r
         YxBGEDbYHB68NxIwxY+2QYfRvr2ehNraifmuPr5HL+wqkwoMNOkHrwILGT/Merm81O5d
         1djg==
X-Gm-Message-State: ACrzQf3OQXSri7+s8q+/GJ7CrUIKChGUylV8ZBCpe9w5mkw6cjagsyRL
        1qibzHxqPYluvW9QRnY8j2DzqJFCETogEZAcVlw=
X-Google-Smtp-Source: AMsMyM6fNrJcy/ldCXE16scGyBBtn1UzzC1lFbXsvLXwjrUnNSGzMa76X0vdtWrVuTOj/Tm4YWXGYg==
X-Received: by 2002:a05:6a00:4006:b0:53e:815a:ff71 with SMTP id by6-20020a056a00400600b0053e815aff71mr11037967pfb.4.1663968652673;
        Fri, 23 Sep 2022 14:30:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y18-20020aa78f32000000b0053e56165f42sm7147031pfr.146.2022.09.23.14.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 14:30:52 -0700 (PDT)
Message-ID: <632e258c.a70a0220.8a31.eced@mx.google.com>
Date:   Fri, 23 Sep 2022 14:30:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11
Subject: stable-rc/linux-5.19.y baseline: 161 runs, 3 regressions (v5.19.11)
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

stable-rc/linux-5.19.y baseline: 161 runs, 3 regressions (v5.19.11)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

mt8173-elm-hana              | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fcf22aefe87101424563a8dd8adec8a75b8c7576 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632df3223de735b945355664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632df3223de735b945355=
665
        new failure (last pass: v5.19.10-40-g8d4fd61ab089) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8173-elm-hana              | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632df303306c072327355668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8173-elm=
-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8173-elm=
-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632df303306c072327355=
669
        new failure (last pass: v5.19.10-40-g8d4fd61ab089) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632df2cf653aadbf6535566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-tro=
gdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-tro=
gdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632df2cf653aadbf65355=
66e
        new failure (last pass: v5.19.10-40-g8d4fd61ab089) =

 =20
