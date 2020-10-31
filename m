Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B568A2A18AA
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 17:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgJaQHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 12:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbgJaQHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 12:07:21 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE92C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 09:07:21 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c20so7598024pfr.8
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 09:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JqMP1tQ8XgRDEfn/fOxaSAiNn4cQs6YR2W5AAHaw/B4=;
        b=FGJDq2R0pe15CC2m6tfvUPTR+ZSFLgs3lU1aatBNL4n55IXRHZ8xdWWelU63tH+g7M
         w0Us+vmvYweN/6pJEtXCOrxgfU9XUak32y0/QS8Ft/WaYC36/syUedMtDeAVa4j+Zx5x
         rquq0KK3ahwtcysYMTpJ68IEhKI7MRQSvLBZ7RQfIxYPQvIOXmoqOzlvfzpURKzmLXoM
         Zu/hlvRzhs3vv93BSs+RZQJw85vFAiDT53Bp5ZifX9rQ8DOarZCo9n3dbAo+fJ+TVnXA
         1nWrWFIFJweCldHAguPZ+HphgmQ5Yt0No66PlCkKticNAbkiaMjABPP/vMGq55J0CS0I
         mj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JqMP1tQ8XgRDEfn/fOxaSAiNn4cQs6YR2W5AAHaw/B4=;
        b=j7Qmi6KMrwZj1F8Ot385XkD65yxSq7nJNoTgqA84aGD47I1MbO1kMP478eW3SjGxBx
         mctFyxZMLgh66i7SXsHcgX9BNj/j2eKauTOFx5EMMlP45aelnM1huKeqWboQqJbdVKHk
         f/rxzT9yeJP9hEGJnMk+cggq5hx3vVrsWL/BLi3rSmiuOfLYnE77Xu7+vTDijytqQLLe
         xuo/q+DBvJvOgJqy94b9DFTiKjg7/H+/6Wus9N3CzeYBbOFeNETd5eQzE4tVNJUMEB3F
         qYdabSh85Ww/Derypl3+/pxemEMJ0/XUEKAMkxgXDR+15GmeyKXwbiasiO1E8kvs527s
         1wcw==
X-Gm-Message-State: AOAM533QtB4tN2Scbht3aYJ/MeZIY7OMTd+Gv1IUtTHmi3SwOUPtP3MS
        4a71mtvY6nSlpQdmq7vsu0Rt/FE7JUbEtw==
X-Google-Smtp-Source: ABdhPJxuXrVrNZhv0z9/o1Z3r/5x216ujVsGStfhL7c0+jNa++vFx5015CGB3XAJcgfgUFxO0IEtrA==
X-Received: by 2002:a63:6645:: with SMTP id a66mr6996834pgc.207.1604160440206;
        Sat, 31 Oct 2020 09:07:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y141sm8988709pfb.17.2020.10.31.09.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 09:07:19 -0700 (PDT)
Message-ID: <5f9d8bb7.1c69fb81.4674a.6120@mx.google.com>
Date:   Sat, 31 Oct 2020 09:07:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-12-gec2eae343a3d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 118 runs,
 1 regressions (v4.9.241-12-gec2eae343a3d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 118 runs, 1 regressions (v4.9.241-12-gec2ea=
e343a3d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.241-12-gec2eae343a3d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.241-12-gec2eae343a3d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec2eae343a3d08d8173b13295fdafd6d8ba96f62 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9d5acbb5b486dff93fe7fc

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
-12-gec2eae343a3d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
-12-gec2eae343a3d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d5acbb5b486d=
ff93fe803
        failing since 3 days (last pass: v4.9.240-15-g726ac45a50a6, first f=
ail: v4.9.240-140-g97bfc73b33b5)
        2 lines =

 =20
