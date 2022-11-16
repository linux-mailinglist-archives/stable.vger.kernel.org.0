Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2731A62B255
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 05:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiKPE3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 23:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbiKPE3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 23:29:06 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A848C2EF50
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 20:29:03 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id k22so16365375pfd.3
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 20:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NWVM7d3rFcV+/LbQduX1H5OVe0fbjIIxmQbDFdOiLLc=;
        b=0tZbEzljCOES+jFcaaR1yNP3S+6XmjE/jzvRZrX0VzvzVENFsypBQ1MF6xSu31iXpc
         mf/QiQCoULRtsTHG1SzKcgZK7JKEtkiClfedUoo/A1zfLidWaUxXBWVUNvfXU0MHEHGd
         DndaVJEZ5QkQLTjIqiSrBMPMVw+XhlBywa0jMaiRIIjhe7f78IVxbDRw7OQjTkNoW1OX
         mNTgemWneG3XbFhAcD+mxa5EPmISsYf7uBe1L50AZPWK4Te71+404/OwoFpPiGjrYozm
         aY+TzHBLZ2/28Wxdqdb5XOj4jH0ozVjyhhEFD78tmIPowoa4gqyhCtqTmUL9y/AY9vyy
         UZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NWVM7d3rFcV+/LbQduX1H5OVe0fbjIIxmQbDFdOiLLc=;
        b=lAOXhjPPQ7B6MpxeWa6qKfxqrRHHYzLYTixZk/s8sgD9U8OkWDeTxjY/pTE2FEWf2f
         xFG32gWnMNQwK12zSIoxhZQ7Iml+aJE5Z+sk+qlt+Jw7/05zhhhx8MRzUfoikVUsy9lD
         47udXGQ0wghsKmG1J47SdILvGIvw/9YC8ZdUvBw+OAD4yQunb4Bn+VfvsqfB/75Uket6
         TLDV4fuhWHkZsaOeRJkBhgXXXhb6cscYcsD8osFrwwQcOdk6R5BYkmuO/7Mj+1eRGBGR
         mE/JBxHR2t30419VgciG2Qkv4nUxCIJq8D/QYb1QHcmyeN5xdONDkx0qMTUXWRzFFZ5Q
         QSAw==
X-Gm-Message-State: ANoB5pmnJyHkvmVfQesMHYuI9s34349ODGMYw0zd0SqxeHXw2uxiOmmL
        XWf5o/a28wgP2JYv5GKk5vGPHQ1zdkA+jHcgkPc=
X-Google-Smtp-Source: AA0mqf5igG9wj5a4F8h9yH5RwoOTvym6Eo8a28iR+Wbe4s9VD7blexN/r2tZLpYRtVKSHDw8EYIEzA==
X-Received: by 2002:a63:c001:0:b0:46f:e657:7d25 with SMTP id h1-20020a63c001000000b0046fe6577d25mr18457220pgg.347.1668572943020;
        Tue, 15 Nov 2022 20:29:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k13-20020a170902ce0d00b0017f5ad327casm10796754plg.103.2022.11.15.20.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 20:29:02 -0800 (PST)
Message-ID: <6374670e.170a0220.3b8b.174d@mx.google.com>
Date:   Tue, 15 Nov 2022 20:29:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.78-130-g2add21d7219b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 142 runs,
 2 regressions (v5.15.78-130-g2add21d7219b)
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

stable-rc/queue/5.15 baseline: 142 runs, 2 regressions (v5.15.78-130-g2add2=
1d7219b)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.78-130-g2add21d7219b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.78-130-g2add21d7219b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2add21d7219bdd039844db5d83fd2d9b286f8b8e =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63743a1a5b6cc1fe812abcfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
130-g2add21d7219b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
130-g2add21d7219b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63743a1a5b6cc1fe812ab=
cfc
        failing since 51 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63743ec19486e636452abd1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
130-g2add21d7219b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
130-g2add21d7219b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63743ec19486e636452ab=
d1c
        failing since 51 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
