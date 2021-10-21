Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648F0436E8B
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 01:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhJUXzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 19:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhJUXzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 19:55:41 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BA3C061764
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 16:53:24 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c29so2094376pfp.2
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 16:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QuwTT/tUbnP3LEpVRU8viguYPi6xOh4y5m/2l210IK4=;
        b=Afc5SzKMzT4qqmI0p2PTvwF26Q0glNEQdI7mwZH/NLqxQdMA4DxD3cqKVz6fRD2lYX
         ybZR3uxMsgBuqGnWMRRCe1CRJz7rRHJh/rdeBRXVJK65gtbk/hRKBnU/C5f3TuRfuLzc
         wiV2VKV/knYwACZDcW+sAt27mwVt26l4sfYXy/+P0YI53QUQ2b/B8jP6xMDYZhm/H3sA
         VlKoKNWvaqMzLgRF+lLaJAuJ+YQMUdF2j7iH1+NHJsxJ92aRYILUg7yTGZSM1uPA+kU2
         5bSrzBUQXEt3nBRuRmmObFv37IT0HgeclCDiLPGcYuSWatUdOB1mj7aGLT3mn8vbv49l
         wUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QuwTT/tUbnP3LEpVRU8viguYPi6xOh4y5m/2l210IK4=;
        b=Wi1bo/2s7Ls8O22wOJFyzC9C3B/U3FnwJBsM7nMyLJ6m++WN1cjED0e0fZux5z5hm9
         fm8/mK8muzSd2C7FDWcAhRZHu/2LyhR929LaK0xxPPtweofRRCe//jQorcR7QBT437gw
         npixRyoctD7pnAsYP+iePG2qZrt40wC4niK/7cDFnqSF+OMxiMpoFc5pCdGTUuhKeHom
         IMCBtA3+i6xU3CCSCvowBh34ast3w68YrbKomgJSmmB49TIf4akUqxN33Kg0qU/pRk55
         JlFEmW5/EKcwiKABznmAPjMc5zg6k/mIaWfOpsY0eFlMP3goqkCoE/1W2s16KFSdvzT4
         LLvw==
X-Gm-Message-State: AOAM532TlcF0qixJgZfH2kIibZA8JOHlEzxVRaNQZ3QesINQgdae7T4J
        AaP6LH3QwgrZ4sXuK1zNicIeyqqm6bXgW9Eq
X-Google-Smtp-Source: ABdhPJxeZc8Bl3jpMCCIxMBCcsTk3bGN64anlFh6nOE9ahhOZj9Quc+O7sgNLr7JdPmQK7L21rq4Hg==
X-Received: by 2002:a63:1d13:: with SMTP id d19mr6712577pgd.383.1634860403929;
        Thu, 21 Oct 2021 16:53:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv5sm8185468pjb.10.2021.10.21.16.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 16:53:23 -0700 (PDT)
Message-ID: <6171fd73.1c69fb81.315d6.5f24@mx.google.com>
Date:   Thu, 21 Oct 2021 16:53:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.289-23-g5001ce17ad59
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 101 runs,
 1 regressions (v4.4.289-23-g5001ce17ad59)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 101 runs, 1 regressions (v4.4.289-23-g5001ce1=
7ad59)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.289-23-g5001ce17ad59/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.289-23-g5001ce17ad59
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5001ce17ad591641a8eaca742c9efb4eb8068dd3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617107303fae505ef933590d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.289-2=
3-g5001ce17ad59/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.289-2=
3-g5001ce17ad59/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617107303fae505=
ef9335910
        new failure (last pass: v4.4.289-22-g983816d12029)
        2 lines

    2021-10-21T06:22:12.681589  [   19.176757] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-21T06:22:12.738314  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-10-21T06:22:12.741403  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
