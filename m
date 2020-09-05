Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D016525E830
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgIENwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 09:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgIENgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Sep 2020 09:36:32 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DD2C061244
        for <stable@vger.kernel.org>; Sat,  5 Sep 2020 06:36:28 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 17so6146319pfw.9
        for <stable@vger.kernel.org>; Sat, 05 Sep 2020 06:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P0fAMxiE4TMX6Y4gitD3x3Ciz8WkoTeGUmvQ9TY86e8=;
        b=gH1QWw2nViMZImydqECAUQddZNUVmXcWgfP1vQwMwRskkQCBJxvBeOekG9Dnk/VVRS
         SRbpeVK+Wbs8cAnLqBHiLtQqFpN9Mq6sb/dQf6kE0SWwVV6dyPV9yC9tJPca5TaU0pl9
         TFfXw07uoV6/a4wczYQlooYYLowVVBNebd9zNuUSjCF/DmjFp9MjdzCz3XhpYLvpJYyS
         za/gYQPwbMmeWpUUK6xbG9cyTXcLhU1GopV1AGCjx+Xreah24HeWKnky79qBOPUl6qbk
         +6dcDJikUPvJ+quh/+O+lrLmjEIsBfGutbLGAV6VNCOYIXTX0wHxdZcAPdJwhVjq2G6f
         Bclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P0fAMxiE4TMX6Y4gitD3x3Ciz8WkoTeGUmvQ9TY86e8=;
        b=bhGWMDh2dH6THJEJ94akb9w1uPl5bTe0dMqi2nbk9hk7zQQvUx/ZLKPVzK77FOhGTX
         AU0ez8klchbhr2jk23CNknivUMPF43V3IaIN7+EwX4AG7PF66K2XaQSn3H+A/eLdbN1u
         4D64AoAdaklQcH2csMku2uWweWsAokYid7gNEz1SYtOaF23IwotQAnh7QCIfLnR5Vr6t
         7SwnJpoCinjZnALk5WUOrAjMov0cxzVIsIO1fwq5hraJN/dTEVXZMxVa4yYWagZyKDhd
         WGDtIzvEfq2JmDK35rVdaxooliluW1HSOM8LjOPJsbxy4dYNyOXNLl+eqIiRCttqJEBX
         IWVQ==
X-Gm-Message-State: AOAM532pBEBGlFcLXzHBT/sYoN/HcYNKFjF9OGqmE1BwpnGYhw/HaKrx
        IZnHFfa4FaYeFmE+1DtjyDpmQMRZZoVtVg==
X-Google-Smtp-Source: ABdhPJwqXKI0Adsom7SqTVbSJg11OEYePvXEeOPE36HHDEvPqZ6GK8yLkJMrVFfClWNg3l4MeM5uXA==
X-Received: by 2002:a05:6a00:228f:: with SMTP id f15mr13285743pfe.222.1599312984313;
        Sat, 05 Sep 2020 06:36:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 131sm8974066pgh.67.2020.09.05.06.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 06:36:23 -0700 (PDT)
Message-ID: <5f539457.1c69fb81.839c9.3e9e@mx.google.com>
Date:   Sat, 05 Sep 2020 06:36:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.63
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 181 runs, 1 regressions (v5.4.63)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 181 runs, 1 regressions (v5.4.63)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.63/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.63
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e32f4fa1b24d825b2560ca9cfbfd9df44a4310b4 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f535e63729cba66f3d35374

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.63/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.63/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f535e63729cba66=
f3d35376
      new failure (last pass: v5.4.62)
      2 lines

    2020-09-05 09:44:03.602000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-05 09:44:03.602000  (user:khilman) is already connected
    2020-09-05 09:44:18.896000  =00
    2020-09-05 09:44:18.896000  =

    2020-09-05 09:44:18.913000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-05 09:44:18.913000  =

    2020-09-05 09:44:18.913000  DRAM:  948 MiB
    2020-09-05 09:44:18.928000  RPI 3 Model B (0xa02082)
    2020-09-05 09:44:19.018000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-05 09:44:19.050000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (380 line(s) more)
      =20
