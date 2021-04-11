Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B6535B5AE
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbhDKOfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 10:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbhDKOfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 10:35:12 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D406C061574
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 07:34:56 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d124so7449046pfa.13
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 07:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SZjlNJQUiy85sQKM72P2A7MxrUF4wjYytU0rPFnvVUs=;
        b=Hz7R6NkQdTaLBwYkHpEyciL4Z4307fY1Rmcfl5rl6vZPBBsjcxJicbPf4Ym4N0BqLa
         wPcIc0Bb4MDY4yflqkORmJBfZD0/Z4M96ZFilPUlR0btnBspr3H5hpnReWQwdro+697b
         YAqE9FzJutDicVlQRYXna8BPnsw24RWUx5Nj6nFUlZ7MzAkve331X1lTf2gV0SUh4lT8
         CzhmPjsA2eUa7sHgDDnDJYJZ9JCiFMuaeG9eOZ5nD1haOWWWkBnOHjq3JrZShmsMlMQ+
         ZfCZGfVuQt3F7cLVnkZdKmTppC1eCwk7n3jF2MItgAVSAjtPEW4ZggESjkcs2DP7CE9H
         Y+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SZjlNJQUiy85sQKM72P2A7MxrUF4wjYytU0rPFnvVUs=;
        b=pgWfaDuJvCwOmDcm3e5DHaLC3fgoNl6luxVaZOw7FDGSDQSUQ6Y1B3OWNOqS/8pO8H
         uwJneqzA1s1GlaUdYXK/+AiccpWv2JsgxJDb6Anq9B2Gkqdjl83pJhc8fpoAbpP+WBmv
         M7YxqHt0NLTSw9yVju+ZxmxiP6LjCjWvpFCC0vflSVDDDkYzhjWDVUVMr/yajW7Ofli/
         IY6SMGtG2G1dvSUATrJBDxaD4GKKiQfCnH0U5N4kriHIqu+VP3xEeI/9m5ObP72h50U0
         CAkfLHeB8WuyfVhllJ1qpRnQ1iEZBnbs2fOUWfkyh3zsjcWZ6xSSTmd5O8hrmQdJO5IE
         zYFg==
X-Gm-Message-State: AOAM532S/v59zDW9c5qZ8DrcbJCS9zQ6IPxiQg1Qs+QOCyIYcs4Le4Lk
        rRmKTefF4HIs792keG0Iv/EmwW8pt3dpWDvo
X-Google-Smtp-Source: ABdhPJyRUsZu2L1NSFiRd8WZME8j6uRpeiuZzAcl6dbu78wQ1uLBw9jY3rUKfJEaWIjZ8JHO870J+g==
X-Received: by 2002:a05:6a00:b54:b029:207:2a04:7b05 with SMTP id p20-20020a056a000b54b02902072a047b05mr20855472pfo.12.1618151695463;
        Sun, 11 Apr 2021 07:34:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6sm8153075pgm.92.2021.04.11.07.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 07:34:55 -0700 (PDT)
Message-ID: <6073090f.1c69fb81.33d6f.37e3@mx.google.com>
Date:   Sun, 11 Apr 2021 07:34:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.29-81-g265162f490ee
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 109 runs,
 2 regressions (v5.10.29-81-g265162f490ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 109 runs, 2 regressions (v5.10.29-81-g265162=
f490ee)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =

tegra124-nyan-big  | arm  | lab-collabora   | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.29-81-g265162f490ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.29-81-g265162f490ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      265162f490eed06073016c74af48151f2e199654 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6072d1b84d0d89ec79dac6d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
81-g265162f490ee/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
81-g265162f490ee/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072d1b84d0d89ec79dac=
6da
        new failure (last pass: v5.10.29-70-g53cd43b21612d) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
tegra124-nyan-big  | arm  | lab-collabora   | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6072e6886bc08d67c3dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
81-g265162f490ee/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
81-g265162f490ee/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072e6886bc08d67c3dac=
6b2
        new failure (last pass: v5.10.29-70-g53cd43b21612d) =

 =20
