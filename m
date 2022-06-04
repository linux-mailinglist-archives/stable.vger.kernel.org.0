Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D644A53D422
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 02:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbiFDAst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 20:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiFDAss (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 20:48:48 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688031D0DD
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 17:48:47 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n10so8474731pjh.5
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 17:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xbrrDzVuD1GEMAURDt59a6llLFqCImULm02fposgRuE=;
        b=DMsIKehFqhpmsL6tZK7+GMFXXWMeD5621DI+OrC/uCpDW2GH3Rz+iqyKiBfRCb7yoI
         s9QsIdsPSxMS+/nDuwUCNQANdCNhahcwh2NbQc2Ln2D4ZwAwcyGiiGL3VB7ymvTR4j/Z
         EqqMOBQFqWXqs6kM53/LGvk3ZUpK/LbL7Ai9Oc4w96lkc5DsvLNiJhwG/toT0ihaTqYi
         86z3XXZ3b9fjKGqG/6R3P2Nd/D0e79xJGtdL1LdzJ9a13l3W3DY0n4i590UKTnuOOpxA
         tIY+GtZDfn67Btdzspp+RLdRtPwhfvqp2rI6dciaRawhzqJ+J2/DDmKKkzcXOHfmUuK3
         J/eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xbrrDzVuD1GEMAURDt59a6llLFqCImULm02fposgRuE=;
        b=SZcJjZyKLBJAetdBaSmuaStC7pa6v+halsQYijjQDNliLTEzapr0M7ISBNVa8CAnrn
         YutGrMf/EK8hDWoOzeRODtCpvz83JFqr9FdGrShOOziNliUtjp/nVkI/ubRJVVGAV6Ul
         D+viiEfqEiwpTj4hkWo8e1ttM0JgbgqXXto2XCusgCIy08WkYWvboKNLOIRoMaa4vVDB
         3A3xosC87L/WltOmBgn4tQEG/vvy/vEMdqcj+7bL+C4C2bApDlSpslToI5YY40ibGqgu
         1mBhWJG663XBJfhYf5YUQGkqOaIqcTNJoNFsfXk1tdPoMlau8IrmW75AfHJbbi2W4cPE
         Iymg==
X-Gm-Message-State: AOAM531zOZy9e1SdnCaFeFBOxx0xhzQsDirahNoRp5oNqci/Gyr0Tmu7
        vCGApjgckNFxFYPS210/Y1qKwkGl29YUzxlr
X-Google-Smtp-Source: ABdhPJxJhg6MTs7DZXOJ29eSt690ubV7azimlpqlHtiiBgvPot43mZb1GbG09c7/rbDNy0vQwnDVqg==
X-Received: by 2002:a17:902:ea46:b0:15d:dbc:34f2 with SMTP id r6-20020a170902ea4600b0015d0dbc34f2mr12258038plg.60.1654303726798;
        Fri, 03 Jun 2022 17:48:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902d50a00b0015ec71f72d6sm6185050plg.253.2022.06.03.17.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 17:48:46 -0700 (PDT)
Message-ID: <629aabee.1c69fb81.9e800.e05e@mx.google.com>
Date:   Fri, 03 Jun 2022 17:48:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43-213-gc5d3dc2dfc027
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 130 runs,
 2 regressions (v5.15.43-213-gc5d3dc2dfc027)
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

stable-rc/linux-5.15.y baseline: 130 runs, 2 regressions (v5.15.43-213-gc5d=
3dc2dfc027)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
jetson-tk1      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =

meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig          | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.43-213-gc5d3dc2dfc027/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.43-213-gc5d3dc2dfc027
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5d3dc2dfc027824f60e0e6913265b16296eceec =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
jetson-tk1      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/629a74d6ebd6a4e091a39c39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3-213-gc5d3dc2dfc027/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3-213-gc5d3dc2dfc027/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a74d6ebd6a4e091a39=
c3a
        failing since 11 days (last pass: v5.15.40, first fail: v5.15.41-13=
3-g03faf123d8c8) =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/629a7604632d4f0a15a39c0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3-213-gc5d3dc2dfc027/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxb=
b-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3-213-gc5d3dc2dfc027/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxb=
b-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a7604632d4f0a15a39=
c0f
        new failure (last pass: v5.15.37-314-g60041d098524) =

 =20
