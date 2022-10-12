Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15B25FC5CC
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 15:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJLNB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 09:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJLNB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 09:01:56 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809D824094
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 06:01:55 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h10so16168905plb.2
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 06:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JDgaBX/8LUkCL6RrWOQpIRhwPNx8mMtsKAIy2n3C+e0=;
        b=Uc5HwAj4p/R+JIjGKJq1+61nhjewgC+LhYlsNMn1uoP5ZFbwEWlp1H3k9S5oA64/pU
         l3L8XfQOF+FSIo34LKICoFjg8wgbgUUVdv1cLwQMc3eFBxQ23vsxmMar7fDxkQvJ1lZp
         /8/2Qog5I+VjnWI75f9OTpmOplr7Rou94sN+2kI4jOMFPeAZM+HdRBsYMQK6gJy1l4yA
         +aUg1e13EgZH5Yxj0RvvsdaGYvXkh8iHUNauA8VJA4EAn7Xmk87j8KbgXCZJkRvU4PVW
         Nvk8x16Gx482w83hTnJVYhZ1VOvARrQwbHJEIcC5x2i8ZemunCkY4y10rVcGRIsW8Z4w
         GuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JDgaBX/8LUkCL6RrWOQpIRhwPNx8mMtsKAIy2n3C+e0=;
        b=PbcCQUlKM6j/JVhV7t4mkiThHpqkGxMH7ktt+N8Syjj+7MP0g+sttJdGpKjd0F+qwP
         fxFyRnfDBamMRFSdFYkqBpJEB6uH0JeUSmQTfCK5iOYPcFJNDPRwV6G29k1dh9R6TTrj
         iWFchgMluyYrFrA/txCRps8iuSCX2pvs+nxpZaW9KHKXYEjEKFzuOpL3wh0R56+v2u/R
         2S9zYRKCndakPi5l2wJPJnQbQWc7UnQGfoBkaFbCldMBmdUisLYuffnosoNd81ln6/Mr
         CtFmxv5Thk/YAzK7+TII3rtbdNSy8XirLXJvWBqZ4auZscjQxSpHh9JOLUQ/jcYIYdHA
         4AAw==
X-Gm-Message-State: ACrzQf1yuEETu396a0kk0OE3N7Zrcdh/J6tmOHgyLmFezi99rgFscgoT
        H+/QFeMxDW133RB1u3JxLokY2cnl8zzT+lB0SWQ=
X-Google-Smtp-Source: AMsMyM6Op0EC9nS8/kvwP7qGrb4/eEekelHaXw+iOi/2DnSNQL0rSiCVHprVdn100dhfkGoe4fJKuQ==
X-Received: by 2002:a17:902:724b:b0:183:16f:fae4 with SMTP id c11-20020a170902724b00b00183016ffae4mr12647723pll.88.1665579714850;
        Wed, 12 Oct 2022 06:01:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a17-20020aa794b1000000b00553d5920a29sm11026627pfl.101.2022.10.12.06.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 06:01:54 -0700 (PDT)
Message-ID: <6346bac2.a70a0220.f5272.2d2c@mx.google.com>
Date:   Wed, 12 Oct 2022 06:01:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.14-47-ga0c4ea5443da5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 95 runs,
 3 regressions (v5.19.14-47-ga0c4ea5443da5)
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

stable-rc/queue/5.19 baseline: 95 runs, 3 regressions (v5.19.14-47-ga0c4ea5=
443da5)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.14-47-ga0c4ea5443da5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.14-47-ga0c4ea5443da5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0c4ea5443da558143791f65be4778834050e507 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6346881a82a29720bbcab5f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-ga0c4ea5443da5/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-ga0c4ea5443da5/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6346881a82a29720bbcab=
5f4
        failing since 16 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-186-ge96864168d41) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63468c8d1c65c336c7cab5f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-ga0c4ea5443da5/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-ga0c4ea5443da5/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63468c8d1c65c336c7cab=
5f8
        failing since 15 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-206-g444111497b13) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634687d88f200a9d4dcab61d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-ga0c4ea5443da5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-ga0c4ea5443da5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634687d88f200a9d4dcab=
61e
        failing since 0 day (last pass: v5.19.14-47-g0f2b1a82748ec, first f=
ail: v5.19.14-47-gc70148895c5c) =

 =20
