Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981992A0922
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 16:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgJ3PFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 11:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgJ3PFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 11:05:12 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D00C0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 08:05:10 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id o3so5425997pgr.11
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 08:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GpypNYmBUUodrD+Fr1ku918nrwYXgxUdfADUtnDHs6k=;
        b=Qp4MeXaESNInjCxgi+OQlsl30NEY0Sya09RROyT3ihKVW51SW+sepY7hEwV3JdQyKU
         yp5g9ehT25c/Bl64Z6Sb1gXmYP6VvR5j5pgdkWSE8kuqBO4Iut/HI59BtsIVrZ9VGRph
         cpCSYdICp2ixl7DtABjHJ1lU1a3IdAxq3HK3tKXQz8v3QvPYTUyZBfoOEVZUEZc28JbF
         4ot1779bdFNHc3Dddi+mx1iRIDrgLXF1QCRG1X0u0jdT+BpTPWWWfbix5KWDKOHwVijH
         ph0yx3pqS3VUlcjd9ygxM5fm7PdTSLECY2Wysde15t3VrWvzklneq2X7j6bWlWt/e8DA
         suxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GpypNYmBUUodrD+Fr1ku918nrwYXgxUdfADUtnDHs6k=;
        b=WofNbmcgHwEWBCNjUQbOguZUm3a3IeCmu1UjkxtC3XL0FVAh02TCIssqFAzChjPqMz
         e8N4JsiRNVKH75+9UMefPwrpy9ccuYnZ+gehotnH/nAmcDJgYVJjZcFbE3LjU4x104i2
         xn49TnV9iDTdjyUESa80tPTa+cQVAewzfM6daCpw/bBV6ddpN5vzddRFdwE557yibqMj
         ErqpegTTN6vp56uUcWT59o3Dgdgo9RTJMAheQa8AjiaUWJqJ0Nyq4M3F/j9nXN6b0t89
         02z9n4puFi2xA/4sM+nzq5eulIQCRl4dFlbEojZT5JQ9qbtOo0QjWwc4C0DQ4cQqc45D
         9YYA==
X-Gm-Message-State: AOAM532C1A6Ax+w+SWV0TpGMbVVxT2zuaAYqcf1NhulWaFJKURzOuWrb
        a4EcD5BIzx5wDQs9RwCk1IabghwcnLUY2A==
X-Google-Smtp-Source: ABdhPJz9X1atS6uvaxsuAH6o7JqfCBxqYKq5xVkbtGNb1YXsXo28q9yL8nmScShfM6EpegWYwdYQ2w==
X-Received: by 2002:a62:ab0e:0:b029:156:1dfe:ae74 with SMTP id p14-20020a62ab0e0000b02901561dfeae74mr9163457pff.7.1604070309902;
        Fri, 30 Oct 2020 08:05:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p19sm6112491pfn.204.2020.10.30.08.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 08:05:09 -0700 (PDT)
Message-ID: <5f9c2ba5.1c69fb81.f60af.e88b@mx.google.com>
Date:   Fri, 30 Oct 2020 08:05:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.17-26-gabb7089aa00f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 195 runs,
 3 regressions (v5.8.17-26-gabb7089aa00f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 195 runs, 3 regressions (v5.8.17-26-gabb7089a=
a00f)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig         =
 | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig         =
 | 1          =

stm32mp157c-dk2      | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.17-26-gabb7089aa00f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.17-26-gabb7089aa00f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      abb7089aa00feed0537006f3265fc31a810670c7 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9bf83aa3673ae5bd381027

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-gabb7089aa00f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-gabb7089aa00f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9bf83aa3673ae5bd381=
028
        failing since 0 day (last pass: v5.8.16-658-gc32c23a5a4dd, first fa=
il: v5.8.17-26-g4cd0eaef7939) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9bf82c7f4322675e38102b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-gabb7089aa00f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-=
p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-gabb7089aa00f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-=
p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9bf82c7f4322675e381=
02c
        new failure (last pass: v5.8.17-26-g4cd0eaef7939) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
stm32mp157c-dk2      | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9bfa7c00605356fd381013

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-gabb7089aa00f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-gabb7089aa00f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9bfa7c00605356fd381=
014
        failing since 4 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
