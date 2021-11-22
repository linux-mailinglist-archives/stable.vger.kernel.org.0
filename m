Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0CF458B0F
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 10:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbhKVJK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 04:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbhKVJK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 04:10:56 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2ABC061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 01:07:50 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id o14so13506375plg.5
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 01:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AuFREHxNj0yhDmN/RN2vFoiVhrWK5G3hkssN6u1SXM8=;
        b=QvpCdwygqVASyOvotcmxZ5Kbskv0q4ZQEejee/Z66Yu9w9CVKzM1kw4otCzAq6dJ92
         HZZAWlJADbGnNGQTJOQ8fBWfHnt9DBcCC6xUwWK6YRfgAQ8NSvF5HLNl8ZBDsndwde1A
         rLb4JspTrxR7NK6cs/0emZWrYIYtSU3N0JvzaEasvkzzWq8GFHHsHukzpj9+BNNI/hBL
         lN8SpuSM6qHXtwxkloYvPXe8+aF7r7utggjlMsKPV5W40zoDMtOZCqH+dRfwWx/u1iZJ
         yrH31LE/fhSKnll4A+SJEh+qSX0p5T5OroXBr/2dA6bX0Xpy2QFoGdPkOVpPbua58ECZ
         FoQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AuFREHxNj0yhDmN/RN2vFoiVhrWK5G3hkssN6u1SXM8=;
        b=XDKSLo5TumkG5g3wa4wa+Z/NHOzO7DccORrCGug/wQM+thD9UM07gA9CeaAUuH1Ce9
         h/qkc4nF/j3TdvEStqz1M7/fcuC0RJRicTbIObHHoh7nIN5oD90g9XbYy3iPcShdD9kI
         XqIWQn7MyTRF6/9DVLhOjVStsQb9kHv4Bt69wyxq46v1JnYTYyvCevADLqhoFSqkgcQg
         qxhSCsJ31XwsI8TAe84ZWNEa14/rHowX4NFN3SfWUe/OOpUzjOGiYiINBPuo+1/dtt6F
         wk92gRGoa12UKPM2x5NKbRn2IX46K/4o3N+kGrF7Dn1BxTUwt6pzp+D9QDLfuPONvger
         ua6A==
X-Gm-Message-State: AOAM530ol2lhtxw+4U8CANPD8NakjXGz6WCnckrNwW08mzy9BJhSRHnQ
        BjmPnGeBXnbErWxW1ldWeC62UAFd3vEUKB3I
X-Google-Smtp-Source: ABdhPJx2i4XcmMHEbXFB1Y81bGflKqlQAYJcpPAaZ+JgVM/sHu1hSOn2fksEtcargOQD1xonIDRw2Q==
X-Received: by 2002:a17:902:7595:b0:144:ce0e:d42 with SMTP id j21-20020a170902759500b00144ce0e0d42mr48322701pll.39.1637572069812;
        Mon, 22 Nov 2021 01:07:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9sm8894253pfm.127.2021.11.22.01.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 01:07:49 -0800 (PST)
Message-ID: <619b5de5.1c69fb81.95f4e.8b4d@mx.google.com>
Date:   Mon, 22 Nov 2021 01:07:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.290-189-gf792aae152288
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 130 runs,
 2 regressions (v4.9.290-189-gf792aae152288)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 130 runs, 2 regressions (v4.9.290-189-gf792aa=
e152288)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-189-gf792aae152288/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-189-gf792aae152288
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f792aae1522884ee163ad942e62d5f146c0adcc3 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/619b244ac504b38f77e551d6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
89-gf792aae152288/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
89-gf792aae152288/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619b244ac504b38=
f77e551dc
        failing since 0 day (last pass: v4.9.290-161-ge496b1c75ac2, first f=
ail: v4.9.290-161-g520a4edb46f8)
        2 lines

    2021-11-22T05:01:48.575680  [   20.565307] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-22T05:01:48.619139  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-11-22T05:01:48.628201  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/619b22e9abdd4fabd8e551d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
89-gf792aae152288/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
89-gf792aae152288/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619b22e9abdd4fabd8e55=
1d1
        new failure (last pass: v4.9.290-187-gc47222584eb6) =

 =20
