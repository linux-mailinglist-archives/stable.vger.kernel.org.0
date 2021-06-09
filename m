Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA123A08FB
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 03:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbhFIB1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 21:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhFIB1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 21:27:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18B6C061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 18:25:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so426868pjs.2
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 18:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ROBbPT2I7G+RaNkoB5DIWmGGHwRPatJSCfTdiQiC8BE=;
        b=JXIobwsdvxqUsbVNJOA9r+miSPPctdUyLhsiCgjLOOzQWSXvhLMQwZG8Q8AKGT4yFc
         W4XdTsLDosTG7kBx2a5VtaW1tWEkU/A7HgNdRo0PyKDw/SQ6qN6JZeLRHb6cCLEnhn8S
         IpA8HTNpECCMoeeKUehSMz6deytkFt/Has3ptpaeuZ7iaOR+zsJ3bteS+7godLRv2LR+
         1Lv1M1j7/M2lxNq5MQmGt0Y4SIsKZ83xYeQ+0D2lGTP8sBddMB+//msi+qbCCGu/EBhl
         39CEaZHBBg0+BOL0ZVeQAQoUz1cebxHW6yXcx9B6FivXnkhP3pqFkgd/gYq/zDe3rFsU
         tafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ROBbPT2I7G+RaNkoB5DIWmGGHwRPatJSCfTdiQiC8BE=;
        b=mlOQKN9ToNfPA1AHC3aWSUFjz9KrkEpsQynyift0FASGQDP6HnJe8XBpf9AN0/YZfy
         WD6nhyI/o63UAl/A16I/1HeoFBGc7LZfCmA2erAdtyNxVGph8Yvc+ku3cOjkHvRKIo8e
         UUOlEur9i4Z7o+483AsOSb3wiHkq1i7/xbsSH3NWp6Jbe8wEb916YMK4TB8Wax8H/5kB
         ehyW6nTlCWuu2bW0o7I82z1xLr5sSW5X8Qo35nCwm8+FwlXj7UfqDUe0+U6r3numU7zr
         4zdfOjw3RsCT3nBkz0xj8knwOVa0oKR52D8q1ihQGYTwm/RSzLlT+tQ6+7SY15NRdqgp
         8mQA==
X-Gm-Message-State: AOAM5318OSLWdRkeBn6MU7eK58v+jMBpwwpXKq0Kh4pVbhDnIQPSbmOo
        L/kD79e7UuJ6wjHdfc6X2HZAxmV68UEiUpsQ
X-Google-Smtp-Source: ABdhPJwUJOswyGY4iaJCwLm9qZ8RHReYAcZGKRq6qHJEsDe/tkeqtCTcsIdQIrQccEKhNmbKDQemlg==
X-Received: by 2002:a17:90a:b28d:: with SMTP id c13mr7760176pjr.80.1623201914776;
        Tue, 08 Jun 2021 18:25:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm11959175pfc.126.2021.06.08.18.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 18:25:14 -0700 (PDT)
Message-ID: <60c0187a.1c69fb81.23ccd.5ed8@mx.google.com>
Date:   Tue, 08 Jun 2021 18:25:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.42-137-g1b1289d4cd85
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 165 runs,
 1 regressions (v5.10.42-137-g1b1289d4cd85)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 165 runs, 1 regressions (v5.10.42-137-g1b128=
9d4cd85)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.42-137-g1b1289d4cd85/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.42-137-g1b1289d4cd85
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b1289d4cd85b6c54f43611532e9af2cce776430 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfe914383aa241820c0dfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
137-g1b1289d4cd85/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
137-g1b1289d4cd85/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfe914383aa241820c0=
dfe
        new failure (last pass: v5.10.42-137-gecb190051c9a) =

 =20
