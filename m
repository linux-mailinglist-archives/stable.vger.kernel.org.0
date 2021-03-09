Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A85332CA4
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 17:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhCIQyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 11:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhCIQyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 11:54:04 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF7EC06174A
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 08:54:04 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u18so6856639plc.12
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 08:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uKf8tfBvqDeiOohp+TxwcKcN+ly10CJYHI3tuNwrmwM=;
        b=aGE9WmeytFC2JB8vsq4553pFmI2/IN6isKobAR9GkYv7bPnsMtFnopwLBv0kTfbNAm
         BaKTX9+IjyVynE+KtBI83fKMNYMYXb6FCmGjfwJo5LZgD3e61c/WRiXv387nbFb4IZn1
         2J177R39hg0+X6T7ai6NbrJxwMAaQy4UA6yIcZKmmWU0EXH+LZpevZgsO5fyx1iSFd/X
         f2/SfPplEsXJdyT2WgU40WHeAIUEg4tZVeYwsxA7A/N1NSRyAJq3bXJK9gRbV2b6bOCn
         N68d98tFWqasXlPboZazwFWGGEb6UhdxJrrzuCUrzr2qWnEygt6ft5mGr1Xc7tISXOsg
         TKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uKf8tfBvqDeiOohp+TxwcKcN+ly10CJYHI3tuNwrmwM=;
        b=k894dXgaCucdhP/G8LZQettDhgvp2KYf6SmGBs/wveryuNJZRgf7h1jric0hqTOrQF
         apPZlpVcwCbhl9GMYsnil1QIhd39lFRWLrRAiDHhaIoV//93znLQqeS/MrJSFLpMNY2B
         1FEeqYiq/FPB2nE0sm7Mf/vsrMVjzMjgxYK0VnavaHPRetG0NVngxtEOnStDjIEinwQv
         cchNBEJPnXtE7lujka1gCDcWzwqM6gTzHqg4ZeHTucc7fwx4FBGgoj5PhAW9YoK8nhux
         mHhy9ACxeP7oSGjNsX28wTnAT00IC2t0Yk2GxSPpVOAB8BdTydBPwHJIiGJK32RVc+hY
         nHHg==
X-Gm-Message-State: AOAM533v0cIMwxJD8DJvmT1V4Tj+VD4EoabltWmvrCPFZ0MogxyCvy90
        SO9rXxOHKZxgKjyZp82eqvAwM/Zo+ITuNXWk
X-Google-Smtp-Source: ABdhPJyXzXJjA4sEXCPeUNwhjT/AOuvtALFPvQUGlgiIozveKv66Ip21Y2YXFdzL5LzEYWQMTq2xjQ==
X-Received: by 2002:a17:903:4091:b029:e4:3288:bc57 with SMTP id z17-20020a1709034091b02900e43288bc57mr26078009plc.80.1615308843743;
        Tue, 09 Mar 2021 08:54:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id na8sm3223303pjb.2.2021.03.09.08.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 08:54:03 -0800 (PST)
Message-ID: <6047a82b.1c69fb81.c80fa.8218@mx.google.com>
Date:   Tue, 09 Mar 2021 08:54:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.22
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 102 runs, 1 regressions (v5.10.22)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 102 runs, 1 regressions (v5.10.22)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.22/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.22
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b672142f76cb904067e3ac6d04002cac3a976f46 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604773a17f25a7303aaddcf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604773a17f25a7303aadd=
cf9
        new failure (last pass: v5.10.21-43-g9226165b6cc7) =

 =20
