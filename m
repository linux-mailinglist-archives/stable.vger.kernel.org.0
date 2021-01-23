Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EC930139B
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 07:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbhAWGfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 01:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbhAWGfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 01:35:42 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C1BC06174A
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 22:35:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id x18so4535975pln.6
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 22:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h3+MXumlhzGyaY6dszUczZLUWtbpJr9/BvXLaaPILsk=;
        b=w+ic9FXQ91D5aQZVAqpf83wjAY4ErrbEKPDFsbOy1onDTiPhl3hzMQ0+tjBUvZJK8C
         cmt79213TGJ2NwYEVMnGZw6nJYLnAlpGq4GABr6+qfGrPnRVhtgkOirk+BaqP9/0s2c/
         ra7mhbZ63zsAXFLDqcDKQSUA2RXuIL43TbksKXsXiLkl1I9xYAdI/HI0WOCLHH5JVa6I
         d3b9Bm5qnnVwTam9WprCjvUVyKPqFrB5p1K50eC466IcL9Hzv/vfdF2U/N8ovWOeFBKI
         0hu+1PTafvnyFJid2BVCFA129gxgOfIGSTfBXG4mmOxDH4VGhfORfIZEO7Xr2jii3vJM
         B9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h3+MXumlhzGyaY6dszUczZLUWtbpJr9/BvXLaaPILsk=;
        b=TY4wi/cw1rCjN19/0thlmsGp9hTAUujCPkWld2PL2AEIvu9yXiFkIzojbtv3AAWOrE
         MDxNvgjlcB9Zh73LaRJcYJWtVcZHTIQs3Ad7Fd9qvcQg1X9ElHT7JPdxzvaiImsgrIs6
         dK8BnsE5oYh75BECIyVtKf4oOw1dJEOlCFqIMTn3pr4717pbuRV6HCFME+g/qZGkoN8y
         KWQVptpA2y0uYQs1b7Md4Nj2LjuDQwMvinj2Ua6qs9vsP5H6YGXYC4BMoDBYKBeKukM6
         pgKAXMr25+UfR+JVI49i91qCzgMB/xqbp6OG/aGcfsOiUqtxFxxP6n0EYidAVxWVHE1N
         VYSQ==
X-Gm-Message-State: AOAM5311DHpj53YTJefHjelXqB87BGHl5HqBMRU+GKw5sEy6k9NPPxTf
        nJI/IVMHzfXjU+DhQdXiLcdUYcUCK4w8vLsa
X-Google-Smtp-Source: ABdhPJz72IPIsmHk1FFOzaNeplIWlaOVD6y3b00teb48Bs5LK6AjmoFIS8el1SfNi6bROoUDL+8GOg==
X-Received: by 2002:a17:902:7684:b029:df:cfe4:6a06 with SMTP id m4-20020a1709027684b02900dfcfe46a06mr8414067pll.64.1611383701131;
        Fri, 22 Jan 2021 22:35:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n2sm10076777pfu.42.2021.01.22.22.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 22:35:00 -0800 (PST)
Message-ID: <600bc394.1c69fb81.5ba7.8df8@mx.google.com>
Date:   Fri, 22 Jan 2021 22:35:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.9-44-g402284178c914
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 157 runs,
 1 regressions (v5.10.9-44-g402284178c914)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 157 runs, 1 regressions (v5.10.9-44-g40228=
4178c914)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.9-44-g402284178c914/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.9-44-g402284178c914
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      402284178c914c87fd7b41bc9bd93f2772c43904 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600b947dfb353b1afad3dfcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
-44-g402284178c914/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
-44-g402284178c914/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b947efb353b1afad3d=
fce
        new failure (last pass: v5.10.9) =

 =20
