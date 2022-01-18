Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B67B492906
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 15:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbiARO7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 09:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbiARO7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 09:59:06 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B3BC06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 06:59:06 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id w204so13265449pfc.7
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 06:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5rH/VuHjyfKuReNNxZo7sufA1QB4WhBr/CVhPVfE4D4=;
        b=ZmC0ut0y6aX/Z8xwquZtYfwehWlCPTFpm33zhl9a9GKIdo9h3rvCH6fFg7V24kldbm
         fkXffaHD2D5fsRbD22amlcwIUQUZ9lE/0AXpmHII/FrboewPlSBn7kjPvsNlOVa+n9q3
         n614PLk4/ijHh9ipkqpRC9UG0TaEH06K8rPJLWGCw2ymrbkbDzvahe1wQ84YqdBqmcUD
         9S4hpwnTbOys2ohjALT6CLlJXVOdsTJEo9mwUdlTLT07uDe5IJNy/5SCsvdj5k9AfbZD
         cCCxFIiBaHuQY9asVegQwtA/Ofz4z/IMoCYkRVPrb+pua9Citxz4mkmmupgdkNRiDcWw
         td7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5rH/VuHjyfKuReNNxZo7sufA1QB4WhBr/CVhPVfE4D4=;
        b=Gp+6RLfN2AOvTuTB4i+JljI7c7ZhrhPqu85tiALf6qXLRMGm+Ag6Gv9j0P2PaDKrvR
         9lFGmD4YR9VKIQz+XnS4ZqSfqN8YvYCbMKMNGLVzcG8Y5SfQJhto9Btl7+dzDGh65adm
         qYeWQHf/dEXxQLcTZq3lSEWfLlthdnkSQfbNTEZC6F6aLNN9gsCg2DSlEPRHOqcWhgcu
         1XO8XTXiHD9/oJYvyKcsrlQyp8K5hdrFEV/59GCvdebbUEeOW3168bVQ/GZl5Uab6ezP
         6YgJnGDanjtuMvrLc0Fsw1zV1b/qDcA2w2Z5MDLIHM5jBQluXP0mCFhLZffa2FtRysfb
         BEgg==
X-Gm-Message-State: AOAM530OerLQb+T2hSJgoM3tKtZEKvGp+kEoh3JzEwSU4etUg+SDvkys
        cm8G72GwmIp/CYCbdyIb0hQqesvd4cFQLTYX
X-Google-Smtp-Source: ABdhPJxmMn5TIGDctGoS8x1V084IJewOGBeqChyzaA8ZvD870XPt/8GuR2+c9Ycc5ul2ONlQsgmvRg==
X-Received: by 2002:a63:e008:: with SMTP id e8mr9122780pgh.477.1642517945645;
        Tue, 18 Jan 2022 06:59:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pj10sm3032239pjb.5.2022.01.18.06.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 06:59:05 -0800 (PST)
Message-ID: <61e6d5b9.1c69fb81.5e7eb.7895@mx.google.com>
Date:   Tue, 18 Jan 2022 06:59:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225-21-gdb00189b94f1
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 163 runs,
 1 regressions (v4.19.225-21-gdb00189b94f1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 163 runs, 1 regressions (v4.19.225-21-gdb001=
89b94f1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-21-gdb00189b94f1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-21-gdb00189b94f1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db00189b94f184ddf0f8d44cdda029d12eb4cca5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e6a0747db3e93c1cef6769

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-21-gdb00189b94f1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-21-gdb00189b94f1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e6a0747db3e93=
c1cef676c
        failing since 5 days (last pass: v4.19.224-21-gaa8492ba4fad, first =
fail: v4.19.225)
        2 lines

    2022-01-18T11:11:32.983604  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2022-01-18T11:11:32.993170  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-18T11:11:33.010746  <8>[   21.308166] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
