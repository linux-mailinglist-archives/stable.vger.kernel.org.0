Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28965304A4F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbhAZFIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbhAZDvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 22:51:02 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AA6C061574
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 19:50:22 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id l18so1433534pji.3
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 19:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sOvbk+fgmkxPf8BVo60WmrhebGS30AeJFD5kIm3/kyw=;
        b=2QKFclqLf959Y/+nsRej2Do8jmUpdQ5H8eBUQANUt269sKFju8iuJ8kQgNGZdph3bo
         75XKZAYR1KpFnqOrWuOaf6plL0fXfde+kxpYhygUIs4CZszkFzvuA+E3+4eSNHdns0td
         Cx8nD48Ns6h110N1hb2IdxV+22wb865uRgWsCYZs0j2rNS5L29rvFnw2kq49m74EBH9F
         eJSbL3Akn6Scoba7wwtp9h/lILYbvOPpvIf9Cf9BR7lOu4AhCflat3Xv+vqNjM9MaLvM
         IavwBIiGSyu0U1FupRfTv23y6m2cv3UWJiG3pyAzsbASUz99Tznqt0POAWjGMpBjxWJN
         HrEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sOvbk+fgmkxPf8BVo60WmrhebGS30AeJFD5kIm3/kyw=;
        b=O065KNWzWqAyRQoYYe3ckS4BXb1a8naS4E4HbmVRKE5ytr88PT9c5SeaIYxutu64u/
         iLTqv98CGiX7ipDYJyv0WcMH+b4EK/M4ughimFEMxTaieW1474seLoaxYH/TACZqVGah
         Jo7CiudDnQrUtY+xURrchXpaW6ig214FwG0l6Ke6OkHoQLJczpEhnDHftCEmGQFI4/YF
         k6x4K9YZZjqfSkbkxvURgPimn9phQY4weJeUdsQzlcNCVGL0f40xG3wbG2J3nO9YP037
         pmSjB4JT9BcLjOiq0Op2xAjM3PzWObf48s1m3wdWJipN3cNupmjyfl2OUSRj8qxrUcj5
         6mTw==
X-Gm-Message-State: AOAM53311HMfk6taBZQMS/0P89niTCTDVBzsYkLXH2GHqgzkFO7VJvid
        4Z85JCqpHmnA6GdfFnWzBBEJgr/2ZDaX8csQ
X-Google-Smtp-Source: ABdhPJxFGvT/oAzyRCHSQfWBJ8eJUGRC+it3R4TaeWeXYNKFdwxUbOai4kGZ7aRjstKytxxsIp8KPA==
X-Received: by 2002:a17:902:8213:b029:e0:1096:7eec with SMTP id x19-20020a1709028213b02900e010967eecmr1231283pln.50.1611633021387;
        Mon, 25 Jan 2021 19:50:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q79sm19096030pfc.63.2021.01.25.19.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 19:50:20 -0800 (PST)
Message-ID: <600f917c.1c69fb81.c4668.e424@mx.google.com>
Date:   Mon, 25 Jan 2021 19:50:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.10-200-gefec2624e657
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 186 runs,
 1 regressions (v5.10.10-200-gefec2624e657)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 186 runs, 1 regressions (v5.10.10-200-gefe=
c2624e657)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.10-200-gefec2624e657/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.10-200-gefec2624e657
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      efec2624e657b370b1621e8514a1fa6d65eb20a0 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600f6251b319e047ebd3dfca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
0-200-gefec2624e657/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
0-200-gefec2624e657/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600f6251b319e047ebd3d=
fcb
        failing since 2 days (last pass: v5.10.9, first fail: v5.10.9-44-g4=
02284178c914) =

 =20
