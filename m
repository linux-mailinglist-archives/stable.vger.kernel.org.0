Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAAB44C472
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 16:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhKJPfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 10:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhKJPfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 10:35:22 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A6FC061764
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 07:32:35 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso2024602pjo.3
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 07:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n9hyIftSVoMA2oDkXTrDeWdXS853GKd1xk3Xpp2W4yY=;
        b=nFW0b86Qir2vwnclvyceH8jvA6ws2yoy+BuRO8QFuuvmHU8a2xxXhFW1J6g5EvIwX6
         6WskpdcJnSlO3vTktz1EINtoKdU2HVjj7rKQgsM1gmVe1bMqyq/EkISWY88THO4nhfv/
         9NQis3g+GdnBnZ+6irbFmnexLa/X67qttQwhsqHKniteeeKGzkQITn41uHe2a0qAQOPP
         QFdtvOTbWNQNzu7q9RRC5hCgFLGKwy/SOWqxEJUewGsK0bmrBLSLwio/fBlmnM5k/gzN
         hYby1yXS7rXf+5N2dseFn5ooU7Lngy6PKZ1vg0oxMpoU0k2T+nn9Q1YVbuCaJKW21LC+
         jq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n9hyIftSVoMA2oDkXTrDeWdXS853GKd1xk3Xpp2W4yY=;
        b=BExFsAmWxWChIdtyJAgg/yftEtSAXaawPMdtS/l0DTcoq2znw9oRrxWHEOGsaTIYRA
         CCEEEb32z8uajOBrL98XP0CoEli0KAT5mZbmXSZ7MnVUHLtuCn7LuT31u+aA7gEzo3TQ
         Mz6kUHONXEMkTFcx0m0XQ72ambK+GXe+Z7yu7StnH+gHp7Sf83WSg0hv4wcUw907Wx5R
         FLk3RsAxfPYo6xU3otw/5oyz61j2InytKD5JWB6amruSr8ldReSoxor6tbd9BDZzDQKx
         wcyULxhRhAn4JkaSiUyIumRtNC653IysLxT/4NL2d+xaczn1zPRIctkeau+81dFXdDGU
         GAUQ==
X-Gm-Message-State: AOAM532hpgZfB9sbf0NTPdTUsN7biVUZCiuJ6KrD+VC5Ad/X6D2KMuQR
        EtWV4Kg9TXZ9oIwRuiRGumnU16neOh6B8W2R/0g=
X-Google-Smtp-Source: ABdhPJy14m3G/R96ZQOL8448W8BRsgQOyWZgXzcO/tRumA9J0dxMiZalYDTucHFGRoutyjGYJzPBnQ==
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr649127pjb.220.1636558354281;
        Wed, 10 Nov 2021 07:32:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k13sm63798pfc.197.2021.11.10.07.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 07:32:34 -0800 (PST)
Message-ID: <618be612.1c69fb81.74b61.0368@mx.google.com>
Date:   Wed, 10 Nov 2021 07:32:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.216-7-ga721c571705e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 186 runs,
 1 regressions (v4.19.216-7-ga721c571705e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 186 runs, 1 regressions (v4.19.216-7-ga721c5=
71705e)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.216-7-ga721c571705e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.216-7-ga721c571705e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a721c571705e30892bfb14848c6099ae774aceba =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/618baa863b5046ac493358ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-7-ga721c571705e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-7-ga721c571705e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618baa863b5046ac49335=
900
        new failure (last pass: v4.19.216-6-gfa81136e6d6c) =

 =20
