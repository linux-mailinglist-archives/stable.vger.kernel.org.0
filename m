Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01183A1194
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238239AbhFIKxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 06:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238450AbhFIKxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 06:53:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F0EC0617A6
        for <stable@vger.kernel.org>; Wed,  9 Jun 2021 03:51:13 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v12so12307921plo.10
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 03:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KphT4PblpTwxoCORZbDI7fuzJdnH7IA7vKzV3hXVj8o=;
        b=RkspvR6qBckAdcGURvsmEbfilMAMehEq+NlkKQi2JCdCgCzzhrxZKd8dTnrEy3qIx/
         q7QFZQU5/lnL75fA/iLhXI80one4Qmd/YrEGOukocH4C4TB/gBcYz4XlkIBKWAMdgvko
         8aQqhoNPhVTQaoVOEt52DXkDy8mSQgsBxx9dSSlGKtuo5jz/XTOTPMyfm1aOCbp80Ghk
         qjm14IwbGwuF/OyM7cbhEapqoGQ2yzJ1DLZqaqGBkfUiCljVoXhA0ZdBKKkqakmxbfEZ
         G/fGQrdQwnbFbPUWZl3x85OiUVEHu/IRmnXS2VV2t1lE4uVEVtT+dh8a/oOyZazpHy91
         frDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KphT4PblpTwxoCORZbDI7fuzJdnH7IA7vKzV3hXVj8o=;
        b=rlHFFtyt9rjGL3nFfwF9C062SEqKVtrFHAKaxEVCNIIMgNwZVPk/3+W30SWv6X+JMK
         n8Y36QctC9Ld0eo4NVBwx/qYI0LE2UfNlXjZjkldH8v1ZSCE81MdH6G3vwxv0F9MTihD
         FP9drv132zi0ZTE3gHiNwjuxHlS4vdj/cHWjdbdQIVGlupDung+UXK8WY/Wgf69chjEl
         htE/4BamHdIzmocK34c5W3Tlcp5zwRFwS2uUgZWrRT5vCoMziDpyFSQB/CGzlcHczf2S
         PwuJfCQjqVmpzoh3XddARPQecXcXh284RiNgeia8gV+oJGc1pXAOksdE0Gxt/QPD7UOE
         at8Q==
X-Gm-Message-State: AOAM532InxAFp5ykZwVYR6F8WnhZNZikjkUcuzbe9AinZ0YjkMHtZqxA
        KGDhv9QSam54lg9bq2jQ+0WGqax6UsRBO1O4
X-Google-Smtp-Source: ABdhPJxGl1s6SzYqGobSE7JvRawaV6kn6Mx3KA4Av/5sg3s4N4oSSDqaP7l/gCXuFUnFkOq1x1NtBA==
X-Received: by 2002:a17:90b:3ec3:: with SMTP id rm3mr25383463pjb.105.1623235872720;
        Wed, 09 Jun 2021 03:51:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t14sm14019460pgk.21.2021.06.09.03.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:51:12 -0700 (PDT)
Message-ID: <60c09d20.1c69fb81.e5cb.ad19@mx.google.com>
Date:   Wed, 09 Jun 2021 03:51:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.235-47-gb003279f4bcb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 127 runs,
 2 regressions (v4.14.235-47-gb003279f4bcb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 127 runs, 2 regressions (v4.14.235-47-gb0032=
79f4bcb)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
          | regressions
---------------------------+-------+-----------------+----------+----------=
----------+------------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-8    | multi_v5_=
defconfig | 1          =

meson-gxm-q200             | arm64 | lab-baylibre    | gcc-8    | defconfig=
          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.235-47-gb003279f4bcb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.235-47-gb003279f4bcb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b003279f4bcbb72fc702dddbab4471618acba7f0 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
          | regressions
---------------------------+-------+-----------------+----------+----------=
----------+------------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-8    | multi_v5_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c068e31c3126d94f0c0e0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-47-gb003279f4bcb/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx=
27-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-47-gb003279f4bcb/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx=
27-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c068e31c3126d94f0c0=
e10
        new failure (last pass: v4.14.235-47-g4491bf20d46a) =

 =



platform                   | arch  | lab             | compiler | defconfig=
          | regressions
---------------------------+-------+-----------------+----------+----------=
----------+------------
meson-gxm-q200             | arm64 | lab-baylibre    | gcc-8    | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60c06db92ff8557b7e0c0e0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-47-gb003279f4bcb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-47-gb003279f4bcb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c06db92ff8557b7e0c0=
e0b
        failing since 100 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
