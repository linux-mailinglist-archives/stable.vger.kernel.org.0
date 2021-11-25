Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC945E1DD
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbhKYU7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242404AbhKYU5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 15:57:49 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F47C0613DD
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 12:51:55 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h24so5889601pjq.2
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 12:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0x/MErPl5BpD5Yo/YoUybjuK67H9BKxQ/f8YVTBtpYM=;
        b=5AsN6+UHEaeutyaiq9v5IUvOZUy4QWQoE0PGZxm6S3AubDa9amIcg9u19XZ6k2BgPS
         uBhHBaHxORVVi+IA84dY5CKVgsDKHie7rVpruWSIU9DcouWoysPIu0i7xVTEklHr77YH
         4PIoslGN91Z33Hmv6j+xVRFPmt68HiiX11Aqb2VkvTvT2MQxIAcKQw/1FhlGrvnhyC4S
         3va2XanGmw2I8fTuiCSi0rIh45MdinnoyPf6i2Mvo09UMRybk2Dap+r/dATrdUwZKjAT
         7fAlqPkdXBqMp7anpAF4fBjTeGy8+lRZpNSxAdOLxkCzWQ+aBy7uN3luSmeqimZHvwAU
         VETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0x/MErPl5BpD5Yo/YoUybjuK67H9BKxQ/f8YVTBtpYM=;
        b=MKqgjjYcMqlc8/hJaref5TmbyFhBcdr1ctPh3pGNkwp+lvwcaUTwwkrke6jb7p3kGq
         guLljD9O8MGQU1UfAQ6IL9R3rTslR5qpE57ChBxC3rg8bUlfxjCo2/T4NkoJMDxCHu/g
         PYSmtfeyWqVaawZ0BwxkGMQmRZDvIrIPazTC4Px+qjZp4r/WJrdBpVbgEy1vLMA2Zx0w
         NPa0aMEijZeV6ApmaPZYKBXAXJjq03wExdD3aF9NHGFtRQ9z8qV/5U14db8GsLsX615n
         IrTF/qbHGPW/KYbQ5raqgM3dHXeNYVedPD2nG7+4Sb9fHE9N7d0mWxCp2/tN33EYY7iu
         KWtw==
X-Gm-Message-State: AOAM532mNj8s8gv2B+KTTRtskXjjoYvIz142nOQmAHCjdQtfF9Ba/XZK
        J1JXKYmwNLC7qdsrU9mnAuwIWQkB6MIFDu1aG40=
X-Google-Smtp-Source: ABdhPJynZFpSj5LdHjgqACAOCUjPDlwWyXT0ZLaGSdAX3xNFR2werQCCnzXmOaG+S5LX4KvijHPpfg==
X-Received: by 2002:a17:90a:d3d2:: with SMTP id d18mr10363713pjw.158.1637873515052;
        Thu, 25 Nov 2021 12:51:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r21sm4016582pfh.128.2021.11.25.12.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 12:51:54 -0800 (PST)
Message-ID: <619ff76a.1c69fb81.748ff.b4a4@mx.google.com>
Date:   Thu, 25 Nov 2021 12:51:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217-320-g08d2d1cabf806
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 110 runs,
 1 regressions (v4.19.217-320-g08d2d1cabf806)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 110 runs, 1 regressions (v4.19.217-320-g08d2=
d1cabf806)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-320-g08d2d1cabf806/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-320-g08d2d1cabf806
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      08d2d1cabf806c310981ba92b2a873777893a18c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619fbc12ec67a4df81f2f028

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-320-g08d2d1cabf806/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-320-g08d2d1cabf806/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619fbc12ec67a4d=
f81f2f02b
        failing since 0 day (last pass: v4.19.217-320-gdc7db2be81d5, first =
fail: v4.19.217-320-ge8717633e0ba)
        2 lines

    2021-11-25T16:38:27.044373  <8>[   21.016357] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T16:38:27.095397  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-25T16:38:27.104788  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-25T16:38:27.124817  <8>[   21.092071] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-11-25T16:38:27.125332  + set +x   =

 =20
