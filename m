Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AA0286ACB
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 00:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJGWU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 18:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgJGWU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 18:20:58 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90CFC061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 15:20:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i2so2504827pgh.7
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 15:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z0OwAdHxM+TFd22DLfTNwUlbQjMq16rh7YcdmYgkX64=;
        b=lxAjwNMEY9rSYzHJm4hWgJW87CwPcqqn82RieGQwlHuEcpPXEVOmTjcoz20ILLdsCn
         OW0jQ3x++bqWC0CkAqGjiSpVI7kcKSnnD0fW44dRUs9qbxq7PWmnsh+ac0OV/5M9To1E
         H8QGehdkcWZwgDIblaifv5oUnBGZVQ4Uo3SHu512E7KgKRep9VQu7eY5bwSF6XAY6kkW
         L5N+jF6ghBEV68szmpoGOhrDmOx5+QzjnKQ3uv0HvbDKLK8QHhvehF/RxBQdPL+O5GvJ
         h71ge5Y3jRuyBq9DvjNejOebD7Y3YZNVvDjXaLe/dZs4pcg1NrsGTNxrEoAd66PJPi4G
         Olyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z0OwAdHxM+TFd22DLfTNwUlbQjMq16rh7YcdmYgkX64=;
        b=Ti1fxrRNqie9AzCFuPk711EFLRDoJf+Oinh3DMs5kOMVS8Q4RkmE4KDanPPSNFaHZN
         OAQEQB4iu1hInAZb345slKtkYgiJBPqJQyg1ZkVBBVTZYaXM+NC/i4Cn5w3hx440nyQA
         k944ZMcXe133YgfEZniw8dQoSqOaXmXAI8KNbEbabrtaJcLCOMebWmoAgIaoiaVwa32V
         e8JuryNx0gbe8+C7+zMz9brn/aId4ZgMTvDA8TY5IWEUxOziGdp9PcLFtLRRSIqLJyn8
         xdAcNvZ+8X0lG6dHutMISJf00tLvtMjTvVljXDR7Uycx+bHpUd8rrXAtsBsMnHhcnylo
         0Xhg==
X-Gm-Message-State: AOAM531wCgAfqCATRWQMNfachWcb+G6rysyxFC/5ota88kzPt8DkJBRd
        U6daYHWLGyji67k5DCDeiPB2IGy/LhQOyw==
X-Google-Smtp-Source: ABdhPJxOh/AygiUEDBuLHFws+NNyGHLlTvFp5KiIJTPRzbXl3LIxOXgbGxdpFAfntpVBHNah0urPxA==
X-Received: by 2002:a17:90a:6282:: with SMTP id d2mr4813902pjj.86.1602109255740;
        Wed, 07 Oct 2020 15:20:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v65sm4433386pgv.21.2020.10.07.15.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 15:20:54 -0700 (PDT)
Message-ID: <5f7e3f46.1c69fb81.e816c.7f49@mx.google.com>
Date:   Wed, 07 Oct 2020 15:20:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149-43-ge0befa4cd000
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 87 runs,
 1 regressions (v4.19.149-43-ge0befa4cd000)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 87 runs, 1 regressions (v4.19.149-43-ge0befa=
4cd000)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.149-43-ge0befa4cd000/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.149-43-ge0befa4cd000
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0befa4cd000d3bee30f08e6abe39279d8f00e05 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7dffccfbb78fc6ec4ff3ee

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-43-ge0befa4cd000/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-43-ge0befa4cd000/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7dffcdfbb78fc6=
ec4ff3f2
      failing since 0 day (last pass: v4.19.149-40-g96fc1039735d, first fai=
l: v4.19.149-43-gf766dc7d9684)
      1 lines

    2020-10-07 17:48:12.897000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-07 17:48:12.897000  (user:khilman) is already connected
    2020-10-07 17:48:28.693000  =00
    2020-10-07 17:48:28.694000  =

    2020-10-07 17:48:28.695000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-07 17:48:28.695000  =

    2020-10-07 17:48:28.696000  DRAM:  948 MiB
    2020-10-07 17:48:28.710000  RPI 3 Model B (0xa02082)
    2020-10-07 17:48:28.796000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-07 17:48:28.828000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =20
