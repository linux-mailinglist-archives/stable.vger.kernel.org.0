Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7832328FC39
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 03:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388953AbgJPB34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 21:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388951AbgJPB34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 21:29:56 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B37C061755
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 18:29:55 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id n14so510690pff.6
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 18:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/CLulklVovsWGM4wsydvxDCC2lDbD1XePU67u5iQsAA=;
        b=OgnMisKCZYyR7NI8sy07TF3bMdxRdM4GfzxPZz1jHlCFm7iouwoPZ1z5hiZD+xJz6c
         SqeXk5CZUOuJGtQQf6a3Bk/cbb3PUZadZlVTdFWFWkG/3coKUEbiDI32UdNXZNmMcgDv
         yN5QdcMFjzbziO7PrU33JYLQIun1flo2hYLg6OL9mESzR4M7AA9Qx8GEWw3aVA68VfDb
         /oOmgZxF2yMKTCFXwP/3Cfysw1fxkYS3t4wHVUoa3K6UgpBKWYlOPbk86vh1h0IwLSDE
         CfuOcRCPqMjCm6f7KL31H+ixrqVdpCXiucsU9R9qT1GoW39V4YqPAQkUvzh7jefC0TPb
         vsVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/CLulklVovsWGM4wsydvxDCC2lDbD1XePU67u5iQsAA=;
        b=RDXGWrv8ZWlRRkDKja74rICmcvTSTrJ1LXf584WF7IDWMoyamo8Sg4NycNT+/MxSdc
         Poq88IJzvfqFYD90vtNYdm2Iu8A4kwzm3GV0RN2dTzFlh8WM/ikdkSHCK/62YIq0cjUs
         9bUrvuNgiqjs9MtKRBwQfryhCHxS6v1cMQ8lbL4jEejLfjEgV8bVm2rvI2Y5nF9n1BtA
         RPcSdNnq7pfodU9yyFQ61Qczcuv4o789yH5NbmPFn23cdeTVPDrx/DYr91yROv6iVH1N
         FsxzLRQkq5E0f21Sh/IEIzVdZnl5nWHqXepy1FYnjw+rGlpQePsFb5jCvxQIGJIJpBBp
         hPPA==
X-Gm-Message-State: AOAM533ajVp53+g73+HiR57UL+MPPLfOKOo62XFsV513DQpINXPCOflR
        IObU8I/n11KYWureL00dd9aFmSjbL0LKvQ==
X-Google-Smtp-Source: ABdhPJyvM0jOX7IyO5fBheofyVGYQsYKpAF+KT6gu8SqpNxuDr7VJxMliRZXaWI7co1NX/zLslaR9g==
X-Received: by 2002:a62:42:0:b029:152:4ed9:1f6d with SMTP id 63-20020a6200420000b02901524ed91f6dmr1363529pfa.32.1602811795164;
        Thu, 15 Oct 2020 18:29:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm617827pgi.69.2020.10.15.18.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 18:29:54 -0700 (PDT)
Message-ID: <5f88f792.1c69fb81.3198e.1ce7@mx.google.com>
Date:   Thu, 15 Oct 2020 18:29:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.15
X-Kernelci-Branch: linux-5.8.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.8.y baseline: 202 runs, 1 regressions (v5.8.15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 202 runs, 1 regressions (v5.8.15)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      665c6ff082e214537beef2e39ec366cddf446d52 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f88b9603373bf6fbb4ff406

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.15/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.15/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f88b9603373bf6f=
bb4ff40a
      new failure (last pass: v5.8.14-125-gf4ed6fb8f168)
      4 lines

    2020-10-15 21:01:46.403000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-15 21:01:46.403000  (user:khilman) is already connected
    2020-10-15 21:02:01.793000  =00
    2020-10-15 21:02:01.794000  =

    2020-10-15 21:02:01.794000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-15 21:02:01.794000  =

    2020-10-15 21:02:01.794000  DRAM:  948 MiB
    2020-10-15 21:02:01.810000  RPI 3 Model B (0xa02082)
    2020-10-15 21:02:01.896000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-15 21:02:01.928000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (397 line(s) more)
      =20
