Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B8728AB34
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 02:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgJLAUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 20:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgJLAUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 20:20:19 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB25C0613CE
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 17:20:19 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id b193so11697759pga.6
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 17:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LcrDDz4sKTtYGaKKuoE/v18MQ7EKZBvHSJmVMKDanS0=;
        b=jLiFuA0Aa5NBlj6mfPDfIArtmC66XZRFlR90eeDn3tMCumIYTcqdsDh//kM4nd6NzP
         T+Nb1EEEhGURUF1EyOiA5qKmXfJcZGzr/cdMkpT2SMpnPBUp/DKLRco8HtGP6De/66rQ
         2ZxJ/wC9j9k+/C/6L3ClZCf9NF+4wEuPUaILIXHD0f3n0dwe9qXVWaz6Wnm0iS0JX9gc
         Ewee53DMwNWDcdTq2MB9W4jQ9pCtsWOi/2Uf56rP0DoVzG++n1dkIif88OGytdzsIThx
         gmhMRTLCcndd8GnFON3AHNVJ83ou+rBD/EUV1aXLUHb7mI8QSAwK3rBjN3k8ssm9M+Xt
         hEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LcrDDz4sKTtYGaKKuoE/v18MQ7EKZBvHSJmVMKDanS0=;
        b=ClhoHu9iNhwpGrpuojNwZ89MvkKEYqk4CypolIHcTV4aoEv+cRSJEierU2h2fGurDY
         V3RPW/Wzqu0+cWTct1P/6nHHJgDwMRc/knGR3Bty8byDetpslJiICspmoQgH81U9JGTA
         5redzJzsKnbEe0Dw7owJ7I3nW75iA73DgisZl9bojwlB8kmexhnB45w0HVegAJAXvvTx
         nV0eLl+IfRgR/f5xT+RzzzA9GNSRPYVpjAxClA3I5j+QOq/fJUPuV6qp/t7kbANjEXCG
         nuOaSdAkITlkynVFPdM5FkzxKV/f9exKw3nI+l8MdXifTJGOeoLpg8o3R2iEX36gbBz+
         GbaQ==
X-Gm-Message-State: AOAM533dWNPQHmhOHorw4dEUr4HdqGAMxYyo3I4NGO/nk+W2FOACKHH7
        qIZ6N5JfCobuh+UiFFLIWC4/62qgP+7jHA==
X-Google-Smtp-Source: ABdhPJySt8a3iLc9h+34bE0a1jiZB8hfHhskgsJnK1+vqs0/U/iLiFkJB5NGsWXRbbpHfmZ4moKJkw==
X-Received: by 2002:a17:90b:1053:: with SMTP id gq19mr14262957pjb.194.1602462017795;
        Sun, 11 Oct 2020 17:20:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y80sm13615885pfb.144.2020.10.11.17.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 17:20:17 -0700 (PDT)
Message-ID: <5f83a141.1c69fb81.52f7a.a43b@mx.google.com>
Date:   Sun, 11 Oct 2020 17:20:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.14-45-g4e0cc9fc2e6f
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 147 runs,
 1 regressions (v5.8.14-45-g4e0cc9fc2e6f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 147 runs, 1 regressions (v5.8.14-45-g4e0cc9fc=
2e6f)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.14-45-g4e0cc9fc2e6f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.14-45-g4e0cc9fc2e6f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e0cc9fc2e6f1a9d8afd3537cc5a5d8cac81f58f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8347ccfee5609f524ff3e0

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.14-45=
-g4e0cc9fc2e6f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.14-45=
-g4e0cc9fc2e6f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8347ccfee5609f=
524ff3e4
      new failure (last pass: v5.8.14-25-g7f6f73185983)
      1 lines

    2020-10-11 17:56:35.400000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-11 17:56:35.400000  (user:khilman) is already connected
    2020-10-11 17:56:50.942000  =00
    2020-10-11 17:56:50.942000  =

    2020-10-11 17:56:50.942000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-11 17:56:50.942000  =

    2020-10-11 17:56:50.942000  DRAM:  948 MiB
    2020-10-11 17:56:50.958000  RPI 3 Model B (0xa02082)
    2020-10-11 17:56:51.045000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-11 17:56:51.077000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (381 line(s) more)
      =20
