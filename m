Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA4E2A6DBA
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 20:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgKDTUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 14:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgKDTUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 14:20:04 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD3EC0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 11:20:04 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id w4so7175149pgg.13
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 11:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qxL1GGCChQ1NUUugEXz+Um6pQqah/tym3zHbb7ZARrc=;
        b=kAAwECzhBZ0TUj137h2wFzQbl7jzphRdqSM7wlCSBxaLAeyB8CQr/oPpkVYyPfwgRd
         sGe4PDC6rCHqw30VLFLybFzAu5IOdr5CbhYAxnUQv2QwGWYi34HO8osR08V4ym6RP8Vz
         84pK542UisfOIH952qjs7vXeqHrrx5n0npUIHYGRqr36evosOHTqC7sGTD/dNjYcHYc/
         dQ3TAbWP1JeVAwc3ZKK2io3BC4xmD89GIItBIbtmcjOuzPaOjEoASoUHzThDTTbB/tUk
         K7QxM/XXTRsafl1CoasqD+/WRuYC6BY1y/CvkOGnJYncwHJYQShjWPjM7nibUzHU06ZV
         HiZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qxL1GGCChQ1NUUugEXz+Um6pQqah/tym3zHbb7ZARrc=;
        b=Z/Vfaw1xeeCJqimuiNaI1VTd5E6nt+txPswQx/p15JYD9mvVvCg6ehPDE28nwTVnsk
         HjvqCf32WFP9sAipZVxPBBJdx8ujURnIo36i/hdd+FprJDy8qzBah2w3QUR4RtPKpdJe
         aFl462RO/5x56MR0e/XenbcdDQk7Ey5W66IC2fsMLKESsDzI9ow7HvpiXFi/mbrRtr1J
         OIEx0J+NXS+x2UkmgaSOjre6lqhN7tKwTFvLp1o18sIty+w+XmlnrZiJrDQdGOYQ59j8
         KxGD4YTrekphhFXxlCZsoAsNcDQBneud21Cm5jMUvxuLR1YT1rtv92OW4Ga+D9s8zwoq
         7yKQ==
X-Gm-Message-State: AOAM531/YuiRQ0Tm38kc+RCeTbGH/Rukg+KaRqt1HfKS6aBOy5ZFU9qy
        vcngNaU7BAeNDZtHeoXbD3I9t7QOA5VXjg==
X-Google-Smtp-Source: ABdhPJzGkEyPtoX/6mGzcZbVfM+WeGrJ8YipMMrERXQ824dvj/cd5chVtq+UZRiTcJAxzcJJVpqKXg==
X-Received: by 2002:a63:1f11:: with SMTP id f17mr3456447pgf.282.1604517603093;
        Wed, 04 Nov 2020 11:20:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s17sm196743pjr.56.2020.11.04.11.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 11:20:02 -0800 (PST)
Message-ID: <5fa2fee2.1c69fb81.6371.0972@mx.google.com>
Date:   Wed, 04 Nov 2020 11:20:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154-191-g7aad7f07408a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 193 runs,
 1 regressions (v4.19.154-191-g7aad7f07408a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 193 runs, 1 regressions (v4.19.154-191-g7aad=
7f07408a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.154-191-g7aad7f07408a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.154-191-g7aad7f07408a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7aad7f07408aebaf219e29e8955150064a7ad6b2 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa2c3762529133136fb532b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-191-g7aad7f07408a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-191-g7aad7f07408a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa2c37625291331=
36fb5330
        new failure (last pass: v4.19.154-191-g43abc622c570)
        1 lines

    2020-11-04 15:04:38.897000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-04 15:04:38.897000+00:00  (user:khilman) is already connected
    2020-11-04 15:04:54.463000+00:00  =00
    2020-11-04 15:04:54.464000+00:00  =

    2020-11-04 15:04:54.464000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-04 15:04:54.464000+00:00  =

    2020-11-04 15:04:54.464000+00:00  DRAM:  948 MiB
    2020-11-04 15:04:54.479000+00:00  RPI 3 Model B (0xa02082)
    2020-11-04 15:04:54.567000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-04 15:04:54.599000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =20
