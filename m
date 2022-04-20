Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE7A508A8C
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 16:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379404AbiDTOTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 10:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380244AbiDTOSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 10:18:45 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FEA4553E
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 07:14:22 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso5061981pjb.5
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 07:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ubb920doRXvVsyBOlnzbB4I4urXuUCO+kxGQTCAJSGQ=;
        b=iQ8mB6oi6EnByjyTzVhIMn7lFmreyLzxInTTI71Kz+UTXZV8CHiUThGYbfbXc1Owr0
         kIsHbPNTbln0DbD8iW2v8e/53Da0NUxNOGQVuJkTyjgAemYLkxyZAlEOO8owgqLpLXEB
         MpgTVwNhHzt6ktdFqzR73qzzvK9FcotJgl5DtbTsMrKvT+hFOFElOLskkPjAp4eSUUFb
         sau/+c7VQnWukgaades0WVEboVx3HmOl6yWrtKF37fYxQG597agxo+Sb1pcwSv9Tqfrb
         jPqnqoCZgYe3c7lLYv1c+tVsbbQreQQOxoubaiiZ0yu4k5OYbm7EjZjrFSLCh7mFGTLr
         TUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ubb920doRXvVsyBOlnzbB4I4urXuUCO+kxGQTCAJSGQ=;
        b=VNuh/5PK2ZwojsaG5UiARfBj3EDY8WcbBiO0bGmumAsGCTyU0uqaowupH1KQjAPDZj
         8mJ2Ucx+wWcMnlihOP2klZyYWSVAcEucJsSU2NMHkM42TgJJ+8ov6tno0T5gwmzUoiUe
         qjndIOJ4T5KNulC8grfhqdaGd3CJMX1MJUS9ZC1DlX7WqBNdD0jrbzAvSgHA2POZRm6P
         vaxg/AkCqf4rDJjzIJ95Oqqw5ZI/0Lpv9CtfYfw/q1bKsLvyG2icn4o/QJkcfUiAoua6
         CdYXhQEh+V3agf+EHKsNs+huCXwUiebmbQNdePeWjBIWseOBoetNi7vMD5pli/lCvmpB
         iovA==
X-Gm-Message-State: AOAM5323mtaqGnBBDJF5BTrAjZao8p8TZXstasjukxct7OgJJF3CpinQ
        zQTGLFD4RHreizzsKZWXY18fen71gdTq+ChH
X-Google-Smtp-Source: ABdhPJzOC5A97YliYnHVTv+qzfu091VBrniIyItjdoRnJJ+O9XX2psKXzJFCK/jOgsTbR/lPxtIziA==
X-Received: by 2002:a17:90b:3e83:b0:1d2:edd3:5639 with SMTP id rj3-20020a17090b3e8300b001d2edd35639mr4687429pjb.183.1650464061393;
        Wed, 20 Apr 2022 07:14:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f771b48736sm21532844pfj.194.2022.04.20.07.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:14:20 -0700 (PDT)
Message-ID: <6260153c.1c69fb81.1e2ab.1b1b@mx.google.com>
Date:   Wed, 20 Apr 2022 07:14:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.239
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 109 runs, 3 regressions (v4.19.239)
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

stable-rc/linux-4.19.y baseline: 109 runs, 3 regressions (v4.19.239)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.239/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.239
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eadf658bb74981dd2509d9e1863574b9f0f90fff =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625fe6a31de763c934ae068f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
39/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
39/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fe6a31de763c934ae0=
690
        failing since 14 days (last pass: v4.19.235-23-g354b947849d2, first=
 fail: v4.19.235-58-ga78343b23cae) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625fe6de5809e606a4ae074c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
39/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
39/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fe6de5809e606a4ae0=
74d
        failing since 8 days (last pass: v4.19.234-30-g4401d649cac2, first =
fail: v4.19.237) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625fe55bddf88229f5ae067e

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
39/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
39/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625fe55bddf88229f5ae06a0
        failing since 44 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-04-20T10:49:52.252331  /lava-6130234/1/../bin/lava-test-case   =

 =20
