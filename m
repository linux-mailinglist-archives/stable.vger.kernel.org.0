Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220B0310AEA
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 13:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhBEMJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 07:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhBEMG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 07:06:57 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6D0C0613D6
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 04:06:12 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id w18so4183089pfu.9
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 04:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LlLqOnrvBZ3uhR2HK/kaGCEo+H8egdrjA44UNcp+mLg=;
        b=AuHnI7+cuzoFa2chaKnirRo38rBFexZQuyTFh+JxRgv3jIWnkp6obr02g9GjRB12SE
         p8AHHKDVigOWPbXxdz/TqwvOdlSif3LXRh8Sim4v15Ti0SNwq4ObzRxOx4WjmFsYdrit
         OgqLpMUrmotNHIU9lsJHYDRqt+2zwBRKve8a1OVLtdFeioMT6Tvrja3XwBw76fP7UKGv
         fvE1ZhhjKPfP35Sq4k0cwN3hGuGPEIZ99oTZlVbtYFe3/0058FtNH5nkw/WqZXd5ywi/
         kblPnKv1tFQkNoeZeJQHJmHfEJkQX8E4f2FCJzvbEwRTpfjLoYsG2Tx7sL0RndOB+0HH
         Jm4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LlLqOnrvBZ3uhR2HK/kaGCEo+H8egdrjA44UNcp+mLg=;
        b=hZpxo5FlKfoF1F9G0JBrWjjK+NCFrrWeWOgip8cTdBCZhi8QVdtf5lvgQrpuwLMpnx
         EbmHqtA/MSk4XWGdn+YaJutwOEwcvoL+lF2t6u9wuvTTGBCqT4z4ZEGFn8w/6FKHwhAe
         TJwvq/1kAiV0fAbWfIIASrDQ/3d6FbduCcucCC833edQ7vdto9Y7eAzbKL1Balvr2Vqk
         MJFKXW+76p4X/Rg8oQvsFHbcA6fZCtmDU3Ir5yoxu4e4m6b/flnV8/EGZWKWoX2soBv3
         b+Ejl6KY2grqhygQc1BxdQVt1ORKDMX8nk3GfxkpdXVMnJia2g4NRtyweKnNjJvApxDP
         EqpA==
X-Gm-Message-State: AOAM533j8UfkP4Ej7ZWE5rmse7/psn1vsAss8FTPjyucHG5NSlXVe7DI
        QQZDvPDwxh/xUqxyqUwmgR5pQkni+YR8JCOm
X-Google-Smtp-Source: ABdhPJyNHFMuOFsLWE+j4uq+yHblpmUp5vUDgKyr4ksn8kw8O4z3HLzkU91N5At7ZnVJA3nXhfWVlA==
X-Received: by 2002:a63:d304:: with SMTP id b4mr4124313pgg.299.1612526771916;
        Fri, 05 Feb 2021 04:06:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15sm9000184pfb.30.2021.02.05.04.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 04:06:11 -0800 (PST)
Message-ID: <601d34b3.1c69fb81.d050f.3689@mx.google.com>
Date:   Fri, 05 Feb 2021 04:06:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.13-15-g57e419dd2516
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 174 runs,
 1 regressions (v5.10.13-15-g57e419dd2516)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 174 runs, 1 regressions (v5.10.13-15-g57e419=
dd2516)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.13-15-g57e419dd2516/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.13-15-g57e419dd2516
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      57e419dd2516b60fcf487c832b0d733bd2455a46 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d02556647e3a8903abe66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
15-g57e419dd2516/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
15-g57e419dd2516/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d02556647e3a8903ab=
e67
        new failure (last pass: v5.10.13-14-g1338c0e853471) =

 =20
