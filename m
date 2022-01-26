Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1366049CB59
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241642AbiAZNv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbiAZNvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:51:25 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9151CC06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 05:51:25 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so6169960pjb.1
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 05:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iBqT06IdUIPgk+4xU8w5UKz1KavbxAMQZN3UF6c6o1k=;
        b=tjmmZyrGZC7+i6Tf6QXogrJInWaile4edUX8b+bAHY6JVx8h1W1XI4i+AWPupoId0w
         Oryzuc1TZXZG73zEPV2iDAfMYMQT5Czxpoe82H3cnswbySt9fCm4xhGvxfQnLLBb7l/Q
         +Ze3npuEhgRx6r0B1z0y0KnK86ttCXEpm9q4sqIdZl1Z8xQmhdLoe4PCtiI0jt10lie5
         vEsPh76E8BYuLZKhqn9jhJUYajolQKQHPCmpD3i+YNM17iPHksvH/WvHqN9JmAE6zWIy
         FzK0Og5kM2vcSdubj59GBf60lSV+xqX4nC6/hUPald82Tm4dzekDyZIFaf7pWx3iQlJL
         eVpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iBqT06IdUIPgk+4xU8w5UKz1KavbxAMQZN3UF6c6o1k=;
        b=3SbMD9C71dX+/ZckrHIWHD8XW0evzIKuOPnHleBZB0ncYUBe0Q/ZfxJBsalBtezAgA
         7+Xy/wiKCg2QixYpLQeOTyMG9WxSeYoro/nGOtKvei2xyd8lT1ycjyze7jYkGEKDF+Pw
         RXK/38FjeWIqyNtTjf4e+ClGVMrr7XVPLr5Gxn5q3vmI6nwjSxRt4I4Cct2se8rRRJ+L
         NJDN6CMPnleF/1HOHU3qpt3HXAfknPABqWYtQYZR0Tx43AOLQ+fZ130PX7ls8pB31qvf
         E9eRPw1PSadCmHUrR/JVSnEcooY0vU8Gmmn3nVf0aLxkgyySPoHzvl8GjODrYQdHszFX
         MN/w==
X-Gm-Message-State: AOAM5337DOYmRM4czWnJpBNqdprCkKcB6Utc3HnZF85OUr7CiJBBMPtV
        n1XsoJbKysVXiLf7edH6a0Fg/lSKvBATT9UZ
X-Google-Smtp-Source: ABdhPJx+pMJW311kQrLFlNQWY/A/xkGGY5Q4kRIKh40fbkEaSuPZywTA9kX3vlTNZ/ctylI9Ut+SFw==
X-Received: by 2002:a17:90b:4d88:: with SMTP id oj8mr4829385pjb.206.1643205084917;
        Wed, 26 Jan 2022 05:51:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x12sm16997513pge.58.2022.01.26.05.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 05:51:24 -0800 (PST)
Message-ID: <61f151dc.1c69fb81.69cdb.ef05@mx.google.com>
Date:   Wed, 26 Jan 2022 05:51:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-183-g3312df9b4d8f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 153 runs,
 2 regressions (v4.14.262-183-g3312df9b4d8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 153 runs, 2 regressions (v4.14.262-183-g3312=
df9b4d8f)

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
nel/v4.14.262-183-g3312df9b4d8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-183-g3312df9b4d8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3312df9b4d8f47988f864e47e17f0eb8130d0aac =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61f14f651a1b7b3343abbd1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-183-g3312df9b4d8f/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-183-g3312df9b4d8f/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f14f651a1b7b3343abb=
d1e
        new failure (last pass: v4.14.262-184-gd0da567ac080) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61f11f53820541ad5fabbd4c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-183-g3312df9b4d8f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-183-g3312df9b4d8f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f11f53820541a=
d5fabbd52
        failing since 2 days (last pass: v4.14.262-15-g1464c5d2671d, first =
fail: v4.14.262-153-g395d30f2bc10)
        2 lines

    2022-01-26T10:15:29.102705  [   20.036254] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-26T10:15:29.146034  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-01-26T10:15:29.155880  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
