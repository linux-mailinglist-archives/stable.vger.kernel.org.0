Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563AD3C5761
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354142AbhGLIcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359423AbhGLI0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 04:26:47 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44DDC03D2B3
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 01:22:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u3so3641898plf.5
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 01:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VqVqrdK5k+Hjz/Kfy/qZPOemQOHMn/8Vvq6WDb2wSpc=;
        b=O5U2Bba+E8EUtp1pVesUU3VkC2VGczZ5ScvkwcGX455hesi+dm1KRo4ufSFmoDz9Rn
         M2mx09lQpP1120Jk+bZ/ZlYwm8RiH5Hy7ntdwP3UakUVWhUBds4KAPei6ozQdMytDb3v
         PZ6Bka675oEq4TtF3MlX+Ft3yM6hMss0IF2xj9EeEG8WmmlMLCaGm03XWbXNsr9dGtYV
         p2816bqJ+/XqRl76rKrrHAd0avfnNt9VXtZgI5F0nbjYBOFaeqd26d/ZLcAXeWT9h+Q5
         hEH1HddAKL4zTTrS6S5u9XC1GALSkeQ25TniyY+fIra4pParQJqjSv9H6HaPQ3c3dS15
         LmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VqVqrdK5k+Hjz/Kfy/qZPOemQOHMn/8Vvq6WDb2wSpc=;
        b=HvqUdYzY7BBuTT//e0xqvHr/voB253VTdkX7kbMf0nCjacu0UiPtMrOlD7atHTL9+m
         sCYMoB+6IGlmiVMNd8Uc0p3iRo+H662gPl4sVrdc0U0UBjohribW1i2AKpMYRapOw8GZ
         DWOTgjc3XLFzWhFlYiWfumtJJ/NZWjVTqnQtWnQZPJJqv++gqmcsVy7wziDttudykezQ
         XNXoe3jlrVzct0LqNgaou4pYC6gua2eX7KLQS1wUvnGcmHFbOsi3gQO9YqqN4GVnySxM
         JBuQTey8/1OlwRHYOQl2XFmligbM8zFBvdPU9vCoK/qrqoxyV3fVSFyuVi9drLi5hCc0
         URxA==
X-Gm-Message-State: AOAM530UI9mBCqDLSg+3xDjyzi+QKJ5e/zyb4XsxBXPykF522OX+KGrm
        s2U9ORouJb2E4iurjZ/hV+TwL+j48xCxD437
X-Google-Smtp-Source: ABdhPJw01JGP4yWf9e+QiuQKIelqjYxBmi3T9RoBML2+S6Q2A7bTmrJKhu2Siv6bUJun5CA3AcLX1g==
X-Received: by 2002:a17:90a:930e:: with SMTP id p14mr2987001pjo.132.1626078144201;
        Mon, 12 Jul 2021 01:22:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e21sm15076264pfc.172.2021.07.12.01.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 01:22:23 -0700 (PDT)
Message-ID: <60ebfbbf.1c69fb81.e189c.ca8e@mx.google.com>
Date:   Mon, 12 Jul 2021 01:22:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.1-799-g450544e613d4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 165 runs,
 2 regressions (v5.13.1-799-g450544e613d4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 165 runs, 2 regressions (v5.13.1-799-g450544=
e613d4)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.1-799-g450544e613d4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.1-799-g450544e613d4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      450544e613d475d4983d871b9f15cb2b078f196b =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebc7d4b6f80f0e7a1179c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
99-g450544e613d4/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
99-g450544e613d4/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebc7d4b6f80f0e7a117=
9c7
        new failure (last pass: v5.13.1-801-gb2246d387d36) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebc9900120b57f2f11799a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
99-g450544e613d4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
99-g450544e613d4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebc9900120b57f2f117=
99b
        failing since 0 day (last pass: v5.13.1, first fail: v5.13.1-782-ge=
04a16db1cc5) =

 =20
