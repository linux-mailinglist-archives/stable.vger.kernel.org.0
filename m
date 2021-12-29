Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E2D4817C8
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 00:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhL2XkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 18:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbhL2XkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 18:40:01 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365C6C061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 15:40:01 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so26012298pjj.2
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 15:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+F0rx3kXAXHp+HXqPjEwwav2xVdLur+FV3iCTu85G3g=;
        b=gWcdnuF5hnB25Ti8jWQFAH53BUPpQtuDon2ZMzmgI4SjD+CMrl2bIobR/h6nvGkbpa
         h9pakGwMjsfQt/SP4SrTzzL+FNKIW+v59A83DogQFpdLt/wqyfQ68pqpfM2CE8g6ifKV
         kGy/ToUvadxCKBHRXYO3ep/BN5nzMqhCm/KUoijf98LP4DnTm/srfdSa3f4AfVUL00B4
         l0R0qE/YafH2Tmskd6zeZU/subOt9aG9ERJaBxMKZ3OyeX4HKaLy3CUvrSUp9ablIh9d
         AL5GCbkEIBNGfLFlEikib+/Q5Dwn+EjL/Pi5lqSckbrW7fxywTm6NvAYFq8cYHgrIdhQ
         0jhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+F0rx3kXAXHp+HXqPjEwwav2xVdLur+FV3iCTu85G3g=;
        b=XaEaJ4FaZ89Jja/lpKad4/bCKofRA25EpThiSnYxT0XeZAJGfBKAHb9eVSENwPopNW
         ewW+VM7+ft+PEC1S6G+sUMem92njf8+J0Zk5DM7zTJVuAZFUIclzYoBDTR+JiAkSNjjF
         JBzfF9Ubdw/utulxn4Z8t9K1GP94MF91sHElEWM9HzJFNTjZEfQaZL1zAkzjUBWPujRl
         NIJPp3DIeDNW0lmhKgvSq/mdm7NUX86kbMblZB8MiplPw3yIBnQz/KdqX5tSbzAfHSsl
         7AS3+cBh9jxoNXJBGvui5N+685tN9jV7nplK7aIsQvkT30sGOPYKX9HXQCh39cV24Fzl
         Ro8g==
X-Gm-Message-State: AOAM533EF+5Tu8VvOfVg8C0j7bXWAZpaR7F0iZVoh+Vf7wtmSOhcg34x
        LLYEQgrw2XVIoNRC0kBVE3wW/U0A6rexQP2f
X-Google-Smtp-Source: ABdhPJzd09q47RI5ywjpV0rvh+WBEpx8bu0aflu7TYatlVHmzdDWrzZQgkrsO8C5HXx/N7EedXeADg==
X-Received: by 2002:a17:90b:4a81:: with SMTP id lp1mr34903684pjb.19.1640821200665;
        Wed, 29 Dec 2021 15:40:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i185sm24660448pfe.199.2021.12.29.15.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 15:40:00 -0800 (PST)
Message-ID: <61ccf1d0.1c69fb81.66daa.583e@mx.google.com>
Date:   Wed, 29 Dec 2021 15:40:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.296-17-g76d42990efb4
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 117 runs,
 1 regressions (v4.4.296-17-g76d42990efb4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 117 runs, 1 regressions (v4.4.296-17-g76d4299=
0efb4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.296-17-g76d42990efb4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.296-17-g76d42990efb4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76d42990efb4902de293be254f5e93c693058c8f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ccba069a31fe4742ef6759

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.296-1=
7-g76d42990efb4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.296-1=
7-g76d42990efb4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ccba069a31fe4=
742ef675c
        failing since 8 days (last pass: v4.4.295-12-gd8298cd08f0d, first f=
ail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2021-12-29T19:41:38.226194  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-12-29T19:41:38.234493  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
