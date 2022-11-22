Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25E263499F
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 22:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiKVVuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 16:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbiKVVuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 16:50:01 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC51F7D507
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 13:50:00 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g62so15582573pfb.10
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 13:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=M1XCCkKg+q064QWubj2i+mQQVWlI70jINBLfl3/Gqj8=;
        b=n9gAsJPTfMYO7I9pcCTMGXMf3mkSfb4R14IalZAfIx8GP39n8sz9lQ0EpsFQbnTM/m
         M7dFRFTR7Xab4kzK5TPMYE/+SWTZprxhOhLH0Z80p0NiIVy2MZZj8BQbrXf2HU862huN
         Run3H2Rzauhv44+Gb5xbGeb96aGrZShh2ViE+cGayyzEqJcZYQMecTwhUn3oRj39U9Ly
         OV/AP4ejB1rMCF3E7V8mtcC5QHm1mlIilc93NyX6ALLPrIIHFIYzoFAIKzdZhp9tyW+u
         9k8vHSd3V1qrt6PizxOP4J46K7lUbeoG6tuLpgCse0w0qKc5W1JhKGCuLK9SydqbzfV/
         tcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M1XCCkKg+q064QWubj2i+mQQVWlI70jINBLfl3/Gqj8=;
        b=3HwgsTNmHNZTn5e5rCHGkc3XWG57cQPdlUn9wVvR9qAdE9mtRhikaQRdfZXcrW5OBA
         xnYgeLcAYaQjFR1pugDbxrN3it0CKJ8ufvOY7ZBFTruPhYAhKudXt186eyJTeXXkVxpN
         n3cAetwdtaj9COJGhcVEUJagYlhl/mBKyuygDC71+ukqDHfAcEjNkmb7KDxSkikmKArm
         17k925n7MdBhp3a447DQqr0x9RDFAdl1HkUcdHd6mzy3v9aJHSa7SKlFq68lbILRE/OI
         gCxti3jpCOkQO5hHnxHOOlBalGB3WrTUz6P71xMBZgoHyIyc8M1pUknYY9fReMcnBS9w
         3q9Q==
X-Gm-Message-State: ANoB5pnpketDGaqIFr8BBzHASTntvKXVhSeKoNNxHoargqprWPXbgtgs
        qmU8X4suiGWs+kSwIYy8igItG1Qim6CQSGETCXY=
X-Google-Smtp-Source: AA0mqf6Zf9jnlIiqppAsm5rtsiE7Nl0FHZJQGiiM+Sr/ljU0hRVZy4KnmjDI620w8RUei8KXvrlxvw==
X-Received: by 2002:a63:e547:0:b0:473:e2bb:7fc7 with SMTP id z7-20020a63e547000000b00473e2bb7fc7mr5168956pgj.40.1669153799901;
        Tue, 22 Nov 2022 13:49:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f4-20020a623804000000b0056a7486da77sm11540924pfa.13.2022.11.22.13.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 13:49:59 -0800 (PST)
Message-ID: <637d4407.620a0220.463cb.2075@mx.google.com>
Date:   Tue, 22 Nov 2022 13:49:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-168-g84ada46f6323
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 147 runs,
 2 regressions (v5.15.79-168-g84ada46f6323)
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

stable-rc/queue/5.15 baseline: 147 runs, 2 regressions (v5.15.79-168-g84ada=
46f6323)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-168-g84ada46f6323/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-168-g84ada46f6323
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84ada46f6323d2c91d8c73811bbd4dd6fc55125c =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/637d1461abfb1307192abd01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
168-g84ada46f6323/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
168-g84ada46f6323/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d1461abfb1307192ab=
d02
        failing since 58 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/637d15c949713e56382abd10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
168-g84ada46f6323/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
168-g84ada46f6323/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d15c949713e56382ab=
d11
        failing since 58 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
