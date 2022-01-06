Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11736486BFD
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 22:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244237AbiAFVh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 16:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244184AbiAFVh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 16:37:58 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD679C061245
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 13:37:58 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 200so3727094pgg.3
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 13:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tnQ52iDAYVElBSRIcSb1kevKDPg/I44RTUcLlxb5JwI=;
        b=qVe+RoR0O8teedlgvEhzr+ySPN3aO7vUMtyZNotdt9/Izqtty/iu/FYwfeSeVH/4bU
         mW8R/VZRdMLLXIsXmcSyx5t3oKzOMS7+ctcmurOt1ZXvbrOH6P3lH/occDv9Se7foCMf
         iTE7Iuq5PjAuSAoFowSyG+FO2pcqqAMDh+w0ha+KYi1zwpaGBh+FCNL7zPp6aUB3Curi
         qwTTy2oRa3OpfhPDBr8EbLAgd+98WJM6AU7JnXnfY00bRWI8+R/kusbuU2Pe3QiBVpo0
         Sgia1jWaS4tB0tXQl3Sx1jxaM3k6hfrVt78fu5ehJu0ciQUu+sSKW63sDQiHbIKnvqmE
         pdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tnQ52iDAYVElBSRIcSb1kevKDPg/I44RTUcLlxb5JwI=;
        b=zkI2P62xa4fXbFaMgKp2cgud2eBsq4NHHyQF/cNAJpJdedlLHJKsEPNUhdtooYUTBK
         GmyuypYd5m4o/EUGK4qr1cyAYfMra+B7JTZVz9tTVUP+gRTmLq5DB6hW6WA/SzCRRPZW
         z9raJbtSmu1sgkaEwUzklajD7mYkJYB/dfvKoDwKkreJZgm7qxsVaNJIDMkKLurnS63L
         7QglagG49FSgG8ed36CvvVhmHC+0+K4D6IV0I+jWmBL13ox2S0DZsSA72d7wPgVB/a+u
         mafvgG2jA4I2nzsRrX44CRQGG9TypwRXPo0hOSWZk/sQv3VYe3QsPO2JQER39t2riERO
         1jtw==
X-Gm-Message-State: AOAM533yi/gFQA8asa9ndWO5ASjecPND/JkCxlN8txzPQ0GKQuLQvrKp
        hkXBF7re8oWfOlxz2m6BELFpwqgljXoayLWt
X-Google-Smtp-Source: ABdhPJwXVHjFkm5GL0frwMIZsQnOP8erwaXVMkJ9jIUzB+oYOTzOvb6a+U1WnmVwb45+oIy73PLDNA==
X-Received: by 2002:a63:a552:: with SMTP id r18mr53887300pgu.288.1641505077888;
        Thu, 06 Jan 2022 13:37:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s14sm3932448pfk.171.2022.01.06.13.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 13:37:57 -0800 (PST)
Message-ID: <61d76135.1c69fb81.fe589.9b6b@mx.google.com>
Date:   Thu, 06 Jan 2022 13:37:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.298-2-g5f49da71474a
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 117 runs,
 1 regressions (v4.4.298-2-g5f49da71474a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 117 runs, 1 regressions (v4.4.298-2-g5f49da71=
474a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.298-2-g5f49da71474a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.298-2-g5f49da71474a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f49da71474acd65edc3812fc388faaebdcad24d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d730846a15eb1600ef673f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-2=
-g5f49da71474a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-2=
-g5f49da71474a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d730846a15eb1=
600ef6742
        failing since 16 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-06T18:09:53.389955  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/115
    2022-01-06T18:09:53.398743  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-06T18:09:53.415234  [   19.271392] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
