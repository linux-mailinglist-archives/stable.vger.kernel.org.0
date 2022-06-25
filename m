Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21D855A9FC
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 14:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiFYMfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 08:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiFYMfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 08:35:11 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA001F2F2
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 05:35:08 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so8089052pjl.5
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 05:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PtoP6UqClNmPXcw8qZjhEX3x+lwDm5qYn+wvByZoYfs=;
        b=6a53EpALjYs1fhWozKaHHcxXoJi/3ZAsr5H+Lf49z07hEQXeJnv7rZjNa8OjUWS+5t
         PPBgdTjN8U9F1D61QBwE00e2tucLNrmah1vTeRmcQ8lXO8aliSy+TC0Dnge0v/G8FvxX
         1wV0H8AQXAnQohZvfvEA1Pe5QbbhgvyDHVsEQOYnOM4kaHjescjGdmxCgeh4cxPJ7IcO
         wJ25uXsRyXSO263vzeU/OBICXhfaFRK5Z9LZ92nBGqi51vdDl6O/Np4dgWHpFGv1seJ9
         TWgs5db96UgovIgWiubhNbne34JX2RJkfhwySkGfWrV/HuPZdFpJCVkmpZ7/nxTTdDqR
         Aiog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PtoP6UqClNmPXcw8qZjhEX3x+lwDm5qYn+wvByZoYfs=;
        b=2dmFp2KRc+WPOmuUIgYQHbYZb2YEzaXgLGjfhp+okAZF2ylFBvsRGOa1bZYnA1T7DT
         +OB+iI7Ngo5mPj1kaf1ADKl/73osef9UDlkqlATEYtmf1rZYC8BjMfhT4gB8QUWnb5gl
         LZsGJMSaf+R6OA6x3+TO8LksMoYbuPH0yVNUDZ55RBMDDlIia3czhTO/gvbOtXQSGAXF
         nwAHIdgWKHnezxfUqz/3rN5ue644I4XIct5CAaHq2e/CzI3AUzRDtLLYUQb2xbaeqg9M
         Oe/OLx4CKwF1rH/alPHF0EvGGFlJF+kHbqgaUCBi9zRkQsnvXDDCbQgSnYnLnM44yDCK
         Z3og==
X-Gm-Message-State: AJIora9emoRKTnnYQ78WW1qr/EFVD9eMaYoSxBUSxhZ3vTjlu6npIMzp
        1VxkKhU3xUYXN6g9Z+CL0MSYYjXVVQ9xeji3
X-Google-Smtp-Source: AGRyM1vqY+g1NbiHYogC1MoT3j8gneFt66/uh9N1uyFkX855T41XWDZCOPfkRw6FI2QmkObiHWr62g==
X-Received: by 2002:a17:902:e746:b0:16a:3b5c:2134 with SMTP id p6-20020a170902e74600b0016a3b5c2134mr4445616plf.36.1656160507603;
        Sat, 25 Jun 2022 05:35:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090abc4500b001ea629a431bsm3479859pjv.8.2022.06.25.05.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 05:35:07 -0700 (PDT)
Message-ID: <62b700fb.1c69fb81.436c2.4f97@mx.google.com>
Date:   Sat, 25 Jun 2022 05:35:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.48-116-gadd0aacf730e
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 129 runs,
 2 regressions (v5.15.48-116-gadd0aacf730e)
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

stable-rc/linux-5.15.y baseline: 129 runs, 2 regressions (v5.15.48-116-gadd=
0aacf730e)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.48-116-gadd0aacf730e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.48-116-gadd0aacf730e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      add0aacf730e0bba8de6382b896a9a55b022cb59 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b6cd628706e19a12a39bfc

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8-116-gadd0aacf730e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8-116-gadd0aacf730e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62b6cd628706e19a12a39c1e
        failing since 109 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-06-25T08:54:39.923062  /lava-6682801/1/../bin/lava-test-case
    2022-06-25T08:54:39.933955  <8>[   60.899812] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62b6fabbcc8d7024d2a39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8-116-gadd0aacf730e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-te=
gra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8-116-gadd0aacf730e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-te=
gra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b6fabbcc8d7024d2a39=
be5
        failing since 30 days (last pass: v5.15.41-133-g03faf123d8c8, first=
 fail: v5.15.42) =

 =20
