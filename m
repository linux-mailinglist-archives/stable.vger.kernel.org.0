Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2202757A591
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 19:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiGSRlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 13:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiGSRlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 13:41:20 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4C41929A
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 10:41:20 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id q5so12607907plr.11
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 10:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zYwgrOOZ2cyGcO/AfD9tb1Kcmrfffx+KpkdEdXlwFEs=;
        b=wq71wYR0gqvhw9UuEiDVIPcDjb7JldSrzjpSYDDbCa7ltNetH55n5+p8sX+7y76X6O
         sCuQTlZCK5YtrKUYBCoanVItgi28PFr2FlLJDyBlqZfMQApaAxdqwcTrWOgfk5nYmiTt
         CDhE3exXuD2qnlrmBwffSLLN6OD2DCYvuEV7yYRhqwLVCM2S+wtVqsDDvxxxbCS04hmL
         vu4T5gLvIv9MQ5rfPPsLqdsgMoRFN/268z7JvavGrhzQITUA7Eae4tPNn1CqOOj/X2vW
         VMi8ib6KsluK/r3xK4Y2iyWbj+QlXMXN8Ys+R9+LY9Gt7CTApKbokvPXkmo7eHktMU1T
         kh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zYwgrOOZ2cyGcO/AfD9tb1Kcmrfffx+KpkdEdXlwFEs=;
        b=5Mk2HFfNAYZJVFkAizxhZtwEmRnQKTEjklJq73p8Vdi8gL4a4wcQnBT+dqxnDv3MUZ
         XDa9yqL7OkPYAira3NB2wr8ElDR/+PuwUBnrt/0SxyjWs/L44sczHhPFicwTy2meDmu6
         S25WHezmDy3hNGbaGuX984L2ciq5XwsVKEaHyIO6tk8/ELLhENc5E/794HuGkJL1AmgS
         ha0SsWXJQsSrz0VYXuh7B+8iTNvzVU1EfZtNmN7cdjWEngKqwHN6rzYt0m5oo/UoBPdH
         lJ8mZ3v+RKt0O33HgALhuECvV9t3F5CoPpGC+NcfYmGBKTWtHVT2vddvlUfEteP09mEH
         t1rg==
X-Gm-Message-State: AJIora8RXwYIGFcsjOM4JoLp5BWH7laigNxN1YptEAIG20BOudmkkuAu
        jfnxSkzUfsDi9mDCTKxriC/xisQtf5YxXp4S
X-Google-Smtp-Source: AGRyM1u7CVIYyy26niIcyI4arf2Wz54cGozZd3fBtEQiZQtOvE8I290idqjCbKP1KbkEetwC4/DpaQ==
X-Received: by 2002:a17:902:b712:b0:16d:a80:87b9 with SMTP id d18-20020a170902b71200b0016d0a8087b9mr4725091pls.130.1658252479324;
        Tue, 19 Jul 2022 10:41:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902ce0400b0016c4e4538c9sm11834565plg.7.2022.07.19.10.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 10:41:19 -0700 (PDT)
Message-ID: <62d6ecbf.1c69fb81.66834.2468@mx.google.com>
Date:   Tue, 19 Jul 2022 10:41:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.12-232-ga04b1a5cb7d28
Subject: stable-rc/linux-5.18.y baseline: 165 runs,
 1 regressions (v5.18.12-232-ga04b1a5cb7d28)
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

stable-rc/linux-5.18.y baseline: 165 runs, 1 regressions (v5.18.12-232-ga04=
b1a5cb7d28)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.12-232-ga04b1a5cb7d28/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.12-232-ga04b1a5cb7d28
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a04b1a5cb7d28868de5bbfba6341f0736b9b4984 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6b70073935a4136daf094

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2-232-ga04b1a5cb7d28/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2-232-ga04b1a5cb7d28/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6b70073935a4136daf=
095
        failing since 18 days (last pass: v5.18.8, first fail: v5.18.8-7-g2=
c9a64b3a872) =

 =20
