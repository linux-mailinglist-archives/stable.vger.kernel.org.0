Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6794FF8D6
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbiDMOW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 10:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236188AbiDMOWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 10:22:47 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D2737012
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:20:26 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v12so2103923plv.4
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Dm8ObPNTwixir73pn2r+72ozScdCw37QgOZwPlSvqtY=;
        b=X9UZ5pc1QQyw95XCTloqP7SPJonye6PTlO30CcETzuNIEJp1LQcX83ThnMp4taP60d
         HarTx3hX1vCfA60HqT9AT7WRmIRH7yKBGSPdBGcvB/gPF7MukyynwDo3xWZAO1wiM47H
         qhnY4TJ6l7qxg2iWfL4s/Vx5EzQZpAVe6tRHTt7z2z25Bo82XCXfnhHN7yhiaZC6SQwa
         DgnKwt3wIUBnXeAjsOP45N3CVdjrogtyiVb9VIDXtIgpI8hLaRq4hfGEL9LUo7vI8igS
         UC/AZvJ2eAwCv/bHRTl2vM4apLHstTIggcpjfnSyl0/jfS8IQSeL2dnBWIT05vCRLTmt
         XBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Dm8ObPNTwixir73pn2r+72ozScdCw37QgOZwPlSvqtY=;
        b=zvhOdCACrPdCfFDxJe3f0h9rzNO8m2snk2e0ZqYFYP+6ln3fsfA6cvscSHZNsm2eHI
         C8I4Tqe4kH3QiSJkg+s+B4Cqey0TKEGhSzZnfuVMPIjwpAwU3I7HnKWmSS3hXbe/ckQe
         pTIN20Rl8LVQokCVSlCuIpoNL6Wilpy1jP/ZybqJNWKP8AZI8szXB+/hx2+oH74NJvHy
         2vhiEPrSv19fSgBoGXSjSBJAirBb1ny1MkE2l5oJUeHays4mob1dTw54avZt3F5SVGXM
         g4A9pb9w0bz3+86d7oDJwGbqAAgcICBTXhZcTHZez4NEa9zhorNjxdJYbdBKx5Ob0yB6
         kRdQ==
X-Gm-Message-State: AOAM530SMaOL+j8ph0jhFj66jdCj93xPALugLswyaXhrqbuJbAJo389+
        D+kkobaM3v0KcQNk6iYxHWHadHruP5/SrnzY
X-Google-Smtp-Source: ABdhPJyNOBUYQs7LhzcP6OkGiPqpWt6CIfKnmxVJ0mg4FtzN/fI2wv06x6tZYQWQv/O15n/L7vfrxA==
X-Received: by 2002:a17:902:c215:b0:14f:f1c2:9fe3 with SMTP id 21-20020a170902c21500b0014ff1c29fe3mr42841578pll.145.1649859625411;
        Wed, 13 Apr 2022 07:20:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15-20020a056a001d8f00b004fda37855ddsm40250094pfw.168.2022.04.13.07.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:20:25 -0700 (PDT)
Message-ID: <6256dc29.1c69fb81.911b7.9f39@mx.google.com>
Date:   Wed, 13 Apr 2022 07:20:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.275-261-g00d64614879f
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 90 runs,
 2 regressions (v4.14.275-261-g00d64614879f)
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

stable-rc/linux-4.14.y baseline: 90 runs, 2 regressions (v4.14.275-261-g00d=
64614879f)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =

meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.275-261-g00d64614879f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.275-261-g00d64614879f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      00d64614879ffe209b04700f240f627c44cd5af8 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6256acce61835048fdae06aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75-261-g00d64614879f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75-261-g00d64614879f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256acce61835048fdae0=
6ab
        failing since 6 days (last pass: v4.14.271-23-ge991f498ccbf, first =
fail: v4.14.275-206-ge3a5894d7697d) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6256a6bf883505bbb8ae068a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75-261-g00d64614879f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-me=
son8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75-261-g00d64614879f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-me=
son8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256a6bf883505bbb8ae0=
68b
        failing since 57 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
