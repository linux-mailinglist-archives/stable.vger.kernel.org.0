Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED602A1779
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 13:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgJaMsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 08:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgJaMsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 08:48:17 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEABC0613D5
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 05:48:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 13so7413810pfy.4
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 05:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z3G4vVfnGw4OwpBixBeP/caAM1bntly1UKnP1EuRzbE=;
        b=RIUaXKUqAYyjrLzFHl0Wqh5ofR+fii5zG1P6FNBb36QnwWSeLET6WHf5M9XK9KCE/o
         yQHGlmKYAQw+WzCLWfhnJBqxXpKBukH7HDH1HX+95FZSc0poegc/8cLLaqz1RfDWFXMf
         cOPPdKbC4txQzUM79aHd/8EV+0TPMY7oU4l7Uluw63PEJdiCqewSp6kjjkJGbseP8xiO
         pxhACk82ovlIZjhewR4Q5denlTYtbt817pA3VzE+qgcdp0m1odqNAlZwqXWjRfJaEKGF
         nrXXFPYkVzFqLpZ/xxsYpFWSs/ngY+rDsd62GGUAIIXxAcpmhN5+NhqKfgeoJ1nHuWGr
         FFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z3G4vVfnGw4OwpBixBeP/caAM1bntly1UKnP1EuRzbE=;
        b=O7ZP7dqxS8UKUKZRsOH3lLL9DzwNApRKWD7B67TitrUuRAcd4rwpqUfiki88qge40U
         zuXJn2YtDxlFDEdJzAANLxOxY7RcRv/p7Xz11uXmA4XiHSdoZEBw5PsHTTCgEdsXzqyy
         zwPlFx+Eyq5p5OrQ6X0Oc5Y/DgUPcjNfm7voxfwkjcp2gbVarDejE4ptpRjOT4xWXvhm
         6XQRMKtkTFnoGNicTYIS96R7AT1o9E9J6irkMSLwuLyBOhQm/7hWnHnzDHAJBWknj46Q
         At0sj3T+5HMwhHIVFitc1jj4zCL51Gd3sCPxJmpgLAo9jQOnZFskETX4DIWA2bZGomVR
         N0+w==
X-Gm-Message-State: AOAM530r7MUWFjtJLNpB3yMmekfKcnqx6ELAdVCme0R0HqfQ6NfNHM2t
        L4cBHisKOO5TFn/mJ9QavuGKcIQqUNVUtw==
X-Google-Smtp-Source: ABdhPJz1qoi0dymvQ2oI6e6bKIBSAEuZA0oPGrpe1IS3qZPem5dBf/6I5YtjKoX7xI8kDiUS2Sb3YA==
X-Received: by 2002:a62:3004:0:b029:156:47d1:4072 with SMTP id w4-20020a6230040000b029015647d14072mr13680628pfw.63.1604148496858;
        Sat, 31 Oct 2020 05:48:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u5sm6216926pjn.15.2020.10.31.05.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 05:48:16 -0700 (PDT)
Message-ID: <5f9d5d10.1c69fb81.a669e.f63b@mx.google.com>
Date:   Sat, 31 Oct 2020 05:48:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-4-g40bcb1fe569e
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 150 runs,
 2 regressions (v4.9.241-4-g40bcb1fe569e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 150 runs, 2 regressions (v4.9.241-4-g40bcb1fe=
569e)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-4-g40bcb1fe569e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-4-g40bcb1fe569e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      40bcb1fe569ef056a2a3aea91829a1a582cff32c =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9d29285256aff0933fe7f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
-g40bcb1fe569e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
-g40bcb1fe569e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d29285256aff0933fe=
7f4
        failing since 2 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9d29215256aff0933fe7e0

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
-g40bcb1fe569e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
-g40bcb1fe569e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d29215256aff=
0933fe7e7
        new failure (last pass: v4.9.241-4-g8d9cc85ab09b)
        2 lines =

 =20
