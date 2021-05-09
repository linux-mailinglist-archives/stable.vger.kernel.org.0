Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6575337773D
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 17:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhEIPTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 11:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbhEIPTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 11:19:09 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31285C061760
        for <stable@vger.kernel.org>; Sun,  9 May 2021 08:18:06 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s22so11514057pgk.6
        for <stable@vger.kernel.org>; Sun, 09 May 2021 08:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x7X5XIl77aZaExLIe3HxMcm6f9c8JgEeAyfogU7rLtA=;
        b=1ePpH/Lk6hTWYSmeWPu7bH/6PeqDmUhKy35rUIzhGwrRQ9abcEgYmj5XeLtVTCbXXc
         096yuVnoJktG6fpvO3MYg+6+zMzmMyEyJYkMK8IRECp+jzZrD0QY7HVcCex4+U58LVe+
         7wXGShH04W4iWYJqBTsIMYKn+rD1rX9nxfSAAE00yapybFbn/NqCnCTdmZr1HwJvvSEy
         mkZs+u3UyThpjqIkZM+ZdCbLQIGC+OG9gCKtfrZLJCfG6P4tJ+Md9EPno7ZJv86/YAW4
         tZdt8sMJF9xSNmCG5CGSCiK4NMGIr/s1SxlvwiG5slk8P/43194+M8g6OqS3lTtlOXT3
         igzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x7X5XIl77aZaExLIe3HxMcm6f9c8JgEeAyfogU7rLtA=;
        b=hteVl7wJyG0+G5ValxrF9+XXlXAyLKVxSlSJCmL5ncfqPlbPqpIXX7AdtP0tIZBKiJ
         wv8wfqKf1D05Gtk0CFqQVPlSKW5G7KlyA+N1ka50Wxj0wFPuyv5YtRoyoc4zaEX9BysU
         dopnbSx56pJSnh7sROUbuBNrev4LVUYQ87C67R3ZFGDnhD2prbI4g4yjlYDuXcfyMvl0
         ae53OB1TBZbOv0NlKBNFh5nKHhva+4vslubssifKzjIGzow+ZnT4oFvr2z+WZMY8cjK4
         GSVdLRZ2yPlhjGH4BxIKPYjkYdderKX//b2hJkZ297G4V5sy/Qiezgfw80qbk7W4l49T
         32Vg==
X-Gm-Message-State: AOAM5309fIohJMP3mE3HvXg3lZKSdTn/6f18onp6KqsgZ4pacOafGdal
        IgUQuJbW0IarMKe/pLqiYbowZQfeK6HTgMP/
X-Google-Smtp-Source: ABdhPJyZzTQSJhVTijRAPMMcxOx2Bf7PJXJk1nPb1runSzOrGjSsobzBpbfFngA7G5lnLFsJp4fgTQ==
X-Received: by 2002:a05:6a00:781:b029:27c:d3f6:d019 with SMTP id g1-20020a056a000781b029027cd3f6d019mr20830531pfu.42.1620573485507;
        Sun, 09 May 2021 08:18:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ls6sm16130478pjb.57.2021.05.09.08.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 08:18:05 -0700 (PDT)
Message-ID: <6097fd2d.1c69fb81.5cd4f.aa40@mx.google.com>
Date:   Sun, 09 May 2021 08:18:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.35-230-gad87ad7f97f6
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 2 regressions (v5.10.35-230-gad87ad7f97f6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 157 runs, 2 regressions (v5.10.35-230-gad87a=
d7f97f6)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.35-230-gad87ad7f97f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.35-230-gad87ad7f97f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad87ad7f97f6f88566e973aaf7001631972e85e4 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097cdb42bf53f766e6f5478

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
230-gad87ad7f97f6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
230-gad87ad7f97f6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097cdb42bf53f766e6f5=
479
        failing since 0 day (last pass: v5.10.35-222-g6e80e7d220ea, first f=
ail: v5.10.35-222-gcc2109a6a918) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097ccf7fced7419696f548b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
230-gad87ad7f97f6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
230-gad87ad7f97f6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097ccf7fced7419696f5=
48c
        new failure (last pass: v5.10.35-222-gcc2109a6a918) =

 =20
