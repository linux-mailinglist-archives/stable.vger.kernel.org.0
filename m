Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D02243125E
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 10:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhJRIrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 04:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhJRIqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 04:46:52 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E630BC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 01:44:36 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i5so4483806pla.5
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 01:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2YdMn4jp2lgUKX5STJmaBpEUbN0lTSYXeWb33/7X1Kw=;
        b=YLP8csgHHWS1UUWQnIbQwKuMruco9I3t9z4IvRVuX8iHp+nOu/8vhQMQtC7sHTPzpT
         Mjnp1r37X0mlw6TgRTCUhYCEUyOTYDsj6XN9+VYftwCb4NXfZzKWE2n9MiRzdFlw650V
         7WTAu7yjeI0wYBrhg7Y3uj95RUgoCQyZ4rygNvtn99FSu1pB0fGdFNq1bVHLv0CBSCL5
         uLbyAtMxSPKJcYav1rA6PIGbjvzUg+T3EZNcDsKaw0Q3V52/qKqm0VtKlWu1PgfeqJGQ
         olEbthvVmSIDg4Ndm0uTpHOH/vEsQvjMA7eikncoPycoBaVHBrFFd4uadaxVj7TKtD2T
         yu1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2YdMn4jp2lgUKX5STJmaBpEUbN0lTSYXeWb33/7X1Kw=;
        b=sg114zwFtugquWyS56M1SG4RAcv1T44usoG6O2/MhfvirUoWwWUlOPEwpD/WvoGZmK
         MRV4BAbfpccUsJPetCtSnv4W2JGFJqEYW3qx48zpyqO/X8FNvkjh0ta+03r3AuzWfVXw
         +oWoTpLCqygSdS+G1Fh1Lpxwmvne6zngnwukpetjP20JZ77fXFySpLgVZFhDtWyIStqv
         ritWjvu2H8bn4s3BTSEMfHlv0ZaEYEqy1rv4S21YW3RvupG4fhEGiX1qe/Js9zKWy3Gd
         5X5pILzUFCH+2rMfHh5GYpXrwEm8FGjQIOUr2es+JmXq+hOgMlXZf5hXrWpZA5Oy++ES
         jAaw==
X-Gm-Message-State: AOAM533v5c7f1NKJQhZNGqKVZWeCRGJ3ClF/+xksawu1lwCkXvXszz/X
        /sU04nSayqcunGofRJEFaT+Ha0ZO5tjKPDJR
X-Google-Smtp-Source: ABdhPJy1krbhtYbgcdDScXiujPwLK8ZoJnE6NCPMyncilrAaKFWpZAWrA1FwYbJdgHl+QKk3wXAjbw==
X-Received: by 2002:a17:90a:2902:: with SMTP id g2mr31674246pjd.161.1634546676355;
        Mon, 18 Oct 2021 01:44:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a67sm12233965pfa.128.2021.10.18.01.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 01:44:36 -0700 (PDT)
Message-ID: <616d33f4.1c69fb81.ff0fb.27a1@mx.google.com>
Date:   Mon, 18 Oct 2021 01:44:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.12-68-g866f6861e71a
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.14.y baseline: 72 runs,
 1 regressions (v5.14.12-68-g866f6861e71a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 72 runs, 1 regressions (v5.14.12-68-g866f6=
861e71a)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.12-68-g866f6861e71a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.12-68-g866f6861e71a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      866f6861e71a6fbd73219f6dfcbd2d824a48f3b8 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/616d0019b8494ca2503358e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
2-68-g866f6861e71a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
2-68-g866f6861e71a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d0019b8494ca250335=
8ea
        new failure (last pass: v5.14.12-31-gc19d5ea47e55) =

 =20
