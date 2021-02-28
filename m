Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C843274F5
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 23:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhB1WqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 17:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhB1WqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 17:46:21 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90D2C06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 14:45:41 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id w18so10233797pfu.9
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 14:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qrTT+XlljOxyPQeXGLKIx4Av6uFTJtmWR5kTGsN57tg=;
        b=QDCE+AZEVgGjhksNvyF8GT58qHJhgLh3Mxdi0liF9pItKDJXtqpcsPIlX4j4TvJKJZ
         KWKCjShoCEG/9K5mp+EcupE6/8YtZl+2IFSeDfSHnUQmhm8yBUyaBz0eElNNmf8Kf0gP
         QQHw1N//A2su3p9JErDXnw/48jb/8MudZrPLloN+3kMM+FjPB2dtq2zJBpoUPZHz6i6o
         dF5tz4TYuJ01k9LXEbavQ8hKKUZlZui0CL3z/+KP5ntuBTFL0v6p6YdI9VGMwD2DH4+K
         lOqnYfNhd7yYRQrrgDC9uH1xEUrBYI3ou37w63boD56WFO+/2LaFdsa8gvNvPyF7h1pL
         PCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qrTT+XlljOxyPQeXGLKIx4Av6uFTJtmWR5kTGsN57tg=;
        b=C1voMyunrLVkEzIqLH07O5jrPxLNnyvJHL6boZGdICuGumv6Yf8yoXqfODpbaBf46w
         9FujvQl0DVLkF8AN9F8IWSRa/YvLp81/yTT5hn5NpchV+CFji/aHoiuea02YpJ+FdK9r
         xMal+e0OM6QRNWUU3WOAi2GGgsPflCMzs+wyVVwNTXJHWYKyeGOTx/tQuET5e3+IWDnE
         +i5Sc9nfgegQOyayj/YHuh+pp+/UqI3OKOSt8YHXJHBmdV2w8JSsYU8FOX6XdadcTri7
         u+ZTpVntqPEE/K9bPBUmt0aWqjbuTF7da8LmnVaUpEXTXE655Jz4pE2vNzp826CQhDhk
         JZqA==
X-Gm-Message-State: AOAM5330KicNL6vrXLLAOlFH8ZtwLd+4yxEbovhsS/dylt6/dOu/876b
        wH1Ie1zHZM4COFBqC1B0c9SPD0iPRXuyTw==
X-Google-Smtp-Source: ABdhPJzTuS5tQHXWrt0j6vAkbqWdHCNYwMSGpApdYsR8CRIRzwNPowO/SJ2uPYcYV3ORcrDD/zLisQ==
X-Received: by 2002:a05:6a00:1748:b029:1c8:8139:288f with SMTP id j8-20020a056a001748b02901c88139288fmr12235123pfc.13.1614552340882;
        Sun, 28 Feb 2021 14:45:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d7sm5120443pfh.73.2021.02.28.14.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:45:40 -0800 (PST)
Message-ID: <603c1d14.1c69fb81.3453e.ceaa@mx.google.com>
Date:   Sun, 28 Feb 2021 14:45:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-12-g575cf23a1a64b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 64 runs,
 2 regressions (v4.14.222-12-g575cf23a1a64b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 64 runs, 2 regressions (v4.14.222-12-g575c=
f23a1a64b)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.222-12-g575cf23a1a64b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.222-12-g575cf23a1a64b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      575cf23a1a64bad102a483de9597bb4bfb7f40b1 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603bedb9caf19f79dfaddcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-12-g575cf23a1a64b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-12-g575cf23a1a64b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bedb9caf19f79dfadd=
cb6
        failing since 334 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603bed1f309c3abeefaddcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-12-g575cf23a1a64b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-12-g575cf23a1a64b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bed1f309c3abeefadd=
cbd
        failing since 17 days (last pass: v4.14.220-31-gc7c1196add208, firs=
t fail: v4.14.221) =

 =20
