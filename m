Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7743E664F31
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 23:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbjAJWzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 17:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbjAJWzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 17:55:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0D426E7
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 14:53:48 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so18060722pjk.3
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 14:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WPbQINbDBRm+y6ckj5hXrlDe7GTc82cBKwq2dIV3IbA=;
        b=F8BjjfaP9prW5FkjoXIWz8iCm+7y1sJu7l5I0ZINzxm8xMwCDmuGpEHDewZHuoM4G8
         39TD17W5Ef1AXuHtLNrSv5+Fpqyvxdt65iX2GBGGI3/m9omYkvZzH2+bxQ87mUf2dyRp
         6k5A91y4ODRnysPbgSR3dydBEKWgg7t7uWB2sPNCGJ1jUzyKh5nYH0oIJP8Z4rNj75yj
         p73Tk88y8hu9IZMvlW9Wo8Ge1EwczVeI39VDgTNkLasDSrwS5D4LAwLh9NJZne/pA/gb
         CK0WX23pV3PjCfq8wXqxqcyatbc23Ew0Ryfr5DUKFigWaJrdMge757JvTGuxniuGKo7Y
         HEpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WPbQINbDBRm+y6ckj5hXrlDe7GTc82cBKwq2dIV3IbA=;
        b=Jc+SmbmNPCY1/pLkGqHlfff/xm9VDblUyieXqarq/x/qcPrM8sa2FmlSYmPH39snMN
         7Xw8Yq2M/EBXaltIFzE885gdri14S7hM/hpiWroKoH9s3gc5j7A25EwWPjjbzIs5z571
         TrLOPdN6XHG/Qv7LvJ7t+uzvAjD6SbP3XW9HhskKCRqDePg3VyMNSbn8hlrre6m9ABgU
         uM8JxNvmOsKETC9s7DPKQs2rbVz3i4rjM0MUFlhSkFDeqmbR2G/cu9lQTL/k/tC+91WL
         uQmM09sTtnxE1+8vJmFQXTKo8Bc+UAvWNZFPF08GMZYWu0VUKRShiJTuiloF332B+meX
         2cbQ==
X-Gm-Message-State: AFqh2kr0MRvenrvCcb624AcM3vSjesWmhglg7Jqg5NDZYSnXwRv3Cl86
        bmSPy2dCxGS5/dSFwfqI8w7sSDlxlvErnMhM7tiNQQ==
X-Google-Smtp-Source: AMrXdXuIl/5KPBTqE5P2P+vqKNSHseP/OFhHio2pFfDpFCky7I/RrlBe3+yIpeSYWqlClMwGV1+4VQ==
X-Received: by 2002:a17:902:ecce:b0:192:b16b:8e49 with SMTP id a14-20020a170902ecce00b00192b16b8e49mr54457048plh.43.1673391227618;
        Tue, 10 Jan 2023 14:53:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u9-20020a170903124900b00174c1855cd9sm8560459plh.267.2023.01.10.14.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 14:53:47 -0800 (PST)
Message-ID: <63bdec7b.170a0220.3bcba.df39@mx.google.com>
Date:   Tue, 10 Jan 2023 14:53:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.162-773-gc525af3d6565
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 92 runs,
 1 regressions (v5.10.162-773-gc525af3d6565)
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

stable-rc/linux-5.10.y baseline: 92 runs, 1 regressions (v5.10.162-773-gc52=
5af3d6565)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162-773-gc525af3d6565/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162-773-gc525af3d6565
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c525af3d6565aafe0def0c44f255f46aee61eb2a =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63bdb59eb4ab75170e1d3a54

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-773-gc525af3d6565/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-773-gc525af3d6565/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63bdb59eb4ab75170e1d3=
a55
        failing since 13 days (last pass: v5.10.161-561-g6081b6cc6ce7, firs=
t fail: v5.10.161-575-g2bd054a0af64) =

 =20
