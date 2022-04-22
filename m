Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA7A50C097
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 22:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiDVUDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 16:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiDVUDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 16:03:00 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208341749EE
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 12:49:44 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d15so13025284pll.10
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 12:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BoriRslxqM/fDbpXH/uLprf3jd3/41I/Fu6p1K4WSKI=;
        b=k4RK/yj3ScsPZoRWbiQy/BqYEZ4ANmznek6IhiEcL4gBC7s7evC6oJuBYR1Y81+EuE
         UavD+JzOfwO3CjTubqe/TaKaJVzRveLLYof+cfB+UpKc2DyQ9t2+qWhbGpSE5JYC+LnZ
         jvG6J/Gs89WgKZHZY7Q81AGaqtgP7KTpIJbVWLxZCtqOQulyuKyB8Gq5D2LmKMdWaOpB
         hOOnS0+j7hxSWAxDp5kfyjmjXuKHHBH8flFvVGMjjUniDvb/1PueTUlva4qxQykhf/j9
         6FKkG+H8tELy7RIvO6zfgTD8A0GRJvgzGktbgHN//EEYGC9fajxCGFbbTF5FQeMnQU0g
         z0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BoriRslxqM/fDbpXH/uLprf3jd3/41I/Fu6p1K4WSKI=;
        b=V5X72pbRgdjqEl1gkNJnRgj1LirB43Os5GN1bceo8IoOnKsLS0GNmD5ghRJ6CqlVGC
         z44zUhOZiocanBGzIcOVkFwuInZzCzcocI39ek/kAySJoezR4hwpiRph04JIZdEk9zbZ
         N8YqT9BQUHMydhAasH/QP6rtLcKnCyj32wlcg+C8IfSBFXwEWzGWQwMmUFQSa27L5iNR
         EkjvnqXMqP+PcUDo7NjvR1CxowL48CJF9XbF+8owfG/h0EiVV858L9LOZ0qkSXuML01q
         bS2fgGry3BP1iesNjgIvOpGT9NiWyi/RpFL5CwD933C61eCHTWcTCPIF8Qxbt5ZsJzXY
         cXCQ==
X-Gm-Message-State: AOAM531bZP+aKMj2A2ywHipRWE34cgKAf0js/YJ3sH6wM9EAi5yXasN8
        v1ZbBtlobqh9IhTLW9SCAyDrc3745JNVGVBKV5g=
X-Google-Smtp-Source: ABdhPJxuihRAH0EG+nnZJPTRS/tUB8Si21sThg40M5FY2U9SRKfWJj2fMEPKQeoKFdKGpxFYdeHlmw==
X-Received: by 2002:a17:902:8f81:b0:154:be2d:1948 with SMTP id z1-20020a1709028f8100b00154be2d1948mr6113352plo.110.1650656693926;
        Fri, 22 Apr 2022 12:44:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y190-20020a62cec7000000b0050adbfee09asm3415288pfg.187.2022.04.22.12.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 12:44:53 -0700 (PDT)
Message-ID: <626305b5.1c69fb81.bc62b.86fa@mx.google.com>
Date:   Fri, 22 Apr 2022 12:44:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.190-6-g063a41f44534
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 90 runs,
 2 regressions (v5.4.190-6-g063a41f44534)
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

stable-rc/queue/5.4 baseline: 90 runs, 2 regressions (v5.4.190-6-g063a41f44=
534)

Regressions Summary
-------------------

platform                 | arch | lab         | compiler | defconfig       =
   | regressions
-------------------------+------+-------------+----------+-----------------=
---+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie | gcc-10   | multi_v7_defconf=
ig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.190-6-g063a41f44534/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.190-6-g063a41f44534
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      063a41f44534da648461007b6360477c84db0703 =



Test Regressions
---------------- =



platform                 | arch | lab         | compiler | defconfig       =
   | regressions
-------------------------+------+-------------+----------+-----------------=
---+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6262e90e750c82350fff9459

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-6=
-g063a41f44534/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-6=
-g063a41f44534/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6262e90e750c82350fff9=
45a
        failing since 127 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab         | compiler | defconfig       =
   | regressions
-------------------------+------+-------------+----------+-----------------=
---+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6262e8fdc72640e303ff9480

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-6=
-g063a41f44534/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.190-6=
-g063a41f44534/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6262e8fdc72640e303ff9=
481
        failing since 127 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
