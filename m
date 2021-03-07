Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD77F3304D7
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 22:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbhCGV0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 16:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbhCGVZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 16:25:36 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE65C06174A
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 13:25:35 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so1874113pjq.5
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 13:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SaJnyObBd9luH2PbOGC6xnL5wm/SSsR2FZvmO3hIF0w=;
        b=Ei55YZWRXP9v+TbSeYTMqxjd079nvf/TDrpdrNmuMUbf08UTLAuTu23fwGb1K21ad1
         UPyxhwEcHlsx/JV0Z3JzfRPDYQ95stiZbScX/k3XR43zqYDBFpz16p96aDIC/hmycNY7
         6mehAlEkpnRvCRm8st9TQLcHuiRdHuBe0tgskwj55pmCu6P54/IZRPFjAKal5kaFLeed
         8SPw3ZiByDApGyGP834odSsXcK8AtJ3h2J6v1M/E3zgZjSkwpO3i0NLhSflLGUTKSqz/
         TJP8uOcqC+yTW1eru/FwqUpbfsT5SYuydwDnvh5vrxkuciVeBKKXiR3Cd1wegR5w8adM
         4M4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SaJnyObBd9luH2PbOGC6xnL5wm/SSsR2FZvmO3hIF0w=;
        b=YtRILvLL5r7PTTLyuJ1zw+LpomnHXwzezARigTvH29eB3uEbD4nbsbdw14y+iw9CFg
         SSuybFuReRGHmSb9Nk7Sl3oFQDg06dtWc3zWChJ0jtA5v6fVjTBwlSOK+ivqsxlMqbxO
         gzSyTMiPQQEsvFShztTVDgvsw3jZXS8H0GOjpXZX7hzL5dgGY6p5DX2HHf3Jl3gVIDbW
         2nV1J+psXqYIqNHPDl5P1ydacrVpOkIuqhKysdWICI8EiNGZJ1JdmZa3ykN6DdAUMFwX
         qE4noRHOY8a/q8t+3zHAxj1Yb8RTQ6ujTJ3b3T3SfYsJGG3DhBw0qyYB8LcFr2FHsr2t
         eCIQ==
X-Gm-Message-State: AOAM5304nsmBfKjjW+gKhlUYKmP4oCJTe9n+2OJVhE9bjNC8ABXRIzRH
        u2kkEcQ4nqx6m3uH33lyOA2qJMKZCsV/SQ==
X-Google-Smtp-Source: ABdhPJzbIdH4xkgX1reETi0QmHHb7joRQHQyiKS/K8WGQNdydKFBWC3sXZpc9EtUoGeOsA615S1MLw==
X-Received: by 2002:a17:90a:a4cb:: with SMTP id l11mr20851240pjw.144.1615152335024;
        Sun, 07 Mar 2021 13:25:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7sm8287945pjr.7.2021.03.07.13.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 13:25:34 -0800 (PST)
Message-ID: <604544ce.1c69fb81.5d923.4ec4@mx.google.com>
Date:   Sun, 07 Mar 2021 13:25:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-87-g2a4eae4f2f284
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 165 runs,
 1 regressions (v5.4.102-87-g2a4eae4f2f284)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 165 runs, 1 regressions (v5.4.102-87-g2a4eae4=
f2f284)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-87-g2a4eae4f2f284/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-87-g2a4eae4f2f284
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a4eae4f2f2843d80b986b857eb27547b45fe8b8 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60450eb991b01dfa4baddcc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-8=
7-g2a4eae4f2f284/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-8=
7-g2a4eae4f2f284/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60450eb991b01dfa4badd=
cc2
        failing since 107 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
