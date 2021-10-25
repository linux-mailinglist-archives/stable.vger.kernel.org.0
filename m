Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA279438E64
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 06:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhJYEef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 00:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhJYEee (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 00:34:34 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32169C061745
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 21:32:13 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d9so9523739pfl.6
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 21:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YjloyC0y30B+niJgqroxNva1sAcK/wZYhurRfe/ddEs=;
        b=w6K2aO0AcX8mC8spdjlUqQTJI8s4GRS28cWFMCjJmM20vkPaqBGpxMWDnf6HQcJ0It
         fE0y6FsX4Hwkh2u9oPUUA/tzowIh02ymD7j1H1q4WRRGHeYnNsKFp5sW/SfXWiiYicH6
         zqWVJcWF4sjENVflYRwSopnZ3/5Wc8p36Ykiczq27RrxW2jNl17dRzmSq/2Yd2qHHaWI
         y1ReEVh6jv81Ng/LD4elIpiQKOZXN4gVhhX8NqAvdpxLR2gtalGKo2SnZTWxALwjI3YJ
         SiehU2jvd+J9kbrWpjL/3xAcx9vbFXy6/2h60UwIkj6yMBUVxIoyQ5KQeyePn43yaxZ1
         +jcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YjloyC0y30B+niJgqroxNva1sAcK/wZYhurRfe/ddEs=;
        b=wGzgvkQD5k1AEX9Hy+Fg5hB+MfSnZKFZ/A+ma/sVZbWVpG+BdO37P2QlbttWW96d4e
         k0iRvj7K6uJHdavPSQmgtNO9VIuJVFWdE5qeYK896oz21JmzUgdVuZCJpUJXvK+j+Ve5
         O7s2F2RGrvv4GKUkS8i/b1odDcJBr4kFqgjZygO4/mKXsWaxzZ/QPQgSWZn2op8keTiS
         3X41Nsb0LIqDXAXa9H493kxVXVO+bB7YjHIlAcPfKchYEUQKVWx0dlXBAoxXNmLbhZAL
         VORPd6IKDmUS5bVAgCxrY8W1Lwmc6aaAbJPgkXEXi73DYZnBTbatwcrTw3r6ad5bPqdr
         /rkw==
X-Gm-Message-State: AOAM5320qnUaTkG2J7g7wDRazEGPbd0Lz8pvDfPvB/LHc9Jg5IIdQzH1
        5/AbfgLV0m7YF+4C+XrftiCbjO6LO/XjuIhm
X-Google-Smtp-Source: ABdhPJzaoTqf8W35J1cv46hsZCHHT9KvSKBD0ZJQED0hd7wgoQHXPNShVHP1lrRlloDtJ7LHasg2wg==
X-Received: by 2002:a63:ae07:: with SMTP id q7mr12190686pgf.84.1635136332507;
        Sun, 24 Oct 2021 21:32:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 31sm13700120pgs.29.2021.10.24.21.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 21:32:12 -0700 (PDT)
Message-ID: <6176334c.1c69fb81.10ee1.40df@mx.google.com>
Date:   Sun, 24 Oct 2021 21:32:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.14-147-g70db019b2220
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 182 runs,
 2 regressions (v5.14.14-147-g70db019b2220)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 182 runs, 2 regressions (v5.14.14-147-g70db0=
19b2220)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-10   | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.14-147-g70db019b2220/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.14-147-g70db019b2220
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      70db019b222043cd628a8f2d7730fed4007cbe5a =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-10   | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/617603c82647b06cf1335946

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
147-g70db019b2220/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
147-g70db019b2220/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617603c82647b06cf1335=
947
        failing since 0 day (last pass: v5.14.14-64-gb66eb77f69e4, first fa=
il: v5.14.14-124-g710e5bbf51e3) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6176028500a4fe83bc335906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
147-g70db019b2220/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
147-g70db019b2220/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6176028500a4fe83bc335=
907
        new failure (last pass: v5.14.14-124-g710e5bbf51e3) =

 =20
