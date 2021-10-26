Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFC743AAF6
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 06:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhJZEIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 00:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhJZEIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 00:08:42 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05947C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 21:06:18 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a26so2172599pfr.11
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 21:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VBWZZS9aofkkBClQ42iEeIByHJHHVvQ1YQKejZID4cE=;
        b=LV1DDGv5N1iAL1r8OLhQafKy3UEUhGR+DvsuXksLiKeP5TLvG0nZiaXHx1anmB43Le
         CtivkoqOVMK7OwyVAOBdOGxNV8HaQDKoVWhW3E5vNVP2Avi4kJW+4piIYUq6Al56P3YZ
         kQg+Vn0eXyFfwW2jtGI2SXea6CgYb/ztr6aB2SCJqQ72l+qJZWwp7uZ+pLE1t32mSAqr
         LYG5hnWoydRnQOKAPb7aOmZqsHtKVXWKu60CF2C+fbS5eNYLwV14Ku1lcEb9m7nvygpn
         XVhYE6+CaduWhbp9M+V3UraXCQSQHEpRxeOeHk3D8DX1dzbTcUj1pYeqrgN8S8FIlvtv
         mguA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VBWZZS9aofkkBClQ42iEeIByHJHHVvQ1YQKejZID4cE=;
        b=y8KDlBB6GlbSGQ6sHB67BMGzEEz6w+mUTljgeMruk3FgpEWlM84l7alm+JKyNQocMX
         qYxDKGcshPEgbhzknWCOswzAwlDjoZF4mPcZhBDHkebPlT7FG6nuDNkDGwdp/apJOllo
         mFxL9zKLyhdTIJbJNKKRM2ZMFZRqDImZ7u1JX3TwvTaBApUit3mYe9GpEC+DM//iI8tx
         XHTTfQ+f3qfvOT6JO59JCfjIr6ZpUK4FQadQUF9ZTZHUzRdd020N5puyPRzzhpOYABcg
         rm3ESMZVNxwW9yEJokr+KjBgMGFanWX+DZXcYx6fp2gQx7Fa70ONaNxEeRcUqbDL/dfL
         lu/w==
X-Gm-Message-State: AOAM533ExgD1/Oq10myhnFvpJB/CJS0OCYFS8W54AJsokrgW8z1uD4of
        o44xWnMLmzuN0qJxtg5Rv3KMBkxAi7DY5E3F
X-Google-Smtp-Source: ABdhPJxTEk24g0TYwYH2DIHebH2nXqAoiuBvc22J3TAHfghnOQZ6p9pgYOkmVHjPY20NXZDuZrv72g==
X-Received: by 2002:a63:9f1a:: with SMTP id g26mr3256282pge.170.1635221178125;
        Mon, 25 Oct 2021 21:06:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b130sm20903484pfb.9.2021.10.25.21.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 21:06:17 -0700 (PDT)
Message-ID: <61777eb9.1c69fb81.7c0a8.8e48@mx.google.com>
Date:   Mon, 25 Oct 2021 21:06:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.75-96-ge2430f94799e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 134 runs,
 1 regressions (v5.10.75-96-ge2430f94799e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 134 runs, 1 regressions (v5.10.75-96-ge243=
0f94799e)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.75-96-ge2430f94799e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.75-96-ge2430f94799e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e2430f94799e6bf1f96aeaca998817fed82e9afe =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61774844170fad1d2f3358de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
5-96-ge2430f94799e/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
5-96-ge2430f94799e/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61774844170fad1d2f335=
8df
        new failure (last pass: v5.10.75-88-g629133650a80) =

 =20
