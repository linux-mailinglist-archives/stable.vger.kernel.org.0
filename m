Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB313DDEEF
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 20:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhHBSJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 14:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhHBSJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 14:09:33 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BC4C061760
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 11:09:24 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so1128376pji.5
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 11:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ml7BD8iYURmJy50gUfJr1ECkhkmifjzHk1PWycuYsYg=;
        b=B1hsKqt7lY1I8lZ5YV5X75+1jAZ0DURLcFA43ipZyUbUU42AF1KgYN3D5iyVYWWEZq
         N6YB7yvS7S6bcTKzBoeaqARBxjSJyDhkLl147em4QWpvQpUzgaOEOplCN0L8tLwoXOGh
         AxXOfmQapKmY8IGw+VGE2hkV/oqqxpVOmVBnBJE/pRdiVA/wncajyom972QLMhjDFEAj
         oLRXP7QHnBvIq0SC1w/6KbC2kDfkzYJwWQliBcYYyXK3xm9Xm0E36GmJb7YZhnHcktVL
         VWwoVCduu07kk+fd8Lk4oDbQ7TjUP3IHPYuG5mRk1RuSg3pGESlBXe+rhKPflPd3qcrf
         ywdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ml7BD8iYURmJy50gUfJr1ECkhkmifjzHk1PWycuYsYg=;
        b=jPLLQ19USqWebcHyPeR9L8rXklztJzEOcGluZDSI84Bp2QsRftEcJ4IpjoVm6rJGNH
         NAGORHAX4Bn+saPh7TRBzrrJ3G7WrGqJAhY6H3EUxrgQMmOvWoz5aJuWryFmOV+HdZe0
         ermZcBkdvwZZmgi1rG9U8HgzDb5KrZ0qFhDfGjrsoeDGE62Jc5PalSrZgXTEnIzYe3KU
         pt+awMpMRCxkkoKKrPFHiOFIuUvo3WzLQmlbWNmOO7LJ4psliIQIie6XhWo3hs+ej5JT
         hdRzrXIodcCDUw3nygRFA2DRHVL5eL7morByGWLV4pn1D3r9BM3c7xn0qw3ufNxa2gMK
         W6CQ==
X-Gm-Message-State: AOAM531xWQmxtqsqtX6YRqcw1BbUQlD+svBF/gbX3H0ra1AdZ2f7HqBG
        6a4w/h+7XWQMtVZI/p6A3oSYaobdzNy2//b8
X-Google-Smtp-Source: ABdhPJy6PzJgMOyzWPI+FpilC4C/JM+ZfEl+VCSDjbLc+wQ7iyLfkoSU/O3b2N/CDOf7XeszWcjoNA==
X-Received: by 2002:a62:17d8:0:b029:3b1:c2b0:287c with SMTP id 207-20020a6217d80000b02903b1c2b0287cmr15054666pfx.23.1627927763476;
        Mon, 02 Aug 2021 11:09:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 10sm12674816pjc.41.2021.08.02.11.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:09:23 -0700 (PDT)
Message-ID: <610834d3.1c69fb81.1665f.2ab1@mx.google.com>
Date:   Mon, 02 Aug 2021 11:09:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.137-41-ge6ba61752450
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 173 runs,
 3 regressions (v5.4.137-41-ge6ba61752450)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 173 runs, 3 regressions (v5.4.137-41-ge6ba617=
52450)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.137-41-ge6ba61752450/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.137-41-ge6ba61752450
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6ba6175245028b50daea574421df118568d2605 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/610802ae2055994c05b1367a

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-4=
1-ge6ba61752450/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-4=
1-ge6ba61752450/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/610802ae2055994c05b13692
        failing since 48 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-02T14:35:03.212399  /lava-4306820/1/../bin/lava-test-case<8>[  =
 15.478852] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-02T14:35:03.212883  =

    2021-08-02T14:35:03.213168  /lava-4306820/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/610802ae2055994c05b136aa
        failing since 48 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-02T14:35:01.769580  /lava-4306820/1/../bin/lava-test-case
    2021-08-02T14:35:01.788105  <8>[   14.053699] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-02T14:35:01.788337  /lava-4306820/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/610802af2055994c05b136ab
        failing since 48 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-02T14:35:00.757034  /lava-4306820/1/../bin/lava-test-case<8>[  =
 13.034353] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-02T14:35:00.757358     =

 =20
