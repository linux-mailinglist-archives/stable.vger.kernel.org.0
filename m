Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3F04BEAF3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 20:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiBUSyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 13:54:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiBUSyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 13:54:10 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770CA111
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 10:53:46 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id d16so15023799pgd.9
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 10:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x7ZHQS03y6BFuD28U2O6bRmUZVQFQMWl/i6M98f8anI=;
        b=dL/xC3Qg+7o5PbDXjp+1Q9w5HDxcZqnYxWndJd3zu4Gs8urathwvWMcdHYpWbk+4dO
         nWwBgz1nrvZaRDDd7VKuD7Pzn50DL/tlrnihvv0LdzE7TMoVLlvPIYAR/FvRRQ8rqark
         xCOfNCb9kjhwOGFBNqVQMuq9T/mXZHZ0t4a4lO6LqMaubbbN7t7wd6pjJNxJxKu/uiIt
         jYoxjtg4QT4SmNiKLZHUQKzgBnjlORIvNZWYABwCuFIn5ZfBlzoGkyIQwdGOGig7goIP
         mXeHmspuG9x5yyer2uUhT5h7UR7wuxUYRowzUUtRLmHo/MGZ1wSjVCbJAnp9hpzMyU7S
         2khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x7ZHQS03y6BFuD28U2O6bRmUZVQFQMWl/i6M98f8anI=;
        b=kJZxp2okr5XUoYcx5efzSu2fB/cWH6Mdexh3290Y2FDoqy1iUB4WvUpgzT74gbTlty
         0BnxVvm0c5LK376UsMQahby5/MEFqzwa1sJjvZxjYN3tuSQey60mgsuwumFtZh2n1LUs
         GrOvTyj4F0XF/kB4IK4bQ97gvBq0a0jYIdYhOcuAPqNGHEGtt3AN+xLjFDg+kstDxTiv
         Xr6GZLXcHHKOsNkIslyt/JQp6OHLBnCZx053W4uUBHZ2PWCiRRIArMRJi2S2arsWJFUY
         TXkre/fZIys+73KGtvuzcWvpp+EuJD2lR7ZRkA/UqIDWWuCsuZnmh7p4z9/UU+3gDnlA
         RnSQ==
X-Gm-Message-State: AOAM533ijZndaFlJpqEpntX3mXcGf7Eq0C2TUUfx7U/4A8ndCWID8q2B
        CTqBuX09I7kjhdEkLJM+j96/F5HPO5KGK1WC
X-Google-Smtp-Source: ABdhPJyVayrK8zYhBddRGBHjJTw6FEiP6Ps2AkIpo5aDWNASSG51dJ9PSShpJNYiT21PKqV4Jc72bw==
X-Received: by 2002:a63:da4d:0:b0:36c:2302:1940 with SMTP id l13-20020a63da4d000000b0036c23021940mr17071997pgj.261.1645469625773;
        Mon, 21 Feb 2022 10:53:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o14sm8510463pfw.121.2022.02.21.10.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 10:53:45 -0800 (PST)
Message-ID: <6213dfb9.1c69fb81.14cb0.71c6@mx.google.com>
Date:   Mon, 21 Feb 2022 10:53:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.180-80-g88ee6ac23124
Subject: stable-rc/queue/5.4 baseline: 93 runs,
 2 regressions (v5.4.180-80-g88ee6ac23124)
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

stable-rc/queue/5.4 baseline: 93 runs, 2 regressions (v5.4.180-80-g88ee6ac2=
3124)

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
el/v5.4.180-80-g88ee6ac23124/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.180-80-g88ee6ac23124
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88ee6ac23124932f4ef910aff8d1a5ed3569b787 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6213a61e2f2031b3b5c6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-8=
0-g88ee6ac23124/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-8=
0-g88ee6ac23124/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6213a61e2f2031b3b5c62=
96b
        failing since 67 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6213a61c652cc61762c62985

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-8=
0-g88ee6ac23124/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-8=
0-g88ee6ac23124/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6213a61c652cc61762c62=
986
        failing since 67 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
