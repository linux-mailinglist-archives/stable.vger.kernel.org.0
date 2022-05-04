Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0413751A81C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354700AbiEDRIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354538AbiEDRCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:02:50 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DDE4D601
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:52:30 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id p8so1579966pfh.8
        for <stable@vger.kernel.org>; Wed, 04 May 2022 09:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4va50iNTm1RBURibP4hs4TxgHFRZBj4FxjHDzbhndPM=;
        b=JztoLJqORSBHvQqoMjkL2s3h8ayubg0PoAYL3QEyAvbyiCvVeAALrFtQk53IOBRu0F
         C30LX0IC7IKHvj5V/OliocDPP4hNjCpsrPnyTcC9Vk/XtSZWSsP7lmotebAg2Eycrjtx
         lYlrgfoOwpcZg8pLoiGJ0bQUYkpumhD4FpedQGZ69arxtWyDW6DAFjED2Yf8J4ZVKWil
         EULxRW1Stu6hSuCc3Hq2AVsm8ORdcZEkzFhQHJYAl+M21f0ddmpnTqhy6V7NQhG1boqy
         SFrP2Ojztz+zgxyjF372iIONCsSJ+H0NMAChztCzLMRRaZg7z3RLD4zmwVV91PtB7joh
         TMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4va50iNTm1RBURibP4hs4TxgHFRZBj4FxjHDzbhndPM=;
        b=DVK8b/eD5JDR/o8KFyzXLZkLDyuxK1ZZHFOZeuNfIqP34ZClyGneK+1yv+5pyZtkoL
         tN+Mz8w4QBUp84RLm+HWkz7U2qO6tTD70W1cnFIw/ihBetztdriCazdvkw20Qkvc011x
         VHpxjxsF4SUNQ6/iZ1frUnzz9g/lGYnVJ9n8mKVmR7VsV1VgBvCkSxdNUXV1PvhGO6zw
         699ENKVrv7vUdykqLPrfQKY70qPe5OtzzVlpfaxVrLxRpypqFGPKLfcuDnnY/gFL3TD4
         t6FO7cTuYoVB1UoamXGesqxavQnu497z5nvFPQRp9gQ0ZRUkePGovqLUEhFrKq2LxJHU
         LrfQ==
X-Gm-Message-State: AOAM532cF+VSb0M2k57Jlvmk3+2LwS001ancfeJkVy9Wys+Y6Wv+7qo9
        E7BmjXtb+G1FchYAvrI1OtZMeOFrbeiduRCQtHI=
X-Google-Smtp-Source: ABdhPJyCeUuC3P1KuG6/iKmNFTiOlkobVhdOm2yIPidUeYMWtixuRg3HCH0IhVTpT6Ff2LzPLU7zfQ==
X-Received: by 2002:a63:8242:0:b0:3c2:91b4:7c61 with SMTP id w63-20020a638242000000b003c291b47c61mr5648137pgd.268.1651683149309;
        Wed, 04 May 2022 09:52:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i62-20020a639d41000000b003c14af50627sm14721254pgd.63.2022.05.04.09.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 09:52:28 -0700 (PDT)
Message-ID: <6272af4c.1c69fb81.b41cb.414b@mx.google.com>
Date:   Wed, 04 May 2022 09:52:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.113-130-g9bf02e9ae445
Subject: stable-rc/linux-5.10.y baseline: 154 runs,
 2 regressions (v5.10.113-130-g9bf02e9ae445)
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

stable-rc/linux-5.10.y baseline: 154 runs, 2 regressions (v5.10.113-130-g9b=
f02e9ae445)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.113-130-g9bf02e9ae445/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.113-130-g9bf02e9ae445
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9bf02e9ae445793d3e1cdb9129d19c5efa417ddc =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62724d287b819170b0dc7b53

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-130-g9bf02e9ae445/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-130-g9bf02e9ae445/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62724d287b819170b0dc7=
b54
        new failure (last pass: v5.10.112) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62724b826f831e9ce0dc7b4d

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-130-g9bf02e9ae445/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-130-g9bf02e9ae445/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62724b826f831e9ce0dc7b73
        failing since 57 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-05-04T09:46:27.007528  <8>[   33.115213] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-04T09:46:28.029092  /lava-6259222/1/../bin/lava-test-case   =

 =20
