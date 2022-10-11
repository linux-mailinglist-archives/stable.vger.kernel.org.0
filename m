Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B024E5FAABD
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 04:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiJKCtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 22:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJKCtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 22:49:04 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1AC844EE
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 19:49:01 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id x31-20020a17090a38a200b0020d2afec803so4865573pjb.2
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 19:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=m4GcbYyz7HZCCthgXwBFsHOJA8bgYEmGY01jr8VcFeA=;
        b=yTBmbrGwKq2f0Zwhj3gY7HjjifnUBzQw3J6yvN03Zoi5wUDscyeKMJkGF5Mf8KGFr0
         KgqpxLDiKLSAJMRVD1cl0WnclNgM+YwCWaT3aoaTBrteicYmovWjm1Yyy12F6c500kFX
         MzCCtJUX2yZ2TGydxu5w4p0D9iNYViPBr4zXWWHWdf8WYbjKHVqggBnscuUSpMyH+xZA
         4XUQsoA8/Xcu+FSDlb/nKrMU+8uUkwSHHYwJ9fjMa2aQiEH81YFHV7dj22h8GKiJJAIr
         QdI/Q0REenJhc1vpIdOVx56+vhMGMDJtua2zPadrnIvaApRlhP2pv4/MSBPbz+DfrmXE
         8R6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m4GcbYyz7HZCCthgXwBFsHOJA8bgYEmGY01jr8VcFeA=;
        b=z1I+kanX67ynfmr+gES7wwxqwqW25O1NU5KR5GNh7tfKOvPdhLjO/8k7TEuKxyn4PK
         P4vOVcG1P6FqM3bJBVQKfaOqs4nHcyBtuNnU3FdSn2S2VGZ73Vyhg1xgKgzdxPBAUf+t
         BiGhTv2/FHBdA7ahAoFNy/ihL43ZrL1/Yc5ZRORL0fuYPCz3Sy/NzCZ2B+/RjOoZgiDd
         0p/Cf13z6Jv+klH9k5v0zoc5wh0zA4MCJUWugga/GAXDKKGmcOGLhlBei4yx9hKKReut
         A3jS9bVr00mgTvE1Il3HHzNs1titFCgxAQm1ko0lqG7n+n5T70qryN9TnMFYIzvjia2v
         F9pA==
X-Gm-Message-State: ACrzQf1FNbYkxXt46asgBzkX8o5X1lRslrX8ajn6Ne73DtNkvRQwFN0W
        05DNCpMg1RGcYBvByqQNS2loumcSPhgcrpsqR98=
X-Google-Smtp-Source: AMsMyM5j8LPWhGOv1mV5sswLz0jTaQ2EJ5j1cRGqcojy2z/5wABaLbLuKXuSkb1TsGrNF7vmvjQGdg==
X-Received: by 2002:a17:902:7c98:b0:17f:941a:65e0 with SMTP id y24-20020a1709027c9800b0017f941a65e0mr21950603pll.143.1665456540891;
        Mon, 10 Oct 2022 19:49:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m2-20020a17090a2c0200b002008b7c9764sm9796619pjd.50.2022.10.10.19.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 19:49:00 -0700 (PDT)
Message-ID: <6344d99c.170a0220.fe46a.1781@mx.google.com>
Date:   Mon, 10 Oct 2022 19:49:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.14-46-gf41abe40d574
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 91 runs,
 2 regressions (v5.19.14-46-gf41abe40d574)
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

stable-rc/queue/5.19 baseline: 91 runs, 2 regressions (v5.19.14-46-gf41abe4=
0d574)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.14-46-gf41abe40d574/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.14-46-gf41abe40d574
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f41abe40d574fde2cc9a1b3211eb198b0f9dab35 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6344a70c54dfac5959cab612

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
46-gf41abe40d574/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
46-gf41abe40d574/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6344a70c54dfac5959cab=
613
        failing since 15 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-186-ge96864168d41) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6344a9effaee07ed35cab616

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
46-gf41abe40d574/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
46-gf41abe40d574/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6344a9effaee07ed35cab=
617
        failing since 14 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-206-g444111497b13) =

 =20
