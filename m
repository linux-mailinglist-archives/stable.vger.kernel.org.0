Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B625C250B86
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 00:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHXWUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 18:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgHXWUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 18:20:06 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113EBC061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 15:20:06 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id m34so5348378pgl.11
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 15:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WCgLmSD8oSldUydBVh4oNCyZnM+8FLwd4GHJ5GpRqqA=;
        b=xuAr/KZ1Eq4odBFhHrz1JVPBP+37x25V3+p5dd/pb+y3QT9Q/XBpSsy9MbK0UFncyJ
         /Gvlmt211ZXgIHbOQfhx2d+C/MRIRiHTkF4C8mjYFX9BcqtenYYmXGko7uyKc1ff/fyO
         xvVJTDjCHQqEXiEvaJAiwX3VnrJyNuBws5JYUnoYUP/uKnxXGIZOZkk0Lg71iTIS3o3f
         pIw/z6kYPqOPTyjTaEfWfSF0x8raDg1j4/7vScJ/C4EKIPT8isPXxbaq4APFcZxSuXTW
         G375jP2oDn14mUmBZPoUKjMq6aL+wQ4swUZ8GZswtcOXgS6tgwkhYmN3EXkdVKm8Zmq3
         rtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WCgLmSD8oSldUydBVh4oNCyZnM+8FLwd4GHJ5GpRqqA=;
        b=hcoI+plGYqmKabRHKMqX8LA8m/TU1uuEqDRTR2iUXw4k5r1v5fphLHqDz0tjk071pi
         KgE96CJVVs0GrMjT2vjHBHE35qY4foyKsTylfTgS9pJXBATaJzhcW8EkgHQpLrl0FCHc
         o97EqJzKPkf1ikP/YLRFW59r/hFQrR5SiEBxlN7MawyugnZTld6GdP6hwLWBm15ZAYKR
         TEqSP57sRUzmtbBkhsKxeBDzWg8Nadnsv89JCGURr/s9x6rliHrX64c0fRHed8s3BFNW
         2SdCTvFpcq4vcazO4yUxc2Of73pD4nuJznZ9o2iZztwxwcOhxpFTuLv7e9Bmu0oC3Suv
         DpUg==
X-Gm-Message-State: AOAM5326KZGyBTpS+VKehGd8mAJDNwkUSOIgNxQibsojZyeZKVihtCWG
        TxYMa3/9oUF37LnWa0Si+An0L0Cf1mqlnQ==
X-Google-Smtp-Source: ABdhPJyiQZix6HoqhWNElbCQJvDFmwD8jbqJWWgHdBIX6Qybkko0dIpR7nREhutTfgOaLEGZD2MB6Q==
X-Received: by 2002:a65:60ce:: with SMTP id r14mr4804519pgv.85.1598307603757;
        Mon, 24 Aug 2020 15:20:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f17sm12861730pfq.67.2020.08.24.15.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 15:20:02 -0700 (PDT)
Message-ID: <5f443d12.1c69fb81.e4102.765b@mx.google.com>
Date:   Mon, 24 Aug 2020 15:20:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.17-128-gf16d132bb2de
Subject: stable-rc/linux-5.7.y baseline: 166 runs,
 1 regressions (v5.7.17-128-gf16d132bb2de)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 166 runs, 1 regressions (v5.7.17-128-gf16d1=
32bb2de)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.17-128-gf16d132bb2de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.17-128-gf16d132bb2de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f16d132bb2de3adb5e9470242c50c83b6d5d9a54 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f44074107516ecd6d9fb461

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17-=
128-gf16d132bb2de/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17-=
128-gf16d132bb2de/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f44074107516ecd6d9fb=
462
      failing since 39 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9)  =20
