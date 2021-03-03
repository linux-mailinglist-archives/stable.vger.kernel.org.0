Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBCF32BC04
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240093AbhCCNgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhCCBVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 20:21:31 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA69C061797
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 17:07:39 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id r5so15033164pfh.13
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 17:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UtPTJu9DzGWRPlhJxlRr3reImhCPPHuiQo4nKwekrPA=;
        b=Lzx/9a4hvJTJ0u2NRjgg4dJZwxXpmK66jmq2snywYpKDBja9eQJ7KTWqzPBv4FS/Hm
         KZIsyWan8yk471LQF3HSMWZeILIS6dmqQFV6WQ9UK/WqDbm6o0d+2Xifm2HD/ZXqXDP5
         8uarTW7qHd/bW9ZhV+mPRemxVwWBTSBHsyC7FzKQT8/y8aGHo+kCSweDCdNwuP62M8Hl
         qpfA9m3m9qjDGdcnuW8vTWtr9aUetBMy7ub2dMM19HzfKYji4/0fAEeeSMaamMNOEkJs
         i8UApR30rrbF/gAm/tA+2Tmdi2U7UOoQhJZ5GrZ1oCNbLywyJVTvh46bem2o8g9JyX16
         wpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UtPTJu9DzGWRPlhJxlRr3reImhCPPHuiQo4nKwekrPA=;
        b=JRSl0kOOnC8DtfXXZYZs/uC9k+SfYTWSu322boeXTQHAKecKczYLGAtCChAWVQedPc
         40a79bKciCe7MLX1meCahAvJhBGsvh5qAfZYXKU1yMcAX8xjKlA6hv3TayTmVxDc20aU
         nuV1co/yAOXb+QblylnLOV0QowVg8yVEDSIC7kdBjnv+iOtAvDDMKi1KSgriePdBNUsh
         G9d/Y798/cEr4hxSY5BPtbcSC3Uf179x3dCIdHU4BoVDBvWT60fKjF6YcgwNPnRAuUzU
         QwFvzR4L/mh2xje62fXQXyeFV5hkEiRv/vyWEyvCFkQ5o3j4C9FBfXvSNps0Lq7up+U1
         uPFA==
X-Gm-Message-State: AOAM533Q5KGfb2qqOQvRy8T5Ikl7IvU9+5/v3ZTBClHBfFa6O6FB4Q3Z
        lQlpfU9u/+VyKSplAxlC8avfIww4SlS8FA==
X-Google-Smtp-Source: ABdhPJyBTe6qeKm4mWD4awsV7iXhSlcDYSMSfN9PY5nUfkJkBqVOIyfGllJAxWyNBJ6d52xF9tMVxA==
X-Received: by 2002:a63:1845:: with SMTP id 5mr20712161pgy.244.1614733658287;
        Tue, 02 Mar 2021 17:07:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o4sm22010925pfg.107.2021.03.02.17.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 17:07:37 -0800 (PST)
Message-ID: <603ee159.1c69fb81.aa406.2f51@mx.google.com>
Date:   Tue, 02 Mar 2021 17:07:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-247-g26e47b79f5ec2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 78 runs,
 3 regressions (v4.19.177-247-g26e47b79f5ec2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 78 runs, 3 regressions (v4.19.177-247-g26e=
47b79f5ec2)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.177-247-g26e47b79f5ec2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.177-247-g26e47b79f5ec2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      26e47b79f5ec2ea5c7a46e578dc0b46b9073effe =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603eae48138b28d2edaddd27

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-247-g26e47b79f5ec2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-247-g26e47b79f5ec2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603eae48138b28d=
2edaddd2c
        new failure (last pass: v4.19.177-248-gbe9fac34eff6)
        2 lines

    2021-03-02 21:29:39.863000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603eae0f08af596840addcd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-247-g26e47b79f5ec2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-247-g26e47b79f5ec2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603eae0f08af596840add=
cd7
        failing since 104 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603eadc4dd8317fe2daddcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-247-g26e47b79f5ec2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-247-g26e47b79f5ec2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603eadc4dd8317fe2dadd=
cca
        failing since 104 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
