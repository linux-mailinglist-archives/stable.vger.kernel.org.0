Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F2A4AACD9
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 23:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiBEWU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 17:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiBEWU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 17:20:28 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D8CC061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 14:20:27 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id x4so648601plb.4
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 14:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I1j6aESFbGnjjAIxcck9PeK6HJE8looBcqapv9oS35M=;
        b=ZCx7xQvKQeZuCT1kiaWoVGNLBgqosWnemoZrMn62876gi8vu2TrsA2XkeVUTOrYEzp
         fMgPlfGdeenCrtsODfYhxVCpxaX6Go1TYn7zGG5Db7S5k/3zcCChinPpxDAtwDNvPHBf
         how6xV4XtwVvwG8YM+yI4786J+t72aJdSNsSO0wmA7kN8AvTIYIRbItzythKnwh06RFf
         3WfIrSEjvyQWE68ra41MVh/L00L7UI6xQlOag2WT2ZqhfgQ5ss3zun5kRqMtUpvrC5zo
         e/xtLrk2nlZ8MNOWFUiZHXdEQTIxcE7ZY+ZtDbAgsaVi2sHNTM5js9mcOfu/Lj1gPv+c
         AO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I1j6aESFbGnjjAIxcck9PeK6HJE8looBcqapv9oS35M=;
        b=lYe34f7qDHT4xfdDMy2tEoEOIlywct8GvnZi0MYuBnsDojioGxGcHtNAwrTWxdHupo
         F3CXEiW8KO5I/XzGztwXL1TOUCTJmF9FxRqIFeqgBaOoLUvKW3xuNvaox8WGgW69yXz/
         hj8e9V7WA9mUpWN4PCs101y61dRJaSO3uNuc6VLpjPKJPHpnAUJkH1JOBKjK/r+d9OKI
         warJULFchVCWpWv71d9LMc6AgD4zyWGatLsjxFyS1dm960RPcy9Hw8Z5ygkZg4aASpmv
         3m/FpwGyeEwYCLQzOwzaw4Ck1JEstML+86YfSBihgAuzBZ+oLuLvau34eNy0Bm56ShQ6
         j8Bw==
X-Gm-Message-State: AOAM530PBu1FRtgZfyIkCWMR23mwvUjjoLhVK476SEfZAQhdcVkk6LjU
        QdFR+AB2bRnPNPOdb+5GzLePqTjrlRskPGJE
X-Google-Smtp-Source: ABdhPJw0aY3AzIMHsVICOEDDrjM5gVDj+HaEewepb7hAQM2doQ1AzEfXcOPnDg0qdOOtG4opG4n9aw==
X-Received: by 2002:a17:902:b692:: with SMTP id c18mr10124578pls.85.1644099626607;
        Sat, 05 Feb 2022 14:20:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 79sm6732144pfv.117.2022.02.05.14.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 14:20:26 -0800 (PST)
Message-ID: <61fef82a.1c69fb81.b4119.16b0@mx.google.com>
Date:   Sat, 05 Feb 2022 14:20:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-51-g458d6a0ac5d9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 76 runs,
 1 regressions (v4.14.264-51-g458d6a0ac5d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 76 runs, 1 regressions (v4.14.264-51-g458d6a=
0ac5d9)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-51-g458d6a0ac5d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-51-g458d6a0ac5d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      458d6a0ac5d918c46a798a6564e77df3e0a2a123 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fec111ab3b1949c95d6eef

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-51-g458d6a0ac5d9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-51-g458d6a0ac5d9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fec112ab3b194=
9c95d6ef5
        failing since 0 day (last pass: v4.14.264-40-g54996bdd9ffc, first f=
ail: v4.14.264-45-g6b11d619aed4)
        2 lines

    2022-02-05T18:25:00.141134  [   19.942504] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-05T18:25:00.185468  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/96
    2022-02-05T18:25:00.194741  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
