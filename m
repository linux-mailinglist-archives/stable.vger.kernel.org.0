Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5AD040212C
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 23:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhIFVwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 17:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhIFVwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 17:52:09 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE91C061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 14:51:03 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x19so6516826pfu.4
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 14:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=whCeaaMN9X8MddTJUio31/pDwWIVKDV67pzALM/gw3w=;
        b=sadP8+gFxGQ3ffbVLre3QpqgtYPuzID41+xqjRKCos3NaQ4X43RdMBXOLCvLWENT84
         6YBG9olbtqjgvy1zhdCgJ3nrE0NiBSkgmIctfj3gxBDK2jZ/L5Ve9aE5HvSrKRGj3taL
         TxA3wzN4lUUciyAfXqAdbnlAnlJPkMGcabcv+Iui5EmrLYmFf6651+FFXzACV5/5Jc58
         5njCMXnxLRRdJ/orv28AnPPrJXjMCX+RmjA6t5RzJQBUj0216UxnR7lDPaH+RRhpt33m
         tY+/INQ08ibNzNsCGpMQZpcy3zeOcZfG6Qzf5HPvlFXnPL9wDODn7JQepviFU0tGX5l3
         WavA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=whCeaaMN9X8MddTJUio31/pDwWIVKDV67pzALM/gw3w=;
        b=IZdZXyaQFkteNRYOQVyR1cWg+GNmrNO7m5twfIIRCZczuQ3CQ2cSDtWE/2mbE1hnxQ
         ZsFKPm0oNOrs0WuR0B40fA8qCtFWuuvfL1pi8pZEVsT+3gi7jgN2ATcusSpxT8ulOazq
         ySxrVM4lCMY6E0rVNXazfz3DdRPVEQE95cIt8srBgUZ7f4LE+Mk/yT6nX7HEmsgH+4Th
         eQJKzN1CmiTD+00AU2wFYCs1torvx7hNeiePzgJa+2HuDaUC4cIOy4EX9Qvtf45FHHqV
         xWRAfrDHjNdUDuo3leyuzHcSsRP/JmjdKKKJF1Gew9GM0EeIfgMTR7HNCDv7MBSQqA6Y
         u/Kw==
X-Gm-Message-State: AOAM533PSXtgcW41X8KsMNVFBJempR86K/pL94DbhJRSlcdoEuoB2HMp
        l6ZX4wRuv6uhYGZk7uv1xqIof1ZY0akCIN6j
X-Google-Smtp-Source: ABdhPJzvVgcmqFrBoNvcFuzv2US7V6V7RKjMhI27ETOmo5anudQKjl5D2yg7Au/oIk9hdMVriFHaJQ==
X-Received: by 2002:a05:6a00:2444:b029:3cd:5af9:821e with SMTP id d4-20020a056a002444b02903cd5af9821emr13741759pfj.40.1630965062923;
        Mon, 06 Sep 2021 14:51:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j16sm8752802pfi.165.2021.09.06.14.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 14:51:02 -0700 (PDT)
Message-ID: <61368d46.1c69fb81.faf25.881d@mx.google.com>
Date:   Mon, 06 Sep 2021 14:51:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.1-15-gafbaa4bb4e04
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 211 runs,
 1 regressions (v5.14.1-15-gafbaa4bb4e04)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 211 runs, 1 regressions (v5.14.1-15-gafbaa=
4bb4e04)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.1-15-gafbaa4bb4e04/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.1-15-gafbaa4bb4e04
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      afbaa4bb4e04f7c99e483611d4436b299129483d =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61365bc568fd85d8b8d59673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
-15-gafbaa4bb4e04/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
-15-gafbaa4bb4e04/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61365bc568fd85d8b8d59=
674
        new failure (last pass: v5.14-12-g95dc72bb9c03) =

 =20
