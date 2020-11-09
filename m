Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A78B2ABF50
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 16:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgKIPA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 10:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730125AbgKIPA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 10:00:57 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3470C0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 07:00:57 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id c20so8402345pfr.8
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 07:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jhFW12UJiu26LmpRdyVgJhefCn8rS6nzfRuYc+Pe91c=;
        b=ke7CU92RST6v5Be0Z0rXuXosmuRzh3bGYF5qp2BB+hC1PFwasE2pcEB4tktsjLusi4
         6joO9x9xX6GENW2WLeoJZOaVFxtLfaj9IdagVZh4xVqhqZtZp1EGVZLuu8Iwt9N50wVt
         UBtsOQg+pX5FhwJwE5uTdbjvTtGczXSNGezxo4iOpthdQWAdRWmG6YiqKKNCbI/6KLFh
         98WgNcWEZIShxqZCJpzatDHeU6hMRxdjISh9/Nu194YkkIH581iZ07uRDcSMy/RHQh0L
         dhNEmY3h5BJf6zz0CIrIxETshHQvNr4bWrlLfGM6wZbeJiw/IerBAeBJF0/rUB/CsLaO
         wc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jhFW12UJiu26LmpRdyVgJhefCn8rS6nzfRuYc+Pe91c=;
        b=kdGxDOy+Lu0nSHHLJNjVC9x4cOsJ0WvRwuaKUllW1xpu1z6V5t6862Ty4eKgP9zgcx
         Avs/NLffCqY7LS+ExjIiOyMXtARTu6DY3Po/q0IOq7FbnZHWkFqdgNQLFwpk3PCLSnBi
         n2KMvJJJPZNkpiZ4al/4b4smyuPVHQ/HehGrabph3g5XLgEafIumU/YDP7eISqLSpGkO
         JqkKNi/Ti+YuNK94cbqpaPYLwIa7AQG5psseBE2Eq6B0aBcbGxMdLPxvVg2OF8+lGNA2
         48QOIWYIvnTOnzxQOfvlkcyJwuDL3uSKuv6IKWUvP4Sk2VhMOs3XXU/CXxlJiDiuhGCq
         L54g==
X-Gm-Message-State: AOAM531dWax4FNFUGYTKb1nfAqpl3DMsUhV/jSJEyMD8OyjUtV/xz/az
        We5/4LYnj1ebAYX5n01TL6lngA8MxK0CPg==
X-Google-Smtp-Source: ABdhPJwhnkKccfIxvcWnA1TUaFgXkF4bewbWF3235+Ot5alhHyXlc/Na18SYi40ffGwalGt4z5b0/w==
X-Received: by 2002:aa7:982e:0:b029:18b:6372:d445 with SMTP id q14-20020aa7982e0000b029018b6372d445mr10921308pfl.31.1604934056923;
        Mon, 09 Nov 2020 07:00:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w131sm11390536pfd.14.2020.11.09.07.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 07:00:56 -0800 (PST)
Message-ID: <5fa959a8.1c69fb81.d5a6a.8729@mx.google.com>
Date:   Mon, 09 Nov 2020 07:00:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.75-83-g25ef9a88d0ad
Subject: stable-rc/queue/5.4 baseline: 207 runs,
 1 regressions (v5.4.75-83-g25ef9a88d0ad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 207 runs, 1 regressions (v5.4.75-83-g25ef9a88=
d0ad)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.75-83-g25ef9a88d0ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.75-83-g25ef9a88d0ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25ef9a88d0adfb8757ef5f6b55c2d681e2fffead =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa927e2f627831898db8870

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-83=
-g25ef9a88d0ad/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-83=
-g25ef9a88d0ad/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa927e2f6278318=
98db8873
        new failure (last pass: v5.4.75-63-g46f91663a79d)
        1 lines

    2020-11-09 11:26:33.337000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-09 11:26:33.337000+00:00  (user:khilman) is already connected
    2020-11-09 11:26:49.290000+00:00  =00
    2020-11-09 11:26:49.290000+00:00  =

    2020-11-09 11:26:49.290000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-09 11:26:49.290000+00:00  =

    2020-11-09 11:26:49.290000+00:00  DRAM:  948 MiB
    2020-11-09 11:26:49.306000+00:00  RPI 3 Model B (0xa02082)
    2020-11-09 11:26:49.393000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-09 11:26:49.425000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (376 line(s) more)  =

 =20
