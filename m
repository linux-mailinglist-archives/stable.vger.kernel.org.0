Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433F8468DB0
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 23:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbhLEWSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 17:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhLEWSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 17:18:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DA4C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 14:14:38 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so6793584pjb.5
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 14:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z4fK92H9VuA75IEG2yWfaEBN6vpKzvQ8hyB6ldQh3dk=;
        b=XAIemCSYlM66VBcl47s+GLrCqX8ynE2w3Sir17LUOAq3aZy6ki39txFNK5W9Uo915B
         tGEHANQc5J8YZIeNE9FwgIPayuy4UfJp5505AXTPpe/VO93SngeIYbqeIjYWLMVEzXy5
         LSmu0gD4mS+ZO5qbye0t+VpWFS3AkF1xdkh5NcqG0y5ov+6L0Q/xvmE/+mmvyJdTtXNS
         tVCaXml60Lb3FEa/YevJA4EQ1Z/cN3RT3HaLRBK6bj7/SAGq6sH9JCR5Qo4fb7rj71pL
         pSsLt9R4PZOXKjCkVoKus+mRL2zpZcCPULFLMRLZqfpzQtIhRmpWHSsr4AFevnKBnzKz
         zq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z4fK92H9VuA75IEG2yWfaEBN6vpKzvQ8hyB6ldQh3dk=;
        b=Rhos4cgJ1qSrqvcx9mTZymcsaY1BoxW+O2EPvMDFMe3rumsCnQpk5GtOdNxIp/RQ66
         3oNNqckuBnjSsda6hXdBPBkfS0zrx9Arhngu4MWRLvufB+wvGuljDFVeVhNwx4gMwhPI
         TVfo/qaNOvxfTnUYV90a+IWjho0PeLY7jJgwPRPy8zk5owH3fxbhXjXyTiDxAmeZ2BCu
         BL/S6mH/hikzw83eEY0gwMQdmXLbSU4vh1fKwwxoVVErhelaszG5I89Kjeb0mC6UIXwD
         cV9uewOiyE28EPL9qtwMUH9xYD6zpVEtIRdHrKaZAYos4PBHxaKRzAmP4tYWSUI+YpnM
         D+tA==
X-Gm-Message-State: AOAM533F6DT1hlHWRvR+nLQLbehftiLE+BRgF1P5Zgplt+r4YVAl3j5F
        +3vWytpkJH1YjctAVvC/Yoslc7dqBEbkYws6
X-Google-Smtp-Source: ABdhPJwmlN7ZeSJ62Ifpyqzy/xN32tleOxBtUjzjCB6ydil/6ktiHyGO2r/bbIYZaKgE1eKdBLVlZg==
X-Received: by 2002:a17:90a:2fc7:: with SMTP id n7mr32570593pjm.141.1638742476626;
        Sun, 05 Dec 2021 14:14:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t4sm10189581pfq.163.2021.12.05.14.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 14:14:36 -0800 (PST)
Message-ID: <61ad39cc.1c69fb81.722ee.d747@mx.google.com>
Date:   Sun, 05 Dec 2021 14:14:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219-36-gd334ce8fcda5
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 124 runs,
 1 regressions (v4.19.219-36-gd334ce8fcda5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 124 runs, 1 regressions (v4.19.219-36-gd334c=
e8fcda5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.219-36-gd334ce8fcda5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.219-36-gd334ce8fcda5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d334ce8fcda536a7c2c188ee1c9f092b8595ecf3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ad03efc590503e311a948c

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-36-gd334ce8fcda5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-36-gd334ce8fcda5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ad03efc590503=
e311a948f
        failing since 2 days (last pass: v4.19.219-3-g91f80b6b7a49a, first =
fail: v4.19.219-3-g04afdf3600b5e)
        2 lines

    2021-12-05T18:24:23.958565  <8>[   21.212432] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-05T18:24:24.003075  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-12-05T18:24:24.012574  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
