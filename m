Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB1D27973B
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 08:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgIZGZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 02:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgIZGZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Sep 2020 02:25:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46897C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 23:25:29 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b17so579942pji.1
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 23:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/ymeRDinBINgL1OmoV0uHnNoOQ64rtbE9qslbnWxIQg=;
        b=CzgsCPAyY/BHM5A+Exq7zPjci29qhx+d3bZq4smSB9fjBFOZL46WVRDgpduIzBrmF1
         66y+jOF+vhZZt7EMTXCw0rspcf/nGZ1CYuHnflXyCx3V+BvG5cNNsnRSPKP2rqMCk5sY
         wc7/tbWwffUSrI+/BvoP1TD50CpX9UsrdMDxtze8Z4frBLJ/3zZnl2Ruuu/PxF0bDA1/
         b3kt5/JyStrP3RwqYu8y0hanPN5NNj7duCLnygKyPkh5jmfLI5u3/FsXZ3706LZJ7hqB
         Oo/jKttNiWkvuOw1wfeFcn9sJXEtSW4mN6dc5EUq4/O/EsBjbPjxOPuzWDipDjuA2n1K
         xOxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/ymeRDinBINgL1OmoV0uHnNoOQ64rtbE9qslbnWxIQg=;
        b=Eftdpf+2oBLLh7GzTaaAWW8dha6gXZuXm3RXzdUXYCutzh8tKlPjywCGxlqb5Jl+1R
         K+PgVyp5k2gnMdgBCJ2uz16wUV5goYmt6JlMnTOhJRKxsPFjF4DfB7/cpiECmKEaSyOJ
         0j66S5MmoufQ0R5Kw7oUhNa9pBANem66PUN25zxGKt1x/1eYaomBTmGq6iaBPQ4ZEmjO
         K4FcwQ1MfkYu8JPTUYnPM5/DeYaLGWQlJF4clo/FZS9SOmQKxBt4q0tEhL1mHYxzejB/
         QSm0Cvh/kMOdYJULRLuGQSDUc4U4C1W+n8wXAUCbt0Mcrd4c9u8ohE9wxVifSkLmJi0L
         jxUg==
X-Gm-Message-State: AOAM533Y+DzftM1xmqetV5pc2pVJvBwv+giQs/1GsJLiBgcj9OPiBzCD
        c9J2UzNn7rCrh9a8xmv6OWfzMmSmTnl2Mw==
X-Google-Smtp-Source: ABdhPJzg89e9SLfydgetpxfSOo9S9B95Z6cAqc7+Dvq530U9TOgC1EiKTGjlI0BxkCET/dbrw5Yf1Q==
X-Received: by 2002:a17:902:6b02:b029:d2:2e08:1b9a with SMTP id o2-20020a1709026b02b02900d22e081b9amr2780308plk.55.1601101528124;
        Fri, 25 Sep 2020 23:25:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9sm3745229pgi.2.2020.09.25.23.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 23:25:27 -0700 (PDT)
Message-ID: <5f6eded7.1c69fb81.ff956.ae4e@mx.google.com>
Date:   Fri, 25 Sep 2020 23:25:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.199-18-gc4b779e87edd
Subject: stable-rc/linux-4.14.y baseline: 139 runs,
 1 regressions (v4.14.199-18-gc4b779e87edd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 139 runs, 1 regressions (v4.14.199-18-gc4b=
779e87edd)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.199-18-gc4b779e87edd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.199-18-gc4b779e87edd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4b779e87eddd094159b0bb29e243e457d4def0c =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f6ea5ffb692572c73bf9ddc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-18-gc4b779e87edd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-18-gc4b779e87edd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f6ea5ffb692572c73bf9=
ddd
      failing since 178 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
