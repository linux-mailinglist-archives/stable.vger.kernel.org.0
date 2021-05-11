Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16006379CF7
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 04:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhEKCgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 22:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhEKCgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 22:36:41 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D69C061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 19:35:35 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id md17so10848110pjb.0
        for <stable@vger.kernel.org>; Mon, 10 May 2021 19:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T5OJkDCm3CJ+MmCvS62l9mkmPO2Kcx6/xZIvyCt0HtI=;
        b=BGdJqYV9GcsPBIHm6bCwqzHeUrki6IeRTOpho5pZ4LFDk4bQHMI65Yhk+JLWKzo8K2
         dECV9D12z5w1cD2X1EiQSiC/hv43xpgXvp0SxVzUIH/6n/lScHLOzmhfb5GsB2Qg2azT
         NBgVPwS7gze9w6xfcaSzDJkRdGilO4pv43HcY8I5xjWCdwnrH96jhI2wgfw8/OTnhhto
         Ofky1L1HU4GXkh21cG5V56m8HwNQH2Uhr6e8Df5OYNhyHUD0j0bxz+MvdX3XwNjVagTH
         SEIwekyYakcDNfOXySLsoKJbyKbfUR8bQKbXIuOUJc0fdf9r8dj6yFz5OtE3QS3SR4f5
         LbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T5OJkDCm3CJ+MmCvS62l9mkmPO2Kcx6/xZIvyCt0HtI=;
        b=n+VTZzn0rsR2Fg9w5dKi233U1QZEmq1oMkrZEnjpFGclDkmy0OxH0SGuWDEUWzGrbR
         ADvGpianofGbcmXghvjRtnM9J+1qMlLdijYbaLpLftLTe8jjxXQomaNl0ECNEo8yGS56
         DgCNb5uN+m2jPS2/NBFwLY3OkyYrMrxMkeGxpEPyrIxvlliyTCrGqVVBaf0U430yO9CZ
         kIK2nLjskokAJwysZ8PvBEVr3HjnxrokA2eYHdrbGeEWKqd9xlP14s9DpDdtMa4pg6PO
         XryfYk8aPUpmQbJ9ViWqQt0nCtaWa33jE/plqZi1gnOtBi+IUyEC9Hc7KLd/wVVIuUu9
         Hn6g==
X-Gm-Message-State: AOAM530doOJp0dnVZlWgHr+KH34Oq4jmJ1TejvckBuf3vIproUdaProc
        QgX6EgVFPJWdAgEvBANLodlgKLDhm9VMQlkj
X-Google-Smtp-Source: ABdhPJzBMGfcCuvz/xs3tnaXQqD+KEKaztgZBzeVSR2/gwZV98O9AQBftfsVos0kZT5Cj6Rp+qC+Jg==
X-Received: by 2002:a17:90b:310b:: with SMTP id gc11mr31243550pjb.118.1620700534264;
        Mon, 10 May 2021 19:35:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h2sm646070pjq.16.2021.05.10.19.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:35:33 -0700 (PDT)
Message-ID: <6099ed75.1c69fb81.71acd.2d6f@mx.google.com>
Date:   Mon, 10 May 2021 19:35:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.2-385-g47db4685df620
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 156 runs,
 2 regressions (v5.12.2-385-g47db4685df620)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 156 runs, 2 regressions (v5.12.2-385-g47db=
4685df620)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
beaglebone-black   | arm  | lab-collabora   | gcc-8    | omap2plus_defconfi=
g | 1          =

imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.2-385-g47db4685df620/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.2-385-g47db4685df620
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47db4685df6206a3e39f7d56d6402b56e151373b =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
beaglebone-black   | arm  | lab-collabora   | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099ceba994917bfbd6f5489

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
-385-g47db4685df620/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-be=
aglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
-385-g47db4685df620/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-be=
aglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099ceba994917bfbd6f5=
48a
        new failure (last pass: v5.12.2-284-g66353c8ef656) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099baffac52d92fef6f549a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
-385-g47db4685df620/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
-385-g47db4685df620/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099baffac52d92fef6f5=
49b
        new failure (last pass: v5.12.2-284-g66353c8ef656) =

 =20
