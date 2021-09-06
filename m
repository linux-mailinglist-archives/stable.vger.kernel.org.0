Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD88402110
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 23:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhIFVV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 17:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhIFVV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 17:21:56 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBEAC061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 14:20:51 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x7so5559320pfa.8
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 14:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=znE0rpd2GwDhdTuNuASynhZToM08fUA36EL7MLe1FvY=;
        b=WrXBHiiDZVrgh6h+yXok2PhP8YPSFOlSxU6gGzWquc62yDFGEvK3bJU4hATqA853Zp
         ThLi3CUFYEE6UU8yPWYhBz1ddsH8TBfmHGD3uCogbVHjDMrTUPx8H0x33ygm+9KFxYm3
         UulR8M1gC7LuE1JyWg150IvV1l/zVTC+2OZPi3GGb7NNiWdBV2amc8P23hIDuzKVPR3v
         GbkreoGAn2C8J0R/kwqx7625FIFHUa2DCa/p/sKrlOVP8Wn9g9ruKwuXvh3UfOeyqVCM
         ZzusJCP0dQf+ChWXxH8T5y6FH9Slz+2+9Y9YTeflfXztdIj+xsVFhElNw4bzhZ3CXPwG
         SNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=znE0rpd2GwDhdTuNuASynhZToM08fUA36EL7MLe1FvY=;
        b=TtcHFi4irY+MMa48zzAaxALM/nhoB5ch4TcANa3WVDrQFLLiQVpqsO2qllYm7X908Z
         PZv1vbp7iWmjc45H4F2xSMVfd6EtRfYzkL4RrbNzEnsvkxjBOA7OOMDJjDACzDEiOj6A
         rYpzRd8qpM/J8e9yiTYBdan9M/9D9KyXjTfps4Cx0Lqf2DVDCZodLpeO6p2cptDB/MqU
         66UZPzkFzvd5oqCt3FczZZsrHQa0TvDjFYDiYrBEBPjMDYhi7uAOmjBub/UiSZiu2tJe
         /eWsZ4h5VxU0tVnACTLoiCNDb3OZe6iwldUXOS4hbKXWeDUmDLDLWbp5xI+Yu2BnUFI+
         nj3g==
X-Gm-Message-State: AOAM531i4Jx+5TssQvgXT6NaA0TCdYRzqdVzg1MxibHNMrPEIi+K/Yw/
        FT9EoOzwCHuCgAUq8/MhmD3p1kv46tHYIE6Y
X-Google-Smtp-Source: ABdhPJzS5g/xZBnVd8APWmaTH1ct2OPjB4ZQZah0473IvgitnCsa8TzE4NnnFEZuQ7pM8ppkjRJdRw==
X-Received: by 2002:a05:6a00:1984:b029:3cd:c2ed:cd5a with SMTP id d4-20020a056a001984b02903cdc2edcd5amr13509123pfl.12.1630963250836;
        Mon, 06 Sep 2021 14:20:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15sm8459104pfq.31.2021.09.06.14.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 14:20:50 -0700 (PDT)
Message-ID: <61368632.1c69fb81.38de7.79f3@mx.google.com>
Date:   Mon, 06 Sep 2021 14:20:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.14-25-g6fcc0c5f7322
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 210 runs,
 2 regressions (v5.13.14-25-g6fcc0c5f7322)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 210 runs, 2 regressions (v5.13.14-25-g6fcc=
0c5f7322)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.14-25-g6fcc0c5f7322/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.14-25-g6fcc0c5f7322
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fcc0c5f7322a449824de7f2641dd0b551ae68f2 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/613652146eddaebedcd59682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
4-25-g6fcc0c5f7322/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
4-25-g6fcc0c5f7322/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613652146eddaebedcd59=
683
        failing since 5 days (last pass: v5.13.13-74-g5a5b2e290019, first f=
ail: v5.13.13-114-gd049bfc3077d) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/613652a0e8b77b440cd59697

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
4-25-g6fcc0c5f7322/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
4-25-g6fcc0c5f7322/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613652a0e8b77b440cd59=
698
        failing since 53 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =20
