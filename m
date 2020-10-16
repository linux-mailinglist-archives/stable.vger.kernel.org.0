Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BA328FC5D
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 04:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392953AbgJPCPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 22:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390154AbgJPCPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 22:15:51 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C8FC061755
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 19:15:51 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id az3so513055pjb.4
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 19:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=69MwzQBDQiEEdUhQvUl57+TOUR1upQxojPj+ezBd+/I=;
        b=CCXAnK4J6tstTt3VE4qTRZ9nG10LSh5dlOFpHjQDNFDg+mpYQzG++uknsg2v6R/KKC
         csCyA/DgXZnGO8pOqJlRuyieR/H95uTO2KHz2xRNcWTeIMFOGoPDbpMNDSYJ6Uxx8qqd
         bYZGYVNevtSn0IVE96MrjvsrCRx2lhsB55KpJlRh7vYB74at7PCq2GmKfY160mziuOfI
         doT5hfsyTlj2oNgW36cBbNLgedW/Wxh9UrlzPWy/8Bm5SNWWgTGuF70D2KWbL/2XHNrQ
         RZh0srmI2Rgf6v1F1EbXJFiy87Wu6qEcCPUUPUdJASFhTuDiCCHNicwBXjPE2zDAKgQV
         tLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=69MwzQBDQiEEdUhQvUl57+TOUR1upQxojPj+ezBd+/I=;
        b=Xwrun2sxA0fA2vixpDeLkLRF4NHozhiBs223wvrN6J/FVDT+0Vdpqdwlj6ngOH4/bu
         GF8vUJZFXwYeuQAXFAwr+9LAx8IBgqaTSv02kDyF+HRvL1nDx3YWMmLxKvKRrV6g7ijP
         4KsqFYFWJwvPBCpzXwkrEQQ5UNYJGk8VPPwiaqdZdR08XWypFRHeCWt2Ql+2zQp8YjdN
         5zW0mYY58IEG0W2dEeQnno02lmbcaIFfMk+2LgC3ihjHXkiKqKskVdJa2Y+DPmi8NZcl
         DVjw+iJAxSii6T5inY4GaEaGN2r+8RNkqbaaA1Ocj/xeP7ZLvF5msdrQuMoiH8Ynfgle
         mdGQ==
X-Gm-Message-State: AOAM531W3ThwnVkex70w28jsW+LaY38WzJ03N5PbsXIFaK64kQjMEiH+
        06vFW1uAgVKS3qdVwA8/7gV454M0u5BpNw==
X-Google-Smtp-Source: ABdhPJwrtFexVxHgiO4ayirhrKUYLWNyI/1XSqc3nfJ3FrJxetAAGlxu/wv/H4cmM1Qwtm6omEY7Ew==
X-Received: by 2002:a17:90a:ba06:: with SMTP id s6mr1710881pjr.13.1602814550374;
        Thu, 15 Oct 2020 19:15:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s187sm699542pgb.54.2020.10.15.19.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 19:15:49 -0700 (PDT)
Message-ID: <5f890255.1c69fb81.6e438.21e5@mx.google.com>
Date:   Thu, 15 Oct 2020 19:15:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.151-4-g939a12d07c2d
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 129 runs,
 1 regressions (v4.19.151-4-g939a12d07c2d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 129 runs, 1 regressions (v4.19.151-4-g939a12=
d07c2d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.151-4-g939a12d07c2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.151-4-g939a12d07c2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      939a12d07c2d78d8f9fd2a74e3c04d03329540d9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f88c9846dc8fb85904ff3f6

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.151=
-4-g939a12d07c2d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.151=
-4-g939a12d07c2d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f88c9846dc8fb8=
5904ff3fd
      failing since 0 day (last pass: v4.19.150-49-gfc7c0b3e8029, first fai=
l: v4.19.150-54-g2e74820a6c13)
      2 lines  =20
