Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27B74A31FB
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 22:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346327AbiA2VDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 16:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346309AbiA2VDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 16:03:17 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B1DC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 13:03:17 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b15so9226517plg.3
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 13:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LeVqAuzIZrg4Fcw2zMhc1rPnxpQb5ck6l47/fYpg5nk=;
        b=lFBdGJQmacDESH4JvCAnJUqAOdnvQcQCrzxYYLeMLjOi5+rbzMx3cFw5fXntpUatF6
         0jHxdWaYDZG9TppEqLWKH5OwCiDMvqTH+GC/xRrlCsT7UzgmJLyfZJMXMN4/VOiSaWR3
         ojkK8p7axtQshrYI/XibUCv172yybfQB5icktrY/gNLYgk2R/2D7MZc6RLzFYG1bZv3+
         m12puslkHTPeTA4MpvTYIgd4S3GwFJy3HUD1pe1xoiQuHl6wl7U4UofosnTTbdkhPEK0
         zHUjbQaZ85EBEXC9pIUml3FNiPMMVz+kui31BKpxLFmjfrPZgBYdE9aDzClSKUpZAF1H
         o7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LeVqAuzIZrg4Fcw2zMhc1rPnxpQb5ck6l47/fYpg5nk=;
        b=07OJxG/0c7ELmUj4lKzdSbnnWuTDMpxiv/YI/BpaWEkBhstShx5aM9OrXp33dhAjrF
         DPQO6tmvdviUB/FxQIJPxXLRmzZIFlsDTu9TscWwW0N/Y2NeKk/REKNFXmPw4m/YYwiC
         ZczNeovjIcWJrgo0HaKfrHfiniMeTDBac05u3Oz4M+30sQtJVgdPkLfVm6td7xYTagta
         EbwUm32q3WZZxdUYeFD2eaU7p95eQL3QfAPcJHcArC0kP+SVKBWehJwnaSh/ivNbWoi5
         qDl1Q8jiNODcQ2B88+UkoexPgmL03puKSD74i5cplaMnluNjyR1XH/p7SbMUtYlUF/ug
         /KRw==
X-Gm-Message-State: AOAM532W6yW875Yq3r2hpJHhn1XD8rP0bTmrDMMuHZj3uUXmdALvkcVX
        we2xEN+13r2xvFDKgatNXou/GPUKrnMLmS53
X-Google-Smtp-Source: ABdhPJzG894n1jWYnpKeoNgJRz2IvAuMZ4MuK8LZ7mUiGrJZSy7Onq00YNOdROYSw340BA8oitoh6Q==
X-Received: by 2002:a17:902:e88e:: with SMTP id w14mr14376016plg.95.1643490196897;
        Sat, 29 Jan 2022 13:03:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2sm13496270pfc.183.2022.01.29.13.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 13:03:16 -0800 (PST)
Message-ID: <61f5ab94.1c69fb81.e3dd7.4367@mx.google.com>
Date:   Sat, 29 Jan 2022 13:03:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.227-8-g4d2a3fae51c9
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 120 runs,
 1 regressions (v4.19.227-8-g4d2a3fae51c9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 120 runs, 1 regressions (v4.19.227-8-g4d2a3f=
ae51c9)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.227-8-g4d2a3fae51c9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.227-8-g4d2a3fae51c9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d2a3fae51c90d12f44e86013f8e00df98161be5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f57118c4e10e3372abbd11

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-8-g4d2a3fae51c9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-8-g4d2a3fae51c9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f57118c4e10e3=
372abbd17
        failing since 0 day (last pass: v4.19.226-4-g38be3b9e94a4, first fa=
il: v4.19.226-4-g23c81f83e59b)
        2 lines

    2022-01-29T16:53:27.263948  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2022-01-29T16:53:27.273219  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-29T16:53:27.288723  <8>[   21.408233] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
