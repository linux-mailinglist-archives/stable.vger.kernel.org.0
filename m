Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF3F41E512
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 01:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350497AbhI3Xq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 19:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350393AbhI3Xq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 19:46:57 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802CCC06176A
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 16:45:14 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so2186397pjb.0
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 16:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YB0SuprtXbDmzyc7c6GQval53sFx+Ry2m0cEUTQaCQk=;
        b=WzWWoH+F1bovWlMAqpXQsTdz8W59X7fu6HlVeTmhqMAGbbIa1ESq5W/kIGCAhpP5VK
         qA8KTSG0TK+Fv7FU9rd5CSEQgqutsSxNrgWw2ov9vjZXDWcbpbFC/T5pHG2eF5OjASZW
         lioImLwkfSBOPWvMJLfJAPSa7cMroY9HTyHKI+oGz8PB5D5anp8axrnEaOyTOaCD1iUt
         CH1k6yC4IX7Fe2OYVZu9mv/bvfAqi+u/VG0IajqLeGeWj8mdV7lVa8ArwuIyNDEhG2JO
         r5JNE09poKfgLGsoIHKnGxVhoSkRiGKHiKGboIRqNLl51pxY9g4py3uLfSbSitJ/1Jj3
         GqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YB0SuprtXbDmzyc7c6GQval53sFx+Ry2m0cEUTQaCQk=;
        b=blI09kBJyWKPcH8QeBmYYYScJOlSkCh1SOZK4XMBe5unPGqdoCB4WeUzJSBEpHpPey
         DNCd9ncosEquxzGXIgAMT1wE1Ew3OMl/AFLlqZk3vYfcmWkUgiTUHL+eao66pGzsYnOr
         05/GSQyJffwX90VtkfbGwnAb6/BlcatD14zTs0cBcN5G1AxMBTSmCCt9RIxBO4Jlp13P
         DZMhvqKHAuMCht2iZQ0nM0troLoSIRMof0SK+6xOTMPdRb5oJYgpwvAYJFQwlNuco9x+
         gsNTDMfLZM2WlElCo2nbQkx+no+mAmnuLt+Bsqj/gr1pHELYs2Wd2bQWvvP5uWF0hPAw
         9oEw==
X-Gm-Message-State: AOAM531eHYLzpiFRu66M34rkMD9qegBwLF9ALWeuJ4dO3WCsDUhf+siD
        iKMTXRyTn8KQsyXbDA1XOB5ANFTag+FpRxqo
X-Google-Smtp-Source: ABdhPJxFiFzry4jOAiskBdhwY1M+BsMltKb4TyLCbAixkh7PdH7Seoy0H1MvdaMJfUrorCYG/ai6ag==
X-Received: by 2002:a17:902:8d8c:b0:13d:be20:e279 with SMTP id v12-20020a1709028d8c00b0013dbe20e279mr7881443plo.5.1633045513373;
        Thu, 30 Sep 2021 16:45:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13sm3577239pjg.25.2021.09.30.16.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 16:45:13 -0700 (PDT)
Message-ID: <61564c09.1c69fb81.5c044.b3f7@mx.google.com>
Date:   Thu, 30 Sep 2021 16:45:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.8-160-g69e08636c9b8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 161 runs,
 3 regressions (v5.14.8-160-g69e08636c9b8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 161 runs, 3 regressions (v5.14.8-160-g69e086=
36c9b8)

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

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.8-160-g69e08636c9b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.8-160-g69e08636c9b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69e08636c9b894ecb227e49dd6a1ff3ead30a8d1 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6156179d57e30b344c99a339

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.8-1=
60-g69e08636c9b8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.8-1=
60-g69e08636c9b8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6156179d57e30b344c99a=
33a
        failing since 2 days (last pass: v5.14.7-248-gf2e859a1e522, first f=
ail: v5.14.8-160-gc91145f28005) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6156163918c61b039499a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.8-1=
60-g69e08636c9b8/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.8-1=
60-g69e08636c9b8/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6156163918c61b039499a=
2e1
        new failure (last pass: v5.14.8-160-gc91145f28005) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61561826cb3d53984c99a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.8-1=
60-g69e08636c9b8/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.8-1=
60-g69e08636c9b8/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61561826cb3d53984c99a=
2e3
        failing since 5 days (last pass: v5.14.7-3-g11f9723f1192, first fai=
l: v5.14.7-100-g3633965a8dc7) =

 =20
