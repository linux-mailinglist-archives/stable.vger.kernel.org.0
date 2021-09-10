Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE11407039
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 19:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhIJRGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 13:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhIJRGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 13:06:52 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFECC061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 10:05:41 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id v123so2397991pfb.11
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 10:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z0CMfiulG8n2BTWPRhNKBytbXDZ/VZivuRxjJj9CAFU=;
        b=MZZJ108ubzX0YYASo8MWHpbWotk0DrKE7l1PTGcX/mMfMtRINPdEr94JXz73ege8fs
         Kgm2CpHg082oDrqRqV1JqTfgWFI3wFmmM9InYvXewx3DrCXhNO/9Qq9ybUPeUZZ262bQ
         SBo+H1uFlGjm8O/LsJxND82YaBiaaLFNvRlD+zeqj27GvZ8W3M4Vpx2k5XprGj84IbQF
         RdYSxoK84/4EWWYQVAJWVZNXav5FfFmdH/9D3xv2s8n5kEeeLusVa6mpVeoM1ZwaShoq
         abTIXLsHX/a4FMr8pANc376b/ftTgVkcIfBA8ZCPksdqZvd/WTCASIta7wZBsXsPxTxL
         8nbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z0CMfiulG8n2BTWPRhNKBytbXDZ/VZivuRxjJj9CAFU=;
        b=XIKi2io3RyqIx2H9ognPs6gQADMHekLfoHeGmxGoY2fhQK4xolkxiUElY/tlsdNH4y
         czvWT4YDDvhsKEug39290f4+6MBldKBnw9anUGAJ/izl3dM5SRNPfK+gm9Ksa/HteziW
         YyJxvSRYVTowJWbsA8aGD3sdA6MuHeR9a5Z7XWYCVE6QKB3DfWnowBb0A3o+ILZQsTvd
         6ZDKQ9hKG0oFl9F9YeMhT2dJZCOcIbloLkMK2PGujDe//q0V4UV+FjYClptuAJOlTvOY
         27dyYeHzctlCE1LfqZUOWROzcnGnbnWht4Ppwu/R+TFpFd2/OuIMiQjuX6ZLbeXxQ/AZ
         ds7w==
X-Gm-Message-State: AOAM532xTZp/Jx8Cg325T4iyzXGtctk6ledjOJyG+dt63PyKRQ2lfGPl
        fyCS96otZ7tAE44mtC3qpXCYnGmbJL9mMTZB
X-Google-Smtp-Source: ABdhPJzWepymvilOjkSOESIMkR0KZMZb4iJT4rWPNIYYgHoBjsJj2IgwfNc3ML5mxd9EHieH9Zi9LA==
X-Received: by 2002:aa7:9688:0:b0:411:b9cb:df61 with SMTP id f8-20020aa79688000000b00411b9cbdf61mr9090751pfk.19.1631293540310;
        Fri, 10 Sep 2021 10:05:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h24sm5587096pfn.180.2021.09.10.10.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:05:40 -0700 (PDT)
Message-ID: <613b9064.1c69fb81.be694.fff6@mx.google.com>
Date:   Fri, 10 Sep 2021 10:05:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.2-24-g08d4da79178d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 188 runs,
 3 regressions (v5.14.2-24-g08d4da79178d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 188 runs, 3 regressions (v5.14.2-24-g08d4d=
a79178d)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig | 1  =
        =

r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-8    | defconfig | 1  =
        =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.2-24-g08d4da79178d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.2-24-g08d4da79178d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      08d4da79178d3d352115625b6aaa4eb58e173f0e =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/613b5fff81b3c3af41d5967d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.2=
-24-g08d4da79178d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.2=
-24-g08d4da79178d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b600081b3c3af41d59=
67e
        new failure (last pass: v5.14.1-15-gafbaa4bb4e04) =

 =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-8    | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/613b5ec14d621351dad596a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.2=
-24-g08d4da79178d/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.2=
-24-g08d4da79178d/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b5ec14d621351dad59=
6a1
        new failure (last pass: v5.14.1-15-gafbaa4bb4e04) =

 =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/613b5eeff0a6eee790d59666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.2=
-24-g08d4da79178d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.2=
-24-g08d4da79178d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b5eeff0a6eee790d59=
667
        failing since 3 days (last pass: v5.14-12-g95dc72bb9c03, first fail=
: v5.14.1-15-gafbaa4bb4e04) =

 =20
