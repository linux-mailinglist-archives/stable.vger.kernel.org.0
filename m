Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CBE445427
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 14:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhKDNpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 09:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKDNpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 09:45:11 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAF2C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 06:42:33 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t11so7220929plq.11
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 06:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CcJefVof6wQGJjT9BRnf+zWmUmlZJLJxm4ZDJB5ncF0=;
        b=cwVZXLGhhc8xVy76RjOwkKVWn9Wa6fG8xZqIdHjkZO4A4aCvuYaGu3D8Sh6mZlQn3t
         95LY6Rnn9gaceUD48jvLSJKGceG/hu2lzWfONYA8/A/tsBZNVUFoUiAlVOJLEAo49XjO
         mV4iAEPC/wgJE8cunCDBV0ZZ795+afu/scDDBzogBJKRWXBWD2h43EC860yhFwB94V60
         1JulqN9zsYTo1imjUzL9h9crpprNR0Hqv1VuidQfQM1p2Q3B+WNN7IEcoWxLzTdZ0dqr
         MPrzZ7t2A303BUcRzvGRbkFzFB5H2NE9ZeXNO4r7lS3qz9pObolK6Pu93rmGBF3Ig1fG
         WCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CcJefVof6wQGJjT9BRnf+zWmUmlZJLJxm4ZDJB5ncF0=;
        b=EMqxqKLWeeRiSQjCgzC283kt/85n5BUsG5SLB/99uPM3dyNlaHfjghkiL0xtCBVATc
         /7kqgG8vW9KuD9lKW+dNX8IOcg1e6jeAAXzlNZqKCJWLIYu/Qn4iuJM3sgYohcU+8Ss9
         PqLAkuBAsmfytDSvODfZAgC0Cv2X99TOatWAMKeZoCcXeKsTUaTRdgTWQF0vAjsCZNtY
         4Xu+7bvxeicKXp2Vih1f6SDXivkHv/ZVMb1DJE/PPEzgEFzZF9oF0qEnY9nDxFSFxelG
         ZIHPiDJyGlexDMbl2FokNtSpM1v6T6pS20erVUhXJ1ZPritUvoptoPM+FGdjyZwUkyiw
         XZAA==
X-Gm-Message-State: AOAM532sEkvuFnrxeADBCVoiOviXtoI7wOxg+j8JHUIFqldSXpOZxqSZ
        QlR03O5S3JeqffM1fS6WsHvROi8O3DQ2XOrq
X-Google-Smtp-Source: ABdhPJwy6DHdqhI1DtoCKdQKSXV0Ir/EXcMgGGcROMKKFvjpA8BrFjmlOKMS8TVMZ9BI5w8DSZEPFQ==
X-Received: by 2002:a17:903:1207:b0:13d:b9b1:ead7 with SMTP id l7-20020a170903120700b0013db9b1ead7mr44742090plh.63.1636033352610;
        Thu, 04 Nov 2021 06:42:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h186sm788832pfe.128.2021.11.04.06.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 06:42:32 -0700 (PDT)
Message-ID: <6183e348.1c69fb81.5e7d2.1e0b@mx.google.com>
Date:   Thu, 04 Nov 2021 06:42:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-4-g0189cadd4dee
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 134 runs,
 1 regressions (v4.9.289-4-g0189cadd4dee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 134 runs, 1 regressions (v4.9.289-4-g0189cadd=
4dee)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-4-g0189cadd4dee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-4-g0189cadd4dee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0189cadd4dee2b58a50f86095821b636fd98d1d6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6183b15f637de8089c3358ff

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-4=
-g0189cadd4dee/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-4=
-g0189cadd4dee/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6183b15f637de80=
89c335902
        failing since 3 days (last pass: v4.9.288-20-g1a0db32ed119, first f=
ail: v4.9.288-20-g7720b834ad25)
        2 lines

    2021-11-04T10:09:16.625726  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-11-04T10:09:16.634736  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-04T10:09:16.650019  [   20.236938] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
