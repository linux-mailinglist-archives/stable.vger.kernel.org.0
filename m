Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35626453BD9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 22:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhKPVs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 16:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhKPVsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 16:48:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E862C061202
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 13:45:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso612754pjo.3
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 13:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h05P7DDHQZO8qwW1moQz0dxD0ra8rRhBX3r4Cd0kDok=;
        b=t7oF82Oox3Y0KTo4qRHMS2i+jZZDmdD866csvVYmECTtXsNiJjc+YkrS/0gkQxsUHe
         2qGepEAk1zmpxmru3MSBR4J+Gzx/mRf096u/bGCVa3coD2WWUKG3uJ8hID0xVN1a61y0
         mZYCsqHnjizuIgd65h93mHcHON+j69XfXYTsr9BHgE4c6n7z48YZDf9j17YavXKHvRP7
         20ftkZYhcgcUfJEuQbCsTusXYo6JRXxVyet2jjkdAxJHxBTanA75U9Iho4CLr+MJTG/v
         AkO7HIiaCDUw5Fq2UvBYkKjEp2bEu6kxmhJAP6NVpTzxGzDddJh9f8fXSMCyCy+2yKJZ
         jQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h05P7DDHQZO8qwW1moQz0dxD0ra8rRhBX3r4Cd0kDok=;
        b=D6sawofOl3eqSzxjuMQqaTpG8fiuv6fTvwbR6sv02N48Yc4798Udek8p8pgCf1YUPW
         jyS0r8NMZqCbG7nOjQDpSUOfLmHmJbUBz5r5t+n69h2TI7+vuKxD0HUf2yKUlp6yaUMJ
         zvYQdNh0OsFjxVUEFUM4BbZLNXcwIQvvouOJds0x5uBFoQAByeMgsLXHcEtyXWkT+5r2
         0BXkQqNjp+YU1oCVOxw8JChfp5I7ZNmxsP8a5egi/SjSvKyoU1v4FB6UIfRFVYdmRgxU
         21u918WRiTTJE2KBxQNIhNeyUYXnkHPQnTOkLar+x6pCWTjNbeE8TxfsVAttJrwPRnWP
         OViQ==
X-Gm-Message-State: AOAM532Nk+xHPIe1R5ii7o2nbuUk4B+h5buROP/n0MKPNtlmwfdunkXX
        jLh1LyA5WrUHeMUbZ5DkWnGzGrqYqcQe2uTP
X-Google-Smtp-Source: ABdhPJwrzekENWE7KIZnvYsM+5BCG8ycSNRC4t1NrkP1br58LiY4lGIVKPIGFdJliCe1vjykkHXCAw==
X-Received: by 2002:a17:90a:c986:: with SMTP id w6mr2974545pjt.27.1637099126932;
        Tue, 16 Nov 2021 13:45:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e15sm18834976pfc.134.2021.11.16.13.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 13:45:26 -0800 (PST)
Message-ID: <61942676.1c69fb81.5cedd.7eb7@mx.google.com>
Date:   Tue, 16 Nov 2021 13:45:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-113-g643cfcb15c40
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 77 runs,
 1 regressions (v4.4.292-113-g643cfcb15c40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 77 runs, 1 regressions (v4.4.292-113-g643cfcb=
15c40)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-113-g643cfcb15c40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-113-g643cfcb15c40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      643cfcb15c400d57fbf0814cdd32a16191d141a3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6193ed3f5b95f573f93358de

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-g643cfcb15c40/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-g643cfcb15c40/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6193ed3f5b95f57=
3f93358e1
        new failure (last pass: v4.4.292-113-ge9a92f80c735)
        2 lines

    2021-11-16T17:40:59.039994  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-16T17:40:59.049859  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-16T17:40:59.069169  [   19.178619] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
