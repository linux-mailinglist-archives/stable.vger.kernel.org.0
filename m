Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F3828FBB5
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 01:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389122AbgJOXVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 19:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389655AbgJOXU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 19:20:57 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5103C0613D3
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 16:20:57 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u3so343326pjr.3
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 16:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qAbs3pEHPIu1VPOMoNFRCuhVhQ8ceQr0VW5VjaOlEAI=;
        b=dXbaiWYb7AVDGrsr8MnCZRmujyJzi9DD0ZZNLT2+1jVLmV5h4OICoZhh7dRz1GPPfA
         o4IlVJDhjfwDZSqPonAoyFxTYPOd+NJRgCqCef4voy/cxW7TxuL/FoNs6daKn6oP9fne
         Z+5rGcPXAvaR2wpCymCvX0fn4PWOs9l7EsWHawZZ0uo7keA2op2CQMv0d9Lvt5Y7onv7
         rx84BFGuyThUa+PMBvICNvCKzIF7k/Vp6MeBUMxG6Y32fv6OltRQkc00Sa+SFP/+1D1c
         EB6uFM9xjoZPshrLIQFrXmnqF4xM+M/PckkL1tE1c4tYjLK+Vk+BkS58WeAPLc0t3n/s
         tcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qAbs3pEHPIu1VPOMoNFRCuhVhQ8ceQr0VW5VjaOlEAI=;
        b=XJ5eAS8gZ+ubdm82ZthpbDR8vpdwttN/ayW4cjtKlnEOhrKaD3eS0RLYvNxyn3Hr/6
         K54CiF/VGqDBq0VkBRv/KxxAO9TTJZgYgwWOfZHx1S0zuyitlFGir6TSNSEc2G8uD2g5
         2dp2gUIF2er08D78S3mne4rbpyCEEDtBUaVoYYBe8ymLX3KvjyjlR3+hb56YO9Rm2Sfo
         rzBFJcMcU2/V07S1zNekuk6X9fMIRAXhyO/cSGUEgupvmOtS1xpQUSm2+Of4ymrNz27M
         Q9BTtnsqmGUfUv5QvErYQFkOh64xaV0aYe6hxujTfzvOMOP+C4wDjGEnwJI9zXwtf3/h
         Qqhw==
X-Gm-Message-State: AOAM5323VJn5V7U2nLGEmmy+X0Ai6Wa7P37XwVtor0aXTj8ywGZBkydz
        czeTBqJrwKGDqQav97tsViktCKFDjKHr7Q==
X-Google-Smtp-Source: ABdhPJw/J/AdA9GolPTaXabpyPZKZWTKhjBEi6rhQLMHxZgDZwFjhEPrcUP76mgTSjKxJds4dgIx2A==
X-Received: by 2002:a17:90a:e00c:: with SMTP id u12mr1047440pjy.185.1602804056350;
        Thu, 15 Oct 2020 16:20:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 9sm360648pfx.138.2020.10.15.16.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 16:20:55 -0700 (PDT)
Message-ID: <5f88d957.1c69fb81.42612.11bd@mx.google.com>
Date:   Thu, 15 Oct 2020 16:20:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.151
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 187 runs, 3 regressions (v4.19.151)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 187 runs, 3 regressions (v4.19.151)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =

hsdk                  | arc   | lab-baylibre | gcc-8    | hsdk_defconfig  |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.151/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.151
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47f6500403ea31aa0c8e329aeee607671d0f9086 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f88a0fe0fad2a3f544ff3eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
51/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
51/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f88a0fe0fad2a3f544ff=
3ec
      failing since 121 days (last pass: v4.19.126-55-gf6c346f2d42d, first =
fail: v4.19.126-113-gd694d4388e88)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f889e91d648b60b054ff401

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
51/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
51/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f889e91d648b60b=
054ff405
      new failure (last pass: v4.19.150-50-g7457eed4b647)
      1 lines

    2020-10-15 19:08:20.241000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-15 19:08:20.242000  (user:khilman) is already connected
    2020-10-15 19:08:36.614000  =00
    2020-10-15 19:08:36.615000  =

    2020-10-15 19:08:36.615000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-15 19:08:36.615000  =

    2020-10-15 19:08:36.615000  DRAM:  948 MiB
    2020-10-15 19:08:36.631000  RPI 3 Model B (0xa02082)
    2020-10-15 19:08:36.717000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-15 19:08:36.750000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (361 line(s) more)
      =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
hsdk                  | arc   | lab-baylibre | gcc-8    | hsdk_defconfig  |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f889f4ad3a0a586d24ff41a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
51/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
51/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f889f4ad3a0a586d24ff=
41b
      failing since 87 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
