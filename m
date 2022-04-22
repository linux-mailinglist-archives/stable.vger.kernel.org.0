Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F008350C20D
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 00:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiDVWJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 18:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbiDVWIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 18:08:16 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEF62C6E1E
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 13:54:39 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-e5e433d66dso9869579fac.5
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 13:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2PhA1PsdJyLxPSoQ5XkU5hGPOcJggpSmyRtoxwQgI/w=;
        b=2ErL7HXtp/ITE7fldvIMfUwTkayoiQWA01QtpLPcA+KwVmEFre7jkyGpuFKpbWTvUx
         zCZW7AydjqE8FtIlvN/4s+jffPJiBE++5jfN1wYd/9cNfSXzYXOTaBfxeip1sIzGla/0
         o5JEFl6RMLq5uZ40YBKLpByRUI3jIRV86nDraKsrAClkPNtj7DVctcCsImPpwnXqn8ii
         iNDz/gcRoVnZSA+B0jtFLwc/NQ5XT9zhYwg+C/jqqn61z6+nZUzleh2pK31yAaykNKDc
         d8SjOuuOjNTGWXjzBp3KvswY3fYNIqXH/ddzFalYHQ6gdeQntYxUhctlU6g4mrKUEj7R
         Pozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2PhA1PsdJyLxPSoQ5XkU5hGPOcJggpSmyRtoxwQgI/w=;
        b=UY4SPfwLhTPiH8g+hevwc1OVPeeSrTMjd2GvifmdkxhaWXRrLJ1eCP7sccRbNYDR+D
         tCZuPppegoSRl+9HdQd8ngch2q+vlGzSeCLTxd6Iw5lclJWYXdTXeRewruou/HdtBCen
         AcK+N6wgDltbrui3pA68UnW16GmAJbeyOLOAWyoqW6jVElhyuQSioJ88RGfbxNoBIWdd
         tWKsSdvYVRn+dvzDa7Var5muVE8P3po8iwvpP4Zhp1MQOr5KWkCiNrNySVMmtHmbToHX
         kmpFwzShgdkTp3o6tjmeaAKX8Po5LtPbBb2s5Ulns4jtK+w1395IeyH0SBBX5RlHGfSN
         aQWg==
X-Gm-Message-State: AOAM533Ae6r2JVYhOPiVs8flJNqnO5ZYg+3+8pNz6e4T99afNQvB4yd/
        tEAVAzZsKLW7/f0tuMoMpgnArDypAId75BbSRo8=
X-Google-Smtp-Source: ABdhPJx9fPzfWltFVbugxV5Tlmv1lUd2qCKzPVhLO0q1ZNdMM82lAh7hzNUsfjPxlHhwm4gI4RjlBQ==
X-Received: by 2002:a17:90a:c70f:b0:1bf:3e2d:6cfa with SMTP id o15-20020a17090ac70f00b001bf3e2d6cfamr7332110pjt.70.1650658330026;
        Fri, 22 Apr 2022 13:12:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d9-20020a056a00198900b00508379f2121sm3398162pfl.52.2022.04.22.13.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 13:12:09 -0700 (PDT)
Message-ID: <62630c19.1c69fb81.86841.8708@mx.google.com>
Date:   Fri, 22 Apr 2022 13:12:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.311-3-g76865159defc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 27 runs,
 1 regressions (v4.9.311-3-g76865159defc)
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

stable-rc/queue/4.9 baseline: 27 runs, 1 regressions (v4.9.311-3-g76865159d=
efc)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.311-3-g76865159defc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.311-3-g76865159defc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76865159defc1acb380f75132161f775dc919081 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6262e866565fb743ddff9481

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.311-3=
-g76865159defc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.311-3=
-g76865159defc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6262e866565fb743ddff9=
482
        new failure (last pass: v4.9.311-3-g86fa99d8325e8) =

 =20
