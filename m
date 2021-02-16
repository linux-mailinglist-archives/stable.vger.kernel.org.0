Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076D631D281
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 23:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhBPWNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 17:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhBPWNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 17:13:13 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051E2C061574
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 14:12:33 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id t11so7157188pgu.8
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 14:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FkO0ys+d9a22g6pCU59NBDTijDG0oErQ3vQvKy2kLzI=;
        b=bgcdvn2vdZpRFhWyaJmeDEStpraVj5H0gNt7nHsvQFUv9xPZzyj7u3XlluFlsJ9tUQ
         4KLVE8CV/BDEvmn9nDcxMNzmXQAkhM1817rjRwwOzKPEHnsQQyZdlDGrwYjrTr2nxd2w
         gE5Ux8pXO5zDz2pYBelRDBuAjDDoC4M7TsuNNxo9Y2VNKUaHC9tdjDhhSgMYKRHeXn1b
         7vsza5zZiC8lOEaG6n6+9ikaFSRrea1MB3rlfjd9GbA09ForrtfLsp0EezRvZ2WxU9oQ
         GmDaqllstLBofjOocGT5JKVRVyMgvDHnV04IeSoY1YpLfdik9qK/KHymE45xrK5iUttx
         k5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FkO0ys+d9a22g6pCU59NBDTijDG0oErQ3vQvKy2kLzI=;
        b=k6/CZlF2zqk/fm9fUaSZpwbZDRgYWFV0rPi7dk2XvMHBcWxP4vO3Qd9NiRPBYRqhwk
         i1C1yZ/f/9WEgg8U4EL5Ghil2N8kxmzmWtXAVcb8Fwr6PNjXJPzVOhBeeSuAvVWwoq0x
         zO3lD6keoWw2ysYL8jsfOF28H1o8OZhStE5Quy2ZP5Edd+5eQiPv3WZ+HYWOAKOdtdzl
         xTUeqMTDVGy8TO3qOlrgQWD6nFxlMUMdHu3yGyiy2EFt+5DyEIIwLP2DNKy5IdbVYu/s
         r65cM8lxKqZZ66PNx5BmyTEJ8QAXoFZuwvZVKLs+/1wtdZQlMWUoTt0Exn82mMdZAngW
         da2g==
X-Gm-Message-State: AOAM532cMqMiaudvLFDMpSkoIo/wk5anIEP/uu0sEUKZ/5gtAeFTiQFn
        dlcjrvnBdQg3iFibhq1gwYaUSWYmaXAiZw==
X-Google-Smtp-Source: ABdhPJwBUArBq+Fkdh9J+f28hl9VmLN4l+SJ+mUF9NVJVEX9Ln98WmCFpa+77VkgdI4kTv2N2Wrx1g==
X-Received: by 2002:a63:9811:: with SMTP id q17mr21300633pgd.238.1613513552096;
        Tue, 16 Feb 2021 14:12:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16sm89637pge.17.2021.02.16.14.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 14:12:31 -0800 (PST)
Message-ID: <602c434f.1c69fb81.1f394.06f2@mx.google.com>
Date:   Tue, 16 Feb 2021 14:12:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-37-ga630db879c87e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 85 runs,
 1 regressions (v4.19.176-37-ga630db879c87e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 85 runs, 1 regressions (v4.19.176-37-ga630db=
879c87e)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-37-ga630db879c87e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-37-ga630db879c87e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a630db879c87e20b8df818e8a4f11c8dd4d177d6 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602c103102e6a0ad52addcb7

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-ga630db879c87e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-ga630db879c87e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/602c103102e6a0ad=
52addcba
        new failure (last pass: v4.19.176-36-gb2b94a71682a)
        2 lines

    2021-02-16 18:31:53.590000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-16 18:31:53.590000+00:00  (user:khilman) is already connected
    2021-02-16 18:32:09.467000+00:00  =00
    2021-02-16 18:32:09.468000+00:00  =

    2021-02-16 18:32:09.468000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-16 18:32:09.468000+00:00  =

    2021-02-16 18:32:09.468000+00:00  DRAM:  948 MiB
    2021-02-16 18:32:09.487000+00:00  RPI 3 Model B (0xa02082)
    2021-02-16 18:32:09.571000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-16 18:32:09.595000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (383 line(s) more)  =

 =20
