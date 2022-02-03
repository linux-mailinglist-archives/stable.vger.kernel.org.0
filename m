Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19074A7C50
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 01:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiBCAHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 19:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbiBCAHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 19:07:17 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E06C061714
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 16:07:17 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id u130so738330pfc.2
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 16:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=su7nkR54pqNXXpVh7NVFXpWoQwXVvxTYkGIQE1HI2lM=;
        b=Tax8zrH8EhWmYIOpipTXwccG2FwM1vbiCVAMBAPRPh80IBmVyaD0Gfl0stxBNfbjo9
         hm1gClmX6bfErRpH16Anjat1/TuBXls/wSm5M4KMgPbOgkIwfkuY5UbvZ1xpaGzbNXAA
         utYz6bj6JhxhbdwAjFqls/Y4CBiKnqh/uLLC+ap0hGOJYnSSjs1cS4S8k02Ynhk/ElYW
         qerzgTPeb6ebWyzi8u62gDFApSxDYxH596Bxfy6rp2/9+PpWbYawRdzR494lTBQIUmdq
         yj1bOR0WzCFMNTBScpp5BotWPz3Mr2V4M14CuHP8Cw3Alugo+i+9S+3H6NvePySVsVCn
         F3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=su7nkR54pqNXXpVh7NVFXpWoQwXVvxTYkGIQE1HI2lM=;
        b=UzAPdll056PmucngYDuocU4LbIsOq4+Uo5WX9gLFaA2jzxLDWxKfJZrBUGeRiresd7
         kXnz4GsA48CtdEQe4GjJMP46OcYez9/1n+soL0Uxf/QM2PgwYN/H58ydnhEBVJrU7YE+
         wT1+TZm/l065rTv7xOgRQfy7W5Blkm/uA43QhfBqsHP9k3rLZuKALDibG0HdUcGdx3pD
         L2QqbXHkkBvlbEY+6yX0NvSgHwAJUlS8UwE7zuMbLvylb8CbIJ6YiPxujt/timcLuRWZ
         PNK0VEoSMifXMaBvjBe0sHUAfE/HZEimYo098TT5tob1gl1dPOlSpBxwxrpG5yEfwFOf
         2kyA==
X-Gm-Message-State: AOAM533U2m/BY09PBiFI6SbClyFSczUz/dMqIOVrl6W+ygNOG3bWcORz
        8gn4zP3NQmEPqbzZKHSLnX2HZ1TFqOJlq8xV
X-Google-Smtp-Source: ABdhPJxsaTZhV6W5w9qnMzP+5zBbe6mLOuPPj8nDzZxTMbDnEOc2eIJ8o8/eJOK+s4v8Pmn9cgZs6Q==
X-Received: by 2002:a65:4c87:: with SMTP id m7mr26193999pgt.509.1643846836724;
        Wed, 02 Feb 2022 16:07:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b22sm27866828pfl.121.2022.02.02.16.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 16:07:16 -0800 (PST)
Message-ID: <61fb1cb4.1c69fb81.15e45.806d@mx.google.com>
Date:   Wed, 02 Feb 2022 16:07:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-37-gd7a066ea05cf
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 154 runs,
 2 regressions (v4.14.264-37-gd7a066ea05cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 154 runs, 2 regressions (v4.14.264-37-gd7a06=
6ea05cf)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-37-gd7a066ea05cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-37-gd7a066ea05cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7a066ea05cf635a399edea1587406674265b25b =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61fae2e2fcca8c57c45d6f01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-gd7a066ea05cf/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-gd7a066ea05cf/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fae2e2fcca8c57c45d6=
f02
        new failure (last pass: v4.14.264-37-g2a37885a2c26) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61fae5668266d731d85d6f20

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-gd7a066ea05cf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-gd7a066ea05cf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fae5668266d73=
1d85d6f26
        failing since 1 day (last pass: v4.14.264-38-gda1a5053b8f1b, first =
fail: v4.14.264-37-g88d20e7b4411)
        2 lines

    2022-02-02T20:10:57.149008  [   20.100738] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-02T20:10:57.190701  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2022-02-02T20:10:57.199832  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
