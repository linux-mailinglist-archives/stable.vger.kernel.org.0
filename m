Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2020332B285
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343875AbhCCAxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576692AbhCBTZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 14:25:40 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89E2C061788
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 11:23:55 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id t26so14554399pgv.3
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 11:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EqjWflW05TxpoJnDHwdjGgNxG2WtxyP6plD91dKtdl0=;
        b=Q3QSdrEPKPAsIi3pONQoGEC8BST7/H5jiARk0O8JgPmPtRU9SE6HadGyIhHkh89VI+
         SxLHos6BlwliOccU6GWDobZcQhiHZGGdMGi82dZ668AB58uRZtaeJchy+RvEIn+S2UjZ
         KhojhDvZEURZhk513RBbxIwfYik8zQozmwg+I9KEKkGKaGc8XASeo6mtvX6k2Hv4JgkF
         oG/xd0XKmmT63W2w7uTrZjksTnt4zUFWKmseXpVjiFXYGfCgp08xpHLA+cE2Al+G4lDD
         99Hpw1lzsXw0yemSOZ7mU7eEk8J4sEehX8pr1otl8Qp4sWw0mp2J+hvz6kyLKgE+s33Z
         seDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EqjWflW05TxpoJnDHwdjGgNxG2WtxyP6plD91dKtdl0=;
        b=Gqc4jQHtcXh6kIZ0QT868TCmXf+bENCEPM1JGRY7WmohEXlAmPnASq+h9oGNy1VPrx
         GgEEpq0VNPS/lyx5Xr4LoYiO06YbKr5NPIV5u5b065P/ehjvBH9305r+a6QpnmbfzPiz
         1G87Z7iXiBXloHyIVniH7kTm+4pGUrloNu/5Shhh0AGkBCJdTwSYO4ve0rJdNCydkKlz
         TFw2R4IDgdTV8h8mh6xVEh+Df2h4D7x6HwHzN7t8GOwQS/p6g90TqAkUc5cyrR7gF+gd
         St0cSA2Np4ZEbVdMKYy1Vst2iVscuxmOKlIQMOjA2gb50IF1/YyhgMfTKudWTweGVeua
         f2MA==
X-Gm-Message-State: AOAM530M9kmg/YgoV8f4skRVDlWOaYxGZqeApBpG5vXyhFcZHqDsIGta
        bQ/sQvdjYp46Eo8OEJSvJi1UhttL35+/2A==
X-Google-Smtp-Source: ABdhPJwqjTMaNYSPZaODTOmfsvA1EuTfVJD8e3m0H/oSj8+C4HwnFHL9IogfgIPpQlWMNgeKWWdeXg==
X-Received: by 2002:a05:6a00:14c7:b029:1ee:481d:47f5 with SMTP id w7-20020a056a0014c7b02901ee481d47f5mr4670090pfu.80.1614713035175;
        Tue, 02 Mar 2021 11:23:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z12sm4313951pjz.16.2021.03.02.11.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 11:23:54 -0800 (PST)
Message-ID: <603e90ca.1c69fb81.aa8ec.95c7@mx.google.com>
Date:   Tue, 02 Mar 2021 11:23:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-659-gf16bfb3dbcd52
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 30 runs,
 1 regressions (v5.10.19-659-gf16bfb3dbcd52)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 30 runs, 1 regressions (v5.10.19-659-gf16b=
fb3dbcd52)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.19-659-gf16bfb3dbcd52/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.19-659-gf16bfb3dbcd52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f16bfb3dbcd52de1d1ba07334aa32710e3d88891 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e613d6bb3492cc6addcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
9-659-gf16bfb3dbcd52/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
9-659-gf16bfb3dbcd52/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e613d6bb3492cc6add=
cb7
        failing since 0 day (last pass: v5.10.19-21-g9b79602baf17, first fa=
il: v5.10.19-662-g92929e15cdc0) =

 =20
