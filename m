Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFB74CEA17
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 09:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiCFIv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 03:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiCFIv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 03:51:57 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E3065813
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 00:51:05 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id k92so1646345pjh.5
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 00:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0WDk3z4MsmxoEPiquA5YyJWO5Gn3q/AstiiTE77Puis=;
        b=S8xnTGdFWsIG4ug09Ro6kAbvA0U8F7+tVRu4JB+bBme0akXQpf5+GIxmp/yUgWkVid
         gHWfdAVhUmWzWMfQXgmWpIQeatgC+6R/QEs6Qkil11MHLNeRgs9y/t4C/qGhKylBmTYe
         UoB6Xa7zrOElEk5R1RZIw6AfwcqTZJVgDvtF0yonnQxRNxi6iCYHNGRL4NFEuFLkoDVd
         sqWQN1MNJXuoV/sNMwTUdka6Pvr5BdN5kbyUS2ZYOkvbArY+tFoWMiin8fdUCaOvpjgy
         W9zsAWICV/qs5ZyH8MqrSDAhqEoLtRvaESjAGdMj70DdC0Ry10JroBvq5fdwppFq2pP9
         y1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0WDk3z4MsmxoEPiquA5YyJWO5Gn3q/AstiiTE77Puis=;
        b=Fx9UOw7VKBq2wHtD8AaG23ou+VQZC6jnhFCYm+1kDn2PwDJtEvSrsllzJdC2KfucnO
         xzPXwgPtbk+TYQmim8cGPG1JfFX47ww8bXcb+nxQzxSQ7kSdgFQVz2A1YsSpn3Ym+Xwg
         PW//jloCg/CgYk7/0v3vEGZ6nTOqdoXJPXvKNwhSW/FIag3sNiVEmGZo9wsPdnpSplsl
         JFEE1Xzqq8Bb7uKf71MrbwYJrlEwMo+vqXFGTQlqV4LbrG9avAN7ZtUQPT6xuPEEO2+S
         zYAh06rdUkeY+PFH82n8zN3/EO3IOkx8KOiLgEkNLg9Oi3lZmr3qsOWLd/YXf5sIv4Ym
         UXzA==
X-Gm-Message-State: AOAM531Y3gSHbIrMItwAVg6ck6BGhNHqjL/ObMLre/NzCiPW/1RyLvut
        X5SSGL67cFYtoJcm1Cs/1w0+Ew8CMinowqkasc8=
X-Google-Smtp-Source: ABdhPJyKNlf9JjdV9XV5rTmpBmpjEDVDoPovhlWDLxue+gwreBTjnRfx9ZZF40Y4r3xYYUr8Hk2Ogg==
X-Received: by 2002:a17:902:900c:b0:14d:81e9:75d with SMTP id a12-20020a170902900c00b0014d81e9075dmr6869118plp.69.1646556665065;
        Sun, 06 Mar 2022 00:51:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d7-20020a056a0024c700b004bd03c5045asm11849841pfv.138.2022.03.06.00.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 00:51:04 -0800 (PST)
Message-ID: <622475f8.1c69fb81.d9b5d.f03b@mx.google.com>
Date:   Sun, 06 Mar 2022 00:51:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.26-246-ged373242c999
Subject: stable-rc/linux-5.15.y baseline: 59 runs,
 1 regressions (v5.15.26-246-ged373242c999)
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

stable-rc/linux-5.15.y baseline: 59 runs, 1 regressions (v5.15.26-246-ged37=
3242c999)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.26-246-ged373242c999/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.26-246-ged373242c999
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ed373242c99919cc0a8552c1f2c74bcf9ac300e8 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6224406b9f7804529bc62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
6-246-ged373242c999/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
6-246-ged373242c999/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6224406b9f7804529bc62=
969
        failing since 44 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =20
