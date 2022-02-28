Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFD84C7C44
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 22:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiB1Vmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 16:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiB1Vmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 16:42:51 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E7C14CC81
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 13:42:11 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gl14-20020a17090b120e00b001bc2182c3d5so377101pjb.1
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 13:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c8vNotG8mACcQtq8r87/e7EOLa8SVDPNJRjMOfPNz/k=;
        b=3VpRAmD4neMhPuGar+lZ/lZqIktGtkXnAgw6yH+WGUSksg22gdZ5e9Bhs243GAhUcr
         oCM6svCzn1vpsnGKT6n937Rtebop3qJ69DT5fDYtVwLAQOuc6kXL6uVFTSJ8kOI1EPTR
         JKX7kntnlM3Qy4N5vfEZV9kenynrcK69TRCB9NVqr/ykLG+e5UZsw+zw0RYwlA0yV2Dc
         6o9jeVCRIhofo61g0t11o6QRoqRmyrWdmQZ2nSvXclKprEzfVn2Oy28zZPtIw51iw59L
         gQ2SPctniuoq+0zr2pB47mkJuRZpVabPUeOP6PItR8nKMqEcANGwferZ/t5z6qXBOKqz
         a/gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c8vNotG8mACcQtq8r87/e7EOLa8SVDPNJRjMOfPNz/k=;
        b=Aq8GJ2REpAId/4tESVuUI41/x7FZO1MdYtLQBKtXMiw8TmKzKsKthCIa2DeE9QIpWQ
         SBhdBnuG58z3mC7XGyMUuyJvVny2Cs8Zc7dpU352tEozcPc3SNosNDSP83oHZrMC3iYA
         85nLDiKOvxFgwXKLk4guz0YXzAMCY5SGoeAl/69TwKohF4us9QvZxc3JAqKOHYSZ1XUL
         G6NjJ+deQ9MGNRdjGAb42a2pujuICvNubFCrqrVJxqGQxS59d+CjYVn7FnnOKsErVMvr
         gu2qISe3d9KUuZQxR8DM/y5YNLIxlC4tn6e4h8RWUEOO+NgIA9KdntthZXx72sXVH54b
         SrGQ==
X-Gm-Message-State: AOAM532DHNFK+/U/S9LN2APGY3yreEeI1nVgn8rbJq4lK5j9nWGfX3C5
        zcmaU020xilsajRPrlecZWAndwHYzI3GDrmzvuk=
X-Google-Smtp-Source: ABdhPJxMq8AufoQgc6T4auu3pDg5RuxkEc/Rezr3+HtexZD8inoHrMI/2t7kgCwFGMjahunrfH2nww==
X-Received: by 2002:a17:90b:10a:b0:1bd:260a:97f9 with SMTP id p10-20020a17090b010a00b001bd260a97f9mr11649493pjz.71.1646084531346;
        Mon, 28 Feb 2022 13:42:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g17-20020a62e311000000b004def1931fbcsm7136176pfh.63.2022.02.28.13.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 13:42:11 -0800 (PST)
Message-ID: <621d41b3.1c69fb81.51d5c.2401@mx.google.com>
Date:   Mon, 28 Feb 2022 13:42:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.181-53-g849778b22e77
Subject: stable-rc/queue/5.4 baseline: 102 runs,
 2 regressions (v5.4.181-53-g849778b22e77)
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

stable-rc/queue/5.4 baseline: 102 runs, 2 regressions (v5.4.181-53-g849778b=
22e77)

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
el/v5.4.181-53-g849778b22e77/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.181-53-g849778b22e77
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      849778b22e776edd70389db4d405ad9a39a66ec9 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/621d08db34e29b5694c62992

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-5=
3-g849778b22e77/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-5=
3-g849778b22e77/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621d08db34e29b5694c62=
993
        failing since 74 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/621d08dc34e29b5694c62995

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-5=
3-g849778b22e77/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-5=
3-g849778b22e77/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621d08dc34e29b5694c62=
996
        failing since 74 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
