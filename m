Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34D4AAB07
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 19:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbiBESrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 13:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiBESrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 13:47:05 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A53C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 10:47:03 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y9so1256661pjf.1
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 10:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TogfhCl4GaRy/hr1nHh5TTtzA/NeGrW8+KleLSPgZlU=;
        b=z4382J6IVb9z2cuv377xLmIkEUoH0+vtvm6CLQkTDbI5W8CcB0INqDGQnJsD1TCNMg
         giWjFysi2W6URakyZEmi0zZnraMcS6w96FIFJTENx1Vc5e39AN+T+h/iFypQXePhiyYd
         dBC1OFdYiDmh8WA3S5/s2ICnULSFL5dxETpIjhUCMqMEQz55GWTpoVKqFq8KaNgZHItR
         kZ3iLcE5gZAA54mmRZlk3iVRXaLXaUz0yO9f13PSXoJEdtqTjqN9u5nCI3f9eeBI/vWF
         3jPrYWWDAZUl8r9/dZDdUtSYsbj4uVB3c4ORumUixL0HK8CyEuBT1ytVLL4KLu0xsHvk
         jOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TogfhCl4GaRy/hr1nHh5TTtzA/NeGrW8+KleLSPgZlU=;
        b=GNT8hgYAULA31/oNlV5EYD5CspVpTKi1TSFnk2HAGPGmaHbdUh4lbM17w5jRjr9TiV
         mcOX4FY7GuLLol0qsW7Q1eIGBzSqffUl8xSLv1DspbzdWQnvgYnmFuMulSyHfwVhVbQC
         IiZbUfeO0t5xkOOFYMnEUq5ljekdFlNQ4Z1aZwMpmr4y6dgk3J+mUDy9cIATSzAToCrV
         54pOqDouQQUXoBoImNcSz1bZG9rK4MpgA2Is6EqZSQ3zts6XfqYo0fy5bL67/4lXlALe
         imQCHQaEIEzOF/ZThT9i54TupXL1PojJKc9YpDH7RMPKfwnMzYoULRb9a3SwpwkRNfxG
         PGtA==
X-Gm-Message-State: AOAM533SwXrpdKJ+Zucc8U2b2jahVD7DPvJIVtolqcC3dcZ+h8i+xtbb
        iWDcHIJgMTfCKe6NY4l+a0XYBsOjlY1gh3AX
X-Google-Smtp-Source: ABdhPJzJR913XXDFlJHxyilfRHBvZU4jlBaOR/iVapDKYAWLRVu+2lTEtUMyneZk4ocrGb9bF00yMw==
X-Received: by 2002:a17:903:1209:: with SMTP id l9mr9106864plh.124.1644086822658;
        Sat, 05 Feb 2022 10:47:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l26sm4369975pgm.73.2022.02.05.10.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 10:47:02 -0800 (PST)
Message-ID: <61fec626.1c69fb81.ce3fe.b196@mx.google.com>
Date:   Sat, 05 Feb 2022 10:47:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.97
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 158 runs, 1 regressions (v5.10.97)
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

stable/linux-5.10.y baseline: 158 runs, 1 regressions (v5.10.97)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.97/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c8ed22bd97d47b7803173c4e2bd3cfd52693cf7f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fe903786679a5d6c5d6efc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.97/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.97/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe903786679a5d6c5d6=
efd
        new failure (last pass: v5.10.96) =

 =20
