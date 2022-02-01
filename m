Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B6E4A5526
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 03:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiBACLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 21:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiBACLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 21:11:41 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C55C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 18:11:41 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d18so14196496plg.2
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 18:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OE/hmbYUiRzOEZOdiVxzZ63cg7adVlv7X9FtbP2QTts=;
        b=Ir+nVib2CfvDLT+s7jbbRu8x4A8C+BdSQnZXufXoksyS3aGloaROyMnCY8chujeg45
         fidad1mZV9zqWRboOo1UlDgXR20z+6BlLIkHB204umnTmWga8YqMYWCt8+t9hxahmuYg
         hCbVqzDKe+DVZ1wzVefqX0qp5/+hPEg3iCVK1kQ5Z3iLS7HqJ49lkgqMlLiFwAclUzx4
         /Ua7JGBbNo7RKvXso8Mowsqb2FkCUS42rx5fIUgy8t+CEeZ5V60P6XMVdyNKXlRcmgJE
         b7HxtscgJlay7HX2DAA7JL5PsFur9bDzlOoAuPlGmudz1VGAHOzOyBVXmS3iJks4EPhk
         awYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OE/hmbYUiRzOEZOdiVxzZ63cg7adVlv7X9FtbP2QTts=;
        b=UkN/7mL/Md+eUyKTVkHnyTifxnFAG3jgJ7UDkfpkKA1J2rBDIhqpAiYKoYsEu9rcst
         QtRziMu1o2sT+b3t+lhU5o/Fx43z5xsGdm3IGib+Jni3/A/M/v0AkvSdPFTFCFOK343X
         tQfb3zQ5bemNiT7MiuLH0RDO+16GV8PN0fYAMKWAncEBIUbOlJZa82v7u5z19+MhQFTf
         wMMxb2/DFXmFyIPKenZOlDI6njKmeuGbihBLAnVWk23DX1Q4Uh4F/IRhm7gYWAXYzU7v
         1ejOvDvyC6cdAWzsYTR64NCqP7KcE7M4Uac78X/IwtiqBSRaS9zQ2rF6c843L2mo7Iqs
         5xOA==
X-Gm-Message-State: AOAM533omlFCJTOx8Cu65C465Oic531nf5B6VQA+8ny6KITei81A8XGr
        kqIfEnx65IGisnVAIvm/l/J2SPzc61Ghhxya
X-Google-Smtp-Source: ABdhPJzDXqZ5qwtvO31r1EKmO2Jla8mE4OuHogHCfoVaYt7OaY+yiZKTgz60rhMQrkWhdt6sFmqdiA==
X-Received: by 2002:a17:90a:548:: with SMTP id h8mr6561614pjf.109.1643681500603;
        Mon, 31 Jan 2022 18:11:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s14sm19056929pfk.65.2022.01.31.18.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 18:11:40 -0800 (PST)
Message-ID: <61f896dc.1c69fb81.abe4.29c2@mx.google.com>
Date:   Mon, 31 Jan 2022 18:11:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-27-g83c2cbe7b956
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 82 runs,
 1 regressions (v4.9.299-27-g83c2cbe7b956)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 82 runs, 1 regressions (v4.9.299-27-g83c2cb=
e7b956)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.299-27-g83c2cbe7b956/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.299-27-g83c2cbe7b956
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      83c2cbe7b9564fe37c9314ef59e643716c83ffc9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f861824af87046fa5d6f05

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
-27-g83c2cbe7b956/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
-27-g83c2cbe7b956/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f861824af8704=
6fa5d6f0b
        failing since 28 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-01-31T22:23:43.418735  [   20.037536] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-31T22:23:43.461324  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2022-01-31T22:23:43.470470  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
