Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584BB45166F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 22:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhKOVYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 16:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353248AbhKOUzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 15:55:31 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7D0C061714
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 12:43:04 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v23so13874124pjr.5
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 12:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZhzboP1CmlMEl6pmluOzWlCDECDlAUViy6e8jOvWrE4=;
        b=h8FfZw876VxoXIgqGX+5gyOi14bSDMAZ9cS1AB7e2TTH4hGjDFCvc73D7ayvXFxhTi
         dKWsstmiG6Ytlxhu7K/PmbPsUnXViKkHCUhpSRs0Q3NDuR5dDKOQjkZJtMLzNRtG8LYo
         Be+3fdsgn3iCltjhaYRvquAVZSg+usR9rAvyzRGxGwdoMOVrXKyc4C+cOuxCcQeLacFd
         ne3zAME9JWGGTX0enIvIS97rA2Pb4BZt93OdB6kicRcDkbd373o0Dij0PHtYrUISRler
         bzaneZ5PY5vYfM43V7fXAGwAa71dAoEPMmSbOdcCyhkComc9loLaG671J5ysqn/JWb1C
         0AbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZhzboP1CmlMEl6pmluOzWlCDECDlAUViy6e8jOvWrE4=;
        b=qCry0xaLKJpMBnvqYel6JAGmdUDlV5MkTKDZJ6u+ye7+bktkAGu6UfNmdoiCYyymOy
         aYm0xNZHxbR+5BDxkKqNR/cHrxneH25FVOnxbGvcCPP0msVmjfFa8ytdJJyN7KZiVMCt
         LKH+O+xbjaXN1KU8oJ4TwWxZf4QxVzzmrvs6+NSAViM7G2UuaIM7OYt1hGwyucujnBAb
         QQxIHQNXl1fGg4sExT8L534Wp3xjS47A8qGg1AMSrM4+o6zSmOfW4uYswdAKnOa2+1l/
         ERLIwS1IFMmiKEaIQtGrbV9TJh8jXUN84Ea8DIxeGZZLBXXwln7ARmAlhcY6EjgPROPy
         UQWw==
X-Gm-Message-State: AOAM530hKFO7d5KuCOtG5gILj2yFkW9LlNisMRNmWoOgXwsuV5K6UJLx
        vz41JGrusMR1D7N5osSAk4n9mbB1a115U9V7
X-Google-Smtp-Source: ABdhPJzzVL8PfydpWaGZjA25nay2iZRhHQMrmOFx6VRyvqNLt36WbKcdaHwxC3OqOqmN/HngrOGWqw==
X-Received: by 2002:a17:90b:33cf:: with SMTP id lk15mr1779267pjb.85.1637008983889;
        Mon, 15 Nov 2021 12:43:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id co4sm212848pjb.2.2021.11.15.12.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 12:43:03 -0800 (PST)
Message-ID: <6192c657.1c69fb81.5fd98.1243@mx.google.com>
Date:   Mon, 15 Nov 2021 12:43:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-249-gbddfd947e3d8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 99 runs,
 1 regressions (v4.19.217-249-gbddfd947e3d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 99 runs, 1 regressions (v4.19.217-249-gbddfd=
947e3d8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-249-gbddfd947e3d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-249-gbddfd947e3d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bddfd947e3d8f4adf31d78e835a9942acf5aacf0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61928232c46795a8e0335916

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-249-gbddfd947e3d8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-249-gbddfd947e3d8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61928232c46795a=
8e0335919
        failing since 0 day (last pass: v4.19.217-72-gf6a03fda7e567, first =
fail: v4.19.217-85-g1a2f6a289a70)
        2 lines

    2021-11-15T15:52:00.595261  <8>[   20.974578] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-15T15:52:00.647403  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-11-15T15:52:00.655973  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-15T15:52:00.674784  <8>[   21.054718] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
