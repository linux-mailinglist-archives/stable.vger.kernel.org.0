Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC444C216D
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 02:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiBXB5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 20:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiBXB5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 20:57:31 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236855F4EF
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 17:56:58 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id em10-20020a17090b014a00b001bc3071f921so4363478pjb.5
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 17:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rHSZeq9fuiFsMerjfyoHIICC0FcEQMM0ZOSIwqE1Wl8=;
        b=dbjEMRxnFqoQId0pLhXAu7bHjg2wF8jnUaTHrg/U6/g9jsPmyhygH68xee/8ES04ye
         zZfUGTrYaFMAfCWhL82ppM41vWEfyLaFWwcnpufMyUs8bqpmyQTYKTpeSM+k7FLyTun3
         VcG0DuGHwVhaQ+cnh3ZTjADpDQ0hNLghUGVIGcVZC4M7wqA+zv6T/kolkddUJS2ymV58
         jq3nvKM+aUNHl1RMkQB0302yDuJ2W8UocmzjOtYzFh8FTr1iNZJOdpM3Bxw+Jw7qfAH/
         uC42PmPMY7aUv8l17W3rMab+xgLztrk2S864T6u1i6H6+QGlIBYn3VBQ8uAiyK1EfgIe
         jPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rHSZeq9fuiFsMerjfyoHIICC0FcEQMM0ZOSIwqE1Wl8=;
        b=QwNFBCQ0uu5cJ3/KWpSsNPMoSI6HDIV8bebLHAe/X3Zj+w4AxWh29XNycRgJXRnx1x
         Ap64OFyRAlNp24rfIg9f5hNt0cJ/WwWcyNohbwczsnTwNHXEA058hxgt1gmxWPgkTQwU
         WPiUV8cKczCAUkvOuLWuWhraCwopDu3ZoThI46XQfrnq0XA6IzVNoEbG/GCb8bzGLxwX
         38A07dlQXkPMAi9xOg+MXN95sqS5ne4b/QCi4zCKre/9/3uNhTqsWoKq11GyWQEf5TVT
         wQ73hZFzykRxtbUhMMnzTNQx5EKbOk3RiDSEpn220KlTGaVSFeW8HVZ5yaXubtvYDmcx
         RTiQ==
X-Gm-Message-State: AOAM533RRsamvc7rwIY3OS3Q8bJ8f4EgH3m3DXO58Tl0FeXbKTOvz9UY
        +UmzZGIt6QEHiexlGgt3rphgt5Bwf4nzYbVEZ0c=
X-Google-Smtp-Source: ABdhPJzSefsG6NXy4CRdGI4BwPP9GXFnaNZgnWxtppIB+7pPU6aCHK5jID/cduvVD4QKKOxcaiiq/g==
X-Received: by 2002:a17:902:82cc:b0:14f:949b:5678 with SMTP id u12-20020a17090282cc00b0014f949b5678mr229919plz.141.1645663781574;
        Wed, 23 Feb 2022 16:49:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1sm721482pfs.112.2022.02.23.16.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 16:49:41 -0800 (PST)
Message-ID: <6216d625.1c69fb81.4d554.2dfc@mx.google.com>
Date:   Wed, 23 Feb 2022 16:49:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.181
Subject: stable/linux-5.4.y baseline: 106 runs, 2 regressions (v5.4.181)
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

stable/linux-5.4.y baseline: 106 runs, 2 regressions (v5.4.181)

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
v5.4.181/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.181
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b6e8856b8a5f7fb8b2fc10636aa05cffed1781b9 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62169d08e5e5caac95c6297d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.181/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.181/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62169d08e5e5caac95c62=
97e
        failing since 68 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62169ccc381d6d4df8c6297e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.181/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.181/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62169ccc381d6d4df8c62=
97f
        failing since 68 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
