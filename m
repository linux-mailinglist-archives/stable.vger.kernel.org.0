Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BBB4885EB
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 21:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbiAHUdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 15:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiAHUdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 15:33:54 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18014C06173F
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 12:33:54 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id ie13so9421592pjb.1
        for <stable@vger.kernel.org>; Sat, 08 Jan 2022 12:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+R1gJDlGRuZ6J+BYagJHAqE1ZTTL8x2mmShhv+OCHzY=;
        b=ggXrZoYCw3TSn7QZFaWyzAuz0U5hfsVnOOg3MwcTXUL7itwso7nXpPpaPnODY0GzWe
         3IzvAfRuKNAwXhKF3QIsvOygwYi1E7cp8l0FYQkdboEHL0j3uB00lbUVmEeU6iMVVo+x
         J+XhwfqdxRjz0ntIGwAqEi9m9c2gZ373I1fkHPzKsrsP7+Aa5h2dBi135G6xC/fOkWWL
         iwGb96uXPCr2cGhk7pfBOU6k/v03iUke9YUuV/fjcw4qh2zuGCUrCmIIauT2g/T0KhHB
         LYlXs09xdR7HlN64FAoV91kK6jBeGuSjiU1Ij5Ie7rpiDMkZBOk0+guN0c5HQVJpfxpS
         GJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+R1gJDlGRuZ6J+BYagJHAqE1ZTTL8x2mmShhv+OCHzY=;
        b=4Dci0phSoqfy9qJyzllbl43b9e1KnqRMY958ClZLV/d7bnINuzl8ikzfyAw0RxgH+q
         u77JqRnSxdEhVuyukYF6XN6CVyC+6KHvMNJUZn7qYZFEZbsulhiem4kfBe1qPzUv8/Iq
         aerLqFfwhs1rfo2IjQNAuk7Vc15xP/G6PPxweD6OaV5JZQPaBDARLtPNEGLvunfMhBHT
         U5LilWkCAyKN2FdUwtyhYrL3ykcu4FTMQCa9nRf3275q81uPengOBLMW3otJmNvFwiu1
         qFkDbvA1R/VJ8o5rFB1+/OdDYk+ZdJ1JPHtY01XmSp5QqXGdAOy9CMaRCE34z0hfbfKi
         wANA==
X-Gm-Message-State: AOAM533I/u1ZXVag6llWBjT1yyFfJVNcMVPaqLwo5VezZgGJ13BGtgn1
        +e47YaZYNn1YI1jGi0pa35jfEJ/nGZuxlDDw
X-Google-Smtp-Source: ABdhPJwUoxY9DiBsxXz9dm9W3g9KkHbWwdOMIBPCvoFVL4Bmu/k+OSSOwlQVGuDOokbZFN5XMvX7ng==
X-Received: by 2002:aa7:9515:0:b0:4ba:77b5:ef82 with SMTP id b21-20020aa79515000000b004ba77b5ef82mr71057643pfp.11.1641674033093;
        Sat, 08 Jan 2022 12:33:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p10sm2696851pfw.87.2022.01.08.12.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:33:52 -0800 (PST)
Message-ID: <61d9f530.1c69fb81.4b0f3.6782@mx.google.com>
Date:   Sat, 08 Jan 2022 12:33:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.296-8-g5df6427bc3d8
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 129 runs,
 1 regressions (v4.9.296-8-g5df6427bc3d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 129 runs, 1 regressions (v4.9.296-8-g5df6427b=
c3d8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.296-8-g5df6427bc3d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.296-8-g5df6427bc3d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5df6427bc3d8ecf23323d1b76ecb9fc8bd668e36 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d9c52369057be8ffef6770

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-8=
-g5df6427bc3d8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-8=
-g5df6427bc3d8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d9c52369057be8ffef6=
771
        new failure (last pass: v4.9.296-8-g4d5dfa912980) =

 =20
