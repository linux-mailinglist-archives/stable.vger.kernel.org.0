Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CDD409C9A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 20:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238871AbhIMS6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 14:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238493AbhIMS6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 14:58:11 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF65C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:56:55 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 17so10338369pgp.4
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JZCJPhnpCi/MAcuQuHPEDJ/aMqvU16FlZEDUpqfAGFE=;
        b=WLos+1DgTWIHrrSAZj0a6MM1WHNth1RO/hqOfQ4pvCDPwa+vOHR6HJ9mAuYJaaJYhs
         quZ2YtzdnGu2Ln81ZqUIvYwJW8Sv8biMIKCCsxNF8sxtD1aK1gn/ioGy7c3tG48gt4jq
         pAsDhPP+25DcJXdZRUB22EaysoyLV9f4jXKPEvT+UpD23Y1IXrtwsvtCwideIrrIxiQj
         prHdh6CYxPVKds/wx85icedQcJcGExncyHP1Ox1iRV8Yczfwf7pJJmAJkr26HnsQKpEU
         YZrzTbLzNprV4cr2JlvpXLT+k0fbykLNlpV5IjwoykeZ7T4Hn+wr6Y0taNczPYOYzVET
         T7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JZCJPhnpCi/MAcuQuHPEDJ/aMqvU16FlZEDUpqfAGFE=;
        b=l9hPPWKSIM8UhRumHdisBp7WBCaZ8rdPeDfGJcjlcfeTWeDOAz2FVRpveneY9CxU8A
         rVd0lksZjQo+V6bo/md7kVGSX/4Cn11sKOfvEiUllsAl3inLViVA89eJKT7cSiuJ5DxU
         pSv0uTvm869QD9vku7klgbDl7TcEziH+FOvG3gONL9LeWi1Wi7a/AmL3iLl4uRM1ko1R
         +p6nPyNwhM0KmZjmRtm30CbGYSNDdsBPWoSO6F2t4nHgJAl+aou1o20m6bTpB5i3oUp0
         2vywt5wdwhXAXIxQF5TIesbsiSs/wCSz6Y0hOUyrKDtczUJ60luK/z/EfElXA2bjqpA7
         gM3g==
X-Gm-Message-State: AOAM533dOOpWz9CLQ3xbQ1UatpiHCtBAHzu1+QSrMoZnYTqULnnkk55D
        qNXJu4jxpybb+QjeZCykt1B2Mgy1A1tNDugU
X-Google-Smtp-Source: ABdhPJzWQSoTMHwJ+6/DueOGhTuNtfUAIPV/o10CuDxE8tlAf85X+QdpPINKg3jsp1lVw0tvzWHfHw==
X-Received: by 2002:a05:6a00:2787:b0:43d:e275:7e1a with SMTP id bd7-20020a056a00278700b0043de2757e1amr920148pfb.49.1631559414915;
        Mon, 13 Sep 2021 11:56:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w11sm8739720pgf.5.2021.09.13.11.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 11:56:54 -0700 (PDT)
Message-ID: <613f9ef6.1c69fb81.ee4d9.8f5e@mx.google.com>
Date:   Mon, 13 Sep 2021 11:56:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.16-301-gdaeb634aa75f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 179 runs,
 2 regressions (v5.13.16-301-gdaeb634aa75f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 179 runs, 2 regressions (v5.13.16-301-gdae=
b634aa75f)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.16-301-gdaeb634aa75f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.16-301-gdaeb634aa75f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      daeb634aa75fbff920be96c86c18510120951cd0 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/613f6d52ee05a92eaa99a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6-301-gdaeb634aa75f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6-301-gdaeb634aa75f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f6d52ee05a92eaa99a=
2dc
        failing since 3 days (last pass: v5.13.15-23-g950636fd38b0, first f=
ail: v5.13.15-23-g7f3773195533) =

 =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/613f6c37cfd826599c99a300

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6-301-gdaeb634aa75f/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6-301-gdaeb634aa75f/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f6c37cfd826599c99a=
301
        failing since 0 day (last pass: v5.13.15-23-g7f3773195533, first fa=
il: v5.13.16) =

 =20
