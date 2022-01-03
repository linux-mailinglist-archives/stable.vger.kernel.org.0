Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFC8482E69
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 07:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiACGNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 01:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiACGNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 01:13:23 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B885BC061761
        for <stable@vger.kernel.org>; Sun,  2 Jan 2022 22:13:23 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l16-20020a17090a409000b001b2e9628c9cso3475521pjg.4
        for <stable@vger.kernel.org>; Sun, 02 Jan 2022 22:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=597pxujH08nSXWcDYOObk3YiLuwn/VfHL4lfD6C+yu4=;
        b=B2b7RdRHCs+hG9zVzYz8dxFXgie0pxaL9brY0uAmJW9UMPcJxfwlzc9E08GNUjE3Yk
         IewNgZtXO9+tIP2D20KerTKvHPqvihs0pJL5PcjbqRs9AWuz2pcp2N0QlRO4dQ92odqU
         zZKtfb0C9R1VyOJ2dtrqF1yG5HjWrZpK5XBePs86IFaNaA1SqY8Hwcz+SBNbrNQoh8Hp
         gKffDFDgWV5MoAfmJ6TJ8OYEquS77VkLvOaIKh0Ua9c3NxZ8InruHM+htuOJdfpZXuo7
         ax5yafaVCJshtXkfLfEd+tVKKRXnlM/MtbKgICGUunFg3wRbstEzpaBbVbI4OaI9Cd7M
         d7GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=597pxujH08nSXWcDYOObk3YiLuwn/VfHL4lfD6C+yu4=;
        b=ftjtNyhWYU7Tvju7L3cFPyelkYH5xlUaVj08Jyz+TGyeJefDB9av01JoI0IX8QEVye
         /OWTOxObMzQspEpyVgfSDfdg8iLxKQAkdqhFjxiiTNDtkLU6gHdTn1CRnRZinkpuvn7w
         qUdemnjUm0WTYdyeF0Y8l6AMrZCNaBuglSJJcnkP50GWV4crbtBJIiW6GzYT8r/fbk9A
         jR43sV/sgBIKassn2c8bGTXNU52BkA2S79f9UJLSTdAU/mydWvyC8pLmbHhMKKCemX2X
         phxa1iUvj1E3+Zj4sidJXwvqLia3om2GTzvyc7lsOJVxwVru6dA5i6C/DwrmIEvgfjjY
         JpJA==
X-Gm-Message-State: AOAM531xK9OiTKhmGPFd7DG7MHy31yAcU9+qxMvmAuDN13N4B+Oj+lHU
        /0eUOd1q5rsHbRysyiR115Qan/IgE8L6DcF3
X-Google-Smtp-Source: ABdhPJyhGVAYsaAbvbHRzGAJh/MG3UhsKNA8VwamPqVg+ohCVS5Bt5cbl12/yaF8VPIwFsc720KaTw==
X-Received: by 2002:a17:902:7207:b0:149:aefd:c08a with SMTP id ba7-20020a170902720700b00149aefdc08amr10643818plb.67.1641190403172;
        Sun, 02 Jan 2022 22:13:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm38765644pfi.79.2022.01.02.22.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 22:13:22 -0800 (PST)
Message-ID: <61d29402.1c69fb81.b3a99.7317@mx.google.com>
Date:   Sun, 02 Jan 2022 22:13:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.297-3-gc49c8d9da3da
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 118 runs,
 1 regressions (v4.4.297-3-gc49c8d9da3da)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 118 runs, 1 regressions (v4.4.297-3-gc49c8d9d=
a3da)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.297-3-gc49c8d9da3da/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.297-3-gc49c8d9da3da
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c49c8d9da3da3f54a3b0eceda0efdc2d7bfe7aad =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d25f15f67df1fbbaef6763

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-3=
-gc49c8d9da3da/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-3=
-gc49c8d9da3da/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d25f15f67df1f=
bbaef6766
        failing since 13 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-03T02:27:13.140485  [   19.130859] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T02:27:13.191256  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2022-01-03T02:27:13.200594  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-03T02:27:13.220065  [   19.211822] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
