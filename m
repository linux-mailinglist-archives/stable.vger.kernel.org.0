Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0B632743F
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 20:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhB1Tpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 14:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhB1Tpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 14:45:52 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540F5C06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 11:45:12 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id t25so10146850pga.2
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 11:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ehobsSYww1Q1Lc3yESBqQZqULl89iYAUakdwUAQizoE=;
        b=uVsblpXbUXLzKd11GBewD6HFsgzucQKNWrsM1BzId+bHKOacGBztyYC6xhLtVk+RDF
         guOyWAYB/uumlD4UhUHNUfwr23wKz7o84DavQxLEMoucTHg+Mc/jzzJm1kzlCCSvKQVp
         TG1tN349aDZxHJFPwR6rNiTaca25Gt5R2XGjv/5b2wOwUxYhNogZfhcgYOPYkthVJuDF
         xylhEXEy0XXUJ9bUcCaq9C8p5gBGhUWx9o8llxDCibXKuo14CTXpwidu2I+vy7DlI1tI
         9GuY2n7lpqp3+u85wutJt1VTGham2XYnAht/lHpH0DiQqUOyCt7X+kFu5leVe9GSHPms
         +/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ehobsSYww1Q1Lc3yESBqQZqULl89iYAUakdwUAQizoE=;
        b=fN04JqXhhc8wxdMOiz+Bn11wbcIG4AfyWRY/5AsC2aydIQOroDyAoAyYwipFiPwyTc
         Q/TAXuj9fUcCM8dVgxS16ojGLOSG03f7zVIkZk1q+mXxnOHutgvP8HjZKwvMuoDILwVj
         gxYfiSI5SN8x9NIsF61LlaAwi92EyTsqi+ENLkDQYt7pqSfa3dFm7DTl/b6y+tGqhEmG
         9zke0JNnKOJcLPQysvN2ZOON0kyL+ZJqo8/TkN+h0zQcysmyNhsXgo1nq70A1fDgQ0CA
         iwNzBg496UQyqXrXmpcZfHPp+WXYSOoX9z4OszagfXtZA/6/xcYsHMGggKaz6M+oRbY8
         9XOw==
X-Gm-Message-State: AOAM531UPjHJr9xAh+8IJ1HcXFkf29qvkTVhsKr2uwohMJ4slMAz4uMD
        SC6YE2PySCmy4JJFBpSChzaEOJyQleUDyQ==
X-Google-Smtp-Source: ABdhPJyEmlhu8Y3CU2iqaJEUe9r8fSxWt2fZz3eCxpycCrWs08kxgPImYyuQk9lnQ+eXI4elWuztvw==
X-Received: by 2002:a65:448c:: with SMTP id l12mr10935525pgq.386.1614541511564;
        Sun, 28 Feb 2021 11:45:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lr7sm4888243pjb.17.2021.02.28.11.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 11:45:11 -0800 (PST)
Message-ID: <603bf2c7.1c69fb81.372be.aaa0@mx.google.com>
Date:   Sun, 28 Feb 2021 11:45:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-23-g1f319f0e51141
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 87 runs,
 1 regressions (v4.19.177-23-g1f319f0e51141)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 87 runs, 1 regressions (v4.19.177-23-g1f319f=
0e51141)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.177-23-g1f319f0e51141/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.177-23-g1f319f0e51141
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1f319f0e51141c1e40c2280578d7bceb79fd7339 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603bc1a2d877640f93addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-23-g1f319f0e51141/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-23-g1f319f0e51141/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bc1a2d877640f93add=
cb2
        new failure (last pass: v4.19.177-17-g0d98970e7feac) =

 =20
