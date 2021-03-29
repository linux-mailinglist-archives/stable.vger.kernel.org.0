Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B6A34CFD0
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 14:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhC2MKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 08:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhC2MKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 08:10:21 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91559C061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 05:10:21 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id l76so9281069pga.6
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 05:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NibCDvx4AxsSv9PxTfzEYP+2GTuPNNw6CN2Hun4cxPU=;
        b=zYM0olhWLGBUlcKufQe+2KW6DlioHinQXOkj3dTikY767MyCKddy35jQ4sQ5BGIuo9
         2wtvsQgmPCBDQ1hMAqrUNmKKuyBx8Q0Amzs7HT92/BZqbvvWpjjZhT2lmLmitcZbk6kz
         YvAb0rkwW6lbZJl5J4nTSzVA9OieBhpF6My4M0wsZ+4v90rapkPdPaYhj9FH34s/yac3
         ANIrRzzB87+CiTwJU5ndjKC+k13J5bOaN+PDhiDKEm2QkJ4P+gBckI4gev2t7d189aJF
         1OUGs+we2c1Hc1491ILJ5Y4qCl1KYentbf5da5G7mbRBTiHZSBFD4fMuMM9Tax9fYw19
         oIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NibCDvx4AxsSv9PxTfzEYP+2GTuPNNw6CN2Hun4cxPU=;
        b=c/zj78EvgD5qryi4R8nBUXOAYg23egNYfFolX7Gy/hZ8+ZIdyQ+utA+UEaSS+GW0kI
         SkhojfS5zXF7W8GYZ+CedzM7syb6Xjh6HNKq6hwcySlZenxDHQrxuHgHuOxwoz7ZRozK
         nNREEJlzC+yyHTgmTAAVTKooQxBocfUrmw6Sk8TAjS9+SbnXfBNBQzxoNeOpWEi5uLNq
         ZYN91cCXt2QC0rypPm+FbHHwrE9Cjid3+NiRW91s5Fi4jXYYAc90DRJpIo488iPDu5gt
         lUTp/6uhE+34l84T2CMqfIxUUbvjP1MQB1NYa383WN83MHJXVk5+/642rQUU2MBSoxJ/
         PCPg==
X-Gm-Message-State: AOAM531HgES0Xk6MTkmg+3qHbBDvrgPMWC9amCq1nzDyPDUdpHBKjLKT
        yjYTI2Vo9fwynrfgjMMwJ7Gnkxfpweu4LA==
X-Google-Smtp-Source: ABdhPJxq1e1GGAhTPCNIPYf7eJwW5anAnE69uwJjBtMcv/2nROGskCO3ZNE2SN18u8gbWPBbE9J4dA==
X-Received: by 2002:a63:da04:: with SMTP id c4mr23304452pgh.144.1617019820999;
        Mon, 29 Mar 2021 05:10:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b140sm17278499pfb.98.2021.03.29.05.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 05:10:20 -0700 (PDT)
Message-ID: <6061c3ac.1c69fb81.aa2c7.b237@mx.google.com>
Date:   Mon, 29 Mar 2021 05:10:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.26-221-g2fa79882e3815
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 171 runs,
 1 regressions (v5.10.26-221-g2fa79882e3815)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 171 runs, 1 regressions (v5.10.26-221-g2fa79=
882e3815)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.26-221-g2fa79882e3815/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.26-221-g2fa79882e3815
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2fa79882e38152d7bc8c49007f72b852957fafac =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60618f0ac0caf099abaf02b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
221-g2fa79882e3815/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
221-g2fa79882e3815/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60618f0ac0caf099abaf0=
2b6
        new failure (last pass: v5.10.26-204-g20c4f011de84) =

 =20
