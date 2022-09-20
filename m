Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197115BEF6E
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 23:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiITVyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 17:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiITVyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 17:54:12 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E21622BC4
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 14:54:11 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a80so4012225pfa.4
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 14:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=NJof76fsYFnn/qJX10tb+kfjFqhsoILuIj+0oVvRVgY=;
        b=cFeggEWBgEn9RNCQyuZCVj+jlPqeNNuvs4MnMXjNuigxpQk134A2TeayVER35mVaK8
         u/Uz5w0nHqBGEmSWDfkIKJuf3JndhPDHeut+DelSIr7qeAJUu11R897RQgiz9DsP4gFu
         lLOVHcoynGqDP7CBQo5iBZkEacyxyrWi/vWI+ncwqKMP9c/tkCzbmQKBwglsXDieLvMA
         TP0nYB6l1oqgNjcJH/0fojYihW90iuCkX92XFrVFM/hBuL0YYU51fhKup8tkuLuROLIm
         75mUlJHUyp8GObe88umN4LUXFAoq50JJyxLKgx3wIRuDEhl9XmWghNooYHLEY9blWSrp
         rpYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=NJof76fsYFnn/qJX10tb+kfjFqhsoILuIj+0oVvRVgY=;
        b=vxPNYhtF1LlPKsk8NLF7SRY/3Iu54psyc6X89dqrkK2xCnMWuymagQpDnbOu+Mjlus
         2yPiVw2TAkXUssGG87ZpMSED1iPywOArf9KrxakA6I5qX55ltDyJBzkPHTGV8fWwniMM
         vn5Rr1+SIW6GGqsXJBDYhR2HwfEs1RcDrSGntoB4OFhsuTeEsGEedcc2hbBKxifPdvwz
         dgqGlktSubCl0fnfzoIWeFVWI9O7puDtfU4weK1TsMsQAgX+lSvLupSSYofPR4S6kTJu
         Ovd4cTD7w8ykTYRKn9xHSfm0NdN4pjcm3IKSWSY7JE4BwG4yXCrquoNKIGpikybpfMkC
         Pxxw==
X-Gm-Message-State: ACrzQf2cNpwqLKwTEiCUgeK+wsRmXTQWSsg9hF72iZDmjTw2lkNSZ1rj
        o0ewKnAnoIlTwCxdr9YSk6UJf+hFawoKQPZhSso=
X-Google-Smtp-Source: AMsMyM4jCBEoUjy1sTcT2ilBcBzVPQCcb9gLhUdJCNTdjRcwRwesX9C4QnZ+YVACznD3lR6hFFKCdg==
X-Received: by 2002:a63:fd41:0:b0:438:7670:589a with SMTP id m1-20020a63fd41000000b004387670589amr21672326pgj.148.1663710850818;
        Tue, 20 Sep 2022 14:54:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090264cf00b0016dbdf7b97bsm355009pli.266.2022.09.20.14.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 14:54:10 -0700 (PDT)
Message-ID: <632a3682.170a0220.da1b3.1033@mx.google.com>
Date:   Tue, 20 Sep 2022 14:54:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.69
Subject: stable-rc/linux-5.15.y baseline: 110 runs, 1 regressions (v5.15.69)
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

stable-rc/linux-5.15.y baseline: 110 runs, 1 regressions (v5.15.69)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.69/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      820b689b4a7a6ca1b4fdabf26a17196a2e379a97 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6329fef94894ab9b92355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
9/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
9/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329fef94894ab9b92355=
646
        new failure (last pass: v5.15.68-36-gd766f744e482) =

 =20
