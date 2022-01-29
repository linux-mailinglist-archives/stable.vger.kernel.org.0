Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8A24A30D2
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 17:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352815AbiA2Qva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 11:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiA2Qv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 11:51:29 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CA1C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 08:51:29 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o16-20020a17090aac1000b001b62f629953so6465451pjq.3
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 08:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=04m9tKpbcHvNXnJALj9qRitl5Fj/XsxpelB7BTHN8u4=;
        b=GnPjLu/Q3q2DTqqgsLJqXPmmpvyNfsaYpbrNb4PiD+EYHzkJ648pAYi87xuMU+xQ3h
         wNOylQxC04GpME19V1xMuwTBu79p2qX3q8c+oZWWdVY5M+SUMAsO2JItb1ani3KVUDBG
         OEdlgjhkxiC97CdJrF4S0fU5W1Z1WLprN/sycvjjDOkfWcJkUxmxlAT5BXnIJOBxYM3l
         dohiM4kp7tw0Voe3i7xb4Z1fuYh0hBZnnd7/ZOQBEIHNfHweGZiVrGBoCeIFGLn9lqpy
         SmoKHp2dUvP+bu30jJi6RTZLI7ygO2RM69EmY1UPh/zqkdSZEhC+OdcEZ36Rk4KmeGGH
         yYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=04m9tKpbcHvNXnJALj9qRitl5Fj/XsxpelB7BTHN8u4=;
        b=rQlMRmja2tjx3dN8ASn2V65VjCGaZ+Wv1xMIegB/K4BEe1onGWrnbJ12SPWE428UE8
         UeDujTG5/Fa35CUC54EpeD/ErQs0A+wmgk8tEU8tUUseLVHUvbPAT9ht/7vq62gccknl
         u4rRYvUwO7h0REjxLoOeAuH65CXpaMQjMsvRzqeXlP5RfCXWBeRx8zj+0KnhIod2xhpE
         KuyQW0uKayKo7YWo6RSr2+VmfpZK/h2x/GcyrqhMQMrQ6M4/fp/c6WCW2VCqWygmYTaP
         Gih7ZNsYqxb+tt9USAhJGmnevT6TEFreHZoIdeGQhPofbKCHqQ8QzDA3FFFOhANe9xBh
         87rA==
X-Gm-Message-State: AOAM533dONgN7mUMSchzMtb/bRTzdfb5K3TUSuqbS37Mh3OBB+IWcBxN
        BCHFMoXosO/ArD6bRUKFB2+D6JCB5a0SlKkb
X-Google-Smtp-Source: ABdhPJxshc4ZqMrXWh/lK0rH5/nWfgW3l7cFIAWF/uZzRMSi57oaAZPQ0iO0zpFf+WHNFOLOFyVj7Q==
X-Received: by 2002:a17:90a:eb10:: with SMTP id j16mr15795209pjz.27.1643475089081;
        Sat, 29 Jan 2022 08:51:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s14sm13789228pfk.174.2022.01.29.08.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 08:51:28 -0800 (PST)
Message-ID: <61f57090.1c69fb81.3816b.5606@mx.google.com>
Date:   Sat, 29 Jan 2022 08:51:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.301
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 122 runs, 2 regressions (v4.4.301)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 122 runs, 2 regressions (v4.4.301)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.301/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.301
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      26acbf7bad62c8236607a00747da2302e7e1bf29 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/61f53dec2e0292b956abbd46

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61f53dec2e0292b9=
56abbd4c
        new failure (last pass: v4.4.300-2-g187d7c3b8ca09)
        1 lines

    2022-01-29T13:15:09.685573  / # #
    2022-01-29T13:15:09.686364  =

    2022-01-29T13:15:09.789657  / # #
    2022-01-29T13:15:09.790297  =

    2022-01-29T13:15:09.891489  / # #export SHELL=3D/bin/sh
    2022-01-29T13:15:09.892052  =

    2022-01-29T13:15:09.993632  / # export SHELL=3D/bin/sh. /lava-1469096/e=
nvironment
    2022-01-29T13:15:09.994361  =

    2022-01-29T13:15:10.095904  / # . /lava-1469096/environment/lava-146909=
6/bin/lava-test-runner /lava-1469096/0
    2022-01-29T13:15:10.097681   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f53dec2e0292b=
956abbd4e
        new failure (last pass: v4.4.300-2-g187d7c3b8ca09)
        29 lines

    2022-01-29T13:15:10.559710  [   49.395599] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-29T13:15:10.611204  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-01-29T13:15:10.616981  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb934218)
    2022-01-29T13:15:10.621211  kern  :emerg : Stack: (0xcb935cf8 to 0xcb93=
6000)
    2022-01-29T13:15:10.629507  kern  :emerg : 5ce0:                       =
                                bf02bdc4 60000013
    2022-01-29T13:15:10.641227  kern  :emerg : 5d00: bf02bdc8 c06a[   49.47=
5280] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D29>   =

 =20
