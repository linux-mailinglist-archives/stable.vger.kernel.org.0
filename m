Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE20926B49D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgIOX2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727447AbgIOX2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 19:28:00 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BD2C06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 16:28:00 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id n14so2851611pff.6
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 16:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ku6ZpdgGszJYUW1AfOj/Rkmrs1Wp/Wo7AmUnsZsRTGs=;
        b=QXu9qFhqN8cblWSS9Fiw8BWdih03NpEQvNvtOZ4af2qXrBMCs9qJxR1Hfskf6i9gK0
         dK8Ph4JylTxHyJFhkZ9rWvABmKKuqC5EOipN3OvuBvNmK9noFonHLAD0bFteUrtdEm3R
         wmTrHjc/71/w2Szb1+p/MEmaArEdsQlL7e5MUXwI8xG7YyQmWZ7uLQwZE3/sViP43A6k
         AKR6QitLm2A67t0jkqsgOs0tS+Z1CYDIdZPrgHxlRKIwNQJMDkBpwAqxW/At9hQO8mjP
         gOl8V1b2VYgufbB/wPPwHdjJQkg9MINa5VL/Gw20PhgD5j3IvawGoKMm+aSzj9kjRmqf
         QJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ku6ZpdgGszJYUW1AfOj/Rkmrs1Wp/Wo7AmUnsZsRTGs=;
        b=QQLWcTcUhqLLmbdYCEIjgjMVUJdQCzCgjv8Ukkbh+uzlO+8NUx4txZNxt9/NtZThsA
         MCjTNYM3ymEuhTYPVECbeIIwU1Fstl2XSJoOVtFiR2jgRwKTsNaR83McMZCG1hhctMMt
         xUSQU2ge+lgRK0Sq1S8FOfnlFqr9LDWqVXmLaD7gG4ZHsS4ICWvac1pOMAbVOcXnbcmS
         cJ6LYsr3KTIaRGU15JLXCV3HKKeM4phoSVgulnPGlGUnBlMi40LOerN7VF7U22qplF1C
         X6QWhxHSqqFuEmLV1vxZcImPMV5h68tHLqx5ZIuZVqSMrw26IElc9bSjy+p/wEvpARfT
         hmhA==
X-Gm-Message-State: AOAM532v5+nOhWD2+iqXdQcz9JKlbXUevZ2WTTcM6eeJztAl+8I/rjwn
        Q7dGiDwME4dH5S0/3q00gcKCeknFsU/Jdw==
X-Google-Smtp-Source: ABdhPJwjQC1X+osQv8i4xxUoxI5KW2nZFpWFr0f0K0bsaKrC6sfojaFlHTIeUQrp1aHRYhuiBqSuOQ==
X-Received: by 2002:a63:4723:: with SMTP id u35mr11942323pga.269.1600212478013;
        Tue, 15 Sep 2020 16:27:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y1sm12160979pgr.3.2020.09.15.16.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 16:27:57 -0700 (PDT)
Message-ID: <5f614dfd.1c69fb81.40d6d.0822@mx.google.com>
Date:   Tue, 15 Sep 2020 16:27:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.9-176-gae714154c122
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 170 runs,
 1 regressions (v5.8.9-176-gae714154c122)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 170 runs, 1 regressions (v5.8.9-176-gae714154=
c122)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.9-176-gae714154c122/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.9-176-gae714154c122
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae714154c122c3a92d92d833f07fddb58937ec64 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f611a3521e953ffbcbed943

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-176=
-gae714154c122/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-176=
-gae714154c122/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f611a3521e953ff=
bcbed945
      new failure (last pass: v5.8.9-151-g179511bc2622)
      1 lines

    2020-09-15 19:45:00.287000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-15 19:45:00.287000  (user:khilman) is already connected
    2020-09-15 19:45:16.399000  =00
    2020-09-15 19:45:16.399000  =

    2020-09-15 19:45:16.420000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-15 19:45:16.421000  =

    2020-09-15 19:45:16.421000  DRAM:  948 MiB
    2020-09-15 19:45:16.432000  RPI 3 Model B (0xa02082)
    2020-09-15 19:45:16.524000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-15 19:45:16.556000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (381 line(s) more)
      =20
