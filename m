Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0796148F046
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 20:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243873AbiANTJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 14:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiANTJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 14:09:06 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514FBC061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 11:09:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so23136910pja.1
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 11:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KNzcwTVcOu0B+eitDszf9SY5tKLz21OTQg3PtTyUyQA=;
        b=g36VcM92VfzpT3mqa5iVGkBFp3I1yMXrTGIOJmDMvmLaiFkLtHZvlBrZXLWMlDChiK
         2oESVv60LotKdBZye2udkdY9tJD/A/XpU0NhTPEElHM5DXdBlbjmIIjjOZu6sj7Gct+M
         a6qPgYF/NYZmH4hY6yLBN/iWgocLPK89oIXqDLL7XjmR2xsx9a4L4AMhA79OelKeQ+Ib
         x7cJt2cPjgW2UJ3K75pWAbgUpSsZrFgSE/ZIhBztJEAVdvs2BQI93zluBLDcuN1uV8ve
         FIoXyYVL1ZxkOwzg+40jfoVs/2/RgGBqvWfWaDod7acZiYoCW8gb0B31KB5HnP4F9dkV
         ceVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KNzcwTVcOu0B+eitDszf9SY5tKLz21OTQg3PtTyUyQA=;
        b=7Tmga7tRovPTJ7dauo1BXKqqdRHQG8Lf1zth9gJrCYOpp4nNHxrwZWe8HDjfWeXOMZ
         5te5x3Gaq557me9eJmrYEvFxGid08Lih4GgUZC9CUQavmiJGRx3NWaWcUPlEDJy7e9nT
         3xerJzddVY2sbkGgNg/i7XsgEyE8nU1Q6L8eer26rj8uNU+FYRFUQK8CC2uUsyDuXfDv
         tX0v2Ntbxt+86PoHs0jF2989dTKfpgjOt561/ynp08GwF4b/mEoiu7wnY0fJ7+jc5dM7
         cgFMZmjWFjb+Mua649yHEWQGJwPr/ShuuqG+J572ivLdNsubzoGfyqPKzfFNjZsTKuUC
         Pj9Q==
X-Gm-Message-State: AOAM532ucMEiSdE7EUO2ktxr6xCdnelZIci1QvhmWyGnPHTMifr2uMVu
        CbvZ1r8P39NlG+8FYSpEPlXcf6N3QvwmYWrR
X-Google-Smtp-Source: ABdhPJxGc9VD5512yp+9c5S6Lr/8sZ8zp6c6uyrWO4R+WhLcgKXh2uPyl0o2EReJIZ9V/hOMo68Akg==
X-Received: by 2002:a17:902:c10c:b0:14a:8def:dc2f with SMTP id 12-20020a170902c10c00b0014a8defdc2fmr4869462pli.98.1642187345554;
        Fri, 14 Jan 2022 11:09:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ob12sm5768537pjb.17.2022.01.14.11.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 11:09:05 -0800 (PST)
Message-ID: <61e1ca51.1c69fb81.de22e.fb40@mx.google.com>
Date:   Fri, 14 Jan 2022 11:09:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.262-10-gc56e65e74670
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 121 runs,
 1 regressions (v4.14.262-10-gc56e65e74670)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 121 runs, 1 regressions (v4.14.262-10-gc56e6=
5e74670)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-10-gc56e65e74670/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-10-gc56e65e74670
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c56e65e746706ec1e6d526f5fe08e23991e64261 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e19a8238346eca12ef675e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-10-gc56e65e74670/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-10-gc56e65e74670/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e19a8238346ec=
a12ef6761
        failing since 11 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first =
fail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-14T15:44:53.556856  [   20.262969] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T15:44:53.569867  [   20.282775] smsc95xx v1.0.6
    2022-01-14T15:44:53.604903  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/96
    2022-01-14T15:44:53.613893  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-14T15:44:53.631184  [   20.337432] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
