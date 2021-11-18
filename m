Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C23455197
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 01:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241872AbhKRAU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 19:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241873AbhKRAUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 19:20:55 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3431CC061764
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 16:17:56 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r132so3685852pgr.9
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 16:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GX1ECmOQU+xK6FrgMAUfy/YgOOEnY71yUwxWRXI5MbA=;
        b=efWEcAlv9u0jFzB8RQIrVA3BSktJgK0NrYBWaq0VxJ0o2fB41ZALDGwcbtgNL08HGB
         mppe1oXdXa0KQAjwaoGHN5KCc9XrIwNbwzyvTyNyGpGGNqV0U9NMe4rAJuvc2JMl2YUe
         4NcHyxRBKxE5yv3g7snVi7ORNGt0KmISeVO4AsAmYbx6nnhGNLXCEtIxwrFj3alEFFKx
         JcXWmVMOZyMuoN/cJENuQzNdk+UcylfiqRI85BWjX38OyvYwUdbr1vdkQsBN23RbLmf/
         A6pySY7StauyQPTLJLB/YHEDhWn9eBmTRjbwW4qNqh6ExDSpYWjWTdkibnJUvdRk9ekZ
         YScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GX1ECmOQU+xK6FrgMAUfy/YgOOEnY71yUwxWRXI5MbA=;
        b=pq4sLYhQpnm9/O/hRCdpYQ/zDfsxvuAQ7JAlDqw5TcX1AI2zllzKQd6XYAP92AXZph
         ErelWdTxesUpQN5tCYBSu1AzN75/cLErh7UOTx4sA7zsKcwsLzCrxEJGswAfHJVgg/kT
         gz+HIHoysJRF8oumXp0FYHDkNbjERtCJ1CynVXKnOSO1TY/dJgtQnJbqU01SWu8yDkT6
         ZamabGwxztJVNmhkZv/EeTkI5cz3w1jaltI6GfOR9/1B/VzunDrratOS1+FPOGMZMwLf
         XVTKEbHpx2xKH8cFo8zSh9gX2oy9bPAYDsysNNsWR3NbZxWhD38APglm/XknMxG3Iqa5
         jw4Q==
X-Gm-Message-State: AOAM5338JPp1UUiRKpSfWCmjnYf42BlHWZ5iIogGihqyuivL+hoBq6R2
        yZv1SfED3+hJuhJbnmc8NtSjkpygEAkWsrPd
X-Google-Smtp-Source: ABdhPJwUJwQgzgomfSw7EWgxKT2bGU0KC303CuynPiqKoLRve5NAzgQB/T8wWtIsDFKWlcz4uYHo5g==
X-Received: by 2002:a63:83c2:: with SMTP id h185mr6484776pge.454.1637194675525;
        Wed, 17 Nov 2021 16:17:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1sm786099pfu.33.2021.11.17.16.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 16:17:55 -0800 (PST)
Message-ID: <61959bb3.1c69fb81.5b382.42a8@mx.google.com>
Date:   Wed, 17 Nov 2021 16:17:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-159-gc2e93e98e6478
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 111 runs,
 1 regressions (v4.9.290-159-gc2e93e98e6478)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 111 runs, 1 regressions (v4.9.290-159-gc2e93e=
98e6478)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-159-gc2e93e98e6478/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-159-gc2e93e98e6478
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2e93e98e6478cc8ffe1d23dd84aa904c368aa1d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619563857fc834801233592a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gc2e93e98e6478/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gc2e93e98e6478/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619563857fc8348=
01233592d
        failing since 0 day (last pass: v4.9.290-159-g2cf93eac9faed, first =
fail: v4.9.290-159-gb2c6c16b9d4a)
        2 lines

    2021-11-17T20:17:54.657365  [   20.094451] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-17T20:17:54.700326  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-11-17T20:17:54.709535  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
