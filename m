Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C040C36BEE8
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 07:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhD0FgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 01:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhD0FgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 01:36:06 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4818BC061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 22:35:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m11so167193pfc.11
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 22:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4eCtia+l/Tv9AvViHOy4g43j8fuwkNXMiagxVysCTgA=;
        b=OFNz1hrjzBmsXfFudYOdvNdhEGWMBCOp+J8e7XBahgQrPK9ukkEBGHWeP1kOsI6ug+
         PQZTqHH2zhIbwbf+7xxUawxW+i0eMQgFOgUzZa8/SvbJxbaF50/7mcJS/hkZ9c91FPE4
         MA3JbvYnF5NF9lh54V/1azdi5Qa0jnvPBGgk1d6/Xgj/XJda3L1mw2SWsztz/sSNO3Tg
         iVfcsVSogLH4lVBmyZEEo3Vnf6bjQJTQ9ZxbdBAIqzjgU9h2wkU6DntinqucSxJhRlLM
         3GpyMYwVYqRT6fV7L34RtOYxoVywGJmD3hz6TL7mc0eVUOaQBf7Q8fzFl7Q/7ELPAfAu
         H/IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4eCtia+l/Tv9AvViHOy4g43j8fuwkNXMiagxVysCTgA=;
        b=EGPxcNKGp8uQJSjfvuH6wPeav69ZKePzlfh34mA+ZujEOPRidQL70PBMIo8YFfvERv
         cutGr3pkf9mePWmjbhGESU1pRpU3OeLgdMmuS+U2zVVJCGWYfKy5HzzqyyPGv8s2cQAT
         pE/0bQisamSxrh4tfn1BUu0o2J8ETrn2PwyM6XkcrajQ2+Phrp9RN+t8+fIUrpJqjByH
         TSVryYCzyYUNDNaDCi/xzKJ+2NaOyfayCyVQyFytwN92ZVq5UshlQneLqMGxAmoraOHJ
         rrXUQDh0XTvWhSNbMhqPZ8Rs9Vom2Y/GXwBP8oeVFi8GigL9e+lvtdznSxQXWmxPbY0Z
         gWxg==
X-Gm-Message-State: AOAM533LHUsaCLZmtxJmVXRnuQC2OGamZfXiJ98AHHvA3g3lc/E1zxlI
        Yxo8iWLr5Clj+jIJlBvHzq9a3xuVhEnkQRg8
X-Google-Smtp-Source: ABdhPJwYPeDDDQDa9jtvFkTXDRMzvUgTDAPJfGzKwRBCC7QmPYMg5OqrI6Twph1sfYTZGQF1h/2gkA==
X-Received: by 2002:a63:ff22:: with SMTP id k34mr20109193pgi.336.1619501721160;
        Mon, 26 Apr 2021 22:35:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a6sm1291095pfh.135.2021.04.26.22.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 22:35:20 -0700 (PDT)
Message-ID: <6087a298.1c69fb81.54e7f.53a2@mx.google.com>
Date:   Mon, 26 Apr 2021 22:35:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.32-36-g0d4021ca2952
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 160 runs,
 1 regressions (v5.10.32-36-g0d4021ca2952)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 160 runs, 1 regressions (v5.10.32-36-g0d4021=
ca2952)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.32-36-g0d4021ca2952/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.32-36-g0d4021ca2952
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d4021ca2952e609ec4559a66b274d3113a21439 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60876f8dc2ed6cfac59b77de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
36-g0d4021ca2952/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
36-g0d4021ca2952/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60876f8dc2ed6cfac59b7=
7df
        failing since 0 day (last pass: v5.10.32-12-gd2a706aabb95, first fa=
il: v5.10.32-35-g413e8e76f9149) =

 =20
