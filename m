Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FC649765C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 00:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240447AbiAWXkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 18:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiAWXkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 18:40:45 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3FCC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 15:40:45 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id a8so8850025pfa.6
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 15:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H3Y/XjPwka/paEq3c3S9irgAV1H59iW5aK+/5LCga5I=;
        b=6Miie054iJJxL5Rz+qkJCvDT7Tefpq+aGVT9aUknIWuS+YfUkT6HkaK4JmYgWueQNp
         PtBUxU8GBN2sJ7Grc5nxeGYPyqiI+m+39xd4B1XDRpMNVLW6cU0ZFZD3fNU46hFCXSZY
         RPgU5M+hRbcvT+RtwGMc/LzXJ8gaMYxxADdhf45oTV1FThCQ+OCt6h8wiWlxxJ7QWfMX
         o3Vb1WX73WObwlXW97rRM7e4d5FIO5a3jR0gH38fVy/MIZGPdS3V+padmhY8HhL/J24m
         v5YFAEcpbN4cuOXcggA9uTxUPCugESu+qJBu2C7o02pMEpp7AqJffTlcSPQ5ZT5Pm3IA
         /tVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H3Y/XjPwka/paEq3c3S9irgAV1H59iW5aK+/5LCga5I=;
        b=swBlAYjL0o/ECD0EgiD1MPho2hC4+Zhtq4gg5beHCvDT9UUEXJ6u++2+17Bde3ITId
         N30u5CKxBDaaL0gGWKkziioxiyxB1zw97F2+4yNzUTNrBx0z9v71HMwH9RsWH+/rTDIk
         MWLSzBfAcfpTGizkqnZyXoCaElMDuDNDI6d/71r/3dpPT36mJvwa0dG0Wjxka47nXdfF
         ueKXI7jB35KAjiBrXt/rdx1CS1PKuoFtlh3ugTsoFAqDQc9/EYiJYrAAEVEUbKKYe/uS
         fmaXDaizTbPhTWIk7/hL9rS0saL9oFTBH/i61+x0LjMo+1i+XVbgU+HU+T2CumzMmakA
         YlBQ==
X-Gm-Message-State: AOAM531ESL2lKPXf7AiBcCli2uzP6aNIbpY6LM59qOiNaj4T8O3Ejxna
        Ufb9WhdlNXCKGXXbDC5BeMZssMMgOhNsdYHE
X-Google-Smtp-Source: ABdhPJyc/O2XXMAb+LGwSjKYatQrAM63YUatt8m84UvDGdufm/jRhmynd/XShE8v9N8RvEFZ/sVBuA==
X-Received: by 2002:a63:6886:: with SMTP id d128mr9937106pgc.418.1642981244720;
        Sun, 23 Jan 2022 15:40:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h2sm14248129pfv.31.2022.01.23.15.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 15:40:44 -0800 (PST)
Message-ID: <61ede77c.1c69fb81.8d5a4.72ad@mx.google.com>
Date:   Sun, 23 Jan 2022 15:40:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-121-g25c9df465ed4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 139 runs,
 1 regressions (v4.9.297-121-g25c9df465ed4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 139 runs, 1 regressions (v4.9.297-121-g25c9df=
465ed4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-121-g25c9df465ed4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-121-g25c9df465ed4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25c9df465ed4c9d433aa835a7b7c116a4d891740 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61edace35d999a9902abbd15

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
21-g25c9df465ed4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
21-g25c9df465ed4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61edace35d999a9=
902abbd1b
        failing since 3 days (last pass: v4.9.297-12-g2155294a7be2, first f=
ail: v4.9.297-12-g4a79c59748ce)
        2 lines

    2022-01-23T19:30:22.142960  [   20.518981] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-23T19:30:22.192912  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2022-01-23T19:30:22.202186  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
