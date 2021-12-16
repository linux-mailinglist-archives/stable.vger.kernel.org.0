Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6302D47682B
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 03:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhLPChE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 21:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhLPChD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 21:37:03 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9055C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 18:37:03 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 8so22346320pfo.4
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 18:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TWwjouwx0a4HU69dKN8SxH18COwpv5e3NwF2YHfUDV8=;
        b=Fn2ktRKua6S9FdI69POoGOQ3eIXqpuuxGwtkRt88fprAcq0D6WTXcUbN2r4OZp2e2c
         jLVoRKkyhcSDhgpLWXHdaSszO9YZsDPJUIIyGgq3LuJB48Z83sF2NQPXYY185ANwrMnW
         iI4+AgiQJfetWdN2nQWOLLtft1R1jyW4dYHidkCVfiRgHGvNO4sDZKvpNRfMoZzxpVCH
         WrITNPAh9W8zMpXnIlf7rT8jVBsNcI9vH8K8IIx+evZm8AXkoRE35ZlWdDuD19JT4vrq
         oLFWoEX0UTJi3KBgLbNGcme/ve3GRUOdKdb1cIV6q+hq0R9E5T55RDq91bNxelzOmM7e
         2sUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TWwjouwx0a4HU69dKN8SxH18COwpv5e3NwF2YHfUDV8=;
        b=zwPUi38xGobqPM2uK7oWyLuFz2EsUSVAgJVUIhDIrpGvtoaf+RTM/ph1HJ/9qUxcXs
         SeJrL1l3ERhhZ6wS1JhN1p2ovEzeLD3fef6W7NbbR8x67IC+0SOwlfrHYgfRKZKaUfKo
         D2pBY8H4xYDNqHCBnq3R+GOU7EMV9v3YmI0vlvYJfK/TaXhz52UJ0n9PH+XOOi+1uhfx
         RwMcXf4nc0iaY9MWdw8EctkbFUCU45Ofyka9pOxh2NkS7mZ3l5ncaKpDwFgGBzpkEbc4
         Qb2cjyeC35x2FEJpuAEhpayFx3z+QUda68/F92kJbF+2++yXfnpT0pvLLEQqYdfSHaD3
         67+w==
X-Gm-Message-State: AOAM531yrSe4iKjT6ulVw96uibgAQjTp44hTrj/KI82PDdnPEDCla/iU
        TuLGDrYKJeEZqvDl08WR62uGuCpl+kVRYBF1
X-Google-Smtp-Source: ABdhPJwi1Kwmj6dvMc9mYz+lDTMxvndhVUTWXzyWHcDlpResCVRZx25zvCMOFkYOx5bT6dz4Wk5QCg==
X-Received: by 2002:a63:f70c:: with SMTP id x12mr10198744pgh.602.1639622223131;
        Wed, 15 Dec 2021 18:37:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v25sm3949282pfg.175.2021.12.15.18.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 18:37:02 -0800 (PST)
Message-ID: <61baa64e.1c69fb81.94a0.bef1@mx.google.com>
Date:   Wed, 15 Dec 2021 18:37:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-5-gf02062a2d548
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 100 runs,
 1 regressions (v4.4.295-5-gf02062a2d548)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 100 runs, 1 regressions (v4.4.295-5-gf02062a2=
d548)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-5-gf02062a2d548/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-5-gf02062a2d548
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f02062a2d5488b2d94937fa9ec5c2a3af83d4c93 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba6d436b59c1492e39711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-5=
-gf02062a2d548/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-5=
-gf02062a2d548/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba6d436b59c1492e397=
11f
        failing since 0 day (last pass: v4.4.295-1-g8d64c5a634d5, first fai=
l: v4.4.295-4-g6f24489e6ad7) =

 =20
