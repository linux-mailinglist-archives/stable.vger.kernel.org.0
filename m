Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31ECC644F21
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 00:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiLFXAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 18:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLFXAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 18:00:54 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D469F3E0A1
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 15:00:52 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y4so15413017plb.2
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 15:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8P6I6CmR179HSIRbfypJsk9y478IgKrUcxzJU2Zdrp8=;
        b=qd84DiUY0/4MjAcHJ/cWYCHbX8vNFpf/1JRmyK8vMqj73zrPWjECJOSa0JgmYr4ZGx
         oeTZd16ahPLWpQ5uIMDZOdk4uQkma/JeOnqKGlciIZir9rIWFSsgY/Y+RZLmURVf/xCn
         51xW1D+Vd0oABUIRiLTu8A+TcSlQlSzGVGiktdUD56nCXpdUIT6s7WkvUtzVWHCjs3CE
         YnqCDah55aQiVxfhZJu0g7NaWqtFsHJm/jY+EgzQ9dlrFIUgEaqtehAmeyxKVwPTI51z
         0P9neUBpkF31Fn1IPZKGZsFsHH3/9hQKktMqnQfDL5XkEdPcxCz1QY4HQ7MP+Pbx9y5r
         hGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8P6I6CmR179HSIRbfypJsk9y478IgKrUcxzJU2Zdrp8=;
        b=EcomN0900/kEXUUmf1Fyj0B1lYKVPZbventYtjRPGOyc7ALjuw8HjAvXv8KuBCOu0X
         Zu9f0IMoH2lA5MLpnerF292Ld2j45g7DRdhJnVIP0bybp4mx8DvMPN0Vu15P0VE6fy3y
         ypgm8QAfm9fAN6DRl0aQlEw+XRruYIOKmWtjTfw2qVL1fTtGLKkP+VC8NoVESXT/zB7x
         TWoRo70BE4Uvi4CMs6DkThS4vcDQQX1qM3325WTQSucE2XV85GY3/jYOA/QB1kgQ0ohw
         6lA+oXnwPUVxAcTcK1kWhud2ZVu4OCb9hqkDD9aJwT7+Ra13xse0zJFpVARjVs++4BLU
         Qa7g==
X-Gm-Message-State: ANoB5pnoOdvwh9L5Fh0JXbFtl1Ye4ssulWuBdHzSGmzp0sPIW02BKSsR
        3Pkjg9n3uubsT0TWz7D6WP4FqqzsrsKUp2x2xTwMlw==
X-Google-Smtp-Source: AA0mqf7ol4ErFdwYhrTCKs4hNE3UTqGaPx6qBBNyKzScM14hRCMHjfyMhDXPN4bS09AcP6Dnx14Gxw==
X-Received: by 2002:a17:903:2487:b0:189:bdd4:1d67 with SMTP id p7-20020a170903248700b00189bdd41d67mr21100818plw.12.1670367652060;
        Tue, 06 Dec 2022 15:00:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t3-20020aa79463000000b00576b0893ecasm6214729pfq.46.2022.12.06.15.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 15:00:51 -0800 (PST)
Message-ID: <638fc9a3.a70a0220.81d50.a996@mx.google.com>
Date:   Tue, 06 Dec 2022 15:00:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.81-121-gcb14018a85f6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 133 runs,
 1 regressions (v5.15.81-121-gcb14018a85f6)
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

stable-rc/queue/5.15 baseline: 133 runs, 1 regressions (v5.15.81-121-gcb140=
18a85f6)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.81-121-gcb14018a85f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.81-121-gcb14018a85f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb14018a85f63c4d07c92570ece242cc382f79f0 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/638f93174c4f831ba62abd0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.81-=
121-gcb14018a85f6/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.81-=
121-gcb14018a85f6/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638f93174c4f831ba62ab=
d0e
        new failure (last pass: v5.15.81-122-g7a192513795b) =

 =20
