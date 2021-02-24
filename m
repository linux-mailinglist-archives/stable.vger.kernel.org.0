Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D95B323513
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 02:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhBXBPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 20:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbhBXBMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 20:12:49 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA809C061574
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 17:12:02 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id kr16so168396pjb.2
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 17:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tGfJ4OjVouP0z8t+BF9V3/fqI1VBygkLiK1DxkyaoFQ=;
        b=p4doVumCvkPRjteOU3yHkVJrDKxQeGlK8VhKyI7ZcYTxuMeCmAavqwKVLCLqo1wj2j
         0wS33KED+3vfu8LK5w7Pst4JApmeH8LEidjCRARX2hhrRADu2MvNLj9oiZk4QYk9rbe4
         7UJgcmuRxTyPXmE8mOQmsRqjYsOxBTaiOzKEqcfFXVzcZZAEM81lpMmfOcwYzzKLcnDY
         ySvrrU9zsbbv60bhanSudk53vL16ng1Re6THHs2+sxBRMz24pSy+szPJPMJLPziIGTux
         3BbeljIP93V7JNz8wkpOWhs157sY/i7U2xHk1AO7OcBOWFIlErEgs0Svo4Nbb55pJ5CR
         ioEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tGfJ4OjVouP0z8t+BF9V3/fqI1VBygkLiK1DxkyaoFQ=;
        b=ZDk2lRyJlOfqZanONBtW8J/Gjbv/ka5heK9IwLTAdEgdWxDKxzEoB9ceIpZuZXY2Bb
         InOK1hAU3d+26zEeeiDSuTHJUF7tUcZBic+8Lsakmq5Y3GTV0xphBcXwtKNCbabFXMSn
         A4/MSTtR1WdD+zv7ME0qBVrvZOcpIrbCtCEsxdvJMaLzIEiVTwxNn60e1yODaZZndCXP
         AJBBQU/asKXrcS2/MRSHehG3lTugpTN/K9qCR6N+cbDrKuy1tNYLCjY0ONcyADcSkMLe
         +AM/+i54jgAbQXsvh7zDYOFrLXpe6lgpciCjFpShCUPG89fIQFjPveTxLb74j6WcjSEu
         tUBw==
X-Gm-Message-State: AOAM530/HT9cPKkstDMimkb8pAkZXzpiqvAmZZ/fgqlF5+oV3emcLUHj
        XgbA6T+ChSIY0cSwWVH+rBSxSDLXHiV2pA==
X-Google-Smtp-Source: ABdhPJxRNvL4nYdpiuTpPdrXVwfmbKr4BwYZYVb7MxKbV2U9q56/rYMOkatRH0My+49+012qN/ObzQ==
X-Received: by 2002:a17:903:185:b029:e1:8692:90bc with SMTP id z5-20020a1709030185b02900e1869290bcmr5096117plg.75.1614129122050;
        Tue, 23 Feb 2021 17:12:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4sm414173pfo.32.2021.02.23.17.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 17:12:01 -0800 (PST)
Message-ID: <6035a7e1.1c69fb81.67f42.1bb9@mx.google.com>
Date:   Tue, 23 Feb 2021 17:12:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 73 runs, 2 regressions (v4.14.222)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 73 runs, 2 regressions (v4.14.222)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.222/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.222
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3242aa3a635c0958671ee1e4b0958dcc7c4e5c79 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6035710f7f3024ea5aaddcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6035710f7f3024ea5aadd=
cb6
        failing since 329 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603577e04eafb825b8addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603577e04eafb825b8add=
cbb
        failing since 12 days (last pass: v4.14.220-31-gc7c1196add208, firs=
t fail: v4.14.221) =

 =20
