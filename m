Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FE24762F5
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 21:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhLOUPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 15:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235337AbhLOUPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 15:15:30 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F6FC061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 12:15:30 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so20346408pjb.5
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 12:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jnyRJcKL/tuTl06ThmDhiDal+AlszFEjCBVVLUwCuYA=;
        b=jqvfugz2vvn91nWt9epmkEAucRFqyDhrlixSzjjdRUktaqskzsBMDnUhPfVBiZN/6q
         d7doUhwPb0p12y7FczQFEHp11uc914RZO9LsL8QowGpHeUS8BSuFpUwASa+IaoVEMJAr
         HJROUhjNq+m5Kkq1XFep2oFURdfRR51pwMYlI6uH6GgBDpwWVAcXKfb8WHJ1BZZM/DwL
         A+lf4gWwgFH+DEKSNziwTBerJFECyVl4bOPy1y/R1ZZkdh6Jrt6P37ixmrnA+FR0aRuu
         Ha9N78tuDyYqEM8tSlGO6JHKMvbKL3G3Dhqg/j1/63+TwTPfC/7CWe4/Gg3OouHDgb4Y
         0AWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jnyRJcKL/tuTl06ThmDhiDal+AlszFEjCBVVLUwCuYA=;
        b=xNoyfACr3QS8a/eg0FTP49dfW3y8diZQ1FfeY3RgOlAbDm+31PqdNKqvu0/8Av5rtA
         CqrKs0P9xt6CmJ4Eu1XqttgA3p8Pd9ZcRirhBZ7P6fSzFwOYjwaRdRaJau+uuKHYUEu/
         R2SpU/CpG9DU3Q8IRJFw+XjRv3mgFSyAGO6QUPiYix/6a3FKRwCLmqeo1EvP7sOajV0R
         5jRgmE++2D1Ti3WeUoDAkWJhCWdL8sJykJUeoGInFRRDmN8n1mSNtj/+wwQYz4a03bao
         DFTcbr1cwPFzROL2oJxOIsQjdHliICjwVCpUT6QcjFgvZS7Bpn2/EsaYTyKEu0OlHf7S
         hczg==
X-Gm-Message-State: AOAM532PMViyq7zy8NPak+mzOWHi+4r6bbxSjR9oy2543c3bP9Tdihof
        BDCBdFDqreKan9uTHxdyiiBZtAv4UO6zOHxR
X-Google-Smtp-Source: ABdhPJwWeA77TMlSPN4unFgvqMwWkYaKrwF07fVrKKP88jydLcRii/U//L6qAfk8JQ0/xYhKavVCqA==
X-Received: by 2002:a17:902:e8c5:b0:148:ab3d:7d47 with SMTP id v5-20020a170902e8c500b00148ab3d7d47mr3626084plg.161.1639599330025;
        Wed, 15 Dec 2021 12:15:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m6sm2796294pgb.31.2021.12.15.12.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 12:15:29 -0800 (PST)
Message-ID: <61ba4ce1.1c69fb81.efed.75ee@mx.google.com>
Date:   Wed, 15 Dec 2021 12:15:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-9-ge98226372348
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 129 runs,
 1 regressions (v4.19.221-9-ge98226372348)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 129 runs, 1 regressions (v4.19.221-9-ge98226=
372348)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.221-9-ge98226372348/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.221-9-ge98226372348
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e98226372348a4c6c5991a3f11a626eed8244f3e =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba1683aacac579be397123

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-ge98226372348/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-ge98226372348/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba1683aacac579be397=
124
        new failure (last pass: v4.19.221-8-g9f411771d292) =

 =20
