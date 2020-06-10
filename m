Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482971F4CA8
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 06:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgFJEzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 00:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgFJEzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 00:55:08 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70AEC05BD1E
        for <stable@vger.kernel.org>; Tue,  9 Jun 2020 21:55:07 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id s88so373003pjb.5
        for <stable@vger.kernel.org>; Tue, 09 Jun 2020 21:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K64935Prs2iy9zR3uCW9kemZxXcBQ6nSJpCAhyVIoGc=;
        b=cDwlaJwAc/FpAM8qmHlAIr1k89JRwNBeZorHRd1EeNybOQkhIvkRtJHRFsUFqmHf10
         QqVk/YgEeEiaW/96uwjZBD1vmjx0ffRZ760a632SOPVO1UOQX23Fi6bBY7p3k57+hDn+
         HX4QRSg0tZoSAumgY+iwsCESxESIj6bvKYvc+kxBrvTzOyVNmbdInOu7nQ5K/b8duIDp
         AmH/i7RPhGbxwbcYV8QBGToyNcET9i8uVjLoH85B/ohK42F9E9sPUN6mtwxiIKsFGzVb
         9sqFn/w4B99uxFKkskQDSmTqu9iTBZs6xTFs+VrchVj2niLr8I2oI1q+a5JlHoz7zOq5
         UHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K64935Prs2iy9zR3uCW9kemZxXcBQ6nSJpCAhyVIoGc=;
        b=SoUqWk/sI19UqIqHGr1pRBS24xUn7/klhmAKGYznUZ6Y4Xtw7WLHCaFfMliEc+ElXf
         hhGIFt47841XTUhPbB3/R6QS+7uewCfZojPhqjlTZkP/9K6OK822YjtPQdVaR1cbOr6g
         i+ajgFH2pFbx1+eTWlz/GwGTp6qt2z9jBo+nhrlP0D4OysKU6JEULBnZUKIc2ndhorNW
         Rw7XdVKj9WS+sSicfeOBZtlC6FfK1Zgcqlah1XNZoPJLLID7BgCwwr4GC4zG1ib49pVz
         id5zBH4aBhBDHsbaxPL3Hjzzd+rfp2MNWbpFJY5SR3fdj69ih3B4BPDOf+ZEnm7aW4yP
         FuuA==
X-Gm-Message-State: AOAM531dkfsB40/6XK9G+X+tavKf64GnIoRSqXyHMF7FMFg4kRzLqT3o
        89l04Z5eBOMBfd6SskZXDB1vYUFdpxg=
X-Google-Smtp-Source: ABdhPJzR8xIxgxVH8nL+fowgxP8oyAhX4xzzbsoLGnoGn9MuHNTyO8N0vmlGPPcoKQIp+uX9FWcVCA==
X-Received: by 2002:a17:902:9a89:: with SMTP id w9mr1567670plp.30.1591764905408;
        Tue, 09 Jun 2020 21:55:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2sm9643885pga.44.2020.06.09.21.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 21:55:04 -0700 (PDT)
Message-ID: <5ee067a8.1c69fb81.ab808.274c@mx.google.com>
Date:   Tue, 09 Jun 2020 21:55:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.226-37-g61ef7e7aaf1d
Subject: stable-rc/linux-4.4.y baseline: 30 runs,
 2 regressions (v4.4.226-37-g61ef7e7aaf1d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 30 runs, 2 regressions (v4.4.226-37-g61ef7e=
7aaf1d)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig           | res=
ults
------------+--------+---------------+----------+---------------------+----=
----
omap4-panda | arm    | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5=
    =

qemu_x86_64 | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    | 0/1=
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.226-37-g61ef7e7aaf1d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.226-37-g61ef7e7aaf1d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      61ef7e7aaf1df32b9a53dda1cdde0caff1293c17 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig           | res=
ults
------------+--------+---------------+----------+---------------------+----=
----
omap4-panda | arm    | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5=
    =


  Details:     https://kernelci.org/test/plan/id/5ee033c9ee406bcbfa97bf13

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-37-g61ef7e7aaf1d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-omap=
4-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-37-g61ef7e7aaf1d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-omap=
4-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ee033c9ee406bc=
bfa97bf18
      new failure (last pass: v4.4.226)
      2 lines =



platform    | arch   | lab           | compiler | defconfig           | res=
ults
------------+--------+---------------+----------+---------------------+----=
----
qemu_x86_64 | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    | 0/1=
    =


  Details:     https://kernelci.org/test/plan/id/5ee02f650fa41af04a97bf51

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-37-g61ef7e7aaf1d/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-37-g61ef7e7aaf1d/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee02f650fa41af04a97b=
f52
      new failure (last pass: v4.4.226-24-gd275a29aa983) =20
