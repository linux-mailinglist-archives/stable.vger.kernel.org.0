Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E415549B78A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 16:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345735AbiAYP1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 10:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349806AbiAYPYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 10:24:41 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A3CC061748
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 07:24:12 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id h14so2786903plf.1
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 07:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5+LGruMmo07z1KI4Z4ngBCWsuhquz8xY2TMOu9SY3mg=;
        b=lJxD3kEN4VAkwwwBSIizHXXwYN1MF7fACHoMVJ4udJsv/R4xih3/GWlosMoh37eSJx
         3cpTEmmsct7tJ6nl5DxT3JaqEvg7xvhbC0vU9/zNkzyNB4fIR1B6+v9Qw+M8rim5C00p
         qxPPFhsB7nSwmgjsur9KwIhQgTWvjel6Rw01DIZraGwkzI6Gxw9BM2fFg9QrOxgtModu
         ucZwcl7SfhvBeA1m/rsyTq8H3MBfUKjymVjPN782R09BCEWsa73/aPj2eBXiMlp0as5l
         ablaKK7Jwt1Zz3b7pY9ZGtf0ypXUCw+wvkuQ+RD7SGtBfVpx27TK5NmxhFmd7fgs2dL0
         njVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5+LGruMmo07z1KI4Z4ngBCWsuhquz8xY2TMOu9SY3mg=;
        b=ndfYgp4k8WsCxl3S3YmR0nXJcJiSoREg6MxIgJyycl/SkPEzL7UiqjGWQaBlZy1Fyl
         Qde47iCrLFzTWaRsyE2EBf+KsOCI6dP2R3YeHokorBoOj9Spfu9nMHGQXWbhPkCWFwbm
         5QkEpUmF+kdTysEKr6q/19+NwEbO2CEA2dGGKys/7iB23WJKcorQ8nggxxkiaqLYvl8t
         g21X1bq20yPnZZYpAbpaMBQewup5ic+Im4D5t9oAEBGD0PcwXRWPiMXhtACYU+uRr9cZ
         iGmmOwLOp/dNcEmYPXclKrd3uOiOI7ngcBGjXCbUS2B4g7yFu2xnM9a5PzmVAlfPz8MU
         CFvg==
X-Gm-Message-State: AOAM530AxwxoxmG8HIdYW1WRLon6ZaQzoXXHZgJikD0eUw5LJ2zSo+Qe
        4kXjoS0evspTtdtAQL5uwFiVsj4JfMJjHaRJ
X-Google-Smtp-Source: ABdhPJzNTcs6xLe10lDnaexrRBc7HQbGA4/3A9sDgLlkJOoPMWtIGYSvP+nHZ99WxxyJg6JdImfhpg==
X-Received: by 2002:a17:90b:1c8f:: with SMTP id oo15mr3927337pjb.141.1643124251595;
        Tue, 25 Jan 2022 07:24:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6sm777881pjg.22.2022.01.25.07.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 07:24:11 -0800 (PST)
Message-ID: <61f0161b.1c69fb81.94074.1de4@mx.google.com>
Date:   Tue, 25 Jan 2022 07:24:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-1037-gab4517ce4dd3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 115 runs,
 2 regressions (v5.16.2-1037-gab4517ce4dd3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 115 runs, 2 regressions (v5.16.2-1037-gab451=
7ce4dd3)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
imx6ul-14x14-evk    | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfig=
 | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.2-1037-gab4517ce4dd3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.2-1037-gab4517ce4dd3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab4517ce4dd33fff304a9685d7ce7d966274e331 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
imx6ul-14x14-evk    | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61efdd09adacaed9b6abbd17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-1=
037-gab4517ce4dd3/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-1=
037-gab4517ce4dd3/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61efdd09adacaed9b6abb=
d18
        failing since 1 day (last pass: v5.16-66-ge6abef275919, first fail:=
 v5.16.2-847-g4e4ea5113e47) =

 =



platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61efe16cea0e8a5f22abbd12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-1=
037-gab4517ce4dd3/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-1=
037-gab4517ce4dd3/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61efe16cea0e8a5f22abb=
d13
        new failure (last pass: v5.16.2-900-gce5c422ee966) =

 =20
