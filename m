Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D3C323055
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 19:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhBWSMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 13:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhBWSMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 13:12:40 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC8DC061574
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 10:11:59 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l18so2506576pji.3
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 10:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GXYQt2Wpqe+2YTHd1+lBTQ7XzqdgDXwNxj5Nszc2O5Q=;
        b=DRoEjRNh7MGTtB/KnwY+yiBa+4Klk0jzpiYM8T6Jtl1jxTRknoLYxZ81OEoAn5yUlD
         hCkgmsyLOfXgC70m0010lysji68iqDHrERNs9qVLpV0ZR9vNKyXOXN0AAqVGUJrYAojf
         rEwcUbIhXBtxa2uAWZsvrWqK3a3OX9kMSJTAQXQ0Gu4snx+752sbhLzmZWlZ6IaQwj/G
         h9/eQ42ojxJ7E/4e+8H4cxTSwhr13HTcrT1uvXGmoLxsFRRLJ6tbcziM5oQtc8UGOFDx
         NdCCiH3KOlHeHQi6LFS2Z+qsIO1X06jKWD2E39JBZdNmgRNXKKiHHMwOaGdRds0i9i2J
         9qaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GXYQt2Wpqe+2YTHd1+lBTQ7XzqdgDXwNxj5Nszc2O5Q=;
        b=pbfVnWKgw+CeRsfVU4L0ZlllcW2M0PLFPD/svlUJmlMcX2dmihkmH4ohMgHDXIe5jN
         zQmt8ZmuZrdPq1z4tm0gBbHovY+HbbdS8JYUV70DaRULtAL+XGGnLdiFn17b8rVvquBF
         dglEu3irNYPWTnUaC7VKP9UqpPE6+wGuKtDhjt5p44y+4DymvrQEGN3mIAaHBgXIE1gL
         NHycyg0i5CA/73itHsjY/GYH0VweHRzQKdsXZLH11THukeAp8KZ0jviE3R/8wallYkwe
         ZyhftS8LAGOKPZKpgAsjoZrs8mNYE8Fm5yI2kKxbA192bIuSfp7cj92dhSwe9q8cxo7w
         dRyA==
X-Gm-Message-State: AOAM5320mmjDuEifUd62nTNwNLHZxWyHdc0OoDkL/Itv5S8j/IPHKo0v
        KSFh3Iu/cGPR6kn0gyegZ9H4LkKYZ/VxDA==
X-Google-Smtp-Source: ABdhPJwWFliUWtUXxCKowc4NGKV4GsuLRXC37uGQTjAuhioICgntQ+SAmgkS4yGp56/yix7Ri9o9fQ==
X-Received: by 2002:a17:90a:f493:: with SMTP id bx19mr17303537pjb.213.1614103919279;
        Tue, 23 Feb 2021 10:11:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a9sm4062680pjq.17.2021.02.23.10.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:11:59 -0800 (PST)
Message-ID: <6035456f.1c69fb81.5467.7e5d@mx.google.com>
Date:   Tue, 23 Feb 2021 10:11:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 73 runs, 3 regressions (v4.14.222)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 73 runs, 3 regressions (v4.14.222)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.222/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.222
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3242aa3a635c0958671ee1e4b0958dcc7c4e5c79 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60350ea7f594bb2db4addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.222/=
arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.222/=
arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60350ea7f594bb2db4add=
cba
        new failure (last pass: v4.14.221) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60350f2b1dab51215caddcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.222/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.222/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60350f2b1dab51215cadd=
cc6
        failing since 326 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60350ea41c5fe4c20eaddcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.222/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.222/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60350ea41c5fe4c20eadd=
cbc
        failing since 30 days (last pass: v4.14.216, first fail: v4.14.217) =

 =20
