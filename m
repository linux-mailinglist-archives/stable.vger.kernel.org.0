Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9BF2591B2F
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 16:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239428AbiHMO57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 10:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238617AbiHMO56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 10:57:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7058ADF2F
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 07:57:57 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 15-20020a17090a098f00b001f305b453feso10809523pjo.1
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 07:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=FshioyBe3Ok84PAAK94AK8a0oJkboaNDaCuzrgfHC/4=;
        b=nMi5Q5nLbA+uICMqa1EYYJCWjioDcwaWv3JYjlGuzMaDtRZOlUFmwlzo50R6WQvbN5
         73JF5aMpUeTFDu8L0GYNTVdFBVKGVDgrPwumho21KCneVWuVi7Y12ZqpLFtwGuiYGRdj
         BvLiU99P3e95wgbJ/8RHsSKZl2Q/gPPkpykqufUdfFRGm5OOvaftbCfJml3tHR4hyeHU
         9ULkwlaD+d9k1U57dvBefyvSQ9HoCrptJS++2lPxoSMGIZ48p6whTMocWDb2eOT/QdEF
         criYzT3/Jq3OK87u6li/tVpTSZ5y57QrHYwsnY5OkZxXSD5K7LkhswijH0uLMp4XmWmq
         eFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=FshioyBe3Ok84PAAK94AK8a0oJkboaNDaCuzrgfHC/4=;
        b=RVPnjIyXZJRSucbDtDt89pCeG7cxrMC6tPbwBkZ1tv14HL4HJ/kVCtfcDzPgqLgIby
         8dEnyBsyoihW4MyMo+VZNoubmTb/aBopLlzg9zaTbVN0oes4MbIBXui9rGH9EB/GX6eM
         5cYrCUKscC3AYAjRiWFwIZUnQyWs0Y+lxfT8MzOnkJl+8Uyy7pvfnHMuyAX6aOFTdyuM
         3zGegirG5TQHGLJv2QQK+cP5HQCp2+I0NtHVMgzo9EMaTmCobY//64NLZAmahBcJs3wC
         32bdr6EaZAd1sBi/W7psAid4VLD7uHF3gpYI708e1czVGdn7iKMJNqKlEMinkG/MXuSb
         fftA==
X-Gm-Message-State: ACgBeo2GKpc7E8jjh8UYGel0b+EwfDVTfev7C2w3IN3KII6UnZ1yBLvH
        ex8bYaY/QjSokJe0AjaUFyaVQQnHcvO9SA93
X-Google-Smtp-Source: AA6agR5OjUtNRpQev91ehQk0f4TnESV/iansLkQVK4rSLASGImp78idi0QqbhLh+F0sPdL0wu4HYvg==
X-Received: by 2002:a17:90b:1c85:b0:1f1:d78a:512b with SMTP id oo5-20020a17090b1c8500b001f1d78a512bmr19271410pjb.92.1660402676781;
        Sat, 13 Aug 2022 07:57:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a128-20020a636686000000b004114cc062f0sm3029813pgc.65.2022.08.13.07.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 07:57:56 -0700 (PDT)
Message-ID: <62f7bbf4.630a0220.d3c4c.5401@mx.google.com>
Date:   Sat, 13 Aug 2022 07:57:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.1-62-gbac914bd6e705
Subject: stable-rc/queue/5.19 baseline: 169 runs,
 1 regressions (v5.19.1-62-gbac914bd6e705)
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

stable-rc/queue/5.19 baseline: 169 runs, 1 regressions (v5.19.1-62-gbac914b=
d6e705)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig        | regressio=
ns
-----------+------+---------------+----------+------------------+----------=
--
odroid-xu3 | arm  | lab-collabora | gcc-10   | exynos_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.1-62-gbac914bd6e705/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.1-62-gbac914bd6e705
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bac914bd6e7055c9fdca879d09d0e7f715a1af88 =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig        | regressio=
ns
-----------+------+---------------+----------+------------------+----------=
--
odroid-xu3 | arm  | lab-collabora | gcc-10   | exynos_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/62f78b248b34b3cc3bdaf0b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-6=
2-gbac914bd6e705/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-6=
2-gbac914bd6e705/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f78b248b34b3cc3bdaf=
0b5
        new failure (last pass: v5.19.1-45-gee0f76071c2b9) =

 =20
