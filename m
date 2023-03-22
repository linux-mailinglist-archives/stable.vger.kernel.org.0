Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244566C5890
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 22:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCVVKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 17:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCVVKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 17:10:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC00823129
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 14:10:37 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso20426789pjb.2
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 14:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679519437;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bpAqlJYzPoGGAAnJtCUo5H99EgCwWFWDglaYgnnqiF4=;
        b=v5D4tX3uTcMboDb9atTfFkCfYteBANQuxdDl9XF2UUoKmbMVFOLKHoL1qRP9UXenBb
         Raw4t5h2vx0Wey5/8PERses0eGvUrLNJT2B7YRzYc4oQkFmQrTliMC5h9lNJeXv0QNR+
         4aDRrCg3HT7SULY5nmw0qu3BkJlFqVkyI3FehzRGvZ7I9+ZaRvyFLi7HtUA2XIKYhkX6
         7g+T8cHpSrF0xENA9HOC2dweAkwjRLk4TB1Wg7cKZqyLSQFIVdtLRnPvHKPRbIJCLAPM
         LJG/uAOeZlqzsxyZv2E8mztFCnh9VzBmZN2Sjq9L96a08siVFaA2/g00kQhpHlKjeqwX
         KCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679519437;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bpAqlJYzPoGGAAnJtCUo5H99EgCwWFWDglaYgnnqiF4=;
        b=Fiv2AVkHxG+5+5ddXgb+W1x8IyWs8018/9IIcUdLkO8cwK98nNowbGSsKWi7oo8IV9
         fjYD84C3d5QGaF3Ymvk1lvpg9BgbXA3Yni41kBoV4ireM/8nZVecTuq1Qqm7wnSGVEh5
         ywvnrk7JT/xzI1dJlqkemUplRGTPYfvjNNa6ccxMod39pXs3rHlz1GWgq+hqE4A3u0Hy
         CAwy/lu7KpjSYEnjbm+mNwAkPbheDueAs6eW67I8E6biEmBEqGzwgRXJZzu6qVeInGBu
         OWdauJjMGWYsKwhfO5R2siuLwF3vzZutaRWrf4vsS7PQJLTp8csPxUzBesTEQaTc50BM
         G9dg==
X-Gm-Message-State: AO0yUKWe7FlaPsnmRrEaC15MA6U+lrri7HRslhvsYIt8QA7aiHzMsrsj
        rz+uNURel9Dv1NR+92eEgVwKiIw+CkAz6rV+euWP5A==
X-Google-Smtp-Source: AK7set8ExV+kOPKbgZDsnl8jbrhWPOc/XBGSw7zX3kLWVeYAzoJrXlrqHWlkA5luM6ZgfTq7+9facw==
X-Received: by 2002:a17:90b:164f:b0:233:f98a:8513 with SMTP id il15-20020a17090b164f00b00233f98a8513mr5790689pjb.8.1679519437032;
        Wed, 22 Mar 2023 14:10:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nm4-20020a17090b19c400b002349fcf17f8sm13772292pjb.15.2023.03.22.14.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 14:10:36 -0700 (PDT)
Message-ID: <641b6ecc.170a0220.bd5e4.9c34@mx.google.com>
Date:   Wed, 22 Mar 2023 14:10:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104
Subject: stable/linux-5.15.y baseline: 242 runs, 2 regressions (v5.15.104)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 242 runs, 2 regressions (v5.15.104)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig             =
       | regressions
----------------+-------+---------------+----------+-----------------------=
-------+------------
cubietruck      | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig    =
       | 1          =

mt8173-elm-hana | arm64 | lab-collabora | gcc-10   | defconfig+arm...ok+kse=
lftest | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.104/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.104
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      115472395b0a9ea522ba0e106d6dfd7a73df8ba6 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig             =
       | regressions
----------------+-------+---------------+----------+-----------------------=
-------+------------
cubietruck      | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/641b3b43e5cdae847e9c9506

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.104/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.104/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b3b43e5cdae847e9c950f
        failing since 62 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-03-22T17:30:30.783832  <8>[   10.000164] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3435696_1.5.2.4.1>
    2023-03-22T17:30:30.894945  / # #
    2023-03-22T17:30:30.997010  export SHELL=3D/bin/sh
    2023-03-22T17:30:30.998433  #
    2023-03-22T17:30:31.101186  / # export SHELL=3D/bin/sh. /lava-3435696/e=
nvironment
    2023-03-22T17:30:31.102304  =

    2023-03-22T17:30:31.204750  / # . /lava-3435696/environment/lava-343569=
6/bin/lava-test-runner /lava-3435696/1
    2023-03-22T17:30:31.206290  =

    2023-03-22T17:30:31.213411  / # /lava-3435696/bin/lava-test-runner /lav=
a-3435696/1<3>[   10.433584] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-22T17:30:31.214121   =

    ... (12 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig             =
       | regressions
----------------+-------+---------------+----------+-----------------------=
-------+------------
mt8173-elm-hana | arm64 | lab-collabora | gcc-10   | defconfig+arm...ok+kse=
lftest | 1          =


  Details:     https://kernelci.org/test/plan/id/641b3d34ca5d61ac2a9c9551

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.104/=
arm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt=
8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.104/=
arm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt=
8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641b3d34ca5d61ac2a9c9=
552
        failing since 57 days (last pass: v5.15.89, first fail: v5.15.90) =

 =20
