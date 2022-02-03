Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA6C4A8921
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 17:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbiBCQ4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 11:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbiBCQ4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 11:56:15 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FD3C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 08:56:15 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id z5so2636818plg.8
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 08:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jQcxWiHRjgVMdP4NLrda6wIBANw1Ijw8Xs4ZZK+XAtQ=;
        b=qu+GC0vntLuwYx9P4u5sRSe7aXDJMs9e90Dzdvjix5SBZMLKJ5DXQI6UuqL36LFYk1
         wpd2URYNMPZXQw+IbDyvPKh2zqoDKVtLQ6jT4rDuQqJd+qNelBzVHEZ6WVx316B45rR0
         Ur47VnTU430QnFsmplpoVSJSbelWEdckjQtkUxVozLJW5SMOiw/Xf0Grv3PC/SDeSma4
         Aq9hVt+mSTEb3JrX10XkWtgRTeNoeALN0M2kxxJNG5YXUtgHreZgO1ysZ/yNatBsmftP
         EPznUB407xCSCrhxmYMgvcKdHxbBzy6Ft7ra2Ep3G3Uq9406KlGAnFg+Q743yPj+vOSa
         u0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jQcxWiHRjgVMdP4NLrda6wIBANw1Ijw8Xs4ZZK+XAtQ=;
        b=nk7BbZQsbZPlJFMJbnKR1lCZ09UkSuLGQeR9SLyVBlhJ38P1p9mysSUAEE/Z4rtu2G
         e+lE2tlrSz/8cE+hCIUi9lxYrbMY77K8bym28GbUJZHcTFpDi+FkW0qli1izYrCvfQ+H
         gS4Sj6b1BG8Sa6+i4uneiROk7WaAHi6cE55enV4AAscNcjWlXeUHITv6pbpY2jLm0k87
         xvG/z0ymkp0H+z+JcZsfIIK2PL17sMW0OkJid4jJ4Hk8OB0SEUhlK4pioEjRqVjSQmvE
         nPDil7YQiPFBVuoUHrJAThRHlibMmPoYQHZnuIr697+z1qNEPEZOsVxeOFa4hCk2WCPE
         Q7rw==
X-Gm-Message-State: AOAM533ebEoMk/NORV+8I4mto7oWGAHkYkKHV4KCBNTzTff/boQ64ylo
        4B7r8y+wjMppwEl7DVpKdw63cbwfe99Hf4VJ
X-Google-Smtp-Source: ABdhPJzMc8tMcwAXsymJjr+mz9ihD7X+0uT/8W2FYNz4lY9mPWn6ZCfdzlpdPFcFpgi/3eYGh2uzkQ==
X-Received: by 2002:a17:90b:4b05:: with SMTP id lx5mr14984642pjb.171.1643907374919;
        Thu, 03 Feb 2022 08:56:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j12sm26970636pgf.63.2022.02.03.08.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 08:56:14 -0800 (PST)
Message-ID: <61fc092e.1c69fb81.cefab.6fb6@mx.google.com>
Date:   Thu, 03 Feb 2022 08:56:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-25-gef15b151165d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 113 runs,
 1 regressions (v4.9.299-25-gef15b151165d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 113 runs, 1 regressions (v4.9.299-25-gef15b15=
1165d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-25-gef15b151165d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-25-gef15b151165d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef15b151165de296153d52b0127a4fd6d2fd2a03 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fbd7440caedd705f5d6f0f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-2=
5-gef15b151165d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-2=
5-gef15b151165d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fbd7440caedd7=
05f5d6f15
        failing since 1 day (last pass: v4.9.299-13-g3de150ae8483, first fa=
il: v4.9.299-25-g8ae76dc07a67)
        2 lines

    2022-02-03T13:29:22.210675  [   20.440063] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T13:29:22.254006  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:2/74
    2022-02-03T13:29:22.263201  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
