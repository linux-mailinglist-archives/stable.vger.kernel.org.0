Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC2B57EFD2
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 16:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiGWOvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 10:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiGWOvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 10:51:17 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFF81EAD6
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 07:51:17 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y141so6703026pfb.7
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 07:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DYs5ScGKKkPtwSugVmGvoAV53jTYi+Kn5XNvissXsU0=;
        b=pXq+aO13Vp+VdOKeUQIGDcaLmdi/JxUosrWtP4WdYraBepWc0ShrpBERU8WihM2fjx
         57xxi+Tf6iBcNzaCU/8QXpPqe7boLMvZ8YY49XiUUrXsvPhlfPg45WFXv8ivCHAhwcmE
         P3Uptr39OAi+y+uKegaOTwJS/2CE9/Ii4qDReAkiOaFH3c8uuk3De+z/eQLq7NlCIhK6
         hpwNEi69Ee1ImdJU3hdi+DPqb+b1coD7sPRhbxtlg8mzIBlFy+RRca0CHNBMUPFGf9dX
         rU+BFVu6Oq6aIu3+/XXGGbbyW/NfL1G791HG7RT9w8m5E20qX9WbVhkpq9qllAnA+6YQ
         4lFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DYs5ScGKKkPtwSugVmGvoAV53jTYi+Kn5XNvissXsU0=;
        b=ewTgE3txtYIIEx7XppHKDJVMNDykmtgBmQjw1jtlBUyFYOBdy5ogQYWZFp/zq71GrI
         xKOrlQb8uTbNLpWWa5jZKWoweRQBpybDHQw2sHoftn7HJ5lvAns5cSj83BWGaH49sSTq
         dNd+YO/2X90qhnLtLXJuJkiyk0a4ZjL300uJkS2+QGFHpCvxO4aVL4T/3StsWk0FjRBe
         OlLs68/5ooxjDpsVtmy0neM5x1S/HpUM4q8uh9kGHC2HKejV7RaKpwxXrl1K7NQR9XWV
         AQpRKySlu178qgQK4AzfFDGXAB27T8cxD8cpupUi2MGEvwgnvU0Dou042m1GMOkedi2/
         1tjQ==
X-Gm-Message-State: AJIora8HSWcwHw96bIUrhLrm72RTKE8rczTOjeobUBSwTBzej2+rdD1M
        E0TOA0foCLoNMEbnGZG6hZrNzIlrX0eF4aWz
X-Google-Smtp-Source: AGRyM1u5y/cMwWlFCbV+wENbjdcr+wOq5LL697ErMT5n7wfU0axZHPYHcSweKsCITbPXtlewY0QzwA==
X-Received: by 2002:a63:560d:0:b0:419:759a:6653 with SMTP id k13-20020a63560d000000b00419759a6653mr4192136pgb.219.1658587876357;
        Sat, 23 Jul 2022 07:51:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i1-20020a626d01000000b005254d376beasm6003982pfc.6.2022.07.23.07.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:51:16 -0700 (PDT)
Message-ID: <62dc0ae4.1c69fb81.c60b1.9a6d@mx.google.com>
Date:   Sat, 23 Jul 2022 07:51:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.13-70-gd9f3f07b8b8f9
Subject: stable-rc/queue/5.18 baseline: 171 runs,
 1 regressions (v5.18.13-70-gd9f3f07b8b8f9)
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

stable-rc/queue/5.18 baseline: 171 runs, 1 regressions (v5.18.13-70-gd9f3f0=
7b8b8f9)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.13-70-gd9f3f07b8b8f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.13-70-gd9f3f07b8b8f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d9f3f07b8b8f9b1b094cf363f0744ab4c1bb789a =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62dbdb81d0e7c22d2cdaf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.13-=
70-gd9f3f07b8b8f9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.13-=
70-gd9f3f07b8b8f9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62dbdb81d0e7c22d2cdaf=
07b
        failing since 17 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
