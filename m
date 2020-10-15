Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338CA28EB66
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 05:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgJODLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 23:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgJODLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 23:11:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD81C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 20:11:15 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b19so824843pld.0
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 20:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YDeAekadxGU82NwNcJ0tE9oqu3Xslc6aIxIj+jtkA80=;
        b=PpBVENFqGVzasRYmEInpsjMg4hH5kuQ8QdWR/BU0x4U3mhR3ABW/FLswMMMANAPvBP
         Zys8uo45cl8UqtbHYMPd/BAIDFN0PMpHHZrLKLCqZ5+oga1dEUf6bsJG93Ju1PMv53uM
         4cPmzdxSFTJuHuYmYZvLZgTDHCe+yx/Kz0inXzqkHWnCLBtsc4RmgJxq+feA6a8G8Nap
         +VsOh9urWr5H9hH1/cEwOh/sI4l3kIpcQdPAl6q6o/uhkNxCAF9Nxh6W2eYrT0MnVmZ/
         t/ABurCaFWc7vmf2727iA7P6wSEADlp1Q/NsrUV3zk7rfWPvDE5gmTgXDCqF7JheBvEV
         Klkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YDeAekadxGU82NwNcJ0tE9oqu3Xslc6aIxIj+jtkA80=;
        b=dxY2XuUXrkNqdGWkfNABEBhPdc1LvlQr+6pCw3gDDtAgEPNb9gWgtnfvS/tPKBFJjt
         JrEDUAKlHYvbpgUYLKUxLbYp7NqmG9fVUizO9V8M43tsOiBQ4N3yz2b5vyMmqj7IO16P
         PlMLyW7WqMfhNtsbtcxA5GEuVdQ6+J0Xg+Ub9INynynEAgg119tU95CLegmOwRVJZbFN
         g8r6HBR2mV+Nv80SHAowQqNxyevhjZ1m5tHdwKSgz+6wCryGtS2O0UTeYTE4RhEuSrme
         paxMB1sfpLudntceGYgv1G0Ws3cqAjl2VtB27Rv1K/BiCOBG74IDQEQkDDB4egV9m5qF
         M0wg==
X-Gm-Message-State: AOAM530b17Z2UI3vPniC0+Ia/lPUUYjA/8JIFBVynNLbhexiymvJ5HLi
        Lh2bv2kY/VQa2+K612gdJVGjSK0JbEjy0A==
X-Google-Smtp-Source: ABdhPJx0nXd2K+jUjp06PDLx3A8c8RPExoTx+9LpaZFDtXracfHNEvN0yLWKSd30iA2N5USMuOF0tg==
X-Received: by 2002:a17:90b:1644:: with SMTP id il4mr2158797pjb.151.1602731474900;
        Wed, 14 Oct 2020 20:11:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b4sm1052790pjz.51.2020.10.14.20.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 20:11:14 -0700 (PDT)
Message-ID: <5f87bdd2.1c69fb81.ad85.3148@mx.google.com>
Date:   Wed, 14 Oct 2020 20:11:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-70-gf87be2102ea7
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 165 runs,
 1 regressions (v4.14.200-70-gf87be2102ea7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 165 runs, 1 regressions (v4.14.200-70-gf87be=
2102ea7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.200-70-gf87be2102ea7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.200-70-gf87be2102ea7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f87be2102ea7ba5a03477d56db79af12b724a4e4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f878686964af05ec74ff4ec

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-70-gf87be2102ea7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-70-gf87be2102ea7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f878686964af05=
ec74ff4f3
      failing since 1 day (last pass: v4.14.200-68-gdb4c16496395, first fai=
l: v4.14.200-70-g143a37943654)
      2 lines  =20
