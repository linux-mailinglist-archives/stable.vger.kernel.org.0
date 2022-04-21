Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985B650ABF9
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 01:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiDUXd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 19:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349332AbiDUXd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 19:33:58 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FB23BFA4
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 16:31:01 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bg9so5913124pgb.9
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 16:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NIW58+28y1xGZnPJwX1OdFM3AGUlz61wvh/zO+Secuo=;
        b=z7a14KDhmV7AbET7Jeb9qaDHQDh5OKcpL1QJop1o56Q82fZ9qskIaz2+qgHaDpPbzD
         2fPlZOfD2CKFjoPYLTWE9jksJWXHnhd4HbhOyokv+y5Tr+7cCLjhdEYidIPN4e+20bG9
         sV0KICu+R0eoBYJZt/POp2hejC0up8G/wNUlleSTjW90xidYd4iKsKxNy5zaRDLCiNfg
         BA79rRpc/UL9f2h16DFSSRrAYjOFQ3hOQCREEe02QUMcBtmWJVgMdrdLyJtTsIjCDzm2
         aARUgMNNKVUNRXwSACqeEvARO21FpSjKDU7VutSQ6Xyz6bqHRVydgo6Rmk4E0NFll2nb
         yfag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NIW58+28y1xGZnPJwX1OdFM3AGUlz61wvh/zO+Secuo=;
        b=mwCCFaSfPfKTOBmOgqV8ohKk7foUcS2Ud0hRH9EJJLG+HnQLxjxDnsKroVw2ImJNN4
         itgKD7Tcx7hHFQOUXeNqGQZudnqiJvFFBh7rcRpbCuI1yY/j50ChuPhcE9uCMm+mOui6
         vLi4zafcytZ3vgM/tenn1W19X8jBEeGiEHD6QAW93EIx2FuVfbPW7NLz5HOq+p6TtZhn
         vAghZWoQLi5NTOdncjqkorASHXwCGCWv1EoPLo/oKjFL8U1xbknX+uLfAAMZEYztK87/
         c+u8VwCWZ/NcVNNDRMSNVjXURxOIoHHGSYXjwygkfl6ABAI9nXq62YCs1cEo+8c2+PnV
         aaJg==
X-Gm-Message-State: AOAM532R3CGJYUrJzO/fSlp4JlcqHSgp/A0KeyBasmKNoP/NdIcLRmEV
        u1ojFDAi/eVPiOy4ZqdyHkjQxd58bNYNrIevCi8=
X-Google-Smtp-Source: ABdhPJxP0K+aMDSFxZbu/vs82ZRUhHSg2YlGEbThMfCgX4kT04ukxPpjyCypf+nKfmH/VDoD8YGaTw==
X-Received: by 2002:a63:844a:0:b0:3aa:be8e:877c with SMTP id k71-20020a63844a000000b003aabe8e877cmr641590pgd.241.1650583861128;
        Thu, 21 Apr 2022 16:31:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fh14-20020a17090b034e00b001cd4989ff63sm3799234pjb.42.2022.04.21.16.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 16:31:00 -0700 (PDT)
Message-ID: <6261e934.1c69fb81.7ced6.a202@mx.google.com>
Date:   Thu, 21 Apr 2022 16:31:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.190-5-gfb99cd737c04
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 122 runs,
 4 regressions (v5.4.190-5-gfb99cd737c04)
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

stable-rc/queue/5.4 baseline: 122 runs, 4 regressions (v5.4.190-5-gfb99cd73=
7c04)

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
el/v5.4.190-5-gfb99cd737c04/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.190-5-gfb99cd737c04
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb99cd737c048fdf72a02c8ca35b483dce306924 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6261b5a2f8b877740eff946e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-5=
-gfb99cd737c04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-5=
-gfb99cd737c04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261b5a2f8b877740eff9=
46f
        failing since 126 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6261b34376d2398d54ff94cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-5=
-gfb99cd737c04/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-5=
-gfb99cd737c04/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261b34376d2398d54ff9=
4ce
        failing since 126 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6261b5a1f8b877740eff9468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-5=
-gfb99cd737c04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-5=
-gfb99cd737c04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261b5a1f8b877740eff9=
469
        failing since 126 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6261b33076d2398d54ff9459

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-5=
-gfb99cd737c04/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-5=
-gfb99cd737c04/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261b33076d2398d54ff9=
45a
        failing since 126 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
