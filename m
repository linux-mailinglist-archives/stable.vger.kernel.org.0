Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6570237B0C3
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 23:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhEKVau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 17:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKVau (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 17:30:50 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E5CC061574
        for <stable@vger.kernel.org>; Tue, 11 May 2021 14:29:43 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l10-20020a17090a850ab0290155b06f6267so403573pjn.5
        for <stable@vger.kernel.org>; Tue, 11 May 2021 14:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QC1PovymNNkKAAvc3+Y2ZnbD7wZWNV2RWB/4FBJfU/g=;
        b=lqmtoYEH5UYlJE24upaNiUrg0JP7YmxD1JMA8ZO42zyiSqBpOoGaPM5H0hRwhHUxym
         n/arSBJ3p59ZkxYyKo63LvPQr7enUtkumLnjD/AKLH6n4dWiGeeh03FDvkc+ClwSmuUc
         UzxJghzdvyl5tauQGMUpnuZ46QYgtSC6vOQJtlvYlEp3w/yjRsJXcDSybw3wrhbFjpG1
         YXm4A9348zXbxKigP/W9cxBI/TWu7qmKAWek652AKuaweMWRTcEQWCCzqDVbSE2X1gBw
         GTiUF5lzgbPL8fqYwR1aGshmBzYhnnOdaUqxGXX6t/UJHZ9zK5s8joGp1K0CwaoHKjFn
         OQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QC1PovymNNkKAAvc3+Y2ZnbD7wZWNV2RWB/4FBJfU/g=;
        b=MfTYZjT0Wn03wuJpJNt3BwQMV0VUBeE63QhRlPfcImXXG+RVZlbRIRq7HIGi+/F3XY
         sgW+0mev79SKzipD2KXfs6ZoaJzV2Q5FyQ1Q3/1aNXIE9bmBigMI6F93T3sn1AkIrb29
         /vJnJHv1sehI7ke03KkLlRHJnzNwMnwoZa/cypNn7Li323+bAvUx2zId1n+aUgBivQ6q
         OMi/gOmYWBDY9Dty8jPK2wPwn7jA5w27XG9ryvBRAMXHBDBif5ibYo2NIOlPwv1qo6FD
         7suRHF5fBceC05r5bibsagpCdSyxTeKUTjbJosWqinEgxcYCo3yzMqZteq2GaLV/5q2W
         Wtsg==
X-Gm-Message-State: AOAM533vuJIghc2jzipP8m0aj/VzVKEhxdFIN6XKofF1A6I5KakQXpS2
        doiKjhvokESzRmQBbMGqEd/6Va2KstLa/fee
X-Google-Smtp-Source: ABdhPJwZONayyRKyBNS2gV7nN5xnrhKCxGZJrYT9jC9x76zHmzWmgcPQ6KqtGZdmNVUZ93hQW8fX6Q==
X-Received: by 2002:a17:902:bc81:b029:ef:3f99:9f76 with SMTP id bb1-20020a170902bc81b02900ef3f999f76mr9724663plb.33.1620768582955;
        Tue, 11 May 2021 14:29:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y190sm14875650pgd.24.2021.05.11.14.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 14:29:42 -0700 (PDT)
Message-ID: <609af746.1c69fb81.bdd93.e3a0@mx.google.com>
Date:   Tue, 11 May 2021 14:29:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.35-299-gb60c63dd73a02
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 182 runs,
 3 regressions (v5.10.35-299-gb60c63dd73a02)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 182 runs, 3 regressions (v5.10.35-299-gb60c6=
3dd73a02)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
imx8mp-evk                   | arm64 | lab-nxp       | gcc-8    | defconfig=
          | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-8    | defconfig=
          | 1          =

tegra124-nyan-big            | arm   | lab-collabora | gcc-8    | multi_v7_=
defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.35-299-gb60c63dd73a02/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.35-299-gb60c63dd73a02
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b60c63dd73a029ca8da93b304328cae9f30e5c31 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
imx8mp-evk                   | arm64 | lab-nxp       | gcc-8    | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/609ac6808f3f194f70d08f8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
299-gb60c63dd73a02/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
299-gb60c63dd73a02/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ac6808f3f194f70d08=
f8e
        failing since 2 days (last pass: v5.10.35-249-g83b7e5089f21a, first=
 fail: v5.10.35-257-g999b6775fb75e) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-8    | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/609ac62caf86b79aa2d08f40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
299-gb60c63dd73a02/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
299-gb60c63dd73a02/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ac62caf86b79aa2d08=
f41
        new failure (last pass: v5.10.35-299-ge46308859abd9) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
tegra124-nyan-big            | arm   | lab-collabora | gcc-8    | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609aec808b7acdb46dd08f56

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
299-gb60c63dd73a02/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
299-gb60c63dd73a02/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609aec808b7acdb46dd08=
f57
        new failure (last pass: v5.10.35-257-g999b6775fb75e) =

 =20
