Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C13429981C
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 21:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388625AbgJZUlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 16:41:23 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33978 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728553AbgJZUlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 16:41:22 -0400
Received: by mail-pf1-f169.google.com with SMTP id o129so1294204pfb.1
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 13:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DRN/17D2sKue0jrsUrvdmhA/5Qrz0LTAG6sYYmqnpsU=;
        b=b8s9kdRw0OqXQFVC6OnyY3aRP26lOjyiMMdmn0y1pl3JxlwSu56a9umLLDC6euZ9lH
         D5B1oAVC+UksaUYfssPimw+JN+3EgTXdXoPSiYWOcS6VYgCaiCEhP45oeHYvUQhNc3wt
         IzUKuIK17//wxoRczr4KvZdo+qkaoZh9AJPf6JMf09I/jfgNlIojjRJQRiXyqIpGvyZ/
         1247AAiH562dber7E3rvvMZaczj1cvFIL9/uc8UC13/5YXO56i6fZ0ngPqaGn+WviahC
         llxTjQgZaa+XwUjdve/YdbnGcHGNxtt1T6bEsJNAd2kI17dUuzbMR4AYNAGkVsmEG/te
         ubUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DRN/17D2sKue0jrsUrvdmhA/5Qrz0LTAG6sYYmqnpsU=;
        b=mrm42mdiZ4htQdoRWnUSPF2THkqM5JavFiHtJz+c6d1vBDFj8rb8b14ryKODrfhwy1
         onFoBF6naHMg60vBqeS0+3CdIKt8RkRQzgitGwGHdakNNgmcMS7wiMNiI5MF6onmHfyi
         o6BG2gJUWi5qk/WSI7HlHtBeeewydqq3xBnNRQxLF9Pu8pegLvtyYrdTjK9vitl4wouA
         BP9x/99HdcBpOrxna6ilT4GWHN4ITpFrjTdrQSjvjeOrEsF9sphKbEZlADebiHh16iLO
         8778FaQdSs+l7GV/8ABpVwy4i/KYXHevfyGr1x/XlB+0XL8u7a5RDhfd2QUCO66iqiRv
         A9Yg==
X-Gm-Message-State: AOAM533lcsUQKTChYf6MA+XStSLw3MkLXJ84Yi8Ny38yLpJlT2Qf3s0h
        uwA/tl4pMBwFGproMleU3aCqRAToyrFknQ==
X-Google-Smtp-Source: ABdhPJzqKfonITl8p+3WPlZwV//oVK0OZqUZ669y8G23pqw1zQgrsRJIupt6ZZV7H212NJLhgY3d6Q==
X-Received: by 2002:a62:1755:0:b029:163:d3e0:ca57 with SMTP id 82-20020a6217550000b0290163d3e0ca57mr6458847pfx.36.1603744880361;
        Mon, 26 Oct 2020 13:41:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t19sm13130721pji.18.2020.10.26.13.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 13:41:19 -0700 (PDT)
Message-ID: <5f97346f.1c69fb81.27ab1.afc6@mx.google.com>
Date:   Mon, 26 Oct 2020 13:41:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-626-gbc7f19da4ffe
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 187 runs,
 2 regressions (v5.8.16-626-gbc7f19da4ffe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 187 runs, 2 regressions (v5.8.16-626-gbc7f19d=
a4ffe)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig          | 1 =
         =

stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-626-gbc7f19da4ffe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-626-gbc7f19da4ffe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc7f19da4ffecb6cd763046c820c7b890dd86770 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f96fc40f2e5bb6f27381040

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
6-gbc7f19da4ffe/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
6-gbc7f19da4ffe/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f96fc40f2e5bb6f=
27381045
        new failure (last pass: v5.8.16-626-g572a2b0651dc)
        2 lines

    2020-10-26 16:39:24.007000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-26 16:39:24.007000+00:00  (user:khilman) is already connected
    2020-10-26 16:39:38.781000+00:00  =00
    2020-10-26 16:39:38.781000+00:00  =

    2020-10-26 16:39:38.796000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-26 16:39:38.797000+00:00  =

    2020-10-26 16:39:38.797000+00:00  DRAM:  948 MiB
    2020-10-26 16:39:38.812000+00:00  RPI 3 Model B (0xa02082)
    2020-10-26 16:39:38.903000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-26 16:39:38.935000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (385 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9703a4c1f0f35f3a381032

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
6-gbc7f19da4ffe/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
6-gbc7f19da4ffe/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9703a4c1f0f35f3a381=
033
        failing since 0 day (last pass: v5.8.16-78-g480e444094c4, first fai=
l: v5.8.16-626-g41d0d5713799) =

 =20
