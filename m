Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EA33922A6
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 00:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhEZWW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 18:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbhEZWWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 18:22:50 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBC5C06175F
        for <stable@vger.kernel.org>; Wed, 26 May 2021 15:21:17 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id j12so2140896pgh.7
        for <stable@vger.kernel.org>; Wed, 26 May 2021 15:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kTmaDtdv9yEsw352JzQsv1/v+RwBAga70wHj8OVCqhQ=;
        b=y2l79tyzEgWZo8vh2ciSDPR2HqZ6uUjfYy9HHy/mDVs1j88pD7otu9wdmADsSMq7io
         WUVJ7qo+gO52nPQEPS2hI0Aook3stqyghCJTS2LXbF2nRE0CI2AjfFUTwfe0coFK9K/1
         YJ6cNbiSTynEfTsJfUr2LyRDXF+p/GcAGvz2+cUYcIBF77tllcbWsAG7n7RF3pKjg9ym
         lOAcLhrbWs48eJhVMlOSIiTmfOgsJcMg3WiJpWs0Sr/vmcxvpKPAatj5ZslrvdEN5iks
         110R6dpUAvm/u+ipw6Rzffx5etTT2DmbL8RbfjS285bGYAi9Oau9yZJP5Sj4dGyqH++D
         3p0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kTmaDtdv9yEsw352JzQsv1/v+RwBAga70wHj8OVCqhQ=;
        b=J4DajL0ggTchO+W+UEueWrgUGqirsu2/boIzA4If1Vk0VtLuMqAQaVpxh5+yySn6UZ
         5l5a9qjGcyuqOrNa51rbmdjEfC1grn/0kg1gFpZbPPFDc3PGjnuB33rdUYg1u67JNERr
         F3O3Ot4AuGiJXiNrRimEnv/ziyN9ZHc4QhXNr6tQh0tIGj9qMyhQLkaHXeb7KVbcXn8q
         tUG2/v3vZfbL4SGLnOMv6ATg49+MDSytg4cOZdFriplr4InxoQPPZbqlgpfEN1RaacK0
         oPmLAOFIE5FoY7NgmpMKfaGRLiKGjGbBp9bDDKNVqZgfkMKGu5+YkQ/Ov/5qxv2sNSYM
         XVaA==
X-Gm-Message-State: AOAM531KnzLtLAPd08yMrK/c9nu0Rz8StJ4evRps0S8uwBHDfRMAdrSu
        zcCsajkcy1c9tO7W3wD/23SiuVysb9moUz/4
X-Google-Smtp-Source: ABdhPJyHTJZvGeTqauZZfsuM2Lpe1oYj9fUDnQcZzwg2b3UTx4T3IzGBaSe/Sjit8tVOae9HId1WrQ==
X-Received: by 2002:a63:5d04:: with SMTP id r4mr698052pgb.178.1622067677203;
        Wed, 26 May 2021 15:21:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r5sm275427pjd.2.2021.05.26.15.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 15:21:16 -0700 (PDT)
Message-ID: <60aec9dc.1c69fb81.632f4.1735@mx.google.com>
Date:   Wed, 26 May 2021 15:21:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 116 runs, 1 regressions (v5.10.40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 116 runs, 1 regressions (v5.10.40)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4068786a86905a7a358b9fe1327a480f08fb6a40 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae9988cf3b395a50b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae9988cf3b395a50b3a=
f98
        failing since 6 days (last pass: v5.10.37-290-g7ba05b4014e8, first =
fail: v5.10.38) =

 =20
