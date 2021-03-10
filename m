Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BBB334C35
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 00:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhCJXGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 18:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbhCJXGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 18:06:23 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E51C061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 15:06:23 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id t18so2477964pjs.3
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 15:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JPEVNvSFuzyg07tbY5USG5GS157dBDAU2RyoTSbAVd0=;
        b=FbfEqZa2yx7Wy/NSFFYLF0akAVfLFAs8WDsrEUdMO5FcctAwqvDN4JaWzPCzmwtQ71
         Z/lhvhquAE/w0fCspP0H5AuWSaiS7GKcm8jTMqq8YvOopUMaelCURhXH0x0Yk5ghmECc
         emm4QmPnw8yth/tuzIkQRQICAbyibYkrEJ16eoWA6Z6u1yubDkXBrvubokkKdVZBaNg8
         rGN348CcHkK7YeKDRcWpNpMb5TxAeMhCuMGr0VqCBZuMC+iUxfWIFNIl57kjxWZDPOrS
         jRnlIHQXUhBajDsqCmTi/5NFpnEmLbRSS6c2tNpbuucCT/J3R1dcd3QlWIFyaBeQVXYQ
         7vcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JPEVNvSFuzyg07tbY5USG5GS157dBDAU2RyoTSbAVd0=;
        b=Ch76Ry5N6gzweyIyvzbyBkExEAmYALgNgKdsqHUNjE5v1m6VTJYB/4Y5I1h+XE1NnU
         UFRLyFXWRGyi1uuF2L01+NYFlBjYEHoxNlo5+pmksSzpbKsaElIvpmEDS1johd70jlAG
         sOl60kUA7/MMV+0DFw9TilZtZ/akrcc8cMe4ry7Ek9ZAqYJTEx4xdCskVuzD+TH3GCWV
         CIAIyIwXDqwJ4tE/Cz28tkCbcf06aoMvoe4UwyJ9dprCdbEdsk/p+adV3pI9n2g/gomP
         j3Dgnoai4f2pWTXjSLRQD6WMmpATIJa1Fj9GkK7X+Vm3I6K0BpHH2ePp++L+50uABai3
         AGnw==
X-Gm-Message-State: AOAM532pPzrl0KLEXZHiZQJ2xI3zi85X8cF4BSmni3kHzstki349ic8c
        6TUue+O3SogEcaK/gY58/BTKvViz7vAp7zeg
X-Google-Smtp-Source: ABdhPJwdc0DwLnxQ4ENzK5EfjbpNZBo6F4cWEp24ohI8nhyLHJY+ZUVLctw16Xz7IkvEYKnYD4Xn6w==
X-Received: by 2002:a17:90b:3890:: with SMTP id mu16mr5825924pjb.9.1615417582926;
        Wed, 10 Mar 2021 15:06:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6sm366372pjs.26.2021.03.10.15.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 15:06:22 -0800 (PST)
Message-ID: <604950ee.1c69fb81.be72e.189c@mx.google.com>
Date:   Wed, 10 Mar 2021 15:06:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.22-48-g93276f11b3afe
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 176 runs,
 1 regressions (v5.10.22-48-g93276f11b3afe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 176 runs, 1 regressions (v5.10.22-48-g9327=
6f11b3afe)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig | regressions
----------------+-------+---------------+----------+-----------+------------
mt8173-elm-hana | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.22-48-g93276f11b3afe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.22-48-g93276f11b3afe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      93276f11b3afe08c3f213a3648483b1a8789673b =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig | regressions
----------------+-------+---------------+----------+-----------+------------
mt8173-elm-hana | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60491f6ea366ad46baaddcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
2-48-g93276f11b3afe/arm64/defconfig/gcc-8/lab-collabora/baseline-mt8173-elm=
-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
2-48-g93276f11b3afe/arm64/defconfig/gcc-8/lab-collabora/baseline-mt8173-elm=
-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60491f6ea366ad46baadd=
cbc
        new failure (last pass: v5.10.22) =

 =20
