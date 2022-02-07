Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DFF4ACC0F
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 23:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244589AbiBGWbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 17:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244594AbiBGWbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 17:31:06 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD92C043180
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 14:31:05 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso660846pjh.5
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 14:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CQLgJYFBUgzNHLq9my2d0GXBTpYrbGNEde4MII8lHM8=;
        b=MwQQcbLzHQYOhpFX44tyzC6WTDeLBB+Y8XgxyWMMqr5hhwazXxoubMlAclAlWSlgIc
         qFZwDcxT9czpZ0mC67wLTYbHpR1bYOljO8AXXdLWYWXuda1fx3DdcysWWIRQOnpI9KSv
         7iJQ7BhZs+gNyf81RbkJqguuKfCJo9ZqjZv2RhBNwWgy9bnbkEp7imLcXIreU4irG0ow
         vB6ccS9e/gfd7dCMyhySJhaX9rrG/PRgkKjX+2VGM+F4DAQQ8DHH8DkT2DPnFOHsdIUT
         EItc3bpe5KlHMS6Twn34ex6KFVDI+V++9kQzYVLtCgbNWhY0w0U4dcQVW5aK6mSwqgGD
         Yt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CQLgJYFBUgzNHLq9my2d0GXBTpYrbGNEde4MII8lHM8=;
        b=JACbfKeBulhJSK7qdgdNBsBLZil2s1phwoXuUHXiQD9pFmYyQFGI6805a2Ok2hZ5L3
         tHXekfXq/oECslZEtUkCf7Vf0uCjhlSWKMbORWmdlmJc4UQS8w3+WRvg4zL3EgDdl5J6
         twplsCGg/i0TpHmabh9NShFahXSOL9myH/y7ZYaLm1XxYb1coOYyB9TU69E1QEuBR259
         uk3nqfnOgXojYdXKhtyV7YLD2zkpZEKzEPQQmkeffY/X1UjoSOmkz1qWWKI0eLHTXjHA
         n0JSl/XZ/afCNngo7KQBD4F3+tD7Knfcp5lSbAY6XgNCa1iwVpGj24Z9hXP34pxSjvOm
         y1DQ==
X-Gm-Message-State: AOAM5339o4OrsTM4r5vrAMfNLOuVox0unK05eo4Gq5kMHBw8qWs6iDMx
        5lHdRkkUdt7aXsMJ36G+cwhqTC9J+oPNF6XE
X-Google-Smtp-Source: ABdhPJwENbYrpyFjGeKXTtHoENx5BubWu7OMtU5mGGYZMQu9d/PaQcTGXo4ev9pwrV62FdLESKPChQ==
X-Received: by 2002:a17:90a:9a7:: with SMTP id 36mr1168824pjo.154.1644273064725;
        Mon, 07 Feb 2022 14:31:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f5sm12836046pfc.0.2022.02.07.14.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:31:04 -0800 (PST)
Message-ID: <62019da8.1c69fb81.35e13.0902@mx.google.com>
Date:   Mon, 07 Feb 2022 14:31:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.177-44-g60a800bc1417
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 116 runs,
 4 regressions (v5.4.177-44-g60a800bc1417)
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

stable-rc/queue/5.4 baseline: 116 runs, 4 regressions (v5.4.177-44-g60a800b=
c1417)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.177-44-g60a800bc1417/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.177-44-g60a800bc1417
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      60a800bc1417d3c1fa943e947dce6db3af0b54cf =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6201649f045aed2e9b5d6f00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g60a800bc1417/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g60a800bc1417/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6201649f045aed2e9b5d6=
f01
        failing since 53 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/620164b8f5e5bc08935d6f0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g60a800bc1417/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g60a800bc1417/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620164b8f5e5bc08935d6=
f0e
        failing since 53 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/620164cbc71669eb0a5d6f3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g60a800bc1417/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g60a800bc1417/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620164cbc71669eb0a5d6=
f40
        failing since 53 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/620164bcb50a8b0b865d6ef0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g60a800bc1417/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g60a800bc1417/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620164bcb50a8b0b865d6=
ef1
        failing since 53 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
