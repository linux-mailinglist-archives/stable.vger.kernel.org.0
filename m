Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FA04FF9C3
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 17:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbiDMPJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 11:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbiDMPJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 11:09:41 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822DA393D1
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 08:07:19 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n8so2231751plh.1
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 08:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PJfTaPbf1TBAVO9H107FkEtLSkmsTF1Ftcz57YZCKgQ=;
        b=bSYSGGgI6jcUlc/WDoFXVBnI+8GQ09Tmf6AjzqCMEERWr9R1QFywR0VPwnbRAXHZpE
         0FmW5A5q5s2sfm1WrgHjscGclzu+9vq1cGhaBNGTv8K1B0KJEDXEBKF8uGhbuuJJsnls
         Z/Pbo5tpinQD53LBKTdQS3rhf6Iy+3G2yhzjcXt0KviKmqbLcwxQacuKFjYQGTMy8ujh
         Ytns7F9/B0PwPmApb5W2Q73FLZVfNIqd2dOlj68wcwGOKvooydBeUsi+PM4cC/nJ1JEV
         fAXSRnk2SJueXVMQle5UiZ2pZip9B44H5Lq6U8ZkZwKiUMC/CVep4mVRl4eJ1oxPYKG8
         YokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PJfTaPbf1TBAVO9H107FkEtLSkmsTF1Ftcz57YZCKgQ=;
        b=w8BNQXfh8cRwXBoehn6ZAencmO4HiF/KNXgKBWkozGWK7z9Kuc6WcRhuCF0TcGGLin
         8E99ged7dfVlYkuFS5CaDkPsZpUSAXU7P4ufdydmGfISg1X8DqGadfJ7QogdWBWHM2cx
         6xbd35Ji0NU9GRopQ8FtApj7UB+RXu1mvLrv3Deu/ncwbC65YG72UtA0LOQ4PkE0wMRi
         xViFZsAP9C9rgQPHgnkDyCgTw6Ycp0+j4gQPey7HB6pRMmJBwZFWiTFpggqa04jjjugx
         F6iWbbdvE6x63koWLSC7V4t8reDXl8+H4L7ymiAOqccFYIkuIW/m/NAdGd92C2pXHUQb
         cm7g==
X-Gm-Message-State: AOAM5335hZHemFTqNLrhlLuu3LLuAvb3/XOnWLSF1phM8U11T/ddhGp3
        bmJeNXRQadEetLVO5NwLQcsQy8jK3vadgCvs
X-Google-Smtp-Source: ABdhPJyWHWM7u3Cfw3ChSdOEjDlVNlQBl9xTTyq/vWQ2lKiEHsflX32+LJonxRims1+F4QxlZG5gnA==
X-Received: by 2002:a17:90b:1810:b0:1cd:4fb3:a73f with SMTP id lw16-20020a17090b181000b001cd4fb3a73fmr4148736pjb.57.1649862438506;
        Wed, 13 Apr 2022 08:07:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5-20020a17090a68c500b001cb651fffdbsm3447785pjj.8.2022.04.13.08.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:07:18 -0700 (PDT)
Message-ID: <6256e726.1c69fb81.d4723.87eb@mx.google.com>
Date:   Wed, 13 Apr 2022 08:07:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.2-343-g74625fba2cc43
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 39 runs,
 1 regressions (v5.17.2-343-g74625fba2cc43)
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

stable-rc/queue/5.17 baseline: 39 runs, 1 regressions (v5.17.2-343-g74625fb=
a2cc43)

Regressions Summary
-------------------

platform          | arch | lab          | compiler | defconfig           | =
regressions
------------------+------+--------------+----------+---------------------+-=
-----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.2-343-g74625fba2cc43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.2-343-g74625fba2cc43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74625fba2cc43bdb2df8f296fb66b59988fec949 =



Test Regressions
---------------- =



platform          | arch | lab          | compiler | defconfig           | =
regressions
------------------+------+--------------+----------+---------------------+-=
-----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6256b62f650685a371ae0698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.2-3=
43-g74625fba2cc43/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-am57=
xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.2-3=
43-g74625fba2cc43/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-am57=
xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256b62f650685a371ae0=
699
        new failure (last pass: v5.17.2-339-g22fa848c25c53) =

 =20
