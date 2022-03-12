Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EC74D714F
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 23:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiCLWt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 17:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiCLWt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 17:49:57 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A2C996BB
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 14:48:51 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id rm8-20020a17090b3ec800b001c55791fdb1so3453252pjb.1
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 14:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BHs6YZn20HCV1dB/UJpijHnBQ71hEyqmg7kyGTtdyvY=;
        b=OR4zluIzxTv97whVPcNQi5q3i2c/FXZ19kIWYrONNcWd+5Xq4Uf8xD/QCGLp9T/DGw
         M9ETAr+lkwL2gELjtjprzGJBNTz3bPgT83dDTyb98e10cZZ148btsq3MqYAdACDQnOR8
         ty6cCNhvXnvAi2MztIh4AvfM8czYXDlmidTp8uS3XKdmOOvQm5zlcnAr5j/57Z75OybV
         6xzv1qqGvW80d21ignc/LmhdWfaZMVIG4Z5mHtc8pDDWdvCfmVYE2GBFdbSFi3sCKOMX
         t/ryCndz1d/1fY8g0l6Id5JEJFqNCz24jOwqTbqw5kFwYZrU0013p13IJegnI29RbBl1
         Yk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BHs6YZn20HCV1dB/UJpijHnBQ71hEyqmg7kyGTtdyvY=;
        b=5LbeeJISubSpmwyq+pdEZi2pForrmZLWIZoDzqmLNu9VGlBzRkTFVsjPryWN8plrYY
         U6L27Upo357q/z7rwBC2joGWdB2eqiGxwjhlwES1Hq3B6GbrSD+1JEgOa05YXRN9C0Ds
         2lRfbuYEon97WylcNcD9ca8QDsqeT0bu6frl3WVGtg1GVaQELL876Wym9XlAqAmCMucw
         1HH1wm0IjpI7cCu2mEa7WhX2Dg4hJxYVGf1uwBr8I4tOhLYMbdjiKxzLwCSbBdRHQNJI
         UUX6gYN4jn1pkCJAQWg13tqP4pB3v7jQvYv/c4z2KGwS937gnBnhW9Va2Mn9AHxiaQ0l
         ogwg==
X-Gm-Message-State: AOAM533OHU9/lvsIadYvCGqSgIAZwG2uvI6DZNaKiq7mgxQX4/VGyW5l
        KI2dVz36cm/EenpynBuzBZ647Xdtbe2yzMs3zT8=
X-Google-Smtp-Source: ABdhPJyM04r5GvY1tK53CSBFezmq6cj04CmEKIooX703kgMVh5AutFJoFo9l+3+q11sWVw5tvZ65lQ==
X-Received: by 2002:a17:903:230c:b0:151:93d0:5608 with SMTP id d12-20020a170903230c00b0015193d05608mr16687578plh.167.1647125330334;
        Sat, 12 Mar 2022 14:48:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm16452226pjb.4.2022.03.12.14.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 14:48:49 -0800 (PST)
Message-ID: <622d2351.1c69fb81.b9c50.9740@mx.google.com>
Date:   Sat, 12 Mar 2022 14:48:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.14
Subject: stable-rc/linux-5.16.y baseline: 92 runs, 3 regressions (v5.16.14)
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

stable-rc/linux-5.16.y baseline: 92 runs, 3 regressions (v5.16.14)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
kontron-pitx-imx8m   | arm64 | lab-kontron   | gcc-10   | defconfig        =
          | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3cfa7ce38ae6c2c8e57201e2978178c42051defb =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
kontron-pitx-imx8m   | arm64 | lab-kontron   | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/622ced91afbbdb427dc62969

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/622=
ced92afbbdb427dc62980
        new failure (last pass: v5.16.13-54-g8a3839d7a6f3)

    2022-03-12T18:59:15.420003  /lava-98239/1/../bin/lava-test-case
    2022-03-12T18:59:15.420449  <8>[   11.360695] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-03-12T18:59:15.420648  /lava-98239/1/../bin/lava-test-case
    2022-03-12T18:59:15.420887  <8>[   11.380742] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-03-12T18:59:15.421066  /lava-98239/1/../bin/lava-test-case
    2022-03-12T18:59:15.421292  <8>[   11.402156] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-03-12T18:59:15.421469  /lava-98239/1/../bin/lava-test-case   =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/622cefb57a81233b75c629aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622cefb57a81233b75c62=
9ab
        new failure (last pass: v5.16.13-54-g8a3839d7a6f3) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622cee07f9ffc15aaec6298e

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622cee07f9ffc15aaec629b4
        failing since 6 days (last pass: v5.16.12, first fail: v5.16.12-166=
-g373826da847f)

    2022-03-12T19:01:13.175864  <8>[   32.317833] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-12T19:01:14.202293  /lava-5867148/1/../bin/lava-test-case
    2022-03-12T19:01:14.212936  <8>[   33.356380] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
