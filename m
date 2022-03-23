Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBEE4E534C
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 14:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239960AbiCWNkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 09:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243877AbiCWNkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 09:40:21 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96FD5E14E
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 06:38:51 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c23so1584744plo.0
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 06:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hf7S+9bZWiwolVzS+croouZAXD2qzGnrPDUMLgydcxo=;
        b=sp1Khn4A3iT0hEm+g9tvFr0gPjD58TBPsJdxLqaZRnlToAQJ5OZd8gosckaYwreLOE
         evANczyrhOQJNAkiKtGLnax9ILNg8C4v1BhxsECgxB56G+JGWPbvzD+O8DKxD0neqdDT
         P2S096z1uPggErXf151kU0WZ2IzWLGvWvIkq8s/AvfKSzv0W5DxA+sgywSKqvo73lJMd
         yvaBDIXMurRxcrvdlR+AuUV92Rkp2+FgGR2iGiVcjkJsuXGr5F9ywU5BH8cUGVMaaBJe
         hctiMvGAegFYt3nfE0EFbVyYYi4VXMP/eMqjbMz6yGNt0GMGAwCu2xFJ4+krj/WebCzs
         SjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hf7S+9bZWiwolVzS+croouZAXD2qzGnrPDUMLgydcxo=;
        b=uFX30j5yH5spaSZ7b5IBJ8ewNaaPKwpPFPXdYUqoVXUT9xWjA/+Pkk22Ni9wvPhJPX
         5UanoDwMii9YdSh9tfrBqlxrKk+4d35mVh8aQmBcg5+n8/ygHvXpzfFkAbZs+OnEpA5M
         pUj00PkfYqmsFFaWcWPsLhl+stHhkswi2bGpFHXJhH32MUxHYWfle9ti1k+7+2GbCS1t
         glj1bbrsInPncHD0k7YED/Vr0uj7gpRssDA/z33JeX1lTmw2T5R/UireL24s7zwB8omu
         gVD3L0TlZUiI0N41cHR4Hb8HtPTecQHTSIq7xDXVFAsd/zY58uOnaDtwvc/JNTEaJmPg
         ndlw==
X-Gm-Message-State: AOAM5307A3vg2eQDloq/kWTZjPxU3/wZtXHw/H61u66pEFM/hH+2q2Af
        yndQOOBl1xGS/mcSRAfWOhtDKla+U+QK3lNMfh0=
X-Google-Smtp-Source: ABdhPJzpD/hflHt3fDd8pyHeq+ESPWDfzVF2jp5W4INGVUgzn71PnfFCxm+EC77ct/7Cmg4OPrKZ2w==
X-Received: by 2002:a17:90a:2d0:b0:1bc:4fc0:6fb7 with SMTP id d16-20020a17090a02d000b001bc4fc06fb7mr12002347pjd.196.1648042731342;
        Wed, 23 Mar 2022 06:38:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004faaf897064sm16575pff.106.2022.03.23.06.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 06:38:51 -0700 (PDT)
Message-ID: <623b22eb.1c69fb81.28cae.00ac@mx.google.com>
Date:   Wed, 23 Mar 2022 06:38:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.187
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 66 runs, 2 regressions (v5.4.187)
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

stable/linux-5.4.y baseline: 66 runs, 2 regressions (v5.4.187)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.187/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.187
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      055c4cf7e6da13450016942e5286492b4a224868 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/623af2278e0e661742bd9217

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.187/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.187/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623af2278e0e661742bd9=
218
        failing since 95 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/623af29c87705c03bbbd91b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.187/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.187/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623af29c87705c03bbbd9=
1b3
        failing since 95 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
