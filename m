Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B73433EE1
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 21:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhJSTDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 15:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhJSTDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 15:03:11 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD659C06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 12:00:58 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c29so797640pfp.2
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 12:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YFGQRSAxUmv7EqWlH60Vm/UQ4fmzdXfLgvToOU53MX4=;
        b=IFo0YX1v9CsWz1PfFAzk9+KnsnxBU/rLri784LyBHAwMcn90UZ1j6+7m/Xfk4G8dvO
         zXwCCjhyFuIOHP378u4RJJ8hAdpA6YHRt91/Ox7dADeZsOQvXBu9MhkO5kDBVcZLxGkI
         WORcVMAtBIkOy7IkoC2UxtQdDwcp9/Kh4xdZgjvi6r2tM5LA0XZSCHUelcSJ5ZyZDhS2
         TkbQ7x9DVuCEcligSaQirotXHOBO7HoH4rMcN1MObX1KgJf3gk3gyb/OOhOmGULAgA55
         ngNY94LTmHI2zf0yVaYU5PE2QN915mP58b2m2A3hHtSUPhhcub9I3vTxLJOUMzGQ6Z+x
         ZCfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YFGQRSAxUmv7EqWlH60Vm/UQ4fmzdXfLgvToOU53MX4=;
        b=fydAIOsBQ8StlNiBWMK7Fq/BuDyqM6AmCgc2ctYDwBUkf48s9mzC1Xevle+M9ba/5L
         BPNI833ZsBEU4kHlrBeVN4RDi5Eh3/cJQekyc8yhEKWq5gIQs5HAHv4Jwd/7Idmr4fND
         Hi8/4n3LTw/4sZPcKHJdJd3Lpod74PzWXNIkCzs+Z6KO5Fb+Ste5ca2zv+yM4enbrRn1
         shUnGrVYS8sf/1A3QfOTgIVMY8c4OKB5UgTMgissqsoweW5IvwT9M9wfFUteFVrF0+8T
         yqX5MMrWg76qNd5vkFIlG9EvU/AzIeMHf7QpqaruvSnoFiprQWdQ9RMJgj5CthiEQK6S
         XDWA==
X-Gm-Message-State: AOAM532metnBUQ4JZ9QgFOOJi12GS+Be2BMb6txA+hCY7NIcJ7wWMMc0
        gWCOJqUt/eW/xsHBDf+ole/NMdmj3D0hOoTD
X-Google-Smtp-Source: ABdhPJzziqoqMIUiGW91bd8BbiPhokqQh9Iqq1cDVx/Fhq5KVRn/3IrafAeume+y14466YW/7cQjnQ==
X-Received: by 2002:a63:7b1e:: with SMTP id w30mr10623899pgc.464.1634670058109;
        Tue, 19 Oct 2021 12:00:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ls7sm3608543pjb.16.2021.10.19.12.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 12:00:57 -0700 (PDT)
Message-ID: <616f15e9.1c69fb81.4c7a6.a86d@mx.google.com>
Date:   Tue, 19 Oct 2021 12:00:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.211-62-g3bd5e36634ac
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 164 runs,
 1 regressions (v4.19.211-62-g3bd5e36634ac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 164 runs, 1 regressions (v4.19.211-62-g3bd5e=
36634ac)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.211-62-g3bd5e36634ac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.211-62-g3bd5e36634ac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3bd5e36634ac171953865c6e35b0cb44c464eb4f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/616edcded297dcaebb33592c

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-62-g3bd5e36634ac/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-62-g3bd5e36634ac/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616edcded297dca=
ebb33592f
        new failure (last pass: v4.19.211-62-gbf52fbbd32a0)
        2 lines

    2021-10-19T14:57:17.702287  <8>[   21.155120] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-19T14:57:17.745615  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/111
    2021-10-19T14:57:17.754963  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
