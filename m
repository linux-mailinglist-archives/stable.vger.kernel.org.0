Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB9A487EC5
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 23:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiAGWIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 17:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiAGWIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 17:08:00 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41972C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 14:08:00 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so13360056pjj.2
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 14:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UYKqDgy1GVT8j4zOgVXGfP+466cFigQNAxt3NTQFGp0=;
        b=UtELAnwxHoGT66xqDIsODkvtU3URZOpPXOpMSKT9T7W4aQ/F8iq2qkFEWd7LGHzAeZ
         jCR6xrFEGK6bt4dcgGZyiRBa5R28thJuDNQczMjMoKgb3NcxPpt6cUQuqlmuPGvs0S0E
         VL0bhU4TgJNfYzHI5zcFjHz6OHpeaE4x4l49Qdmw1+ZvXZwOgSTINmjsEVAc4osYNNB1
         onVFQQ69eZkjuCLEv3FOd0hNNzwJa1bmL6fu8jnHv2wfQtnAEQ0r267o7x+xOHaW4M1J
         5PbLZPHWME9MHkoQPGhFJbPtoq0TeG9c9Kp9FSwDV/K4I/qzY70ioW9WIveC8u/JsBt2
         lsHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UYKqDgy1GVT8j4zOgVXGfP+466cFigQNAxt3NTQFGp0=;
        b=yeby6IAs070qHlnbScpOT3H0Aacz2KEeZrrYdHzR+Df7DpURJJ0GzoL7sLbq88roIV
         fJqh2o1ruoYLZnIBogCJhtg2FoWvxAD0RNzbWuoYmh7k37+kS9UD1IejaAEUlIDir0n5
         eCWdh52Ph5Hx34AGYoMm7kwgetuFQM0eD9Ela5FXB0O7Rc26FTzwoWirbyA2wb1Yb1ci
         RBen8Fu2fUfSvQqTVvg/Ddkc2vhOnBmMwx+5/FQ4cqyPp7Ib9xrswMGinZpCp8cVzec9
         VJsIylY6r6x5s7XHL2350gD4ljlRlE1DmxnJCPzAi1NuHo2eCIYl6KlcOwDjzr+r4Kry
         vgvA==
X-Gm-Message-State: AOAM531cxFr9qna17T6OZFcjCbAcG45h3oo/+MH5Sq0VXyy539fyM9pt
        4pov/Tr3YUIHtOj74YyGQp42ruL986upNYAt
X-Google-Smtp-Source: ABdhPJw7AXW1nF3CdJ6GmRwjqlSgOLB9IXucTM3mXdcqFCWQ88bRrUsIFqSypaJbV+2ob9vZMyp2tQ==
X-Received: by 2002:a17:90b:1bc3:: with SMTP id oa3mr17956295pjb.0.1641593279659;
        Fri, 07 Jan 2022 14:07:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f13sm1862727pfv.98.2022.01.07.14.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 14:07:59 -0800 (PST)
Message-ID: <61d8b9bf.1c69fb81.88478.4800@mx.google.com>
Date:   Fri, 07 Jan 2022 14:07:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.13-31-gd7b607ed9408
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 152 runs,
 2 regressions (v5.15.13-31-gd7b607ed9408)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 152 runs, 2 regressions (v5.15.13-31-gd7b607=
ed9408)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.13-31-gd7b607ed9408/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.13-31-gd7b607ed9408
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7b607ed940890b92d770bed536c2a5e83366d18 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61d88791c4ff06b162ef676f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.13-=
31-gd7b607ed9408/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.13-=
31-gd7b607ed9408/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d88791c4ff06b162ef6=
770
        new failure (last pass: v5.15.13-2-g6db16d35c2fc) =

 =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61d8883567cd323d9bef674e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.13-=
31-gd7b607ed9408/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.13-=
31-gd7b607ed9408/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d8883567cd323d9bef6=
74f
        new failure (last pass: v5.15.13-1-g59461093d2fa) =

 =20
