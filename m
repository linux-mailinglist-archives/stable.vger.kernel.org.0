Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AFF373297
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 00:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhEDXAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 19:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbhEDXAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 19:00:40 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374EAC061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 15:59:44 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s22so341132pgk.6
        for <stable@vger.kernel.org>; Tue, 04 May 2021 15:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cy3+CeHSZ5IPDJXUyPG2HiDQlRBVTuOb39av2bXikJU=;
        b=soTFOqUgLXmz+ep7Z3+TF56yn+7dKN/mdcf1OJyGCyUlBUr2admk2hgXm5zSCYId8U
         hQKlyVE69dtyzsUUpzfG0f62QK5PX0R3jfRuiUIh4XwgXwMOKEUhWh0aRCt3GF0QLJY0
         o+LXfne03fB0/abvO+7SCckMGGrkVDB1PhrjTxff5VIPpRSi4Lvd6SveiZmHqNp9sHis
         PixxDe6/uPJlBTkSNeV9LRjLbVFq/j+WrDI0965stDe3mwKtc/Ld/Yw4NCHpqDTGq/9z
         pzHmKXU3lx0Fv1FGC017g1DQ6E7coR7Pj7FUxXP30tvqfNAm4AvIfQ2Ijwv2d+tIp4aY
         cEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cy3+CeHSZ5IPDJXUyPG2HiDQlRBVTuOb39av2bXikJU=;
        b=WIbUcrh78ei07RshSHA6cuVeI/v5+RRVp/TNPiHVVPht18aEFWG8RW+xwhFsZRr6Tn
         x6qor0CM3PO0GXltYE99n+tBEIcfV702mpNlBUKOhlvRYujCX8faqgkyz1G1/HjP4kM4
         PQQbDER2IrLhssNXaqXddx9qo1ZNT/KwL7P8ZfPN/pdL8soD6QrrZTmetwjj+sHPMKdf
         64v1Zhlf0PFkx1L0bkJruAKN1zzdam/5xh3CRE0R79lFgJnZKo+u9FXyC0TxOSsqLf8A
         sbpJ3ANeoX1l+GgJGB4a4NxU5TV9YslNNO0PR/oGsH9djui+poEmZH++IP/TCi74gGCh
         x2bg==
X-Gm-Message-State: AOAM532evcE/QWV4zV7aMKVaI0eafBqGyNYI+iYEk8Y603HL7iUnDkGA
        nA7D+4db+hi38ShTFuLzQwDhA3+S8+izVByv
X-Google-Smtp-Source: ABdhPJxZlfSp2U5W7VEue34YCcP5PHLdUsht5KvErZV5KXCdTZTg/qjnmmCr6erJ5F3VB/h+rUKL0Q==
X-Received: by 2002:a17:90a:dac1:: with SMTP id g1mr7819762pjx.199.1620169183488;
        Tue, 04 May 2021 15:59:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q23sm4643047pgt.42.2021.05.04.15.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:59:43 -0700 (PDT)
Message-ID: <6091d1df.1c69fb81.5e98d.9218@mx.google.com>
Date:   Tue, 04 May 2021 15:59:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.1-7-g47de21d5d220e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 88 runs,
 1 regressions (v5.12.1-7-g47de21d5d220e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 88 runs, 1 regressions (v5.12.1-7-g47de21d5d=
220e)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.1-7-g47de21d5d220e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.1-7-g47de21d5d220e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47de21d5d220ed2809caef4940ce6d1c346b28cd =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60919978cd9ed561cc843f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.1-7=
-g47de21d5d220e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.1-7=
-g47de21d5d220e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60919978cd9ed561cc843=
f23
        new failure (last pass: v5.12.1-6-gcc8057a398c24) =

 =20
