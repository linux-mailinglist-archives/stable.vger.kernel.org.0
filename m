Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D28B2854A4
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 00:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgJFWdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 18:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbgJFWdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 18:33:04 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4341AC061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 15:33:04 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x22so161393pfo.12
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 15:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4S+mLmihPVmLU42iSdMySK+YevNk2nMQphErFsJsFas=;
        b=tYlHP3pwZLrUHCcB53MQ5bcWa+vZOhj00c3zqSa1uVjFbZpok3rxnakPROrURLmJuR
         hFx/okdWKrkYxHpd5UKAtsrmLblSqSz9306nw8lYVSVtbOa2ZrQTeb5Q6Qgm6/+zrWsG
         xNLvkm8+NPKfSzmiXtMnneqLBjp5ShnfEmx6azY7WUEne7tYtj2Bl/hQ+93KF9mow+EG
         NCd9okXdbPKDTHed7mNDfVj9LzSbxDrsUpkeBIASRXgOOh4hOEa/mkw5tdY3o6KgpWT7
         YkR7pWYm84ubpztH4njhBWEWljsaBEMyoDmFyyF6AR+UaujR0+JcAAPrjkai0Cnhi5v/
         2Pqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4S+mLmihPVmLU42iSdMySK+YevNk2nMQphErFsJsFas=;
        b=hpRsiRVopeISOIFO1xWbjv6K6ve7WRgl0CCqwjaEvmgRBaWYa8NxGBNwWl9teO5AGU
         TktMk4CYIWKeL6tUquXQzZU6UrZ6++71A1f8bgapH4YkNNFI9TvAEBBdrNoUKdu+jOWl
         47KseDwwzZEwc15ebL+qjvvcAt+bGltEKguyYyHXxW9ws/N4aD2wrIGEj6ptgl+URHDa
         cuWWxeYJd8n4xIvJDBcSGZECVnQ0WjEcMQHCFLXEVk/wg2ck0bfzMEBzeQsvL7iuQTem
         JiQw71XtLsrLEyaQIYHzJh9hUAtSXmjZIxhRLqq+GOoUET5dluSebcYr7CjOkxGkAHul
         1dng==
X-Gm-Message-State: AOAM531SWhIx8yrPijnnnIsFuQ+G7+v4hi1c0NnVjk2oFG19vVQIgVTb
        XL0wrQ93jsmPMwts2VvAvMQwjV1Og1qgLg==
X-Google-Smtp-Source: ABdhPJxINht1puMamegSXLH9ttIM5XF95kkqE5hW0U7GX0pYd/KvcclFSkNUh6A0pBhAuXF4VodB5w==
X-Received: by 2002:a63:591e:: with SMTP id n30mr354849pgb.340.1602023583020;
        Tue, 06 Oct 2020 15:33:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm211788pff.167.2020.10.06.15.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 15:33:01 -0700 (PDT)
Message-ID: <5f7cf09d.1c69fb81.cf3f1.0a92@mx.google.com>
Date:   Tue, 06 Oct 2020 15:33:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.13-85-g2e8af6025bec
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 99 runs,
 1 regressions (v5.8.13-85-g2e8af6025bec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 99 runs, 1 regressions (v5.8.13-85-g2e8af6025=
bec)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.13-85-g2e8af6025bec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.13-85-g2e8af6025bec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e8af6025bec9043306a39c50f77db1b2f1aae60 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7caf24de54d684db4ff3f5

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-85=
-g2e8af6025bec/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-85=
-g2e8af6025bec/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7caf24de54d684=
db4ff3f9
      failing since 2 days (last pass: v5.8.12-99-g7910fecf197e, first fail=
: v5.8.13-3-g58c57ca2b2dd)
      2 lines

    2020-10-06 17:51:28.267000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-06 17:51:28.267000  (user:khilman) is already connected
    2020-10-06 17:51:44.017000  =00
    2020-10-06 17:51:44.017000  =

    2020-10-06 17:51:44.018000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-06 17:51:44.018000  =

    2020-10-06 17:51:44.018000  DRAM:  948 MiB
    2020-10-06 17:51:44.033000  RPI 3 Model B (0xa02082)
    2020-10-06 17:51:44.121000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-06 17:51:44.154000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (385 line(s) more)
      =20
