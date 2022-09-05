Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AD05AD5E3
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 17:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbiIEPNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 11:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238725AbiIEPMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 11:12:52 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1872E15A03
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 08:12:12 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id iw17so2128905plb.0
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 08:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=EWvXFqCBo2jXkxgaGhqZkDtCejJDUXpaGZm12BKHGTY=;
        b=VgdX3ugMgcZqc18xw8EQ1olGrEoj8rkgjFhtqVDLZlljx0rk63UXkngsAskC7ssDEV
         DadaUlFs0lNnFEbw+aq0WjBdUOBzlmGh/vrvoJVrm4rWZKhXimi56zNZMkfp0HMfJaXv
         DQLhGGWOIQISGXTpy0GvGp5hHMrhD2qxzlFHaDXUAiaBfSABPpfLrjxJ8kBucn8xhRpV
         BYkeeoMftI2C/HjRXItd9KbmI15a/GSgdEdhiDQZDsVhwPFTKYArKMSq2t81Dus8Cy75
         rCcfenGOoqwxuYhqwldMg+IOXjQOhIvt501ll/yryDF4kU3BlG10JxuGT3E6Kt01U8NS
         hL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=EWvXFqCBo2jXkxgaGhqZkDtCejJDUXpaGZm12BKHGTY=;
        b=59vgY5WdsttLQOdMkCL4X3vW4lXazsQ5pvkSVsiFjOXRP5/ftawk0NSKGWZXzYdmFu
         tn2D4axt/RzbEDcRwYXHlmuKSs7NGSmyvfjp5Vgb/163WKTjtS5W11a8bVankAscolaB
         3PA4j6nABMvJhFpFaIS+4isB2FSxAKTZXGGyNa2ai1aAiHS9TNJvyprNxl2zsG40Nzaf
         v0+A/gh4ZSOvOhG7buUTaST6aDt+wNvpdadr0/MK4bdGa13WgGRWknw7TMIM4UzWfQj2
         tfiI1nZg8Hn6NCVnoblLgreMw9zs96qysAgWMAV9h9LcO/YMtulPmpRpKdYKXv7dYnv7
         pr0g==
X-Gm-Message-State: ACgBeo0BnZlVCfG2azndw0ZRB8qH5BCoQsVgC/Pe+Dj436Dgxe+7lyEG
        0M7jpzJBMf7EPQTWh+xBOLY7gHFtoI9uS3I8pTA=
X-Google-Smtp-Source: AA6agR4uwCG3HbEp05Xr2ymAfVdz7kfpe/qviRpDMGEzsLaXKsmzyFUmkc/oqx8B+w6AhSUqzPO2XA==
X-Received: by 2002:a17:90b:3a89:b0:1fe:4d6d:bd75 with SMTP id om9-20020a17090b3a8900b001fe4d6dbd75mr20492954pjb.199.1662390731909;
        Mon, 05 Sep 2022 08:12:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a7-20020a1709027e4700b0016d8d277c02sm7724693pln.25.2022.09.05.08.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 08:12:11 -0700 (PDT)
Message-ID: <631611cb.170a0220.9e703.bceb@mx.google.com>
Date:   Mon, 05 Sep 2022 08:12:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.7
Subject: stable/linux-5.19.y baseline: 137 runs, 1 regressions (v5.19.7)
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

stable/linux-5.19.y baseline: 137 runs, 1 regressions (v5.19.7)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.7/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7d0a458e1963128ee5a85bf0584bea5e75149946 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6315de9aed6d10c9ba355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.7/ar=
m/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.7/ar=
m/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6315de9aed6d10c9ba355=
643
        failing since 18 days (last pass: v5.19.1, first fail: v5.19.2) =

 =20
