Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F84028CB3B
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 11:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgJMJyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 05:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgJMJyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 05:54:45 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDD9C0613D0
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 02:54:45 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id n14so16390147pff.6
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 02:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KbMbGQh0t7XRGdNeWWCpuKFqIPU4mZLzhoLtumVbf98=;
        b=QGwMXtrTmcBQkKG5ul9/jzHwePfvteYeRRfzu7t4ZwM14yTCRZrpWy9y+1dqMZWjyB
         vn6XiGtfYWq1ePpGwc3syCogW2DcgMP3fwj7T0gfvOJC2/G0XTOOh1XNbJcj6w6VNZEb
         01Y1pyqKYiW3v34UTRkWHiOeJIRCrsjqpnZtDHqz0VUqRMimUQtEOVyDL9sFGYnL5O6X
         Ta4iq7wJ2e3DE8sPchh4WbSQPhUUJ358UqOQFLXT5THKuU03icD8Rc2GCgHJmX1F4sUX
         a380UYEFdHT6jyJDo3ZAsqIaEm+dtHawjGQyqrjqM0L7qagr0wpg7P4RIv+5epQGprAw
         cPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KbMbGQh0t7XRGdNeWWCpuKFqIPU4mZLzhoLtumVbf98=;
        b=RrG/GTqzllFWJx4LPas5gPd+jToQkvHcYcx3qfY016sXl+qqxhh8HL3lJzQ6didZSv
         +AJMV0qv+5CPvfBwKM53CKXSrWmYYnYFq9lxuHPV7s0tyMIotMSXHb5phHUZbbreS3gk
         qhHu1EB4ayHdOR2g1G+E5M9xXNasrU7h9EOGSGZ2Rz07U6lnqAB/ely4lMm6b++yi8IP
         BTuZSaaua0lqmO4xnl7jvCXWMoaITUifuF5ZRxLmI1ZCT4jooWotouvgQG1SSmIz1rrS
         4eIVM8q6y2EdAYDNOIqk+vOLmzYfpq8bdOT5BWVv/5PWOIlXg2EKoMKb/739UPhUUQbW
         u9aA==
X-Gm-Message-State: AOAM532R96S7xSDT6nkUfKhPXAs7SmgorBAEIrJ04/5mzxJ0LgqWCb7e
        TT6KhCu1SC0+zzNRuOCSwaFRMRvGheCyFQ==
X-Google-Smtp-Source: ABdhPJwmXMhB4uT0KtcGQxXLmQ5XqsFep+3EwFrFqWveTlWjjW3DLtwjgYPWf+sESTKumQ3aTsz7lw==
X-Received: by 2002:a63:ce17:: with SMTP id y23mr17210777pgf.447.1602582884762;
        Tue, 13 Oct 2020 02:54:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9sm22250403pgp.90.2020.10.13.02.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 02:54:43 -0700 (PDT)
Message-ID: <5f857963.1c69fb81.a6a9a.b07f@mx.google.com>
Date:   Tue, 13 Oct 2020 02:54:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.14-125-ge6c999327e0b
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 135 runs,
 1 regressions (v5.8.14-125-ge6c999327e0b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 135 runs, 1 regressions (v5.8.14-125-ge6c9993=
27e0b)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.14-125-ge6c999327e0b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.14-125-ge6c999327e0b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6c999327e0b2cafa09454d792c63128dbe65d40 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f851d95f20e1085dd4ff3ee

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.14-12=
5-ge6c999327e0b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.14-12=
5-ge6c999327e0b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f851d95f20e1085=
dd4ff3f2
      new failure (last pass: v5.8.14-112-g39817a9e3cbf)
      2 lines

    2020-10-13 03:20:48.367000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-13 03:20:48.367000  (user:khilman) is already connected
    2020-10-13 03:21:04.284000  =00
    2020-10-13 03:21:04.284000  =

    2020-10-13 03:21:04.284000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-13 03:21:04.284000  =

    2020-10-13 03:21:04.284000  DRAM:  948 MiB
    2020-10-13 03:21:04.300000  RPI 3 Model B (0xa02082)
    2020-10-13 03:21:04.387000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-13 03:21:04.419000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (385 line(s) more)
      =20
