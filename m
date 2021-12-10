Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C13470502
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 16:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbhLJP7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 10:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbhLJP7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 10:59:49 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AEAC061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 07:56:14 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso9785198pji.0
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 07:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2yzulQgwhpacDJPVE2dpEhG8LOQmDAGqsg9fhwszxmY=;
        b=JVUjXz9UDYPPHCJCcggSRLVxyowKgYW4NlJbzU6HS4KKZNLAoLUdhKKi5nmc7+wSjg
         p24Ht5J60ktiKk1CMZSYxNyaKqx6V4P89XxqwKmnXvYkRi5hAWt7gGncjI4et3ACya5f
         CPJWheYUo1jCFH41ytfFO4f/dVCrRfOJI5HdiGcrkLJ9RQ5Ma5YgFhhfwnGCBIpIV+zi
         /9Xn421FsLQSUEcNaer9JjHuFBgG6WU6MDgtuNB0xa9rwDv97rsOyHGJHHYAyAnJH6eT
         AfwOjdgPGX8AL+FqhNtdeE/8NHsWU6jCNwD/nAz3iuzeqEnYAeC+bY06+/ibubqHj18v
         HbXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2yzulQgwhpacDJPVE2dpEhG8LOQmDAGqsg9fhwszxmY=;
        b=PBcD2KYH/HLPrpWE+cOq2pmkZHcY+lTTaaLVuXOsCPkNIB0o9U3Hj+ZIUIB0GS09BU
         sB3CTtXXOWpKhljTfZmsKYzwM5Y1UOiYJEYxroiOzx/rft7mbTHBXmJnmbHLDdVBlI0k
         xl75cSxUUyjPE/H+iHhSaUllN7M2uM2HgT6uSMW0dkjPWrLqI2GFg2bXXadmBbN6+o6p
         j5A70wugMxCxo8UEhPhTFAYs9kG2nYfdGvtpJre7dtjYu+WIDcev8Qt/oApCKfP0ay8W
         Pyf7F1uforXYWUyPMmjddSLqFyy4lfu5WEc85yTvjvurwdaN+kfV/gp3vSXDZZLGfD9V
         qrJQ==
X-Gm-Message-State: AOAM530nQUyRW+WoUCZ9BEV2p1apG6Y0YmRuxUd8iYddlAx1aWB5/0nj
        Drtdevpvp7HJ73QuE6V9+EcMuOgV55gC3MRK
X-Google-Smtp-Source: ABdhPJylIHaW542RL5QhHOtlfdWpkw3YAPPusk65LePQ1k1DRlSRdQ7MeTIOpb/SL4b99VYFFxON7A==
X-Received: by 2002:a17:902:9a4a:b0:146:8ce2:672 with SMTP id x10-20020a1709029a4a00b001468ce20672mr31596892plv.29.1639151773801;
        Fri, 10 Dec 2021 07:56:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2sm4103071pfv.198.2021.12.10.07.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 07:56:13 -0800 (PST)
Message-ID: <61b3789d.1c69fb81.39002.b977@mx.google.com>
Date:   Fri, 10 Dec 2021 07:56:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.294
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 134 runs, 1 regressions (v4.4.294)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 134 runs, 1 regressions (v4.4.294)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.294/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.294
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90b74a039f807b3ff911d886afe2645c4522542d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b347cb5182ee0017397123

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.294=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.294=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b347cb5182ee0=
017397126
        failing since 4 days (last pass: v4.4.293-32-g8d63932e73701, first =
fail: v4.4.293-49-ga70466410dce2)
        2 lines

    2021-12-10T12:27:35.756715  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-10T12:27:35.766261  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-10T12:27:35.781981  [   19.090515] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
