Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2BA49E56A
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbiA0PF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238316AbiA0PF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:05:27 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE1FC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:05:27 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id h23so2482111pgk.11
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mn0pGy3ZsX+VTjmedaLOcf0ylftrYzWoWFcw3IfbP+o=;
        b=myy7TOR4FfBZ3ud22uoLI9y7pSYA6TKqbiu1cai0NQbKqjpy1Kod9FxKPc+CxfzLu0
         qjyRKciM+Y193dZJtTdXvAlFOTkZlzToz8FwzVc5jfzAC5Ku1yCiT9SHLec5l6HAr/JY
         z0oxPnSHkVNOwPov47jTmkyqsbetznvaZic+IvGUq6f/R0879MyzdCDqW7kgZbwm8rqp
         VAH3kmJVsuaFP2xsD+OqWTuUeUknHwVBBatsYkWRqxeBzv5dXdSqjl313LUhketXHoMb
         /gGpVY+zBo+tW9ihT9szs9v6EwIMX/gEysaB11ldM3nE0gBjeoHk0Yioscs9J667NYt1
         hyzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mn0pGy3ZsX+VTjmedaLOcf0ylftrYzWoWFcw3IfbP+o=;
        b=qNBfLeRsxIwdI8tewts+mTSKyK6V/JY1wnL4Y1uhPpyI3oKoGQJNrdOUE/F6U5hHRy
         NQElmAbID5nuDcRssjRTK2t8Yt2wliIfxtoywxo2XaLtxLthM7RWiF6kTB8kuOWRbLgJ
         GKhLsGwKqFWE74atNuqjEEIPbBWbQ0IKz05ldhV7k8woy9CoQbEu8PkHU6tXcGDCbPGc
         ftyBYD43NmlmNWEVy3m7YF91COJexoDr41DiEi7DX6fcHn5B88Bmv3EzddVJ1jDRhIYH
         11nSxa+96K1YnsasCaTNuYBG/py8MlQDLLPou4LYJj5Q/2Dmc+v8wPqm9etQUu6hCTBA
         ggAA==
X-Gm-Message-State: AOAM532Z2alOZ9qCldoZJML1QC3TAGKQagcoy6GpvfNeaZM/G1Maailk
        Xs2XDnJBjWrdhRYq2ARWPO6Vn06c71iUMKE7n1o=
X-Google-Smtp-Source: ABdhPJxOOfCPTh9yaSmyW+noGekMOEwQ4M7vhhbPwN4YTdstgaAc63yzoBsI/B1lWmlKe7X98o4dUA==
X-Received: by 2002:aa7:88c9:: with SMTP id k9mr3365291pff.58.1643295926484;
        Thu, 27 Jan 2022 07:05:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o13sm14884703pgu.89.2022.01.27.07.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:05:26 -0800 (PST)
Message-ID: <61f2b4b6.1c69fb81.f963b.7ae9@mx.google.com>
Date:   Thu, 27 Jan 2022 07:05:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.93-560-gc5cf5a611862
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 189 runs,
 1 regressions (v5.10.93-560-gc5cf5a611862)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 189 runs, 1 regressions (v5.10.93-560-gc5cf5=
a611862)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.93-560-gc5cf5a611862/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.93-560-gc5cf5a611862
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5cf5a611862bed05e417209b60eb34b90beeb0d =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f27d4e2383156595abbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.93-=
560-gc5cf5a611862/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.93-=
560-gc5cf5a611862/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f27d4e2383156595abb=
d12
        new failure (last pass: v5.10.93-560-gad15458eaca8) =

 =20
