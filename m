Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CF759CDF9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 03:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiHWBkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 21:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiHWBkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 21:40:11 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DB51BEBF
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 18:40:11 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id f21so12687309pjt.2
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 18:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=rPD361ZYSnPKcnHiIccWQ3d1/LQ4SXbOPZEB4L1YTHg=;
        b=RyTDPxj2wYx8T7QePUqETbE+puFPN5pspS/Hv+vS0HlHkkGg30lZUXn4NqSetIa0WX
         y7eEdHLd4eaDnPhTwSti2PbpeYcM9k2a3zHUdrslDbVy5YgLMaix2wlcA7uoJMontLxB
         i+gHPjnq1AAblOH1DbdL0mVPQ5lXovw/kykTpKu43bfFpCYZzCiPbBU+NV4ei8cF5Jot
         OkvDezH8DCbXxXp7ETbpnee/FHW1ap14o27/OX7tG1piVLvFx+jWbvxhGtJYUqjHzL/J
         3evnkZS/CW+L+TSn5hAEAA2kW63OOmcM21lUsTAgvTXZ093u3T8mVoArJs2R30U8C2nU
         SbUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=rPD361ZYSnPKcnHiIccWQ3d1/LQ4SXbOPZEB4L1YTHg=;
        b=NdVPtM4lS0hBPSrhpwbn1tDjWTfzMgMCTVj0qe1TeR4lmivsQEsY2y1GKoFOPftZ7D
         iOFsA2stv7LEbzLbCG79YyUAxbppkqvH4B3LRJn4buhgwYNa/nx1qkdW2dij2LRM5Pju
         OBJO3sRuQWX/y+DiumSffCXy80FI/vB2Q1jnOJYZr3B0dgnSjFpSoupzel+q3SOHhioS
         67kPnbgyOulpLkGG9mVeTbKl4ffFl/CkZ9/pzTqn56IxI/R0XTqXGQqnh6ghSgjFWB6W
         Y2oJlXxKVeq8GbpWXl1Y9n801TR7s5A1e19q4M5JMQlIPAG8BHF3Q2V+ziz+FmMLtDhb
         XcKA==
X-Gm-Message-State: ACgBeo2Vr5+vCM2QaV2n1/pZCXDxfORRMN4uZ13h6kZVrRwVXXSYhS6x
        xQ3rZ4/4t4B1cMzEH2ZLE8NHTmvjCjQlSsfw
X-Google-Smtp-Source: AA6agR48F4sSc3oLDCNiNbFI4UIQaABwP8kkFHp7m+6Ba25l+IqWDKecYviOQqcuhBDFDaQx+LHWWw==
X-Received: by 2002:a17:902:b20a:b0:172:7385:ea63 with SMTP id t10-20020a170902b20a00b001727385ea63mr22620145plr.54.1661218810513;
        Mon, 22 Aug 2022 18:40:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i13-20020a17090a2acd00b001fb277223bdsm2939554pjg.2.2022.08.22.18.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 18:40:10 -0700 (PDT)
Message-ID: <63042ffa.170a0220.4b08f.5244@mx.google.com>
Date:   Mon, 22 Aug 2022 18:40:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19
Subject: stable/linux-5.18.y baseline: 120 runs, 2 regressions (v5.18.19)
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

stable/linux-5.18.y baseline: 120 runs, 2 regressions (v5.18.19)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

panda              | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.19/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      22a992953741ad79c07890d3f4104585e52ef26b =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/63041da69ebcc423ea35567d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.19/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.19/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63041da69ebcc423ea355=
67e
        failing since 38 days (last pass: v5.18.11, first fail: v5.18.12) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
panda              | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/63042dfb0831448269355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.19/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.19/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63042dfc0831448269355=
672
        failing since 5 days (last pass: v5.18.17, first fail: v5.18.18) =

 =20
