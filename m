Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E3B4A9031
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 22:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbiBCVu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 16:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiBCVu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 16:50:26 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB2DC061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 13:50:26 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l24-20020a17090aec1800b001b55738f633so6534100pjy.1
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 13:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qXZzVq+y80oNaDKLFBGjl/y16xoC/zJdFL57KJZ6I5A=;
        b=kf0w09KyciSUQzoEcFN6Muk8jKQnzu7QxOgk85ZaVXn5V50daW1mUh3ppSE5KvGyzH
         cIAM85130ZgUv3J6oumj5QUuAhuo2CZ4Q/IYSgmkVJ28aU8ETsfzBUOi2ii8TJZ0vU/E
         gsXj2z62qIdBtJmQehvkVMrUMte90QHXM6co+fq8WQAAak3X/+Mbf3AG+3zSAwDXgO6S
         ChuxZOIJM5yPQOXvoWJQZ2yj221vs5jqBBT56xt5yHbUKAlcuHuvoZ/j3eBnQ7LjBg/8
         A1UT97rKbheYMCge3AF+vnWysgfQuAM4kaREMG5qiFtxIHUNAD7Pgn8dH506UUH2YiOf
         DoZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qXZzVq+y80oNaDKLFBGjl/y16xoC/zJdFL57KJZ6I5A=;
        b=SzF0spkbJJdxQSp6A8dQunnWe4PybZe7clvYsoil+GPASMkc3T6n68hK3QT9/ZKeuQ
         FlrYxdmLQnEEdD+at6bCeBndiVApFhRNNdHHNrOaoANkuZzAATvXCRszjN7/9hotGB71
         fIIRngrjgKoh+UTxuRASIlBTo8ZDrUTe6ZPAh5xu70YrW8keJUKKgk3YYaKZlludtFNl
         wWUGwsHrpmJFYpwU8t3JUFVKHQgAJ0IeiPiVNvRlT332FtrsuBuS0n8R0Hi8KfdtgW7L
         JCcmVpNug2oBzNX98DhnH9k6SGPguVhsUlQo3tAQnbpbVLRcB+d7HyKYeAbCle0khyIU
         0MmA==
X-Gm-Message-State: AOAM532nYi7uEhb1jB1aoA+fpMBUhGupXIsoDzwXjoTV+AwyolHsOAfb
        ByHOkKQBjEgOxt9ABRQxCtUBqedd+PvYmjUV
X-Google-Smtp-Source: ABdhPJy7bMTeruu+g8TWXaVifi2LuJ/rxu922vbvbaL/OFLgxAFWgHEwsCW98pqC1HwahYuyimO/oA==
X-Received: by 2002:a17:902:ced0:: with SMTP id d16mr67022plg.47.1643925025353;
        Thu, 03 Feb 2022 13:50:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s15sm30946845pfg.145.2022.02.03.13.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 13:50:25 -0800 (PST)
Message-ID: <61fc4e21.1c69fb81.4f4bd.0ee4@mx.google.com>
Date:   Thu, 03 Feb 2022 13:50:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-25-gd81b8d7bdc72
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 89 runs,
 1 regressions (v4.9.299-25-gd81b8d7bdc72)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 89 runs, 1 regressions (v4.9.299-25-gd81b8d7b=
dc72)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-25-gd81b8d7bdc72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-25-gd81b8d7bdc72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d81b8d7bdc723873e4eabe9bc884f5d92fea689f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fc14acf597525a365d6ee9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-2=
5-gd81b8d7bdc72/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-2=
5-gd81b8d7bdc72/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fc14acf597525=
a365d6eef
        failing since 1 day (last pass: v4.9.299-13-g3de150ae8483, first fa=
il: v4.9.299-25-g8ae76dc07a67)
        2 lines

    2022-02-03T17:44:41.877260  [   20.492309] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T17:44:41.928912  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2022-02-03T17:44:41.937766  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-03T17:44:41.958370  [   20.575012] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
