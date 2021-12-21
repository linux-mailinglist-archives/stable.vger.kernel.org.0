Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E678F47B845
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhLUCMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhLUCME (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:12:04 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADFCC061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 18:12:03 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id g2so8389852pgo.9
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 18:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RXa7NLMGLK0rTB/xzS23+5/4SaFsAqv+MReYEIQCbJ0=;
        b=kBTCQlm6LbTvUqx3Dab6i177QmBU+WXsHIaXl/Uju5p5WBQ5tlTvp0MxLLCkEfhrhW
         mIpeBmLiC2pkA7Q4LKMLfi3sYwLunn7lvDmU0O7Dd4rrUqfglwTYuZVP6QMemqYqoKs2
         m7ZWZrisWMayxgJUo8gSbl1IR14i6MzXioVwqIsC3X5nhFDzmKpJCQfGHokssBBxylhE
         KJRnBo72hdJaaOYImHWRmyHSco5/HbpJIZ0Aewqnpa3B8MrsY3I4LM27067Iryl6U6bQ
         ZRjWkM7+pqywfP1sGRB+r3tQgLTUjm6aoNtfUZgAxnqwYwQSRNZIUV6X7Tcm/xY9TC3u
         8duQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RXa7NLMGLK0rTB/xzS23+5/4SaFsAqv+MReYEIQCbJ0=;
        b=PP6vUfNNjjehxHUBXlZM7Y6uOr/B8qXbR2905ckRTqhiYIpsLU6gBW0uhADVRARioa
         /9W4t1LGyqA93wtECxyXWd/CYzDCyMCTilTRu+DuzshQScbjSH1fUFI0N5E/W1FrkQkz
         0eMKzt/2/MDAoGg4ZIzhGeCU3wo2PAL9IXiqzm1M8KhGP7jyFkRMty59s5xeUKAQx8Ak
         DvT+lj8c4447zW4tfQrjLmAsKZdYdgSz8Xtwf0VSi0TIGRVCFjiOYC1Va36eg7ZdnXTD
         y/XzYTMK2qgxjtqT49OYCRF/Dly55Vd8q/NtaFP2UOVEG+00E+vHqxxeN+1lQKcG/yGk
         AFGg==
X-Gm-Message-State: AOAM53322pPvBPbCnLiMF7wK8TCEfu9JCAbnRmtHhwweaKr2ynFKw5ey
        4kOnYAck+GcSCQ1Kv3b3H0kMXjzGGGKZKDbI
X-Google-Smtp-Source: ABdhPJxujYuMJ9pJSWONRxX3wjf8nMJLbLrZnzNJfZlPQffYNztuEuBHM4fQb59x4wn1laibc92dPw==
X-Received: by 2002:a63:904b:: with SMTP id a72mr920079pge.28.1640052723043;
        Mon, 20 Dec 2021 18:12:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v12sm18250528pga.51.2021.12.20.18.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 18:12:02 -0800 (PST)
Message-ID: <61c137f2.1c69fb81.da87f.2e1b@mx.google.com>
Date:   Mon, 20 Dec 2021 18:12:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-23-gcec9bc2aa5d3
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 104 runs,
 2 regressions (v4.4.295-23-gcec9bc2aa5d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 104 runs, 2 regressions (v4.4.295-23-gcec9bc2=
aa5d3)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-23-gcec9bc2aa5d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-23-gcec9bc2aa5d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cec9bc2aa5d3a7d067b2af0927e41f41905492c9 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c10392f517e408d2397198

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-2=
3-gcec9bc2aa5d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-2=
3-gcec9bc2aa5d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c10392f517e408d2397=
199
        failing since 0 day (last pass: v4.4.295-11-g16c28781820e, first fa=
il: v4.4.295-12-gd8298cd08f0d) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61c102c389a209db7339713b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-2=
3-gcec9bc2aa5d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-2=
3-gcec9bc2aa5d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c102c389a209d=
b7339713e
        new failure (last pass: v4.4.295-12-gd8298cd08f0d)
        2 lines

    2021-12-20T22:24:47.296005  [   19.286254] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-20T22:24:47.345843  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-12-20T22:24:47.355244  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
