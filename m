Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B802951A2
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 19:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438278AbgJURhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 13:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409090AbgJURhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 13:37:41 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37405C0613CF
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 10:37:41 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id 1so1582608ple.2
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 10:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vv4D6R8eCrxIdV737anNuhnF8IUhGJrIC7ODh0WqRn4=;
        b=dlzULxYrcwFEAysolrUXefx4l0ArH8nOmnJo9alhmX37Mhvb1oCaeM0cyMuqsVJPQl
         TPii35xDDMoDi6pduoTF9DRMB8GzzU9hHqQDHVOWvSUF1VmR6AaN0FgbUv586hY+OXtt
         zVETlZB5+cjylJDAFM5jRpD0Qu1vuI+0mu/QsL8I4TMtODLEK/rkHSIuDfS3pvvdsk71
         GsS8tLoKCWWAaGK5UkHzZBug+JfgAHhbWbd4JCjvwon8Ju0iimx0Xlj1Wye2mvuk5cfh
         xH+no8SbXkI2rYTdZX9PhK3Fon1bGR+JC2lh+g1KNODz8/Cjm2Azl9eaSLNKMkHTRX0a
         Ay4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vv4D6R8eCrxIdV737anNuhnF8IUhGJrIC7ODh0WqRn4=;
        b=CwiD3cWfIr+2AG5neLt57haoOQgQ+4oUA4pDRKq03Kuovw6PN1frzZXX9k9fmix6VH
         QPmwdRWR+F2NLch4XdBQvFXjbwhbMowQbaEwzs/6vpNlgK1jUGf65D2gMh2tP+fZxx4Y
         TSYJ/sApkQgWwB9bRveNpYCRgNJbCCHsek5ZZJH+z+Uv3dsPusdHnmo7a2jRVAPQTqM7
         OBD5aWJovyykGv+vb164YKKCdKdAfQVe9hissWbXKvQCNmZdlZdj2JPYw+FHNdOLHLzt
         4h0XMTciHS9EV1y40jpnT6SAPcFIMjh0U6YAItpKLnOh7GGT88K0ngDPW42lQ29jYVeu
         hgxA==
X-Gm-Message-State: AOAM5319KDhXpiVtJqnZXcLrZq/Qa+Zc8yRSXvMCfGRf6veOmRyyU6Dh
        v78jTvkUyIld82BJEqfGX+UhfloVFrEcYA==
X-Google-Smtp-Source: ABdhPJyqXLky4rR61ibxKJuxM+nTdYLB/JGLg+Umjbt8bqpnF/9Ka1rpKVnlII7e64wNkJ6e3zEARA==
X-Received: by 2002:a17:902:23:b029:d5:b88a:c782 with SMTP id 32-20020a1709020023b02900d5b88ac782mr4669113pla.5.1603301860444;
        Wed, 21 Oct 2020 10:37:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z73sm3063510pfc.75.2020.10.21.10.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 10:37:39 -0700 (PDT)
Message-ID: <5f9071e3.1c69fb81.22323.704e@mx.google.com>
Date:   Wed, 21 Oct 2020 10:37:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.152-15-g0ea747efc059
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 153 runs,
 1 regressions (v4.19.152-15-g0ea747efc059)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 153 runs, 1 regressions (v4.19.152-15-g0ea74=
7efc059)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-15-g0ea747efc059/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-15-g0ea747efc059
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0ea747efc05951b70fa9e2e3e2cbec0d5b4ee2ed =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f9040e3420e3690594ff49e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-15-g0ea747efc059/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-15-g0ea747efc059/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9040e3420e369=
0594ff4a5
      new failure (last pass: v4.19.152-15-gc465dd732a86)
      2 lines  =20
