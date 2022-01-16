Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E9848FDA7
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 16:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbiAPPhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 10:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiAPPhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 10:37:03 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5833C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 07:37:03 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id u11so12583055plh.13
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 07:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=175LBNkKrygItWZmQGVMVVqsVSiu234+wcNZv/en37c=;
        b=feFx8wEvUE9JcK27m2XygxBvfL6NSjm64bAgJDpzIE1GRY7/yu601bxMtygr6MEhtd
         FEQUM/XxNRLqLsRoFaaT5msf7JY6CEBCSYBdE7H4fJrcCtm7FrgZ0oG2zIRVwHKHtTzZ
         4s4oY3oPDwABE0/WDuQPGDFGfm0sjggIZqVyxOfYciUKdF9mxJH6vFQhZiqHl4t7bHHJ
         Ti73+QJAIdHEtdC57YEhFoEv3IrYlHS24q6fa2h/Q0hCBLgVLkM7DpcLjirPwHSqIVz2
         za/bhkr5KjEdBweqc0UREMM4AABgIL9HMjY23Vi4fwJNwKOdCNsYrwkw6VnJltBCjjOQ
         NQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=175LBNkKrygItWZmQGVMVVqsVSiu234+wcNZv/en37c=;
        b=kbi9e6hGCfZeEUhsvUUVUMNo2H5EONLxDtfQ7uR9eIVSMDrv77h5F4F01eoFCKQw9U
         q96fOgDS4RfG46af5vPe67o7pqsghhvsCNLe0W3NRqjC2xYnEVNvLR0b+YMAlsKRq0ZP
         JAk4cigPapvlhXJhTcaEhLYiv8HCuV0r1uNXj4ARUL5C9UECmjzAARAmRSaLsxZFuuuo
         q9LdbQLMknySqB88J0KKRzWb7a6N8DL6iKm5OlYtZ/4xIh0sqBBqvAk+bIJNchMhMFcg
         PVOGUFg6f8t0M5jgGWZ8z9aEdT/9VvURshvCMs0qYzrCmTJUNxC0O2AU371uVTH9dTu2
         DUiA==
X-Gm-Message-State: AOAM5313N2wdxQJep4BsVrln/qt6AvJ1QCb9eXn3Y/6tvhA6W3kmw4xh
        ZGA7hr3rhemlYUiiM8oCmHY53hzzMelIAPev
X-Google-Smtp-Source: ABdhPJzfRpJG7FVnkJDApw5vsyV/BFybjpqlswB96A7mC4z8YdrxgMu6A9e1VoxwzQByeUQu5sQ1jA==
X-Received: by 2002:a17:902:6901:b0:149:4e89:2d45 with SMTP id j1-20020a170902690100b001494e892d45mr18129037plk.22.1642347422978;
        Sun, 16 Jan 2022 07:37:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t8sm11704855pfj.114.2022.01.16.07.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 07:37:02 -0800 (PST)
Message-ID: <61e43b9e.1c69fb81.e7779.0197@mx.google.com>
Date:   Sun, 16 Jan 2022 07:37:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 151 runs, 1 regressions (v4.9.297)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 151 runs, 1 regressions (v4.9.297)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.297/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.297
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d58193689d0deecd834a254892b4df49a723d54 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ddf260b155c4e407ef673d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ddf261b155c4e=
407ef6740
        failing since 8 days (last pass: v4.9.295, first fail: v4.9.295-14-=
g584e15b1cb05)
        2 lines

    2022-01-16T11:57:57.530660  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2022-01-16T11:57:57.539345  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
