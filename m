Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BBC417EB1
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 02:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbhIYAt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 20:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbhIYAt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 20:49:56 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D6AC061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 17:48:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k26so5724850pfi.5
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 17:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mT5dMXWUKX+R8S+BsF14WOkCu0DhJivxV7pmWda8WU8=;
        b=ecMh4DUZusTWNo+uLtMBy1aDCxJFLP42ftuTvDIKMVy/IL5MvbQFwkv/Md8h3Yf7Eo
         Augb5apPp7rBim1Yd5xwp0kMhJu4nL/SSLDsPasmqeFXiCz6B9kmYeFC7KKpBUXmM/5T
         9wn6U7HmUFBrNNEr8ZqmbSjXem45b+xViElQ56MMc1zpMHtncizHWLhKLikrodg9FTse
         pEawtt//LEfkXyAI41fvFRYB3apgWp4YGVYRL9jg0NgYQZvTRmRQ5ba6Zp5xKYpqJ7Lr
         p+z1B72NB1O0tD98FHYpCdraBfjFRe6LuM7r57pMUDjQNTw1gHS+WeBK9dewaKx/9Jz0
         i/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mT5dMXWUKX+R8S+BsF14WOkCu0DhJivxV7pmWda8WU8=;
        b=wPLsOk2wPQR7+c6AQC/hWSFR88pM7MshprE5U9DUV/qxw9MlcrbvCpdvPdJeYzd+d+
         3Q/4qkjbr5aUDn4zu7VlIrLKYbwVJLNn8gu5ZCkLJfUnrBgw8QnoWDNZl+1MWRyciHnY
         hbg3jQY0uoHiGdNdz7T4sk8Ghvwqu6XDu3oFAg+c2+CPiZZ2TIScF/s5U9/i2Qcxa/PP
         c7mvw6dc+YbO8+4oQL7sy9jphBfNDC0itYH/FjKDbq8vYMJLWZ4l0QKWFYr6Bg6pkhEA
         08uM6OXl1o2dHevLJJqu9Xf9zdb9hy9Ikp51sUm/Phb0ezKSuB9iH2h6LX5QjaBeuRmh
         mW3Q==
X-Gm-Message-State: AOAM530HmKltoORyaK3fLPc5U5KBogQ+cPP5AD+qSHoVzWmWrcIha94h
        y97HqpiRcrkk86YNFctBiijSdkXZwo8zbEs9
X-Google-Smtp-Source: ABdhPJzV6yF1UgSRowKylmmInO9PEnKmhLbsBjXVzzPFhYl030SV7kMPEcndLXZyFFIRsXb44TWHDw==
X-Received: by 2002:aa7:8ecc:0:b0:434:d4fe:311b with SMTP id b12-20020aa78ecc000000b00434d4fe311bmr12612983pfr.22.1632530901333;
        Fri, 24 Sep 2021 17:48:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t15sm11150624pgi.80.2021.09.24.17.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 17:48:21 -0700 (PDT)
Message-ID: <614e71d5.1c69fb81.91fc0.4b00@mx.google.com>
Date:   Fri, 24 Sep 2021 17:48:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.7-100-g3633965a8dc7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 89 runs,
 1 regressions (v5.14.7-100-g3633965a8dc7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 89 runs, 1 regressions (v5.14.7-100-g3633965=
a8dc7)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.7-100-g3633965a8dc7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.7-100-g3633965a8dc7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3633965a8dc7d8edf171701cf7a714f6a2c74091 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/614e317997516bfa5699a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-1=
00-g3633965a8dc7/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-1=
00-g3633965a8dc7/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614e317997516bfa5699a=
2ec
        new failure (last pass: v5.14.7-3-g11f9723f1192) =

 =20
