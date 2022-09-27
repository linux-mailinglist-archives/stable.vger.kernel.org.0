Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC3C5EB6A5
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 03:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiI0BGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 21:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiI0BGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 21:06:21 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C04F7C30A
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 18:06:19 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id bh13so8055349pgb.4
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 18:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=hdLwSXy69mEYwc+LdBxZarwy9iltvcwAjfyKQrwItrY=;
        b=KJHVVcDS20rRMtR+9lvsNYxwdTsoL3t2AEU+5VfrafOZg6WqVRHRZIfjfxXyWdklLL
         ZSVLuZj8F6Jg+TLOpq5BgZvfRt0U6eISV0DqmWiZWAz2qgRJUi3gLMB7WxE29vIa0NaX
         ySLkOXDZHDbtZhtSTCtIFb+G3Dj0t9qwhwOz5YUZ0tl2Tdg+ZtTog98eeDqVjKNYUsAk
         SZ6qIWzNE0AYRgnDkpQ+BGQuBt1+KcTYlluiCwsN5eGbEuWAHs68YYdByYN+8Z9Dch+V
         0D9NOmMJIXUqFyWxxqDrNjncy4jiiXsEiBZ8JcOhqASbJo3cPK0KPXOCS/N0oA1PEqDf
         Fq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=hdLwSXy69mEYwc+LdBxZarwy9iltvcwAjfyKQrwItrY=;
        b=wdgcg9fvI2MmS6jDPyGZINyJN+7HbgoQcC17Z4yBnXrMgoQX1WgU+sEHFiwjjZZUoD
         c3zETHCwY5g0BBvX3/PMK6vKauyuKjwyvrnHnV1sVXadve4DQBZ1GbgCOfLx/NJAfTA8
         hM0H1BxmKn5GQhFyEGFQPM49PB0NFyCVAU1H/i+5t/8p1v/p9JEgIF3Y4Z+G7G3DF8go
         iToOT9R/ihtUZEoJ9rtGCQ4emAT281n6/+kOVJU10q+SuYCbNWSGYjpE+Q8wQ++EGJTb
         bCP4qIxQIlF0A+WHXb1eE5q8TlkPeiCB/XeYpGB0DxSC7OlzfD6YqWl3CNAKFeqaYFo9
         NnPw==
X-Gm-Message-State: ACrzQf04+9t1PnHtG+ljtU9LwVUsAK5Doxjg9A0l2Nd8718iWXsilXjf
        WtDU6DnrtC45ziLSxz2o+POyyvZt+Tm43TfG
X-Google-Smtp-Source: AMsMyM77BWnoFkIMDJ0a/SVQ92Uoe+mmugOZ5MvaWSu+GUim5B6bO/mwuqILzv+LcU6hL8tCjgrrkg==
X-Received: by 2002:a65:6bc4:0:b0:439:8ff8:e2e1 with SMTP id e4-20020a656bc4000000b004398ff8e2e1mr22321758pgw.91.1664240778865;
        Mon, 26 Sep 2022 18:06:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ij4-20020a170902ab4400b001785dddc703sm72817plb.120.2022.09.26.18.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 18:06:18 -0700 (PDT)
Message-ID: <63324c8a.170a0220.7b1f8.0375@mx.google.com>
Date:   Mon, 26 Sep 2022 18:06:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11-208-gddfc037235223
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.19.y baseline: 199 runs,
 4 regressions (v5.19.11-208-gddfc037235223)
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

stable-rc/linux-5.19.y baseline: 199 runs, 4 regressions (v5.19.11-208-gddf=
c037235223)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.11-208-gddfc037235223/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.11-208-gddfc037235223
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ddfc03723522344950fd8eddeec14bd1facf0ba5 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63321409de2a135d2bec4f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1-208-gddfc037235223/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-un=
leashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1-208-gddfc037235223/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-un=
leashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63321409de2a135d2bec4=
f1b
        new failure (last pass: v5.19.11-208-gf962b265cecbb) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63321a1d0c15c172b8ec4ec4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1-208-gddfc037235223/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ul=
p-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1-208-gddfc037235223/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ul=
p-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63321a1d0c15c172b8ec4=
ec5
        new failure (last pass: v5.19.10-40-g8d4fd61ab089) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/633216e952022ed2adec4ee1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1-208-gddfc037235223/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1-208-gddfc037235223/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633216e952022ed2adec4=
ee2
        new failure (last pass: v5.19.11) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63321bacee2815d460ec4eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1-208-gddfc037235223/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
1-208-gddfc037235223/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63321bacee2815d460ec4=
ecb
        failing since 3 days (last pass: v5.19.10-40-g8d4fd61ab089, first f=
ail: v5.19.11) =

 =20
