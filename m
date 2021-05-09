Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC5237785D
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 22:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhEIUHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 16:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhEIUHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 16:07:46 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53217C061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 13:06:42 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id lj11-20020a17090b344bb029015bc3073608so9066383pjb.3
        for <stable@vger.kernel.org>; Sun, 09 May 2021 13:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lSvAYcgZhjOjojnw95B18AhUBFizBaml9lF74pwFsqQ=;
        b=RXc33tO+AAZv06CbF5DywLADGYmVDSMfBPEvarzfhB43Ln3EXrHzjotSo1TJJFUq4N
         qTyk39SBAZljiyEj2lUsHchN7XsS8dH9lHfYU3fzThusNKnhe2rPs7X78pLkh7ijttzt
         XlxxjgSsfatKEnKzWXUCSS8dkISIFmnBZnDd0NSjUWG9xOZbSWPf2euh0AVkVmjdK/m3
         2O5NrY8/YkGT8sX4aNlC5VNtWmaXxujDyMFD0wWYohIS8wHUaaBewvdD2hTOch5k5+3W
         RA3yuZ0+0aoawWxxg+0vx5E0m1ISD3/yTfi/4IUkrQy1X2jreJ4Y+CP2mmpVHk4TE9kv
         bTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lSvAYcgZhjOjojnw95B18AhUBFizBaml9lF74pwFsqQ=;
        b=MtHxfTIPDT5M5ZquJxwoQMgkaGtfe8EbtC0/78xa1Nw9WlI4Co4JJXjR4YbbCCSwyD
         vkbUtWYYNr8kwB6DhZERoEmQ9Jjxk/mA6su5uJMIKdb8kV39j6RxkDe932NYdf8iUYG3
         AEYxgTWanQqAJw131ci6Knm5HwkjDxoMxYj6kAynv6VPzpph+zr0K926FGOgoCohTMFT
         5RiQLzueWpJMudZR1Urc+YK8VrzEYuob0gK9ihuIpeoAXTb7jTM/Tfw8HCUAD165EkL9
         2ASw+8CyPxAH8Z4KQMfpmcrjrHyHPEwMpdKDAFyoGlBJw2yQteWkJNnm+LLSCsF1vhP8
         smfQ==
X-Gm-Message-State: AOAM533+pbqSmE4ARjffc8cDlywAqrND+NRGJnPB04B1K9IhtS54S+aJ
        glvfaVPfcYJ4jWXj0enn4X05c+EihhTC0g==
X-Google-Smtp-Source: ABdhPJwJ0NHMf+OiHEHtpxzNvFZxbQb2yOA+gS7EJu/nR/A+TtKXRE5kRvAiKTE9TcOWYAJgyms40g==
X-Received: by 2002:a17:90a:b388:: with SMTP id e8mr35546899pjr.167.1620590801731;
        Sun, 09 May 2021 13:06:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c195sm9531619pfb.5.2021.05.09.13.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 13:06:41 -0700 (PDT)
Message-ID: <609840d1.1c69fb81.c648c.c8d2@mx.google.com>
Date:   Sun, 09 May 2021 13:06:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.35-257-g999b6775fb75e
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 162 runs,
 1 regressions (v5.10.35-257-g999b6775fb75e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 162 runs, 1 regressions (v5.10.35-257-g999b6=
775fb75e)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.35-257-g999b6775fb75e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.35-257-g999b6775fb75e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      999b6775fb75e215d19f9f5d7e92bc2889878163 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60980f251957e602c66f548b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
257-g999b6775fb75e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
257-g999b6775fb75e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60980f251957e602c66f5=
48c
        new failure (last pass: v5.10.35-249-g83b7e5089f21a) =

 =20
