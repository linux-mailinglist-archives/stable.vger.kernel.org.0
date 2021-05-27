Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0578A3932F6
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhE0P5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbhE0P5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 11:57:11 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349D3C061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 08:55:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e15so196422plh.1
        for <stable@vger.kernel.org>; Thu, 27 May 2021 08:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cK+xwRkdvh5uyY8006sTmKtJR9OFz1sQPSWTqnhtv6U=;
        b=kTvYZE3mS7AZA7BTeYCp+J4OZnWAkuVgrhvG/P3AJftI0WDBsw4sAcQp1nU5FkFQLP
         APJIOSXLr4GtPHZ0Muh+Pr1Ic8KqNjKNZFcpO9TMeUZKeVZc4zDdjwt6hKWCmZOJfudV
         Ci/gSWzX0mUnLDOZp7JwUXh3AVm9xjg8WXZ1QLzUJCZdXqAIKZmOZZY0WyTq8qyjUe1Z
         xJcM5hYHNm6TJEA4UZwwxZO5uNlg/gGb9OUhspBzsCy0/TxRXR82QcwST4tGskRemAsy
         zL9vJMVv1gbwSYv3DgUCd8y5iVq4mSJXwUeAxCdS0ZqVUwHmzvjV6ZDzB3b3eTcr4+Ya
         ZiIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cK+xwRkdvh5uyY8006sTmKtJR9OFz1sQPSWTqnhtv6U=;
        b=JTavj9/j0rTCXxwIs/IH/iIeF1l0Fx+L0fxC4fdJ33qnVMDp3ZvM4DUL65IXaB3TUR
         oZZQuogH7eRiH4y2p1fVB3RUKztFTQP8TI6iZ1IzCHuBi+wbrbLFsT6xsevCId9DLXY0
         WkArF2azYakukisXFTZmBM21qpx/WLqnb9F4Brdj27TFkuv7yC/RkIrZddmDxVK80DoQ
         +Z13hUkFq1gjELVlRlX6HLWW3FWfM/PYjlM5tYuj4bjuvKLp708W/oTqcOgRuXlv8zA5
         9GHk8H2Nlem5T/d5tiaPvEUANE5m78rm5lttNhb+V45NX6CzIJQ2xQhx9H7MQEGYGZIv
         QUFQ==
X-Gm-Message-State: AOAM531wDRPj6xTicwA+eGFDks0VHSqfqNHWDmN80THPJ5c8vmY7ivWl
        1I2ceKpE8ZG0F/N3/HqTDzZ4WkHD1+XFSA==
X-Google-Smtp-Source: ABdhPJzYn3o9XMWvgXaXLsiA6ThhMQJP+6m1llc8w+rRR08dUxkGjam30a0nNxXyZgiKYpW4BlIVuw==
X-Received: by 2002:a17:90b:3792:: with SMTP id mz18mr2000619pjb.17.1622130936535;
        Thu, 27 May 2021 08:55:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p8sm2206980pfw.165.2021.05.27.08.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 08:55:36 -0700 (PDT)
Message-ID: <60afc0f8.1c69fb81.e912b.7544@mx.google.com>
Date:   Thu, 27 May 2021 08:55:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-8-g1b534e285a7e
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 156 runs,
 2 regressions (v5.10.40-8-g1b534e285a7e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 156 runs, 2 regressions (v5.10.40-8-g1b534e2=
85a7e)

Regressions Summary
-------------------

platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit       | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_d=
efconfig | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-8-g1b534e285a7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-8-g1b534e285a7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b534e285a7efcb69f99f199d47c4592d75c72ee =



Test Regressions
---------------- =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit       | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af88f694a110c01db3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
8-g1b534e285a7e/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
8-g1b534e285a7e/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af88f694a110c01db3a=
f99
        new failure (last pass: v5.10.39-110-g154f82582cf1) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60af8a267a5fbc9711b3afcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
8-g1b534e285a7e/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
8-g1b534e285a7e/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af8a267a5fbc9711b3a=
fd0
        new failure (last pass: v5.10.39-110-g154f82582cf1) =

 =20
