Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9670747D5F8
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 18:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhLVRql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 12:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234397AbhLVRql (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 12:46:41 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083CCC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 09:46:41 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso6541331pjc.4
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 09:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mLpY1tTspbwzzZloR2GDQxDblQPuqCEzLs9SGmt1Klc=;
        b=Tne6XPjL8oX8QG/yjxEavTFi1b/uDcjhHNceSxDvA4BaSboH55g2vabsy6SPGcjZrO
         +JSQaQ2ZtWfH2omW80XV/tzT3/aOQoX4m1AoHD5FGXtlRzxrK1Ds3Dcs/cG2EZgIPeJT
         FwkGbPomdsWMGG6cMmls2GsrW+/FRqreMZIhV2fe/8KzibKgii1L4Uwa1Mw6y4AsgtZv
         xEtPfh2ke0p5WD6xSPGCzPpHLo1348T2JnEA5BH/xqt3iRW7Xw2kJK0L+0zzw2IyGAG9
         Y/oyIiASzMOfxSuuBY2EbaQ8p4SrPH9T77ee5JhJ5Kno4wEPfc0F/pLENGCeenrY7Y01
         x/Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mLpY1tTspbwzzZloR2GDQxDblQPuqCEzLs9SGmt1Klc=;
        b=lno/2ZBS8c3+UnZJ/ESF8gsnMf+KYfcLYwCsJ4UWdNVOKMyORGmlhQ6mBwOlqMD+h8
         Vto9Cgp/gh8X0PSObvpsYPbGvDQxX5gQrz+tb8SRpGe6K8JXwIcjWGcpGTWPkKWO3NJk
         g6615Sba9M2VgGLAZ7AuMnYFlsUOExY+FEDARw0aJS4rgIjkgAqqcrMSzL+RtI+3z6N1
         1U+Cd+nR2GosLk/w9fLwfc7luncz83z6wIGrvcolMLZwzDNWzPF8hxuLgXe5CwmIK5YD
         eTGauGPT7yfapU3uFLsHgueuSKyof6TMKYC+NPxewS7BeNWBy1CSANrIrSGvMYruR0IQ
         Axbw==
X-Gm-Message-State: AOAM533jq20t6VYNoIVbWmsvJPQPFieHjJUuOdGNRSkVmXIwwG94rSOA
        R+JVLBr9RTZ9thouh0vqqkpSgXv+NteZYvBppng=
X-Google-Smtp-Source: ABdhPJw/zrg0KcPWt3/2xp7TK+zgczOP7RNhZGXD41uzHdyiOlqsWncVTVHa6bgSvBABLB5f+r/MDQ==
X-Received: by 2002:a17:90a:e7c6:: with SMTP id kb6mr2505786pjb.234.1640195200362;
        Wed, 22 Dec 2021 09:46:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i15sm2587021pgd.16.2021.12.22.09.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 09:46:40 -0800 (PST)
Message-ID: <61c36480.1c69fb81.c6b45.7013@mx.google.com>
Date:   Wed, 22 Dec 2021 09:46:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.296
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y baseline: 124 runs, 1 regressions (v4.4.296)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 124 runs, 1 regressions (v4.4.296)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.296/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.296
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3d70a885819277a1c81c31f200059f35983911d1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c32a873ab5d4e99a397124

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.296/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.296/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c32a873ab5d4e=
99a397127
        failing since 25 days (last pass: v4.4.292, first fail: v4.4.293)
        2 lines

    2021-12-22T13:38:59.146352  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-12-22T13:38:59.155651  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
