Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1C0269EE8
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 08:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgIOGzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 02:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgIOGzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 02:55:00 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B402C06174A
        for <stable@vger.kernel.org>; Mon, 14 Sep 2020 23:55:00 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k14so1459147pgi.9
        for <stable@vger.kernel.org>; Mon, 14 Sep 2020 23:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SGOv7QsFCCjp0p8LMOpvhnZ4jU81SdHdQvOMEck6q5s=;
        b=JhPE0bRnLnRGCxZbnBMyksnzeGVAd4KA1nY5ZEwCl+swYHBMXrjzWd+bxby5MXCdqK
         PuZ5j0A3BmmhqnsuCjU8+JoXNudWxyWKsslA/42nXnHxdZhkog4L7nBUTxLBr1OVfkeL
         XVmt5Zy2hwxxbktlQ9+HpCwEPM9Y6r9KNGZwIe8dZF8LqBZW7nPDrGwhloNYRvNj/pwX
         tM2XUorJrY3QbL74pi9uDL+zqnatSeBm9vw0yTJASw4v1961b8RlZZUpHVL1Z8c/SHcx
         3Rds8swGNt/D/ceapx0s3JPmV8azmUqzw0SZjRgLSLPsS9CoIkCT2cU+8UIMZMIHskPq
         6zIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SGOv7QsFCCjp0p8LMOpvhnZ4jU81SdHdQvOMEck6q5s=;
        b=bbMjOnYs6Mugu5YO7rtR+Pa73Hglsl9joFlwQ21VmXKchQMAAZHSgEWVvX3fIZYb+f
         qSVShrxZj7p9YEDSrzLftENSpWalzT7evaIft+O9XEUm3fqsoJSmyY/fWonyAAEUpPpR
         ZION5Vr4Z3EyRyVHOQDBY72UPA7JytWWLEsHtluMhFF7eTkz/sqQCLC4dpa1gHGcj9BG
         ZjqjaZk/QEKKRsMsnT7TDwBZf9wHc3FOERqj1oXpuQO8pDmMv+bDUMi26mHfCfDhXYsc
         aWBcwe3nuW9hoahA4xGHLaTbBepvEAADLFqybuzJ0eOVOLBcywTot9f6482PGb+LT6Pe
         LvEg==
X-Gm-Message-State: AOAM530K637MXd++y/3Xsts4UPic6NO/CexuG7287f/xxIFGNC62ND2J
        uhJeXanXTL56NolE27A5oVvzdkM5jSH/xQ==
X-Google-Smtp-Source: ABdhPJxzJNM4Nw6bs71dTre/sFzng+IAjA7cgMYCdoj21j3m21uiQXJz/znoJOT9as7dvt6vz3UeTA==
X-Received: by 2002:a63:c1e:: with SMTP id b30mr13627908pgl.345.1600152898849;
        Mon, 14 Sep 2020 23:54:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 17sm12023096pfi.55.2020.09.14.23.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 23:54:58 -0700 (PDT)
Message-ID: <5f606542.1c69fb81.85f33.0a5c@mx.google.com>
Date:   Mon, 14 Sep 2020 23:54:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.9-125-g5c90015d384b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 189 runs,
 1 regressions (v5.8.9-125-g5c90015d384b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 189 runs, 1 regressions (v5.8.9-125-g5c90015d=
384b)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.9-125-g5c90015d384b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.9-125-g5c90015d384b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c90015d384bd4d942ed61f349095d9fff6cf00d =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f602f674461b62cc0a60917

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-125=
-g5c90015d384b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-125=
-g5c90015d384b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f602f674461b62c=
c0a60919
      failing since 2 days (last pass: v5.8.8-16-gbd542de38b92, first fail:=
 v5.8.8-16-ga447c0d84b6f)
      2 lines

    2020-09-15 03:03:01.429000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-15 03:03:01.430000  (user:khilman) is already connected
    2020-09-15 03:03:17.195000  =00
    2020-09-15 03:03:17.196000  =

    2020-09-15 03:03:17.211000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-15 03:03:17.212000  =

    2020-09-15 03:03:17.212000  DRAM:  948 MiB
    2020-09-15 03:03:17.225000  RPI 3 Model B (0xa02082)
    2020-09-15 03:03:17.315000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-15 03:03:17.347000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (386 line(s) more)
      =20
