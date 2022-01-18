Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC3A492E40
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 20:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348656AbiARTPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 14:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348578AbiARTPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 14:15:21 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8C5C06173F
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 11:15:21 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so282004pjp.0
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 11:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5AiEco7ZssBb+f3lsAxK8e5zgYn5HCEocer4+mLRioE=;
        b=bWJD2CvW6D33r8lwI7J2k5lRF/StNeN6du/2eH4nHhj2wyRV/KEFMUP6tbDfgBpT3q
         Dn6uzVRpVjlQk6tYiG0wpqHmzMXtLDbXpljdUBWGQfeMkHhIxljQ17RNz63Ft2j5PcpJ
         0nryisY+3wh4wufHsWs376y8ewqqzPt9exs8BkAitg203fxrlbR9hFwKl4E3xeaUU5xS
         kkGFrqEIOh6pu8TDG1kBhl8BkuaKUK0MHW3i23EsOhzzCEStoQOB3BaIBb2T9Fto36zD
         APQ0WovEMuSVP/RTGc5gX5aTR9izuIkM51KW1tRPpx/8wiTtWiAz7q9IRMBwnK3oDzDv
         WXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5AiEco7ZssBb+f3lsAxK8e5zgYn5HCEocer4+mLRioE=;
        b=wmMsaqDT3Y3mfxOAdZOD/0mK/bOo2/leVDYbCv1U989zFL5Ugc336rB5kC5KcBBznf
         +9aTNQODxrbS+VRCIWohERp1H/tpalgE4kzP0c3sezk+yRH7VvYCxzSdoqYAYqzHSSgS
         /M6qqAfzXWQ2fxLWKdENoQUWQJk91kyXj7l8Mg9kQPoBjb/OhF2r2mPMau5aiv4/gpw6
         a3YDd9/uV2Qie2ZK9RcelXjLBKZyaRHnR+nk+sIzbQY7wsDD1ozeEdT+Y2XcgACmFuW3
         B93t6tELME0ytwsv6XDQ7DvqWdxkyTi09yf6TjbO+kPk9EeU97YZT4OtT9SjdTxvTmPf
         eG6w==
X-Gm-Message-State: AOAM533IJfJMvNV2CARLkxUecCjEIER+qSXbsDjhHA5/3qihbOZiAPN/
        23QZb9azqxh+Ly+fV5NUUXotp5AW5AauZ0o2
X-Google-Smtp-Source: ABdhPJymkECGQdCNjAb/pJVul1tkdZumBinBFC4D0Zg0JrOp/bVBevF+8ioUhsam7u1jVXiTm+YNOg==
X-Received: by 2002:a17:90a:53:: with SMTP id 19mr4914293pjb.159.1642533320805;
        Tue, 18 Jan 2022 11:15:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x185sm5682132pfd.58.2022.01.18.11.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 11:15:20 -0800 (PST)
Message-ID: <61e711c8.1c69fb81.c8d16.dec2@mx.google.com>
Date:   Tue, 18 Jan 2022 11:15:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16-66-gb71cc2d4ec38
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 138 runs,
 1 regressions (v5.16-66-gb71cc2d4ec38)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 138 runs, 1 regressions (v5.16-66-gb71cc2d4e=
c38)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16-66-gb71cc2d4ec38/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16-66-gb71cc2d4ec38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b71cc2d4ec38ccd47280665f683bb65885471598 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61e6e115af14032eb1ef6755

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16-66-=
gb71cc2d4ec38/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvato=
r-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16-66-=
gb71cc2d4ec38/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvato=
r-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e6e115af14032eb1ef6=
756
        new failure (last pass: v5.16-59-ge029ce95d1f7) =

 =20
