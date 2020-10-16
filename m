Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F845290597
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 14:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395316AbgJPMxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 08:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395292AbgJPMxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 08:53:35 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B1EC061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 05:53:34 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p11so1233168pld.5
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 05:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZwXb0gEWQBZ4bbpobLggzuQLfeHUVM6jmZcY2upJ6m4=;
        b=dpDtinGyHpPBP/cJ8kjogpDz+6jcEp4y8uw8VZc9wlPdaOKJcSmhNw31L/s14Njjy0
         h0A0Qyvl0G9Ltj+xBjPH/VVTGxmLhwhDmDGqwm4mkTW9G2ek+E1b5Rp/RqFzVBUYAjc7
         YLAbbIDXv4LZdZ+PqBejrqwMYG7nbEHto1PPLmnHk0M9VKRJXdHtIhGXbvWIODv86UNz
         YQNn+YMgPmGmws5d0rd/75gt7MTk5W+2Z4AZCMHe/hUQ8m0nV4j7CbExoozRC949mFar
         bbfRtL5E8xNZHSPe4N1odGlTHR+hkuz2LlW6iwlSnNDbSRwVwgWbLszs+3ZIsGvNDGnv
         tWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZwXb0gEWQBZ4bbpobLggzuQLfeHUVM6jmZcY2upJ6m4=;
        b=mf8z+Z2FfgpHs+VIpNYATgEpaFzqyPdImmtJugNveNVM2ZYYp7jRLdjbULhaisDs9H
         LWPLI7h6TUUs8/AuDbJJVOrtCJbPTDRAY8mrYHjZ6cA4dkKlTQIKgSBNY9jggRiznQp5
         H9vdGBfAWujgeCqT8l6t4/aI7d5PEDBMUMFkDhEBix+hZ8YKCyrVABR9ALnB+QG/Jmyw
         6iR+imNMv9pUAL7s8xCuOUox0Sg6YjVfSFbr0iMzf10f4sd8b8kR/0uGAUyhV5kh+G9G
         p+JqOUeFps5SacJDg1fvUHoAbI4GehjwO++1sm2phuiM6QKH4scKKjc+veS2n+fUo2ci
         9M4Q==
X-Gm-Message-State: AOAM531pSP55Bg8eVLpVGxE7CXDv1h3iNzJ/t7YfG8ZhFXS89Vph0zgj
        T3r6OiBGi70UcuHhqJlEKd9MSd8H+YkdsQ==
X-Google-Smtp-Source: ABdhPJxTps1/3/fLjrpMhaIUkfFcQHbUWPpuvhkpP3uG9MWUdoLXI4n2sYBQWEDi6qlphcOOU6d63A==
X-Received: by 2002:a17:90a:8c02:: with SMTP id a2mr3945356pjo.186.1602852814045;
        Fri, 16 Oct 2020 05:53:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j12sm3015588pjs.21.2020.10.16.05.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 05:53:33 -0700 (PDT)
Message-ID: <5f8997cd.1c69fb81.b506.6273@mx.google.com>
Date:   Fri, 16 Oct 2020 05:53:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.15-12-gf18c79419fec
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 188 runs,
 1 regressions (v5.8.15-12-gf18c79419fec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 188 runs, 1 regressions (v5.8.15-12-gf18c7941=
9fec)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.15-12-gf18c79419fec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.15-12-gf18c79419fec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f18c79419fecaa0b96e605f39b8ebc530bb3fa3f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f895bd6521a81a8844ff3f2

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.15-12=
-gf18c79419fec/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.15-12=
-gf18c79419fec/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f895bd6521a81a8=
844ff3f6
      failing since 3 days (last pass: v5.8.14-112-g39817a9e3cbf, first fai=
l: v5.8.14-125-ge6c999327e0b)
      2 lines

    2020-10-16 08:35:28.343000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-16 08:35:28.343000  (user:khilman) is already connected
    2020-10-16 08:35:44.110000  =00
    2020-10-16 08:35:44.111000  =

    2020-10-16 08:35:44.111000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-16 08:35:44.111000  =

    2020-10-16 08:35:44.111000  DRAM:  948 MiB
    2020-10-16 08:35:44.126000  RPI 3 Model B (0xa02082)
    2020-10-16 08:35:44.213000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-16 08:35:44.245000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (388 line(s) more)
      =20
