Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B9931C436
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 00:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBOXMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 18:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhBOXMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 18:12:21 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657D3C061756
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 15:11:41 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u11so4476065plg.13
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 15:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ii+HeSbYe/VvwpkeeYIsRXnxnbdsHw3TuqlZQkC4/E0=;
        b=2Pb2Gn9PDdsduf1rSSTKNSSsEAkEHy8W5DPeNzMiSwxyfkwzMM+5Z+DDK5o7sDf5xe
         lIlYnI4VoM9C23Jc6NAeynedxI/MXAWPo9uTD8T4JpADxTtwPeJkDVJG6f7KG1FBtTrF
         zjFEOtvB6qkf6SPdSbyreA9PTr4+9lcyPHLxsvNo7+4y04EWVh/CfM6teQJqFR0KgtAE
         qyMxXW873cXj8AGD44mrzSeWdoCCbf4k9ztaBzj3JX7vFR/N6hCNsCzYpTbHwCfqxM1m
         9fKc6hTH81KQIYd3wUIKsLvjQJlln+Ho4wtePY01bbrzQRInlLr0Q0jyk0ZvnyIVKUOW
         7S4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ii+HeSbYe/VvwpkeeYIsRXnxnbdsHw3TuqlZQkC4/E0=;
        b=ItObTqixcKDYlbG1iWGgg1LJNapMxRtp+RoOJGX+ur55TlAMRXNp3MOUJkTeZkfI7y
         7H1DvgznrVuwTXKsZWGhpNkDtN/Iw0kQK5GyvMB8wSQkoagPy04v/wJOZ/ow5wSeWSc+
         ehRxsRQUo93jfHCvuhdBwNKeSIJmV/guEkFiR3UrR+bPTGAi/nCUl8U0OxhvQuot72mT
         wTNEsz2VA1iXFaHCSzizkOHsnbVwtEg45O3IGIS832mZZhyXrr074dlZF5Fsv+94IbYx
         PRDbFuIHQmu4qFstIaXg39VWdv0F3Ma9D2To3b3ykc9YMqKGaaA07XUvd4K5EJI7Sthj
         NQYw==
X-Gm-Message-State: AOAM531sm5ymloyTKNl+sazG5WZdNs692wiyC0U4e25dxDRUNpeu9pUs
        GGb9wmXoay80O4McXBE8Mfp+SI9nIen2og==
X-Google-Smtp-Source: ABdhPJzLE+bLLYr5ZxgchqfXIAfgOqc2VfBThyHYWmsK6xHfTuNYjlKje9pMcvNJJOBinND3cQuIYA==
X-Received: by 2002:a17:90a:4301:: with SMTP id q1mr1066602pjg.57.1613430700651;
        Mon, 15 Feb 2021 15:11:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f3sm19175611pfe.25.2021.02.15.15.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 15:11:39 -0800 (PST)
Message-ID: <602affab.1c69fb81.edb03.8215@mx.google.com>
Date:   Mon, 15 Feb 2021 15:11:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-37-ga4346d5d945c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 79 runs,
 1 regressions (v4.19.176-37-ga4346d5d945c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 79 runs, 1 regressions (v4.19.176-37-ga434=
6d5d945c)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.176-37-ga4346d5d945c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.176-37-ga4346d5d945c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a4346d5d945c303262908275419f3e36d888fea7 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602acd72d6f6c1c79aaddd10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
76-37-ga4346d5d945c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
76-37-ga4346d5d945c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602acd72d6f6c1c79aadd=
d11
        new failure (last pass: v4.19.176-4-g075b14a30060) =

 =20
