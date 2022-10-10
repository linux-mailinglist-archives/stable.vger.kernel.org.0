Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5725F9652
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbiJJAdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiJJAc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:32:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB0931344
        for <stable@vger.kernel.org>; Sun,  9 Oct 2022 17:07:31 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c24so9033540plo.3
        for <stable@vger.kernel.org>; Sun, 09 Oct 2022 17:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=w/wR+pBQrEOlT8JTF7LAQY7aE60K6gP2zgYOmiPuLiw=;
        b=vsDAUsRgIkrHkbiG8VPVVaGg6hiNt9zuVzBhytEzI6xzFyx6clJIcS/uKojm0OlmOi
         8TkEWyenFX+mDXN56gFg1ulcI9aLCG+KLef+K0vE5K/pRjEa4P+3JCcGOck47YV10j2Z
         /zmNp+qNfXgP8+19iuEum9IyaokDpmwW+dx3cqe7mu7imkmxijehjdu7j2x9Ndl6JCoD
         Crm1YvAjTaD8OVNg7ctuBLac2ivypGeVW6Iejcu38NlqtcUkrNnlIJviyE9LFuQ/T+Gs
         hjQh9iECPvPu4qWyN4+H5IICQQFktKYh6Gc6LxaFRgLn3DcweIadbVHVfMRaFm53VLcG
         c7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w/wR+pBQrEOlT8JTF7LAQY7aE60K6gP2zgYOmiPuLiw=;
        b=tRZme0lJs1PIaOEBnItsRmQDwIYoejmmV5WtO32EJWfVAq4sQRzCLEMYvZICYWcVc1
         Sokpo+4m4gwYn35BYXvP1YXeVsWyJ2YYjfvGcMMYxoJmf1llDprVz0VDBeyxOmOAl0oL
         rrdLIKR6xVQCEQCObAuR9tM25P4GTahqxO7owc+p4q0TWR8QKd7+g0n75o81HY+wel2f
         8IGNLf2yDUpjAg21ltsPI33/GgZFm6KgMudlycaDywrGn5iGzBLG6Whi5Vp46P5Ivbvh
         0QrykeOja858JG302PAQZvL37WorcU6c3l4RhZ+BRWDogc7+jioc/4Z10Q+bp8rMJoQA
         uEbQ==
X-Gm-Message-State: ACrzQf30WyMWnEzZtFWwpdlVh3qT1QzArLO3iEh93OEbWwBxPdi5/fkx
        ppYdbw5VgKI7qSBllKSjn3QV+WTX61/V/SGGue8=
X-Google-Smtp-Source: AMsMyM6H6+WQwguupWXWd6C6BOi6XaXrBVuDroj82+pVLqbgHTksNDenzfTpjUTO/V+cef9alBuOSA==
X-Received: by 2002:a17:903:2c2:b0:182:df88:e6d3 with SMTP id s2-20020a17090302c200b00182df88e6d3mr234787plk.81.1665360451293;
        Sun, 09 Oct 2022 17:07:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s33-20020a17090a69a400b0020aacde1964sm7958841pjj.32.2022.10.09.17.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Oct 2022 17:07:30 -0700 (PDT)
Message-ID: <63436242.170a0220.ba797.dea9@mx.google.com>
Date:   Sun, 09 Oct 2022 17:07:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.14-39-g57fa2dcf24d2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 157 runs,
 4 regressions (v5.19.14-39-g57fa2dcf24d2)
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

stable-rc/queue/5.19 baseline: 157 runs, 4 regressions (v5.19.14-39-g57fa2d=
cf24d2)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
hifive-unleashed-a00    | riscv | lab-baylibre  | gcc-10   | defconfig     =
             | 1          =

imx7ulp-evk             | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defc=
onfig        | 1          =

mt8173-elm-hana         | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.14-39-g57fa2dcf24d2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.14-39-g57fa2dcf24d2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      57fa2dcf24d2de1b228789489dbe06807fa001aa =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
hifive-unleashed-a00    | riscv | lab-baylibre  | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/63432d6359781a3ecdcab63e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
39-g57fa2dcf24d2/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
39-g57fa2dcf24d2/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63432d6359781a3ecdcab=
63f
        failing since 6 days (last pass: v5.19.11-208-g633f59cac516, first =
fail: v5.19.12-101-g42662133e9bdb) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
imx7ulp-evk             | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defc=
onfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/634332209305d774f7cab615

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
39-g57fa2dcf24d2/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
39-g57fa2dcf24d2/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634332209305d774f7cab=
616
        failing since 14 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-186-ge96864168d41) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
mt8173-elm-hana         | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634330b9ad047382afcab5f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
39-g57fa2dcf24d2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
39-g57fa2dcf24d2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634330b9ad047382afcab=
5f1
        new failure (last pass: v5.19.14-7-gf73a6cd88959d) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/6343316b13797612fccab5f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
39-g57fa2dcf24d2/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
39-g57fa2dcf24d2/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343316b13797612fccab=
5fa
        new failure (last pass: v5.19.12-116-g5104816afb77d) =

 =20
