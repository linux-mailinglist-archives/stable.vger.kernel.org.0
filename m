Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD94B4CD75F
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 16:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiCDPMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 10:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235400AbiCDPMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 10:12:12 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA7B1C2F5F
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 07:11:25 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id bd1so7951417plb.13
        for <stable@vger.kernel.org>; Fri, 04 Mar 2022 07:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t3gHzaXAKBn+dlAMZEX6uuPq2STkBXWMbJoj/NER0bI=;
        b=4/FSb0z4pfoM4zlxNlu0ycF2Fn8UoSY98kV0qmunh4zM/iUtpbSONCJjjbkKh6B/Xk
         U0yAa2Vu/YJj9MwlMATCd9t+JVO7jZw6D0s6wt8Sv76MUgaZgZBnaD2DiYMIjZJl6Hjs
         ST3bDoAAs3yd6p0w7aa7497sz0zJZ+7kvF39yTy4h4yJIzLjSU+cqXOE6DQkGhi9OTMG
         /YI5/rpmkfFMuEf0yHODuxcZ71mBgf4s5g/O9IFXe0Za1/c+DSRaK7TPuHwVAhCZvCSE
         QiSErhb68eSJR8sYeyKjNOrypDcB24KglUJ/54qEcWlC/Q8dkWFOR9Dz8U23xKD08D/E
         67FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t3gHzaXAKBn+dlAMZEX6uuPq2STkBXWMbJoj/NER0bI=;
        b=ustU45rd2VSftIwUwb4ZDt7he8UFkGrGEIiVx0iQnBoC1ht2GYi8JShTA26x2usDxJ
         cWnMfSoVKGy1nN112bwih74L02CILhj1Rf7Hib1o/I31e7uzTn5focWudnouvBOY2mKy
         pmICp2sQCGzd41JR0Ck1WW9vdYtvZRpyts4gYJG7Fj9YF8tn9UzHKUqx7CST6iKCrCsz
         NUve1N6SXAWXayxpEeDKJMmfF3kr5BYKbVabCJHt7VtRSsuYVRcBe86wjRg7uplzF1UF
         DS3HmFWSO6F2+FBZD9HPB8+KPZ6zD3KKOIrZh9Lno/NbCwjEfPfK9BvwM/ETcLuAoqLz
         PeNQ==
X-Gm-Message-State: AOAM532IvF69F6TGNEJ7wmNwnvGTwEh6pi8HYtPLRTvW3ZEshCiyQtVZ
        RDpcKew7A8EiL2PetKdjAjvEIRh86kRsB6hwbMM=
X-Google-Smtp-Source: ABdhPJyPl5sWJGKhuwHQjVKHa8fcxBw3U5UmheP1aWfmAntmYiISRnNpOgypwo/lLsQX/UAj8HaBvA==
X-Received: by 2002:a17:90b:2092:b0:1be:e373:2ed9 with SMTP id hb18-20020a17090b209200b001bee3732ed9mr11047349pjb.128.1646406684464;
        Fri, 04 Mar 2022 07:11:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8-20020a056a00070800b004e14ae3e8d7sm6219247pfl.164.2022.03.04.07.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 07:11:24 -0800 (PST)
Message-ID: <62222c1c.1c69fb81.3602b.031c@mx.google.com>
Date:   Fri, 04 Mar 2022 07:11:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.182
Subject: stable-rc/linux-5.4.y baseline: 83 runs, 2 regressions (v5.4.182)
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

stable-rc/linux-5.4.y baseline: 83 runs, 2 regressions (v5.4.182)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.182/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.182
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      866ae42cf4788c8b18de6bda0a522362702861d7 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6221f35acd3d3de766c62978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6221f35acd3d3de766c62=
979
        failing since 78 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6221f35b5d9fbccbc3c62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6221f35b5d9fbccbc3c62=
969
        failing since 78 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
