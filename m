Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68974C069F
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 02:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiBWBGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 20:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbiBWBGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 20:06:05 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3562F37BEB
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 17:05:39 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v4so1241181pjh.2
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 17:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hw6ewzegKRISD9F/Uq2/lYQH9UhZHIrJvMUTk+7vjIk=;
        b=b2ApdbUlZ9uIHBTCuPXfNHKeJMgZ0sOOFAj8PF0vbf+nek3gx++N4jPgw6sKG31cQR
         3UU3OrzQTYB9f48/0B6IDToieNYujozcyia0eRagAe+g9q4j88L2vGnNROFizdTfmuJF
         NgSDKuLiN1jGZ5pxTg6bnqEaOBv3B2C9aM56s2j1ExNQ9vIpTEaCrwNKfR4RcENqO/k8
         D51Qd7njItOZgXYtt6RzhUfEgTmkRfuWvj4BYB1arTpd9zTEBaiAA4qr4fBe+NC+lcYi
         g9bOe31yBPkmnyYe0Gcs60TjWnOEk2ytOh1j08bqZHLI6eKxfS4iz+8U1zfEe5uwK6xl
         XieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hw6ewzegKRISD9F/Uq2/lYQH9UhZHIrJvMUTk+7vjIk=;
        b=yMCGXcRfdPPvcZMfHQPXtIgkLwnaRzn80++yJeleouYspCcUpGBR8YyPYg040/puNJ
         KjP7DHEOvIUr3RKz5ZjWh8YLeCe5y5xlre28xq7ZMSP2pP9ow/0DYLjBd7AtfGdOuKGk
         63wN4goG6NnBGsvRYJbphzhburGhRsyqRwGGz4Ynoxteh4R62D3IWPRWFvhs+AqPBGTe
         J6wCed/HwiOdkMEr13/omL6pUSyhu8z/P4+CYLSGdVgTHjzkiqkb4PZIB5vYeczMZByd
         i6Ox1U0SIel2ghNePih8wLqxBUWtvLyuBH+ENTgEQi6qi6tu4IDXySjYOSCUK2/clkDF
         vS9A==
X-Gm-Message-State: AOAM530m+gUlVTJCFvLj0Bd8YYcpj9/NShJD2j6B8E25DIaT4rP7LquX
        cM41GA1k529a566kjpdyukhXRKN1hH/NuaLP
X-Google-Smtp-Source: ABdhPJyclUr5mTQ7l0yuplBtRU2vIG6yidabdKMmWteLsw2P0TiHFKEeyJGLuarK17+KRBZ9nIBcrg==
X-Received: by 2002:a17:902:6b81:b0:14f:37e1:3940 with SMTP id p1-20020a1709026b8100b0014f37e13940mr25092491plk.115.1645578338536;
        Tue, 22 Feb 2022 17:05:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g12sm17608337pfm.119.2022.02.22.17.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 17:05:38 -0800 (PST)
Message-ID: <62158862.1c69fb81.0b97.1217@mx.google.com>
Date:   Tue, 22 Feb 2022 17:05:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.302-33-gc104fa3ed149
Subject: stable-rc/queue/4.9 baseline: 61 runs,
 1 regressions (v4.9.302-33-gc104fa3ed149)
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

stable-rc/queue/4.9 baseline: 61 runs, 1 regressions (v4.9.302-33-gc104fa3e=
d149)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.302-33-gc104fa3ed149/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.302-33-gc104fa3ed149
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c104fa3ed1496dbe545173edfe2432985be8c94b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/621550f5fcb48e8d24c6296a

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-3=
3-gc104fa3ed149/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-3=
3-gc104fa3ed149/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/621550f5fcb48e8=
d24c6296d
        failing since 1 day (last pass: v4.9.302-26-gf49b0aafd7d5, first fa=
il: v4.9.302-28-g96ac67c43b2b)
        2 lines

    2022-02-22T21:08:58.903808  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2022-02-22T21:08:58.913142  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
