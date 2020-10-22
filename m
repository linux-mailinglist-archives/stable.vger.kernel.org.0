Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C58329658A
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 21:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370441AbgJVTxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 15:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S370423AbgJVTxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 15:53:01 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD39DC0613CE
        for <stable@vger.kernel.org>; Thu, 22 Oct 2020 12:53:01 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id e10so1868383pfj.1
        for <stable@vger.kernel.org>; Thu, 22 Oct 2020 12:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tVrs05k99qObM+pRHeouhZwCLuO4VhsZWPskOfa8Img=;
        b=tQhAy90nZqWHbzKpXEPHPPyGD/fNzBZmt97Mlkoa7yVrqZJRFkf7atmag8gaSlwFRL
         WMDHKxnjU0oQ5keImO4EFUywqfguUXUw0dQwY7Sy118l5oziBgVbydqxTCe1AnMyBWD3
         xDkVthgEsqIRkirH+aBM8xJuY9ITYurKpiVZilkRgsdjr0hhBBRLfsuw8VcVYHCeek+J
         60d91KA7FpBH+4woCM73tscTeUI/pxih4Gj6UkoNZLS+VvNUL7h6T9ihRCn++VKgai+c
         mRYhoO42m2UI4rQLfj30dqGfSsXpe7BzRRIOptAcj67RjZg8yppV1eMbGj3nrtIbnht8
         4Txg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tVrs05k99qObM+pRHeouhZwCLuO4VhsZWPskOfa8Img=;
        b=Mcobjr7SYat93v7eVtlUZZHJs8hyzotecCvMyi8OI7z4w6pUhiUaFMu+3X7OAEPf/M
         Iix1dAaSRLwk9diQdViCxS87LCgnh0JrMaFjCOpePDZP3pnaRhZioJBBRC5rwuvBBLWQ
         C/ddlMp/GI8pMUNQT9vFYzJyz4Y8XdkBzHSFUPZ7HUNmv/1NTCO4C8/V7sCgCK2szGCW
         fB/GERbpeEke482RcaAyp7H/YRIe94VSyrJUw6dfZP6tckBHxkdn7/KY2WkU2j97raS7
         0ajLpAOUh1oZOivqk2ispPT2zxC7k33nu3wFVEvIhXYqmJIY1UxnANkKLpiSLgtF7DIP
         NTWQ==
X-Gm-Message-State: AOAM530XhEQC/t/MJHt0ZVbIF8xFWhQhlwmNBpCm+UkqlhHbeqJVx5LZ
        FvP+xfwe6oU73PL6Ti0JcMN9n5ql1DgoPg==
X-Google-Smtp-Source: ABdhPJzgyPfhx5j64lEO8xPvw5PobeB6rBNLtn17x6piB6GF6A/GO2sawHGT8gLQWQcfHKJw7d+maQ==
X-Received: by 2002:a17:90b:2301:: with SMTP id mt1mr3542888pjb.80.1603396380961;
        Thu, 22 Oct 2020 12:53:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y10sm3156286pff.119.2020.10.22.12.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 12:53:00 -0700 (PDT)
Message-ID: <5f91e31c.1c69fb81.7f9d9.5f96@mx.google.com>
Date:   Thu, 22 Oct 2020 12:53:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.16-29-g7f7c35e6fb34
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 177 runs,
 1 regressions (v5.8.16-29-g7f7c35e6fb34)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 177 runs, 1 regressions (v5.8.16-29-g7f7c35e6=
fb34)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-29-g7f7c35e6fb34/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-29-g7f7c35e6fb34
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f7c35e6fb344bb03b90db9a4ad6346b8fe7c87e =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f91a9e7d03ca1e60311095c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-29=
-g7f7c35e6fb34/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-29=
-g7f7c35e6fb34/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f91a9e7d03ca1e6=
03110961
        failing since 1 day (last pass: v5.8.16-29-g970dd0292df8, first fai=
l: v5.8.16-29-g94b8033e99d8)
        3 lines

    2020-10-22 15:46:12.965000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-22 15:46:12.966000+00:00  (user:khilman) is already connected
    2020-10-22 15:46:28.136000+00:00  =00
    2020-10-22 15:46:28.137000+00:00  =

    2020-10-22 15:46:28.137000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-22 15:46:28.137000+00:00  =

    2020-10-22 15:46:28.137000+00:00  DRAM:  948 MiB
    2020-10-22 15:46:28.152000+00:00  RPI 3 Model B (0xa02082)
    2020-10-22 15:46:28.240000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-22 15:46:28.273000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (392 line(s) more)  =

 =20
