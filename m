Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF98E267B29
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 17:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgILPCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 11:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgILPB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 11:01:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA8EC061573
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 08:01:57 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b17so3108263pji.1
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 08:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3L8yGJppvZxLj3tgNtU2sAVws+CjDXcrLUYHKMkpwG0=;
        b=0kPtlc8i2h8U+Z6yaPYgzvpDIAO5FtOCHhzyAdXcS3fkIReanLMgYm9dSqCbvkhMlo
         mFBFu5RO+9elOvt4j7PMu89qJ2cYPvcQfmoJCVE0uxhtBYozt8yoErzzpqufj6HhElr/
         JvBVmuuKeTxGbmaULCKhrE/VuKtE5G3IIa3cN67ssm3X1vJsBGb6V2F95goRtI0pqqFf
         1ETZgimF2eZp1AqPjj8SZovCKQdW3EQdyEQ91+QHAB6f/w5hWCNhb+fjA46HhAa4M68h
         VGN8nMZSji7wlyJ7oD5tXKss+oF7LOPO+KdzzWnoHjX10LrCKdn6dYfCPF4EeSLbXNPb
         +HVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3L8yGJppvZxLj3tgNtU2sAVws+CjDXcrLUYHKMkpwG0=;
        b=eCLtXQu/SrNRkaDB2+oiscoNXTemQSv1+qT2hPGX1q9M8u8jhiIvVAIOCJbcCSUKc2
         RWrsdZ3TShItR+RoWg3sP23913ArNHt0TclajdPdY+IQciaM+7OJfaaJxVkc8oS1ijcN
         /5OG5KwLKu/D7oVD1d1grsAR6wWarCj/L8IA2R/UTlVgCl1BfE6miPYJ+UlZ3GbRnN3w
         CMvO1jcbAMjUR4gmQ3XUVwO4C6WtsOVilMLCcgXuYZp/xrh9Qp5kQ2RWRuQEZrEYuKpW
         Ym5UWalTfuh3+NMw90MF5s5J8jhu3eF5Y82jjsgfJ1ZdVU+B6I82HEBBOEbiAkRJYiwk
         U6hQ==
X-Gm-Message-State: AOAM531P+6jv5OI21E5loktH5hda+eSXB91pvK+dYIsMkT7rdXdS7jPW
        pvFi5ZhrzhfO827L5cgz5HueDcla1rapJg==
X-Google-Smtp-Source: ABdhPJzTDzueP9l/kNyLJZDVYAk5WEWHyHK9AyLBtapOKxN5gEXtzg3KVHvdcFiGUkqpsq/eMmKw/g==
X-Received: by 2002:a17:902:9341:: with SMTP id g1mr6553889plp.94.1599922914574;
        Sat, 12 Sep 2020 08:01:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bx18sm4582734pjb.6.2020.09.12.08.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 08:01:53 -0700 (PDT)
Message-ID: <5f5ce2e1.1c69fb81.aef08.b5dc@mx.google.com>
Date:   Sat, 12 Sep 2020 08:01:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.64-8-g94236713d3ff
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 183 runs,
 1 regressions (v5.4.64-8-g94236713d3ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 183 runs, 1 regressions (v5.4.64-8-g94236713d=
3ff)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.64-8-g94236713d3ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.64-8-g94236713d3ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      94236713d3ffccdd8562e43952fa6234fc5b531c =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f5ca8e81f7a8d8a53a60917

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.64-8-=
g94236713d3ff/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.64-8-=
g94236713d3ff/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f5ca8e81f7a8d8a=
53a60919
      new failure (last pass: v5.4.64-8-gdca50a33fc3d)
      2 lines

    2020-09-12 10:52:21.970000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-12 10:52:21.970000  (user:khilman) is already connected
    2020-09-12 10:52:36.909000  =00
    2020-09-12 10:52:36.909000  =

    2020-09-12 10:52:36.909000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-12 10:52:36.909000  =

    2020-09-12 10:52:36.910000  DRAM:  948 MiB
    2020-09-12 10:52:36.925000  RPI 3 Model B (0xa02082)
    2020-09-12 10:52:37.013000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-12 10:52:37.045000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (385 line(s) more)
      =20
