Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFF5401DF6
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 18:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243687AbhIFQCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 12:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243685AbhIFQCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 12:02:16 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AD0C061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 09:01:12 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r2so7191140pgl.10
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 09:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8KgzXytXp8cumFH1OfeLSIowC4tvZsXhAHP6NNEu2M0=;
        b=RbuBmOs4KYqDus5D6JSXLYrNPvavYvZ1D/DjQZzsuO2dk13EkEY1mB2nwEppYjuWA9
         337Fl3vG06v+F8m6L+JnUakXrxAHwcCzf5OgIPH8vh5nsImnGEXQzq/bvzVOjU3DIVWb
         QNHM0QOy+vGHw11LAUydUt69Adgdhpo7uzGsgSUjk1ibnOyKe214lZwXlFuUZaN1q9Eq
         /2IOVLchHZKS/RjF/SFGXEZX+YVmQeDlFPdp5+sZMggVke3FDji15AXL9zUbpky7zdn7
         O7TayAI5HFG+lEq1yYZeEISVa1iVGf/5v4csY6p1iF5rEJ5Yoe1zmoZ+HfWK8LJvynGO
         UsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8KgzXytXp8cumFH1OfeLSIowC4tvZsXhAHP6NNEu2M0=;
        b=d4A3+7wO6/ytzp5uCVaf/kgcEvArpb//HyWk6EmzmyDKjhCyDp4fvZlzh2zfA8yhkm
         n9/OUyfc7Qy2cm/eExJSZGYfGgbXF2TYj60XKlAXncM7gokkButnM6MTqoXfRv2v6sL7
         5kfX2Sao0w12kBioQ3Ci5pOPU9zwFubeaeIL4ahE9kqcUOnN43SjGMTaatKa+NKz+sw+
         DH5kbbOSUSg/ymDe79YZYSUD7EDbPQme2E5Ev+9TJZbUCes8mjokO6IvYp3TG5U0cgJb
         YXx+gGb7UmjjGT7qK3AZzsSyGbUcUJnRFrzwBho6P0MRSMTbnbG5A/x9JbbBeCveX379
         AeDw==
X-Gm-Message-State: AOAM53193sMSimaK6seIFOCb6s5jUox524cA3FzsFKqIzwEeVujvTJk8
        HWuEm4WpxHxeuksYBemaJsENYVQxozM9lGl1
X-Google-Smtp-Source: ABdhPJweszjuAGiZ0aKu7CpjjfxKB9/8gX9C4ZvW8WfIj+kq062pyZIFBgCI15kETJilXoOdmECTEA==
X-Received: by 2002:aa7:85d8:0:b0:408:78f4:a5fe with SMTP id z24-20020aa785d8000000b0040878f4a5femr12636523pfn.2.1630944071403;
        Mon, 06 Sep 2021 09:01:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm8350811pfq.15.2021.09.06.09.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 09:01:11 -0700 (PDT)
Message-ID: <61363b47.1c69fb81.51afa.6e0a@mx.google.com>
Date:   Mon, 06 Sep 2021 09:01:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.14-24-g859da76e52e2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 201 runs,
 4 regressions (v5.13.14-24-g859da76e52e2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 201 runs, 4 regressions (v5.13.14-24-g859da7=
6e52e2)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.14-24-g859da76e52e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.14-24-g859da76e52e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      859da76e52e2455411709de66f4d4475a7d21a6b =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61360b1207051338d0d59675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-g859da76e52e2/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-g859da76e52e2/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61360b1207051338d0d59=
676
        failing since 2 days (last pass: v5.13.14-2-g1b53bca7aeb0, first fa=
il: v5.13.14-2-g74aad924bd80) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6136096e4177f75555d59694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-g859da76e52e2/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-g859da76e52e2/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6136096e4177f75555d59=
695
        failing since 39 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613609d6228f530970d59669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-g859da76e52e2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-g859da76e52e2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613609d6228f530970d59=
66a
        failing since 2 days (last pass: v5.13.14-2-g1b53bca7aeb0, first fa=
il: v5.13.14-2-g74aad924bd80) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613608d831cdb7208fd59694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-g859da76e52e2/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-g859da76e52e2/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613608d831cdb7208fd59=
695
        failing since 2 days (last pass: v5.13.14-2-g1b53bca7aeb0, first fa=
il: v5.13.14-2-g74aad924bd80) =

 =20
