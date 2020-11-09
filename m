Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D702AC034
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 16:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgKIPrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 10:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIPrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 10:47:00 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F75C0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 07:47:00 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y7so8514014pfq.11
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 07:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y7d9idYc7KAC0+Iclb//4adMoFD+8I9qsyQPAfEV2s4=;
        b=CgyzOtsvLIdaxFMFKiWt09hB9vQyClogamPAjd4No1Jng2Pjufh38pQmQFZhmXXI8Y
         1gySRDSZhygijFDdAuhrKOGUWQdUpZsYXZ6a8gdzBrF1JvFR8plgZql0n3t16E0rJnac
         FCauhDvW/yj7jNevxAvLSVC7eLHHO6O9sOQmkf9UB0CKa2TN8dNp+yqyKPz6togLKNpc
         3WAKK+97LDSF0zd2P4sx6CEGOLn6r0EUJj9x65m2PmzXfmvO2EyDDVbCmKwS8k0vuIUs
         2fCKdTApH76nioKE3MzeJG25Mx8VV1hEhSo+pkBWDA6l0Ms3/7DnqvHl9V8IiSy1w5xZ
         cO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y7d9idYc7KAC0+Iclb//4adMoFD+8I9qsyQPAfEV2s4=;
        b=cCVIElfHw9OJdczckzCCdJx6RcgM331RYdoeaK+ZGpVJeLlMXbh9PTi+/RM1/J4E5k
         FKV9LzydOqv65Egt/gqtAzRRZwymDHFg5mKgvjU33a1VrH9myzitapfK+BfCgRLCW5v6
         Wq3wyWtT/XtImVg4qx4kbpOT3VR4UjtGZ5IZ5gxzINDFci8cAgyG1m4A1ptMkCXcxwyx
         qCpYE5smhrj9lTbk6dT3R07A7Fqwwv8kxea/4MJSvzviqAeKe7N/rcyXE3+uzUqjy7jn
         wnuDVe+Sv/ZO3H8q3hSqU3L/rn5bvXrhiepiBnDsCNXutAvxoTD9ZUr98bglNgMJqjvD
         c4zw==
X-Gm-Message-State: AOAM531VhEykrq1JbxwqpSnfoMcVGbWVYntIirU4C4TKmndjCSN+gv/Q
        tBfh+z1lKpiLn2m542pdJfTfeDD9sRt7DA==
X-Google-Smtp-Source: ABdhPJwEs8vdBebM614rLChW9e66FXrXk63D1WFAJp6LliILeX1+WQVnZTkpyZmV8OHbxKAOPNhEbQ==
X-Received: by 2002:aa7:9f8b:0:b029:18b:9c0e:a617 with SMTP id z11-20020aa79f8b0000b029018b9c0ea617mr13975340pfr.16.1604936819688;
        Mon, 09 Nov 2020 07:46:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t36sm8087450pfg.55.2020.11.09.07.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 07:46:59 -0800 (PST)
Message-ID: <5fa96473.1c69fb81.50e43.1f73@mx.google.com>
Date:   Mon, 09 Nov 2020 07:46:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.155-67-g568604746268d
Subject: stable-rc/queue/4.19 baseline: 169 runs,
 1 regressions (v4.19.155-67-g568604746268d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 169 runs, 1 regressions (v4.19.155-67-g56860=
4746268d)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.155-67-g568604746268d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.155-67-g568604746268d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      568604746268d5268468b014b0b6fc1b5fa9d6d8 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa9326ce8a4b2db07db886f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-67-g568604746268d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-67-g568604746268d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa9326ce8a4b2db=
07db8872
        failing since 0 day (last pass: v4.19.155-45-g6679aabaf3341, first =
fail: v4.19.155-55-g37e579005ca6)
        1 lines

    2020-11-09 12:11:31.782000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-09 12:11:31.782000+00:00  (user:khilman) is already connected
    2020-11-09 12:11:47.501000+00:00  =00
    2020-11-09 12:11:47.502000+00:00  =

    2020-11-09 12:11:47.502000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-09 12:11:47.502000+00:00  =

    2020-11-09 12:11:47.502000+00:00  DRAM:  948 MiB
    2020-11-09 12:11:47.517000+00:00  RPI 3 Model B (0xa02082)
    2020-11-09 12:11:47.606000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-09 12:11:47.637000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (371 line(s) more)  =

 =20
