Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EEB35BF16
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239356AbhDLJCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239783AbhDLJBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 05:01:18 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4727AC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 02:01:00 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso6723424pjh.2
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 02:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A7ON7RiVUWRRqOIZUrdABoEea3huUWG63tBmheX7jqc=;
        b=zbRb/uu8DnPigGkhMAoL161fJDIHriVYDf90Nx+kdIiZfdmgLyF2DWT9VrY19lpq9g
         cxN0z9s5Y6RHpO2S9cApTDD7Wg2wdBGQycqHdfg+dJB230LysgO76aX2OaRshIWXnvN8
         qcg84kVCRUlUE0WpxwkmXuJNJsspmXEVkdrqFfIX/BWB11mozeVDYTnbhtvkUhYaauk/
         ge55t9TAt5FAtYlADEwM6iZx+fsX7s/ET5V+33S1+RIR8k+xNn9VVVjasfl/grlOVV0q
         5ETz+CykmDx6PgZiMGf1/XG51hsV2RY+NY5jMtnNik+MPqvU10JFakr47S5em9v5/a1q
         Ql8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A7ON7RiVUWRRqOIZUrdABoEea3huUWG63tBmheX7jqc=;
        b=fJzmpN6Ln+ddToFtYMeYEDQ1mylymDztWE5VABuU2BYU7W6n8Ps7Dte64xqorC+vXj
         FM4CQgX7LgLy/RtWJsZs15IxjVf9I353/bbw1lpXbXDDcEe4FemgtHQNRdZ7Sl/pU7oK
         FQcqSbFvq0Tq3g4GdSQvS/qog4pXq1gsBbFtrfNA3F1Pioiq43EqK63Y+B45eB0kn7iR
         wn5TozrUCpQBgvPCM8v+pc0Y2Fd/XybifhVMEO6vQUtzJEGdNIDcP2fIvZfdb2nsP3ZR
         2NN+/VuozEsmpt6IoDqZgjO/Q1nDHiQTggJ3IUEly2gBpyorOiwz5W9kwh28r8THFog+
         wvzg==
X-Gm-Message-State: AOAM530/xKLE9PsZlVRjXnIZfLUq9QSzf9BoYUzA/pTmezek57eW4+Ms
        hCg8TpbZusaJ88LHgqavWUHFplYMfP+AOtKM
X-Google-Smtp-Source: ABdhPJydr5P4iqbbS0gByMs59V2zYld5DwQpKcxMg33pRGQutI6KIi2fNvCr/dMJE60qHNT+U9ZEDQ==
X-Received: by 2002:a17:90a:9a2:: with SMTP id 31mr4442655pjo.206.1618218059595;
        Mon, 12 Apr 2021 02:00:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g12sm5499690pfo.114.2021.04.12.02.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 02:00:59 -0700 (PDT)
Message-ID: <60740c4b.1c69fb81.d6683.c24a@mx.google.com>
Date:   Mon, 12 Apr 2021 02:00:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.29-168-g2e40b2aebb7f1
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 166 runs,
 2 regressions (v5.10.29-168-g2e40b2aebb7f1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 166 runs, 2 regressions (v5.10.29-168-g2e40b=
2aebb7f1)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.29-168-g2e40b2aebb7f1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.29-168-g2e40b2aebb7f1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e40b2aebb7f15ec66f6cbe0825e4588784e8db3 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6073d860f52bbaf910dac6b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
168-g2e40b2aebb7f1/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
168-g2e40b2aebb7f1/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073d860f52bbaf910dac=
6b4
        new failure (last pass: v5.10.29-93-g05a9d4973d3b9) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6073d83d0ace63f7d0dac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
168-g2e40b2aebb7f1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
168-g2e40b2aebb7f1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073d83d0ace63f7d0dac=
6bb
        failing since 0 day (last pass: v5.10.29-90-g9311ebab1b30e, first f=
ail: v5.10.29-93-g05a9d4973d3b9) =

 =20
