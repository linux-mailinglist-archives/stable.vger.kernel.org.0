Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC59B4C52B1
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 01:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbiBZA0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 19:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbiBZA0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 19:26:47 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DD4214F87
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 16:26:14 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id cp23-20020a17090afb9700b001bbfe0fbe94so6278943pjb.3
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 16:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wrxgcQ3yke/U9aSDdx00si5EuTzRwVFP9ellsjW+o9Y=;
        b=yLpOlHwRdH09ukULExfyXxSecNsqA8AdLUqx3/WAnoUP6ISg9sgPe0hCrm6aASNYRL
         0oKEvHo49rHdDvF5dMga0p3JuMSPaYHGKorEyY54uy5UaJ2LwaDaKL9TTcdIB8ggckJ5
         XRPdht7zC422h306ccuxJ5H7tQCf6o14WjmTMf/EfMMmhRBIEANZi4msNv3h1Z+DaXE4
         oxHZj96oe5SFB+DEzEPO8JFO/wZ3G2JXL8pigyjSsyr6m4ACQv/sRRLdU82QghhFPrul
         B+E4g36v0NGvoUC2gEN68JDm09fNuITdZDrADGxpq5QNk8pecu2VVQwJKbvrjcUeCzX2
         hXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wrxgcQ3yke/U9aSDdx00si5EuTzRwVFP9ellsjW+o9Y=;
        b=8PEoINtT0zjoCqJUrKhjb4H2UHQ/GJ02CJ60WJrwOU427ObVLtlfFRN85cOOGXqzd3
         Tv5JhxL2/GTRLTJ+kOKd/E+cP/P36uhlhWzGQncxgWLIKFIcUX96UzSjWW1TGzPBJPUm
         o3ZStfM8befNq38ZjYChH9HgiywKsla10DNSWMTMpNpZwi+7RBorj8xx9pDu++slSd1j
         BRWLRt79Y5usfw4QifPJfoJnIyMtJ5sbOgTq1WBhzu13Jfvy9od7seiF2mAeoT0xaR/1
         zmAIY4iT37zdYdDq76d5OgLeteipIbgVkpXQQv2E5Qpb0dwcQiVW1goLKKqIPE8ZrTOE
         gq1g==
X-Gm-Message-State: AOAM532EZgbd3Sgd8Oke3Gk5DkAxmSImyM4mF4KarGct4gWGUBoRh9pP
        vs1blcdePXy5pddSysOM+6nNRlOjSCK8ctw0zdU=
X-Google-Smtp-Source: ABdhPJw04pQn9emdCN6Nj9obMpH4O90KtZzPq7xXGdN2Swh3z8M0+RAKZzDu64F67E2H4/GZxJqXFg==
X-Received: by 2002:a17:903:1cf:b0:14f:ea85:4be7 with SMTP id e15-20020a17090301cf00b0014fea854be7mr9872643plh.10.1645835173578;
        Fri, 25 Feb 2022 16:26:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id qe14-20020a17090b4f8e00b001bc72ef1eb4sm3274237pjb.3.2022.02.25.16.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 16:26:13 -0800 (PST)
Message-ID: <621973a5.1c69fb81.99ef4.90fa@mx.google.com>
Date:   Fri, 25 Feb 2022 16:26:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.303-13-gc02d679f6f6c
Subject: stable-rc/queue/4.9 baseline: 57 runs,
 1 regressions (v4.9.303-13-gc02d679f6f6c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 57 runs, 1 regressions (v4.9.303-13-gc02d679f=
6f6c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.303-13-gc02d679f6f6c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.303-13-gc02d679f6f6c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c02d679f6f6c0952509477f7e6f709d468a2bd07 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62194147b0dc032061c62981

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.303-1=
3-gc02d679f6f6c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.303-1=
3-gc02d679f6f6c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62194147b0dc032=
061c62984
        new failure (last pass: v4.9.303-1-g1189e2c583a5)
        2 lines

    2022-02-25T20:51:00.022620  [   20.807220] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-25T20:51:00.065452  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/128
    2022-02-25T20:51:00.074914  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
