Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905F33DC18B
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 01:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhG3X3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 19:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhG3X3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 19:29:22 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF01C0613C1
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 16:29:17 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id e21so12899288pla.5
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 16:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G+dpn48SU/oerz5B741EapZ9gptGQckzyZfO2rfCtuI=;
        b=N/bAeWrO+Z9taqk12aaHCUK7d8CoFvHhOcyjGhNMqYOq9uODD4UISpyR10a2dEBpRw
         QRMEmsEJZzjKlkEg3LsoDcshYKnmAyUv7UaYXO4uu5BhPnkeMs8RLtfePzauPN9JWJ3p
         0yuVs2hNbGsDdaBlpVYOHslJo7dT0VKnxMDGJYCXSnBW1RqFyJZL/GHLuPXuvCJOii7h
         35WJwCBWMXPYbhYnp1M3rrEsytdpXlUjdezSVkAjSoNMsoYMa3zt/uvQI7BX+kusE2nv
         mHspcGPiAylgozeyKuKRocB3aM1ba7ZvfivGwSOvSaeZc/5ba5Ab6YXV7Q1S2+hXIyW+
         rc3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G+dpn48SU/oerz5B741EapZ9gptGQckzyZfO2rfCtuI=;
        b=IO5pIIZLYq8KbZdqpZkXhJ9m37mwIAJ/vJ8jbueCAcaGqdZoxUjiBYJilgt6KkoggL
         nldmuDCHFBYapPSmLTsJKzpNtCqgiSaX9BCvEoYwrjQ8nWl1TuLIuISczsWxNJ/c4Lq9
         gY3wS4D2T8KEk3WAvGPFc10cqEoq/s5u8Y3L20utGmc9rMGxDQINMcQ7/52+2TG9silJ
         PqwyDQsOf0IzTv1QewHctG/w2x2Egb+GyuPaxr6TUQATUVTZNEB0NPG6OGnXbSvGUHmu
         Ugp8Gm6+ZdAUD7BqPqDluYRTvExY6CoN45muAgltGQNsjiIW6KZ0AltZ/1eVmxX3TuyG
         GHDQ==
X-Gm-Message-State: AOAM530PYcpqO314vBaUmkrkyKqLGT7d6Z4bjAuTp0NXHUJsMptAP1TG
        TbiVkp85felPWMfDQgvmrI1hRu/ugRavTNKA
X-Google-Smtp-Source: ABdhPJwdeW5uFy3lyyNRBJcvbVV0hQO6jTfiXER5fnW1rUe0iNgEFRi3G/4pd6emSPawgVsA+cVfgg==
X-Received: by 2002:a62:bd15:0:b029:31c:a584:5f97 with SMTP id a21-20020a62bd150000b029031ca5845f97mr5084447pff.33.1627687757097;
        Fri, 30 Jul 2021 16:29:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm3429402pfo.159.2021.07.30.16.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 16:29:16 -0700 (PDT)
Message-ID: <61048b4c.1c69fb81.e3084.9f6f@mx.google.com>
Date:   Fri, 30 Jul 2021 16:29:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.136-1-g73afab406b90
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 168 runs,
 1 regressions (v5.4.136-1-g73afab406b90)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 168 runs, 1 regressions (v5.4.136-1-g73afab40=
6b90)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
beaglebone-black | arm  | lab-cip | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.136-1-g73afab406b90/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.136-1-g73afab406b90
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      73afab406b90a31a91b0835f58b90e2a984e5573 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
beaglebone-black | arm  | lab-cip | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61045464fbf8ece76385f46c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.136-1=
-g73afab406b90/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-bla=
ck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.136-1=
-g73afab406b90/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-bla=
ck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61045464fbf8ece76385f=
46d
        new failure (last pass: v5.4.136-1-ga433f3f9d3c1) =

 =20
