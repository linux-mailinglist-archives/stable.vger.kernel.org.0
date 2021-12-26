Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2212B47F511
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 04:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhLZD6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 22:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhLZD6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Dec 2021 22:58:49 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2825C061401
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 19:58:48 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id i8so2204610pgt.13
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 19:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Hx/nzHyD7XeKe3dJVM9zLKnGgzPpkmN1ifpCk1KjdGA=;
        b=fhaSXV1OsEsuPiobnF1PLjc3FKUFatBJfpNowpQUAApcnHj792FafwWWsN4wtPliBe
         VT4jLTwCIB0TV2AGvASjChI6LLb2XMlB9StIASjK6fjWkkfdhOx3stRnk2ijQuDTVD8p
         huKVEOUx6o0ByofuMVfb0UmSd/50bC071gsbfULNvs0XndQko1wvINPu/2vg8ZDjKSq7
         KfyjEJgTOBZa3pf53EZhhi7njK4p9cTbUISv2Ed0iA+aXXHO6PpPIP4iDMFT/5OOWsSl
         zJ3/6XfjvlxXBaL1bLKhJP5bzfrLCctSQlA+7AXkcfpMRczjyiLVxtMLxldLxgaYU8Qe
         f0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Hx/nzHyD7XeKe3dJVM9zLKnGgzPpkmN1ifpCk1KjdGA=;
        b=K+G6p7RCAcR/eV+7ocj4u5qtioMnPfbxBK1+ER0I0tXzgSYwzFykarZDSEANELOILu
         my6ur1VkyPoXSmXmbin6s0PBBHhLqnDA4alxcYiP6/swEZasJ13gBgitxBJoJlh9SBTZ
         YdttJP3BpchSafpZLr2WKqqJobAw1jtr7R0Rauwmwo0FA2900boyi1ixcW0zdWyLTJ87
         snI3U1jEF+Kb3iJxsfeSpcOea2KPt0CY3W3eQYSofipgwgSUIivMWrhDqbWjwN65zRvu
         dRgKOHkYnS/MMIHkGcUdNFWZmw0dgPwh6Q76ThNMJfZTtx2kkeof3W1PU6YYOWYZq0Um
         Lqng==
X-Gm-Message-State: AOAM531/rG3oGNo8YeEZN8jkZleMXuWR2Lv2Ryfe0U6K+Y/f6D1WqSDu
        4gGZtU+c0UUkhl4azL/eLs5mPUwzH49AfX3E
X-Google-Smtp-Source: ABdhPJyF1dcKDy26xu8cHcmajH8BMIRgbNqDg8EVIftlmdi4PcbKGejHynnj9n3xOv7Jn8GrCu/PfQ==
X-Received: by 2002:a05:6a00:884:b0:49f:f5b4:5d17 with SMTP id q4-20020a056a00088400b0049ff5b45d17mr12560937pfj.55.1640491128112;
        Sat, 25 Dec 2021 19:58:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h17sm7796665pfv.217.2021.12.25.19.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 19:58:47 -0800 (PST)
Message-ID: <61c7e877.1c69fb81.f74c7.6e3a@mx.google.com>
Date:   Sat, 25 Dec 2021 19:58:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.259-13-g53632f774188
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 166 runs,
 2 regressions (v4.14.259-13-g53632f774188)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 166 runs, 2 regressions (v4.14.259-13-g53632=
f774188)

Regressions Summary
-------------------

platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
asus-C433TA-AJ0005-rammus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =

panda                     | arm    | lab-collabora | gcc-10   | omap2plus_d=
efconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.259-13-g53632f774188/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.259-13-g53632f774188
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      53632f7741886fc3068dde7a0a40a6b006c499fa =



Test Regressions
---------------- =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
asus-C433TA-AJ0005-rammus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c7b0aa421b426ec8397132

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.259=
-13-g53632f774188/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.259=
-13-g53632f774188/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c7b0aa421b426ec8397=
133
        new failure (last pass: v4.14.259-3-g939915040d24) =

 =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
panda                     | arm    | lab-collabora | gcc-10   | omap2plus_d=
efconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61c7b004ee670e8aba397140

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.259=
-13-g53632f774188/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.259=
-13-g53632f774188/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c7b004ee670e8=
aba397143
        failing since 3 days (last pass: v4.14.258-44-ge424e12a40b3, first =
fail: v4.14.259-3-g939915040d24)
        2 lines

    2021-12-25T23:57:42.272383  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-12-25T23:57:42.282025  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-25T23:57:42.297906  [   20.428222] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
