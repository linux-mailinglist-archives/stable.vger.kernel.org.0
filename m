Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299E25606A4
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 18:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiF2QtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 12:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiF2Qsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 12:48:55 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71D83F884
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 09:47:33 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s206so6846123pgs.3
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 09:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+IvbG4aasysVMGzkHThgynM+lWUzWeOJ7bmpTWcHhpk=;
        b=DFocRnVbEXeLUQbni2Pqm3dGQn6u0Xqlj6Hy2MHqsF8pOwMSQFtox7EX6rtgk+Z70L
         TVf6WyYvs4zMp68UwBYUG6IejUNBHMYc4+m3qZNc+Xw1W37abYFhv9YrY3Bs4dEqRhAd
         NY/FfSKEz+iZR2kLWoMifYdB1tfQKxivp1U05b4LnDi162ycZGj8Elo/Nwf3ojExegxU
         ceXyb5gCpn5RTsucnqtH8WIovoptJHkzCjhwIHt7yifKXVpffu039EKxXA15X6mPZT7Y
         9eb5gmbPDkJheJ8UBfvUhIdkruu3DTwKI+71VCxTh38YfuCMZBn71IJ9SGXtaQ+9EEZJ
         HrHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+IvbG4aasysVMGzkHThgynM+lWUzWeOJ7bmpTWcHhpk=;
        b=ZKRk/RQtxS1Sxtz6xdAVbpcuBB+ybBV2OG2rmcM6/ex/yjaYF6nbUBfCfHQCJkyegX
         vjQRDWJxOkFxZF1fmayhOTZBQVhIERCsWFy8qPUB8V9xviqrw1E+OduXLXMRdgDAW/TV
         ZHEEPuPIbcTE9qn9aScVAU2y1IEFToZ2WYK+J3Xvl7Iz1lfqlQW8c2Gd9Z8IcST4CZDA
         YIsHxLWRG1A8aQnQQc41Wg8QCGilFzt65xW+qlvjK5745Z+V8wwgnU0jpDhifQZFZkZd
         hCWt+k9Wj34+Ho92kIuFBdmvrpy31efuxTziwI5f9byW/oywLnLHJj3AU0DtNhqg+aBR
         T27w==
X-Gm-Message-State: AJIora+0VVlusNakQW31YFS4splCf59QCr5PK5/BvxH5K5E4k/ZGLzhw
        oKnBD1DOqY2d0azS6f4LNxh1wX6qJ/XxB13JIAU=
X-Google-Smtp-Source: AGRyM1taTFYBzyo69gwGDzN42C8kLTgMKXZdFOdH40oKmUuOqb8Sf7BOuFVtJvkci0OPxOboaX43vA==
X-Received: by 2002:a05:6a02:10a:b0:3fd:da84:8859 with SMTP id bg10-20020a056a02010a00b003fdda848859mr3738427pgb.412.1656521252704;
        Wed, 29 Jun 2022 09:47:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902e14a00b0015e8d4eb273sm11551563pla.189.2022.06.29.09.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 09:47:32 -0700 (PDT)
Message-ID: <62bc8224.1c69fb81.1c4c0.044e@mx.google.com>
Date:   Wed, 29 Jun 2022 09:47:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.8
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 166 runs, 3 regressions (v5.18.8)
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

stable-rc/linux-5.18.y baseline: 166 runs, 3 regressions (v5.18.8)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2437f53721bcd154d50224acee23e7dbb8d8c62b =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62bc4dc5646759bc32a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc4dc5646759bc32a39=
bcf
        new failure (last pass: v5.18.5-154-g1fbbb68b1ca9) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62bc4c3506080c75baa39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc4c3506080c75baa39=
bdb
        failing since 15 days (last pass: v5.18.2-880-g09bf95a7c28a7, first=
 fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62bc6c969a6da2954ea39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc6c969a6da2954ea39=
bd1
        failing since 16 days (last pass: v5.18.2-880-g09bf95a7c28a7, first=
 fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =20
