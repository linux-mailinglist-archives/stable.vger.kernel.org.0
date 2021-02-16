Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4468F31C4B5
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 01:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBPAwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 19:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBPAwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 19:52:46 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6DBC0613D6
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 16:52:06 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id t29so5133175pfg.11
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 16:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3xwWdeYMA61cekd9Ilscx69wWznjYmavhU4kaHnhxwg=;
        b=bETdBqg4udCuZqCRPmypMgOr7JDIHuAc5U8myBTp5k0M4jduSpgpbZIDzfQr//paHH
         4CUUkjUnEFVr8cwcHl+P936C3Jheh29M9XlRz4cf2McWCI2Lr/VYMU4TUpzUhWZaBdd1
         InfDr7yVgRUbt/fDRGL5T/4Dr2joLgdq7qfcfQNj0f7Au6Nucamai4LIHhfU90BjX6cr
         lociSChxDvB7DQ8WQ8A+TPU3jyyE8iWTKBPOsW30N9/9Bi5Z2GYlylL2RZ6hCEvRFqlt
         nqqROTPvNHdDt0tb10R6hTH73D09L/B4TIFOw6hM18uM9E4OB4kYsWM+KVpnn+/gPjLF
         7U2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3xwWdeYMA61cekd9Ilscx69wWznjYmavhU4kaHnhxwg=;
        b=nP75ZbGkYUJHQhCoBUHMvyqpbF1c2wy3o+kpUozzLwoXcR+3ms4a5UK9b9wolvXEuA
         IOyOpfuhTrz69evhPHsKvZN+MWiBliF16oXELbz0/G3KCSfC3+m3n24nqxEubrDRRaSv
         zQYMgTjABqqaC1rEe2XZfAYMvZKEWhkAB73n681z1eF1LS1i9ohp3EHLkvVjW+Z3kjlq
         OHnT2P7oJMKymzOqr/SxARRiJJ8qeeEzTzxWzQ8yJDUM13qqiTfzvfEinnSY6RpvATqB
         bU7A4qAlqH0dguIjMtrpTPQVVbodgckGgbB641D8EWSpa5pJr5T7zIPek4HIuje7Q0e9
         4afw==
X-Gm-Message-State: AOAM532eqgTFHPJW63Y25dTre7euLTHozG3UXk1p8IGaRScgWryajOdY
        GOL2DEQ7hhhDCxjS+S4czXD4jNUfJmhc8g==
X-Google-Smtp-Source: ABdhPJzwtz69mfQfXKft0o94Bllsd1+a5izAfZBXKotYEFGL42YrcPclHziDWUzu1WjQQsFD7LCvdg==
X-Received: by 2002:a63:fc07:: with SMTP id j7mr788112pgi.401.1613436725939;
        Mon, 15 Feb 2021 16:52:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y67sm20105320pfb.71.2021.02.15.16.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 16:52:05 -0800 (PST)
Message-ID: <602b1735.1c69fb81.70014.a675@mx.google.com>
Date:   Mon, 15 Feb 2021 16:52:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-36-g4abb8e08b6ae
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 75 runs,
 1 regressions (v4.19.176-36-g4abb8e08b6ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 75 runs, 1 regressions (v4.19.176-36-g4abb8e=
08b6ae)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-36-g4abb8e08b6ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-36-g4abb8e08b6ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4abb8e08b6ae01266ac6045fad9f6e2b8724e479 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602ae40cf663e1c06baddd2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-36-g4abb8e08b6ae/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-36-g4abb8e08b6ae/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602ae40cf663e1c06badd=
d2d
        new failure (last pass: v4.19.176-27-gde63c7784ab7) =

 =20
