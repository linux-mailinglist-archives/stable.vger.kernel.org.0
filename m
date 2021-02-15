Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC0D31C42F
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 00:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBOXCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 18:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhBOXCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 18:02:35 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83131C061574
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 15:01:55 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id e9so4497402plh.3
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 15:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YErOxxVpLrnus4jY0sVKFkS1B4lJQHKXGlgD2PjIihQ=;
        b=0dYq2HTmngctVBPBhfukI0Nm/xS2ySKcXiMYs1w3ChOaRrIoc6wuon/18pPDVoDKxK
         0xR4bMU8qgNxh6kAuff1zejOQur3897mWxapFUak7SRHFlY8wZ83h1d3erzmZyIcjSTZ
         SDku4K/1wEAuGp+2Y9sGYsQVDcPhhXXxawUknylcfJS+6f8JuCCoQJMHRzYqKYWhGaQe
         +r6T8GmV299N7bb9/Q6QqRL9ucVdgppQvQkbvB0acaLqwxo3lacMlJVr1zPVNh0/xeZw
         Sjxh+0FV7MEXgWkgZK5S31qedJI2H2paKS/YtHpd3RsWU3yD98jum5kPGtwFVmYuOVli
         4czg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YErOxxVpLrnus4jY0sVKFkS1B4lJQHKXGlgD2PjIihQ=;
        b=JaWBr95m8ISo0IgYFTUM5s9EKpbDq65TQlMd4f9VRsfXefm1o7MMm+8DmBUyJ1nbLR
         JYNIBRF8mYht3G/RSROVZtjOQciIsHwZx2u25mH6aTknt/Inj2s1A5Hwqgv+vGxihyWY
         3+ibIJPiHhxHWZ6FPPXM7xvHdLDEs0gJuDFBLPGwK3LQQRtOicCQVnaWQgNWP4B4RdWO
         aQWtuL9Smx4adFybMOpGnPOwyZaVO/xnaj2l+1kEaiTeY1SeAG+d7ZEXHC9d8iMEi9mp
         6hGsCstmEcd2ZzhFpfs+bj35PHPAhtIJ1bcuYG8ZhgTHbDosBxyN2G/m/sRSV1Zwm9GK
         7thg==
X-Gm-Message-State: AOAM5334C5j9bk4z7Si3nk878uXuflifCCwx5zwheNBKF5a/bIw/91L2
        LncgnSK05/2iqwH7rfW5qmRmj3IImQgdUA==
X-Google-Smtp-Source: ABdhPJzalGCffyLTnDMYSxzKVgVjjVl1BdvL8gtNtzGo97i7QWx+yv5oFN1gPx5nfsj4giMVzkv/Sw==
X-Received: by 2002:a17:90b:3805:: with SMTP id mq5mr1025853pjb.93.1613430114805;
        Mon, 15 Feb 2021 15:01:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 9sm19628891pfw.48.2021.02.15.15.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 15:01:54 -0800 (PST)
Message-ID: <602afd62.1c69fb81.a34ac.924f@mx.google.com>
Date:   Mon, 15 Feb 2021 15:01:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-41-g0cd87528249a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 61 runs,
 1 regressions (v4.14.221-41-g0cd87528249a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 61 runs, 1 regressions (v4.14.221-41-g0cd8=
7528249a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.221-41-g0cd87528249a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.221-41-g0cd87528249a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0cd87528249a1f846e713efc707a5256f69bec98 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602acd76d6f6c1c79aaddd15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-41-g0cd87528249a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-41-g0cd87528249a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602acd76d6f6c1c79aadd=
d16
        failing since 321 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =20
