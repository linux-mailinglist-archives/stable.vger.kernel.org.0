Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41F0673092
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 05:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjASEvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 23:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjASEuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 23:50:25 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD1D66EFB
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 20:44:38 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id v3so599504pgh.4
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 20:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VPsb4xDlL3oWN3VPa7y5KLra4iNTeDlYd6dc6q7Vr7c=;
        b=IztZo3GxLGtlVGSMU+jw1gZBt0d7UA8fcvyGk+TfISJTMl2asWoUdn9GnWDMZcjEYc
         SfgcxWF/inZ5ofI7sGwxQAODUPUshvjJhtTxwisgeSdTyIvYcHfE2tdMu+TwvZjLqmdt
         vyImTNw5+H1FLpQHflaXNL6AfAnCsreI5xOd4CtftjMcqce2J27hccewXOzsrXfbHNPF
         OwL97H7KDS7kP7KeVAQhg69g7wGjhn0kLxS3uVUcfIDl2qZqPLkr3tAKb7pCoyk+spsU
         H9DCTq9leXEGUDybtAIXQcfihUPoPdR6x11ODWkG8+1f9PRsXEwnZaYJ/cSooSMv/0Fv
         4W7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VPsb4xDlL3oWN3VPa7y5KLra4iNTeDlYd6dc6q7Vr7c=;
        b=ML6PFblMwTaSK/yQpFX6Ywq4iY8pVgJ/09VpLWw0Xiw9cNxiSlzmFs7nUDEmEVw7wy
         i80eK5oRmXQihGBs3oEWtO35QHDwg7sCVa0Xtq9iNCCTCmNouHFJbk0IqeAmR8slunrB
         hvXAU9YO9bbTocL8nbbVaW0jQC/vSJIENLNx0oyxb8jItDLHwAKJDX0S2zsN0GsjkzYV
         UoU1ncgGamL+/gmoQ37l0hfGwHldormfOcbyaW2wXTJ/PtPum29HWJZ05J+I+DLky2co
         cPKAeOQCFmKrnskikSqkd7by8lQCw1shLsRFAI0NkjFAj4xyaHaWQn6+W06h3nPa99aD
         PK5g==
X-Gm-Message-State: AFqh2koBFyWWYkIeGlfsA+MZAgCvjMgba1jnxrHLFZ6O/f2Ko/Wm99eU
        Ik9f/TJnBgwnyeXnepQJNgPuFMtR99mlPZ6yBIFyig==
X-Google-Smtp-Source: AMrXdXuJCJhmCRfp/z6XOANtz1zhr5gCSw36z2hei6eNI+irSqfNfQxHpU14ubzxj0iad3hAuIzWDw==
X-Received: by 2002:a62:1851:0:b0:581:95a7:d2f4 with SMTP id 78-20020a621851000000b0058195a7d2f4mr29752531pfy.9.1674103477732;
        Wed, 18 Jan 2023 20:44:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o193-20020a62cdca000000b0058d97f2ab31sm7403259pfg.184.2023.01.18.20.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 20:44:37 -0800 (PST)
Message-ID: <63c8cab5.620a0220.e94b7.c902@mx.google.com>
Date:   Wed, 18 Jan 2023 20:44:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.162-861-g1743de7fddb1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 154 runs,
 3 regressions (v5.10.162-861-g1743de7fddb1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 154 runs, 3 regressions (v5.10.162-861-g1743=
de7fddb1)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
beagle-xm                | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3      | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.162-861-g1743de7fddb1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.162-861-g1743de7fddb1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1743de7fddb1d3105caffb317776d25265d8dec0 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
beagle-xm                | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/63c897d54c073a0508915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-861-g1743de7fddb1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-861-g1743de7fddb1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c897d54c073a0508915=
ec1
        new failure (last pass: v5.10.162-851-g33a0798ae8e3) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/63c897f6649eb5b8cb915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-861-g1743de7fddb1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-861-g1743de7fddb1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c897f6649eb5b8cb915=
ecb
        new failure (last pass: v5.10.162-851-gae91cde757a0) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3      | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/63c897f85035b2905a915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-861-g1743de7fddb1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-861-g1743de7fddb1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c897f85035b2905a915=
ebe
        new failure (last pass: v5.10.162-851-gae91cde757a0) =

 =20
