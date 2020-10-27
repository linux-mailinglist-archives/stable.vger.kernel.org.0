Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E333529A29B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 03:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504441AbgJ0CQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 22:16:44 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:40035 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504440AbgJ0CQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 22:16:44 -0400
Received: by mail-pg1-f172.google.com with SMTP id x13so7148477pgp.7
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 19:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JoNXMzWUPdYD7EdiD3KgUXLzbl10qPJ/4W0lWyGLQbE=;
        b=ttDuMw5AwtL/ZCmJdCA/uKlSiJGdofeSdHKpxAAzMj/KomJrByo8urja+QXwrG4PZE
         K9jGlViKKhHwAAZm9mlDMiBOZAD+r8HRsS+kw17jl2MM3bdX+XEapegGRBFJNEgb8RJN
         28o3y9QGg/3Nvw9aQeyuoa2pPML6h17QpHIf6PYGL4HZM0gpIpMoD36qeLSjSnVQ4dxT
         r7JbTwrSxCCYn9pqzenQsYX8AXVOhSigfI+NCVBkX/Tzke3mRLDjzgKc9n56gZkbcorR
         wRZgQRc4R70nNCeUMTSaX8l8Rw6hU+MSa5IC4C8fch81egK4XJw8wYxUsQwwHwCajCi6
         jv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JoNXMzWUPdYD7EdiD3KgUXLzbl10qPJ/4W0lWyGLQbE=;
        b=SRsdCFRnLQfKW1/aE4o//WPvyeuSnpjF1VaBZtBj99qmmMgxIKhKVLfr3Fpv8gtAdp
         Kr0ZgpnEXKfa0tIEFx+KXxs+fsxfH2Wt1fDSoat5dfeJgsO/YeIqmbBDi0VlNqz4P0N2
         UTbSr6aozzrvdmUng1Ewi+d8UtjP1uW0sgPVVgvtMUa8Y8hZlhVj4m7wHplT1erygEMA
         fbreFGiu9W4JEVFnrKPX8XFaqajnb2zPFaDLizSv51wU9xMg8L+bw4PF6tMGOwZMht9f
         ymz0lELB9+Qj+zRCoCsgmP23HrVrsDFf9S08crUEmyj2oz1d3GQs4RszYkZnZRZF0vi4
         ayhQ==
X-Gm-Message-State: AOAM530nZMeenow8loz2vd6KCBJ7njcmvqsT21B2DWQumU3TMV/902em
        6gH9OspBA6MZC3QL+MCU/n3pQZvBB6hs/g==
X-Google-Smtp-Source: ABdhPJyjj62Rcqc2VvwcHuW9nwcaSanQoFXyExN6VX3aTYpo6OrR15LTiww8JuPZke/gLFklX0WUog==
X-Received: by 2002:a63:d54c:: with SMTP id v12mr19766273pgi.429.1603765001652;
        Mon, 26 Oct 2020 19:16:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i21sm11994690pgh.2.2020.10.26.19.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 19:16:41 -0700 (PDT)
Message-ID: <5f978309.1c69fb81.a42d6.8e94@mx.google.com>
Date:   Mon, 26 Oct 2020 19:16:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-627-ga9047ecdbcb4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 179 runs,
 2 regressions (v5.8.16-627-ga9047ecdbcb4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 179 runs, 2 regressions (v5.8.16-627-ga9047ec=
dbcb4)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =

stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-627-ga9047ecdbcb4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-627-ga9047ecdbcb4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a9047ecdbcb47c8615fd48e9480a3b985620a67a =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f974e187aa9a4d636381022

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
7-ga9047ecdbcb4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
7-ga9047ecdbcb4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f974e187aa9a4d636381=
023
        new failure (last pass: v5.8.16-626-gbc7f19da4ffe) =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9752f649ea8c9939381019

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
7-ga9047ecdbcb4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
7-ga9047ecdbcb4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9752f649ea8c9939381=
01a
        failing since 0 day (last pass: v5.8.16-78-g480e444094c4, first fai=
l: v5.8.16-626-g41d0d5713799) =

 =20
