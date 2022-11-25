Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE36C6390F7
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 22:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiKYVLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 16:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKYVLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 16:11:36 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0B02980D
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 13:11:35 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id ci10so4564455pjb.1
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 13:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bF9nZDfij322I/DlaHgnPmlX4ZHa1bSJuS3G3joQ7PI=;
        b=iEu2N3dGE2bYpyxtN/yv+HXRn03o2MTM5IiqJREkATamhxd3uxET+Zy6rocM6izcl+
         0wYbAS949XEXgqn1AtmS6hE6bQDMR6T5baYYxZkgXMwu10XC3hpILJXYF4+kbdfAJ1+K
         rpla6yHobRHDHpNxxULfqkBY2aSQOxZe+EBOOOLLVOWL1d9KWKw5MvCBsHcRIKz4rw26
         v/3XYYyPf3c4HfQICcHo8p6Bm6FWhaLZJ9C7Tyt/gCmeYpnzY8coY8sHCxx7GtVoFFIU
         DGrTd1ZLmivg7M34VI8/XoRxTZg7LUY0y/TGUe7bQEuTOBwwvRoJZ9umKcmh5XONLzlb
         zLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bF9nZDfij322I/DlaHgnPmlX4ZHa1bSJuS3G3joQ7PI=;
        b=orRtZyrBndRUPvjS6HeuaPXV6or4sPdpySZ/030TDPJFKiDvqEhwTlT3VIMhZ7FBzD
         Yx5CCnZTCxV7RyHL/OmwAK5oKYmZbCHlFw14xZ0lEUrL81XGilBk8tIj+7LUsvKZ9nBL
         dG0n6fkWGLR9UCGSqlpw3BSrLsN9ALfCJPvUHUMKNe61PhTS5rvaZqgJol22irppmoYi
         +HmLXw2ygATbNzNbECbled0aUrEV4ZNFH9dz9uSx4AhVWXEG8/B/Zyursb6FgGe2VYnj
         PGgrt0Lm+jHWoA5W4A/1VIOYC873bk7J8CEitikqdUA59ByWtUcwpwH4TTvf3n6IMXrr
         P/vw==
X-Gm-Message-State: ANoB5pmbAwcQGuicV7EDe7tHqVz8q8a/fuuikvQ241Ntn9y1k8Cu4B/x
        DSQC8pSWerGKA622Lbh6dDlW715YIMbDVCHD4OA=
X-Google-Smtp-Source: AA0mqf60sJJABpP0Qk2F2D3qc1UO2MdNl/kADlxQBXQCpXnqEALBh2P5frqA+B72fo+12dJw5xqssA==
X-Received: by 2002:a17:90a:448a:b0:218:48f3:2e48 with SMTP id t10-20020a17090a448a00b0021848f32e48mr41604748pjg.36.1669410694255;
        Fri, 25 Nov 2022 13:11:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9-20020a17090a3b4900b002135e8074b1sm5362414pjf.55.2022.11.25.13.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 13:11:33 -0800 (PST)
Message-ID: <63812f85.170a0220.8edbf.8942@mx.google.com>
Date:   Fri, 25 Nov 2022 13:11:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-180-g4da6d9574b9b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 81 runs,
 2 regressions (v5.15.79-180-g4da6d9574b9b)
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

stable-rc/queue/5.15 baseline: 81 runs, 2 regressions (v5.15.79-180-g4da6d9=
574b9b)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-180-g4da6d9574b9b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-180-g4da6d9574b9b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4da6d9574b9b930915c3edd384d3006799c25005 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6381050f7be7fc3aaf2abd13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
180-g4da6d9574b9b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
180-g4da6d9574b9b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6381050f7be7fc3aaf2ab=
d14
        failing since 61 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/638108f79ad2709e9e2abd03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
180-g4da6d9574b9b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
180-g4da6d9574b9b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638108f79ad2709e9e2ab=
d04
        failing since 61 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
