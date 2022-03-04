Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585934CE003
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 23:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiCDWA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 17:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiCDWA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 17:00:57 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6252F27C7A3
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 14:00:09 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e13so8924251plh.3
        for <stable@vger.kernel.org>; Fri, 04 Mar 2022 14:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vVrEbKDjQHaO97dPP+5WW2jlD0al9iAZqfr+Ahnj9j0=;
        b=q+zlQCySjGXNO9cgIjUQQHDUGFvzL8N2377eOqF8MWrTQCNfDbijSQuKf9yUsXSifF
         U0CeOiH/ZrlTzY3AKxs83OQuVE1/Rn+CjXq1hLQkC3DuZHa7fwaGaa4bLvPJREUxY0lG
         l8jHsd+z1L2D4PPPJ69Mo67tu0oD2cVIx+zlboJEiVaNGdXccOi+AedynRVO5CGfvnkz
         rtY8U2lX69cuxRMhv+Q5ofAAn6lI0B0mgTcoaSPQrIvMIXci6gw24q+mF16W9Qzorw0v
         ZGQ41S6iCpkueJxHBVDwZSnzz+I31qwyw7f/JiKv5QYjFM/VIFYG4G55CeL/yXNnqD7e
         Ki9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vVrEbKDjQHaO97dPP+5WW2jlD0al9iAZqfr+Ahnj9j0=;
        b=PZNZp6r5qAu+Wzo+TwdCufG1nvZIQn+YZAdm5hbgx7bOHd7+n0pHJjzxTJTJar1HNA
         /WO1m+Scqzj+tmKD8xzfCK0piFTUZLtPRZivXBCCKpc3xZpIFJNPPSPgy/sQVA5iQLy2
         YGwhAsJpMklEBJr1qTQmbXluBMRtJQYkO/w4kqS3ZnOwvdVjfG4ZwJn9ZdsS/aTCsTZM
         hrkUnv6UdoFiOr/uUwxnymw+N3eWREhq5pzY6pw0I1W3jg68eNmxhTORhQ994CmOkPAK
         UZDOzUjpE8z+D+nVLfsaeKnPWmWb5fZP0arpQ6/b8g8ySyHppbPahGfaTFCDBKtoGere
         7lZA==
X-Gm-Message-State: AOAM531Evrl5ud0vD7xRP5+OCANNLStel42la3uux43Ae0RvRVXyFFL5
        GU8OnWpKPXBxdzi/gIxXV9nRBCB+aYlYr+QKF08=
X-Google-Smtp-Source: ABdhPJwHYmBfNemC+TQLWc/pO5P1e+rwLi/YzaKqqhtdHialRzMh3OyMc3oZD6rhaM4mCOQImH0TlQ==
X-Received: by 2002:a17:902:7c94:b0:14d:77d2:a72e with SMTP id y20-20020a1709027c9400b0014d77d2a72emr385714pll.153.1646431208752;
        Fri, 04 Mar 2022 14:00:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d3-20020a056a00244300b004bc9397d3d0sm6885725pfj.103.2022.03.04.14.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 14:00:08 -0800 (PST)
Message-ID: <62228be8.1c69fb81.1591d.2e48@mx.google.com>
Date:   Fri, 04 Mar 2022 14:00:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.182-14-gf7e6d607adee
Subject: stable-rc/queue/5.4 baseline: 87 runs,
 2 regressions (v5.4.182-14-gf7e6d607adee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 87 runs, 2 regressions (v5.4.182-14-gf7e6d607=
adee)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.182-14-gf7e6d607adee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.182-14-gf7e6d607adee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7e6d607adee40bda513d8c59635232a8dfbc69d =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/622258b439379db664c629db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-1=
4-gf7e6d607adee/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-1=
4-gf7e6d607adee/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622258b439379db664c62=
9dc
        failing since 78 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/622258b339379db664c629cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-1=
4-gf7e6d607adee/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-1=
4-gf7e6d607adee/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622258b339379db664c62=
9d0
        failing since 78 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
