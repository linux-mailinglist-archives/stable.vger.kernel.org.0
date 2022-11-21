Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25E0631D12
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 10:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiKUJnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 04:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiKUJm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 04:42:57 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105C9B4AC
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 01:42:54 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id 71-20020a17090a09cd00b00218adeb3549so2346910pjo.1
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 01:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HjiL0zGjm2rCjobfgtbFqyBt3orgESwJRfwLpSAimks=;
        b=xs9yEBSFO3K0/IAr3vOzgfX8pwq6ckJ2Wja+1fEDC+PTItPq+/CtauXU2HmK/zqVIF
         wuZo2fZYyK/oRMqMskKHh0mzW2jt3KUMfqYb3ChFi1MPGrPZzVuGqjbhQVCGL24NPKP4
         B8O86ajTbzbF51jNB53GeFpp9+2/EHC247n4ssayWT33YJEc1Cfh0HhI8u49NkQwAR6R
         /gyJ8hoBI6Vlad9xfDLri+LzV78dsqXGo7ACtIV1nFuU1pAKdwCZDoVEUQcjbj3GDCC+
         baHHGrUGJ5M6OA0iX66DhI2nOotu6UvTwlV7QThe6db8no8ItQk5qGrddAeZx6q7Kblr
         jj1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HjiL0zGjm2rCjobfgtbFqyBt3orgESwJRfwLpSAimks=;
        b=uh2mC+zC3IPCL3fUHfSXSASuYJRZyZ6aHNitg4zzldyJfxaSul56KT3EUj7qFrTCja
         zjFTRwf4RPQyrBPauyeB+gfm882LCAwSYRDC/j9UrSzx/tuWStBm9+cZiHQnXYEd/+8O
         aBiA4w2nkiOqwkcJpSPLSpyMQqJ2ML0mchjXIDJmzNjgBa0eRQj93je41mjeh+MtIHUc
         OgetO2z0btycfWWUW/ANedn3sq/XhRUhbOcRQVNYN0Op2Zmz7e/OuxnddWLfpxc9Ifrm
         8OHPQ30VkP1lTxAZ5rn06ZFERg2b1ekkGSnxBwJhs5mWsFmtxmA8aoPzq9K3pqzlYzhw
         Lqgg==
X-Gm-Message-State: ANoB5pmK/EXB4WUoejk0sAFsJHrnpRBZVFpcPe7IATFO60zn7G+t5DGe
        FHvdevBMjXyMpP3pZluliLVJ1wjuIuGBMSv5/6g=
X-Google-Smtp-Source: AA0mqf59t5mMWFDZhQrX/AEKuBJrk7aCMZcQdB2b9/5GX8veg1NIT4fhUu+k9/mw+Zr7/aC41kwGeQ==
X-Received: by 2002:a17:903:240a:b0:188:abb9:290 with SMTP id e10-20020a170903240a00b00188abb90290mr10810562plo.86.1669023773407;
        Mon, 21 Nov 2022 01:42:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j17-20020a63cf11000000b00460c67afbd5sm7143058pgg.7.2022.11.21.01.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 01:42:53 -0800 (PST)
Message-ID: <637b481d.630a0220.5e4c8.9da4@mx.google.com>
Date:   Mon, 21 Nov 2022 01:42:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-106-ge7e2069801de
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 173 runs,
 2 regressions (v5.15.79-106-ge7e2069801de)
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

stable-rc/queue/5.15 baseline: 173 runs, 2 regressions (v5.15.79-106-ge7e20=
69801de)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-106-ge7e2069801de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-106-ge7e2069801de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7e2069801de250fb6d5ef5d28a1dd88ec4ef22a =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/637b182407f52248e42abd0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
106-ge7e2069801de/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
106-ge7e2069801de/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637b182407f52248e42ab=
d10
        failing since 56 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/637b16bcca10eb6e322abd59

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
106-ge7e2069801de/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
106-ge7e2069801de/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637b16bcca10eb6e322ab=
d5a
        failing since 56 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
