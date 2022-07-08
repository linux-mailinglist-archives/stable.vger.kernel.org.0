Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E382656C345
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbiGHTQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 15:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGHTQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 15:16:15 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88714507A
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 12:16:14 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p16so2372465plo.0
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 12:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XmiD6v9Q/suOfNP9kdEhLLDHVj8v0vQ0WZzBUeKI7y8=;
        b=8HKT9roMug3LEHZLJwQiYlAC6OQpCG/QimpZfz/+Hn3yn5JTAMTHeoYsMVq2VfrmOc
         Ox7p9PtR0FEo1ljB4O0GhyS8l0wY28S1242tVaRxcUHDzuNepiW1lKyatHp1sPwebwmP
         hlTldgSmX59hViEAYnBh2W5OHwjfoQWMxnRqeSI8fzgHHu2ZVgfDYP3e2wlDHoeskGOQ
         vrHoZjQH1t0zsnkJncW+bMJRWoS4Rdd1NIF3V32we/SiAAabpMrxIBBPtLfyZD/sPKF1
         WVXBCfs51ewdlVmvlJDF3+PaLv4fdaZq7vcvhmO2dTmOvK7aVVcUROeDLXSq5Mls2iOB
         MZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XmiD6v9Q/suOfNP9kdEhLLDHVj8v0vQ0WZzBUeKI7y8=;
        b=JBCOvjDtztPY8o0zmbPUYEuwg1wOAX1+saHS3wK6SpBSIuvR8katR3Mq+oOzTPD34+
         tJUoKcQzN1GdkvSAC8376KrbU4938hgBfi4lsFy99ST6b/OvcEwRAXyFMYdI1twDc7vG
         HAv5MJbfH6k4dKcwOeiXzaje9x5Dct1caNYLIbhU+thrvhwXOWCW/bRnjg4YQHFOHpYa
         goaA6rgoAfViW/JD1a7sLSr5uJORb18zwHntUIAe4bN0etK42u+cEkubebOm3Vzg3E/9
         iW7FVVtALP5j6zN/4Jl1hylk6aJL/hn+NIVi4/GbH3huw09MZMgEbQ/Z47ipQsWWkge2
         XdNQ==
X-Gm-Message-State: AJIora8ODN5oB0Vz8AcxNhycikUZ2E0SSTfECFn1N+avjr7MNysAukP2
        AlLZJhyCplcxCAdLOq3Kdc6z6+2xn5bmM1Qc
X-Google-Smtp-Source: AGRyM1vWj1aMGvSAaBmETeiCrL9HE9CWPHSOfgDHBjWwVQDF9VIRlECL9qHyC1DxfdvwPRV63nN69g==
X-Received: by 2002:a17:90b:3502:b0:1ef:92a9:2b4c with SMTP id ls2-20020a17090b350200b001ef92a92b4cmr1459102pjb.65.1657307774117;
        Fri, 08 Jul 2022 12:16:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o20-20020aa79794000000b00528d7d27211sm3080024pfp.178.2022.07.08.12.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 12:16:13 -0700 (PDT)
Message-ID: <62c8827d.1c69fb81.2ae09.51ad@mx.google.com>
Date:   Fri, 08 Jul 2022 12:16:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.322
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y baseline: 29 runs, 2 regressions (v4.9.322)
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

stable/linux-4.9.y baseline: 29 runs, 2 regressions (v4.9.322)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig | 1  =
        =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.322/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.322
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      445514206988935e5ef0e80588d7481aa3cd3b7b =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/62c749612129e21a2aa39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.322/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.322/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c749612129e21a2aa39=
be8
        failing since 43 days (last pass: v4.9.314, first fail: v4.9.316) =

 =



platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/62c76b3159d2190349a39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.322/ar=
m/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.322/ar=
m/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c76b3159d2190349a39=
bdc
        failing since 43 days (last pass: v4.9.314, first fail: v4.9.316) =

 =20
