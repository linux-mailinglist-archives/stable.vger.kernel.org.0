Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881FC392143
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 22:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbhEZUIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 16:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbhEZUIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 16:08:44 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8188C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 13:07:12 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id kr9so1423024pjb.5
        for <stable@vger.kernel.org>; Wed, 26 May 2021 13:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p51ckBct05sJnbwCzQ4XEVDSg7dSdECuGWpKFLoPREE=;
        b=utm4j1DLGa71VzerM3NipA3+OQtZQZxyNFZ0v94jFUF/3djgLII+D37STv8uHUbEcz
         ffvfHI7T30emIopSri7oPTDTTPDmcSc7bJV7YChflJcbtwWACLJWhq9ijGFri1r1Eh9n
         HMFqxH2KcHEVAr3XkZntekTxGjgBWzqP+H1Ey40/QkROGXaet1Brtcgd0j9qpIyaWgag
         3FDr1wnAMZqpEJmfhC9CAlNs+8aJLlBtxG0a/JmzXhU2aoiXD/U5+FWuXo2brRfkzYD8
         vuFq6Qpswnq9FkASgn/7RyEuqa98IGoULoWSDCjH5scRTGJsswSei8wxIZl/2lDUTHKa
         UjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p51ckBct05sJnbwCzQ4XEVDSg7dSdECuGWpKFLoPREE=;
        b=Ymkp8L15bYI4Nuv+m2eJ5ZJCbEi8N6O3AIXBNnaXmO0aAQaEdGKLeimo9BLA45D1ci
         6K7jvs1ar7rGKAmWtBVUxN5f35OJCEsAFQ4S1nzkRwcjgKqCanWnJP1gSiDJ/HTPFnM6
         YaAJ32xUuUS0acynJbMa5YeGg8aGFlTJtoX23w4dQSBGfLWEQXw/pfJ234IFyuazN8c6
         xH3BhpItZAi+uc/FuN+0WpX3gETqwryYKkEhEUvmeA5c8sJFaBHJ00s3ZS/le61og93H
         Z8EOonQIJ+681G73qjcAA4kkma5R0RIEawMZUxLU3pjmoDoierCQ2UjH9bDorRGuKkNQ
         zc/A==
X-Gm-Message-State: AOAM531kooIKosKqjuPwSmJODrg1Xug4qvMVewHfije1+xmfMW5SGjUo
        qwvKm4LUvnPsjU2Fb9aKniX1rV0WSVgnCzf1
X-Google-Smtp-Source: ABdhPJyraHOj78XVk5i7TnS2YXDnzILzHZTT5uo+Hqh07YgZBvmpBQnSc7a1erJnX0Ki8rZoQ5hRRA==
X-Received: by 2002:a17:902:db0f:b029:f3:e5f4:87f1 with SMTP id m15-20020a170902db0fb02900f3e5f487f1mr36982945plx.26.1622059631862;
        Wed, 26 May 2021 13:07:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s140sm64739pfs.73.2021.05.26.13.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 13:07:11 -0700 (PDT)
Message-ID: <60aeaa6f.1c69fb81.2565.0567@mx.google.com>
Date:   Wed, 26 May 2021 13:07:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.121-77-g25f112ef6424
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 117 runs,
 2 regressions (v5.4.121-77-g25f112ef6424)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 117 runs, 2 regressions (v5.4.121-77-g25f112e=
f6424)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.121-77-g25f112ef6424/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.121-77-g25f112ef6424
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25f112ef6424a68f694a0d767aef359172d77f94 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae7796e749133f45b3afc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
7-g25f112ef6424/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
7-g25f112ef6424/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae7796e749133f45b3a=
fca
        new failure (last pass: v5.4.121-73-gf68ce40c7139) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae774719fb5e4cdeb3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
7-g25f112ef6424/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
7-g25f112ef6424/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae774719fb5e4cdeb3a=
f99
        failing since 0 day (last pass: v5.4.121-70-gb3c1ba3ecdd9, first fa=
il: v5.4.121-72-gb7d94ef5137e) =

 =20
