Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E36E26882D
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 11:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgINJTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 05:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgINJTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 05:19:49 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DBCC06174A
        for <stable@vger.kernel.org>; Mon, 14 Sep 2020 02:19:48 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id l191so11043217pgd.5
        for <stable@vger.kernel.org>; Mon, 14 Sep 2020 02:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J7shcnfnGXwwSx9r1VOglUbpyte7UWr/gkNjDqBFVQI=;
        b=QAvkp4vEjB1Ki0bJofQgEVyOCbOlu8YXSFExs/tunuIN0zLoOYIY6niyul2kbcxjKw
         BFQmXDVzgeFzTyA1q3J8hmKS7jShUrANx9/iBgyC7LHEFmEREHpSGaSF+KrULGI2iCNS
         yfxg8br57q8kKsA2fFhwJgExPpN10M/mU0RWHio5VC0ltxZdbiLLl7y5SVWdUBEnp66G
         VKA4VlHStR8CZrf9FXG2tIoBPKFqdjmipMtFXFplSGLbIHeq9c/gS2SCDcv8uo/O1sk/
         zmR+LvD3p31X5DRI2RgCWFv9Dd5FwUy8YkOtwvjk8LPu0rNIfFgoub1D7oVfsgNtC/Hh
         mUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J7shcnfnGXwwSx9r1VOglUbpyte7UWr/gkNjDqBFVQI=;
        b=i2EaFeg+1vvXjTgr8ujjOIKnWsr32QiCQpvQV0p07S0YIA5NnnNqIK4/EP4bfZ4RL8
         esDHl3HuYLgYff/m1PYBttYcNCX4O1YEUyqNv6YZ+pA34AW7umj5SuaTpBjyyYZC9HAk
         mne5oN1msycBGu+ucm+b2GsvkxruC2zmzj294rE0QgZoOS2nY5xpZ3ZGAkxQPm+m9O6p
         NkQXKLuE8P0gZE/HfPAmvuAfY1VeHFs3Thzs3JY06UrQFZ0V5HqyOF8yUEqXbCg29SUx
         p5CbzO+r2syFxXzBqZlq3ZDoschmf8UzjTpvXPU3ypxnm//IPfcylzG45yQtpR49lWeQ
         ZBcQ==
X-Gm-Message-State: AOAM533Q/Lhl9WvPyfQhX8VWsP0PZ9Xi5eMiKn54FWofNa4Dj8LZUD+c
        65IwaHcHPVHwVziF5q+O6fgk5SaSqhWEiQ==
X-Google-Smtp-Source: ABdhPJwGc31UIVKMIy1NiIkr4cR9TSPTY8QxAuEkN2Z2AnqDcCzBgwDQeam98YpfCP1tKEIJ00HFJQ==
X-Received: by 2002:a17:902:8643:b029:d1:920c:c1db with SMTP id y3-20020a1709028643b02900d1920cc1dbmr14217740plt.42.1600075187706;
        Mon, 14 Sep 2020 02:19:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm8163725pji.19.2020.09.14.02.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 02:19:46 -0700 (PDT)
Message-ID: <5f5f35b2.1c69fb81.ec21b.50a3@mx.google.com>
Date:   Mon, 14 Sep 2020 02:19:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.9-108-g5b82fefdb13e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 164 runs,
 1 regressions (v5.8.9-108-g5b82fefdb13e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 164 runs, 1 regressions (v5.8.9-108-g5b82fefd=
b13e)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.9-108-g5b82fefdb13e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.9-108-g5b82fefdb13e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b82fefdb13e7638df31383c434411b43c1ad7fc =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f5ef74a6034b7db1ba60928

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-108=
-g5b82fefdb13e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-108=
-g5b82fefdb13e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f5ef74a6034b7db=
1ba6092a
      failing since 1 day (last pass: v5.8.8-16-gbd542de38b92, first fail: =
v5.8.8-16-ga447c0d84b6f)
      2 lines

    2020-09-14 04:51:15.503000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-14 04:51:15.503000  (user:khilman) is already connected
    2020-09-14 04:51:30.897000  =00
    2020-09-14 04:51:30.898000  =

    2020-09-14 04:51:30.912000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-14 04:51:30.913000  =

    2020-09-14 04:51:30.913000  DRAM:  948 MiB
    2020-09-14 04:51:30.928000  RPI 3 Model B (0xa02082)
    2020-09-14 04:51:31.019000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-14 04:51:31.051000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (386 line(s) more)
      =20
