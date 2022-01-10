Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E024898B0
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 13:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245530AbiAJMgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 07:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245525AbiAJMgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 07:36:11 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52520C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 04:36:11 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id n30-20020a17090a5aa100b001b2b6509685so15716287pji.3
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 04:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KBhEZpQ6hibdC0VvYKd2WvxrgZFOiO37bh9GMlOv2t0=;
        b=QXjN4SnF+aBhcxMPwPrbs/aK5bqVLPy6VvmuGD6sPsPVccrzQT01/DMPHlxNgwadt/
         /ArNKF88rS0B7h5jkAykvPzE1vpPaeYHu57QGdAoV4LWQ87eS6tPF9/egTtYGjV6Uj8j
         gPrpQ46zHHEmNOTP6SauTn59y5bbul3pKWBx3levnkgdSRl/r5n0Y3qPiDRz/eQH24YH
         mxv8sfEKkJrvjR7Z5uN7ufZFJjFH9v6cyojslgxXiAJgx3vuo7V/QtcdQdUtAMN/FA/c
         xPLs3uk5k9nWLvoQYlBxceFB5AAVNtKRB+i3BNHJlGEYthM9aZCqQ6BrgNEDaQyTSKO3
         IWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KBhEZpQ6hibdC0VvYKd2WvxrgZFOiO37bh9GMlOv2t0=;
        b=HNMvFp7Sss5TfzPGEIGq7ZTj0ZRgY8/RTjYKJP43LQo4LMmeRGL2mIM22pccz/Awvb
         Y3S95ou6h8FdHs2TvEOa+GdnGRrd2LztMyrwOnVWSgLsdWED4xk8qcDlTYfRcVxOw7EF
         sTTMhCvQYbbuRp8s+pvChI18G1Md85RAguX1yZL4YwMxmMMZ6Z+r4O1w2Gc/wYjcsIgD
         peaZbjIo7wkGu7Mp2n6TCCoGoBIhK7gKSboXTBsTw50vE2fCPStIW6vUJ5X4H84mqJl8
         /XOtHAcPtjvMJgkFLAE8cJyeIYsVsrhtaDdyZf8iZIJuEbM8m2whvKt1USll9ru6TX13
         kWzA==
X-Gm-Message-State: AOAM5323qlXg+VbTXRYeJOMt8wY+V11oJrLZzkxEmIZVe3dUebsicOZi
        vr6XKFGWDoQc0q+aA+6YbE7UoT1Z0IgV81sD
X-Google-Smtp-Source: ABdhPJy76F54ocK6NpIncv3DSlycTq6uHALLiF0qli0qa4/uftmOwfa0gfSndh6Nlu13336za62pSg==
X-Received: by 2002:a63:2cc9:: with SMTP id s192mr6858940pgs.241.1641818170760;
        Mon, 10 Jan 2022 04:36:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c124sm6708298pfb.139.2022.01.10.04.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 04:36:10 -0800 (PST)
Message-ID: <61dc283a.1c69fb81.a4b6c.0177@mx.google.com>
Date:   Mon, 10 Jan 2022 04:36:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261-23-ga751bd8de086
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 94 runs,
 1 regressions (v4.14.261-23-ga751bd8de086)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 94 runs, 1 regressions (v4.14.261-23-ga751=
bd8de086)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.261-23-ga751bd8de086/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.261-23-ga751bd8de086
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a751bd8de086600da0cc012daffcce7fe474cf5f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dbf46dbd2225674fef6795

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
61-23-ga751bd8de086/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
61-23-ga751bd8de086/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dbf46dbd22256=
74fef6798
        failing since 18 days (last pass: v4.14.258-46-g5b3e273408e5, first=
 fail: v4.14.259)
        2 lines

    2022-01-10T08:54:52.932905  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2022-01-10T08:54:52.942153  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-10T08:54:52.955251  [   19.946289] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
