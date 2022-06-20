Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017B8552644
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 23:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbiFTVJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 17:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiFTVJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 17:09:32 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B7EB6C
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 14:09:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d5so10762607plo.12
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 14:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cn8uEfcl8ReDzwdo46GMBc+SgxBriTAoFZm+BfBwsVQ=;
        b=cV8cCLkg6pnmAQVMgRJ1BT9XnfyrWE58/tkrHOIZCXiMJ1bkIOgvKDGFv+RGyMEHQz
         rTaoIXVB5DP2qCf0IaAl4wMvpz9+u94noeANkNFRQIxB1lhObT4JV5b2m9UBusNWINUq
         dAp3F/qaNgJS+enHBJjEdpABC5bYHvyLa/sEpk39o1VSm1VW+N4A5bSgxK5oySbaUzOY
         2uDKtvhAKbAuAaNeF6IwIE7ZnMVLnqqC1gWuLHskVUW5zD3aEQmZ0qRUIT6CCvA/EvOH
         QdTyQ8hmhxyPHL6Yexdbz0xuz8cyN1ilkdO3mMnL0bvoiNNOP5xD87K+3IU5NJ5Iu/R/
         uQ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cn8uEfcl8ReDzwdo46GMBc+SgxBriTAoFZm+BfBwsVQ=;
        b=ZFOGqVDl49WE6O2auY0u6vjiTy+tUcLM4Y39fynJNn1h8kOGBi9UKOuFeLl9q/j5xm
         fCesCcZhVcDFdvZY0VOHyRf/4Ai4S2VMcQ+fANIVB0wLeBANOgKlhyOs4xznHuHEBV4Y
         9SePrW2kQW+Cn2H9YIim5tp3XIGIWe9NjvV03JA+JOk7dDmagw1AVcgHTVTGppEkvQIX
         u8Ym+kzir63nCKWyMmz+5Wu2/AJ+yAmycgbIz9lRpOaN4VXvL/QdFdGkSN5GHyPeJ9/a
         HmLKjWBndaQMgPNKHknoSH7K+t1NS8ukHRVUKJkxBLQ0MjLC2WLLuBdpilgm4IFZYfN7
         gynA==
X-Gm-Message-State: AJIora/pENbWBdFPoMCNkCFiKa8I6lpIK8NbYDIz79U0XTT3yBNZgHtN
        bNMr56PCsBCjrSQxyvUZ04f1+9pebRNb/wa1pjo=
X-Google-Smtp-Source: AGRyM1sPevt+0goLZVfRIn0cKOn/rLUWNjryJZDRo/Mylrksn4z9Jo6JvnqQanU16tUNjjlWP7Pijw==
X-Received: by 2002:a17:90b:2251:b0:1e6:76a8:44f3 with SMTP id hk17-20020a17090b225100b001e676a844f3mr40752620pjb.71.1655759370118;
        Mon, 20 Jun 2022 14:09:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w9-20020a639349000000b003fc5fd21752sm9606196pgm.50.2022.06.20.14.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 14:09:29 -0700 (PDT)
Message-ID: <62b0e209.1c69fb81.45afc.d303@mx.google.com>
Date:   Mon, 20 Jun 2022 14:09:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.48-107-g3797b8fe60254
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 35 runs,
 2 regressions (v5.15.48-107-g3797b8fe60254)
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

stable-rc/linux-5.15.y baseline: 35 runs, 2 regressions (v5.15.48-107-g3797=
b8fe60254)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.48-107-g3797b8fe60254/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.48-107-g3797b8fe60254
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3797b8fe60254ac3f5306d5e452b088e9d57f180 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0acb3947242b797a39c40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8-107-g3797b8fe60254/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8-107-g3797b8fe60254/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0acb3947242b797a39=
c41
        failing since 39 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0ad4d16830ed2b2a39bd2

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8-107-g3797b8fe60254/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8-107-g3797b8fe60254/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62b0ad4e16830ed2b2a39bf4
        failing since 104 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-06-20T17:24:02.705998  <8>[   32.665066] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-06-20T17:24:03.731206  /lava-6654404/1/../bin/lava-test-case   =

 =20
